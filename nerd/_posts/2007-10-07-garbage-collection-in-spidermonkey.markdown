---
layout: post
title: Garbage Collection in SpiderMonkey
date: 2007-10-07
author: Jeff Watkins
categories:
- Uncategorized
---

So let's say you're using SpiderMonkey (the JavaScript engine from Mozilla) to build a Web application server that naturally uses JavaScript as the server-side language. Naturally, you want to support XML, since you want to be taken seriously and of course, you don't want to write your own XML parser, because [libxml2](http://xmlsoft.org/) is really good. And because you want to be extra cool, you want your XML implementation to support [DOM level 3](http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/) out of the box.





All this means you'll be able to write code like the following:

    function setValueOnParent(id) {
        var doc= XmlDocument("file:///your-xml-file.xml");
        var node= doc.getElementById(id);
        node.parentNode.myValue="foo";
        return node;
    }

While this is basically nonsense code, it does exhibit some of the challenges of working with the SpiderMonkey code base. When this function runs, the JavaScript engine creates a total of 3 objects to represent the structure of the XML document: an instance of XmlDocument and two instances of XmlNode. When the function returns, the engine is only holding a reference to one XmlNode.

But what if I have the following code that uses our fictitious `setValueOnParent` function?

    var node= setValueOnParent("foo");
    print("parent value=" + node.parentNode.myValue);

You'd expect to get `foo` as a result. If your wrapper for the XML library is naive, you won't keep the original JavaScript objects associated with the document and the parent node. Where would you put them? They have to be stored as a value on some other JavaScript object, and unless you want to reflect the entire XML tree in JavaScript, you're out of luck. (I know this example isn't very good, because the JavaScript objects _do_ have references to each other.)

So what do you do?

You explore the fun that is the SpiderMonkey Garbage Collection API.

I posted the following to the development list on Wednesday.

> **date:** Wed, 03 Oct 2007<br>
> **From:** Jeff Watkins<br>
> **Subject:** GC & Caching JSObjects again<br>
> **To:** SpiderMonkey Dev List<br>
> 
> OK, so I'm now writing my interface to LibXML and I've run across  
> some conceptual challenges. Naturally, I'd like to wrap a Node with a  
> JS object and return it to be manipulated by the script. But the  
> script might keep a reference to the node or add some properties to it.
> 
> Ideally, if a different part of the same script were to ask for the  
> same node, it should get the same JS object back complete with any  
> modifications.
> 
> So I'm thinking of something like the following:
> 
> typedef map&lt;xmlNode*, JSObject*&gt; NodeMap;
> 
> When I wrap an xmlNode with a JSObject, I'll add the JSObject to the  
> xmlDoc's node map. But I need some way to mark those JSObjects as non- 
> collectable. Should I be using JS_AddRoot for this?  Or should I be  
> rooting the Document (xmlDoc wrapper) and keeping every Node as a  
> property on the Document?
> 
> I really don't want to wrap an xmlNode unless the script specifically  
> asks for it. Otherwise, I'm pretty certain the memory profile would  
> be unpleasant.
> 
> Does anyone have any suggestions?

As garbage collection isn't terribly well documented, I wasn't terribly optimistic, but Mike Shaver came to my rescue. His encouragement was what it took to get me started, even if I _did_ go down the wrong path at first.

It turns out, what I needed to do was install a garbage collection callback to manage my objects outside of the standard system. That way I could keep all the objects in memory until _none_ of them were referenced by the JavaScript engine and only collect them then.

Rather than recount my trial and error process, I'm simply going to jump to the solution.

## SetGCCallbackRT: install a garbage collector callback ##

The first step is to install the garbage collector callback. You might be tempted to use `SetGCCallback` rather than `SetGCCallbackRT`, because you probably have a `JSContext*` hanging around -- since you need one for almost every call. That might fool you into thinking you can have a GC callback for each context, but you can't. Under the covers, `SetGCCallback` simply gets a pointer to the `JSRuntime` and calls `SetGCCallbackRT`. So I figure it's better to be specific about what I'm doing.

Now I have a mix-in class called `GCManager` for native objects that want to interact with the SpiderMonkey garbage collector:

    class GCManager
    {
        protected:
            GCManager();
            virtual ~GCManager();
        
            void registerManager();
            void unregisterManager();
        
        private:
            virtual void markLiveObjects(JSContext* theContext,
                                         JSGCStatus theStatus);

            static JSBool markLiveObjects(JSContext* theContext,
                                          JSGCStatus theStatus);
    };

Of course, the _implementation_ isn't quite so clean. First, we need to keep track of the garbage collector callback information:

    typedef std::set<GCManager*> managers_set;

    struct GCManagerInfo
    {
        GCManagerInfo()
        : _count(0), _oldCallback(NULL)
        {}
    
        Mutex _mutex;
        managers_set _managers;
        size_t _count;
        JSGCCallback _oldCallback;
    };

This allows me to install & remove the callback as well as track each `GCManager` instance. To avoid construction order problems with static variables, I have the following function:

    static GCManagerInfo& getInfo()
    {
        static GCManagerInfo info;
        return info;
    }

If you haven't run the construction order problem before, C++ doesn't specify any order for file level constructors, so if you _might_ be accessing this information from another file that was constructed _before_ this, you'll want to force the constructor by using a function static like this.

The next part is pretty simple, the constructor for `GCManager` registers itself with the garbage collector callback and the destructor unregisters the instance.

    GCManager::GCManager()
    {
        registerManager();
    }

    GCManager::~GCManager()
    {
        unregisterManager();
    }

The register method does about what you'd expect: first, it acquires a lock on the mutex, then installs the callback if it hasn't already been installed, and finally adds `this` to the set of managers and increments the use count.

    void GCManager::registerManager()
    {
        GCManagerInfo& info= getInfo();
        AutoLock lock(info._mutex);
    
        if (!info._count) {
            RuntimeRef runtime;
            info._oldCallback= JS_SetGCCallbackRT(runtime,
                                                  &GCManager::markLiveObjects);
        }
        info._managers.insert(this);
        info._count++;
    }    

The unregister method is just as simple: acquire the mutex, decrement the use count and if there are no more instances, remove the callback, finally remove the instance from the set of managers.

    void GCManager::unregisterManager()
    {
        GCManagerInfo& info= getInfo();
        AutoLock lock(info._mutex);
    
        if (0==--info._count) {
            RuntimeRef runtime;
            JS_SetGCCallbackRT(runtime, info._oldCallback);
            info._oldCallback=NULL;
        }
        info._managers.erase(this);
    }

The last piece is the actual garbage collector callback function. Even it does about what you'd expect: when the garbage collector has marked all the live objects the runtime knows about, we iterate through the set of `GCManager` instances and asks each one to mark _its_ live objects.

    JSBool GCManager::markLiveObjects(JSContext* theContext,
                                      JSGCStatus theStatus)
    {
        if (JSGC_MARK_END!=theStatus)
            return JS_TRUE;
        GCManagerInfo& info= getInfo();
        managers_set::iterator begin= info._managers.begin();
        managers_set::iterator end= info._managers.end();
        managers_set::iterator i;
    
        for (i=begin; i!=end; ++i)
            (*i)->markLiveObjects(theContext, theStatus);
        return JS_TRUE;
    }

## Marking your objects ##

So if the boiler plate of the `GCManager` mix in does about what you'd expect, where is the unexpected bit? There really isn't any. There are just two more functions you'll need: `JS_IsAboutToBeFinalized` and `JS_MarkGCThing`. And you can undoubtedly guess what these functions do.

If you need to know whether your object will be finalised (deleted) when the collector is finished, you can find out with a call to `JS_IsAboutToBeFinalized`. These undocumented functions have the following prototype:

    JSBool JS_IsAboutToBeFinalized(JSContext* cx, void* thing);
    void JS_MarkGCThing(JSContext* cx, void* thing, const char* name,
                        void* arg);

For `JS_IsAboutToBeFinalized`, you pass your context and a pointer to the thing (in most cases a `JSObject`) and get back a boolean indicating whether the object is about to be deleted. `JS_MarkGCThing` is a bit more tricky, you need the context, a pointer to your thing, a name for debugging purposes, and `NULL`. It turns out the `arg` parameter is actually a pointer to a `JSTracer` structure, but if you pass anything other than `NULL`, you'll get an assertion from the runtime. So you might consider passing `NULL`.

And that's it.

For the XML wrapper, I only want the objects to be collected when the runtime holds _no_ references to any of them, so first I check all of the objects to see whether they will be finalised, and if any aren't going to be finalised, I mark them all to keep them around. Otherwise, I just let it go and allow all of them to be finalised, which automatically tears down my native objects and releases the libxml data structures.

The method is really simple:

    void XmlDocument::markLiveObjects(Context& theContext,
                                      JSGCStatus theStatus)
    {
        object_set_t::iterator begin= _objects.begin();
        object_set_t::iterator end= _objects.end();
        object_set_t::iterator i;
    
        bool dead= true;
    
        //  First scan all the objects to determine whether ANY are referenced
        for (i=begin; i!=end; ++i) {
            if (!JS_IsAboutToBeFinalized(theContext, *i)) {
                dead= false;
                break;
            }
        }
     
        //  If there are no referenced objects, then allow the whole document tree
        //  to be cleaned up.
        if (dead)
            return;
        
        //  Otherwise, mark all objects as referenced so that the whole tree is
        //  kept in memory
        for (i=begin; i!=end; ++i)
            JS_MarkGCThing(theContext, *i, "xml object", NULL);
    }

There you have it. I've promised Mark that I'll add some documentation to the [SpiderMonkey API wiki](http://developer.mozilla.org/en/docs/JSAPI_Reference) eventually, but I wanted to capture this before I forgot.

So, [in spite of being a moron](http://ajaxian.com/archives/apple-store-hits-the-dojo), I guess I still know a thing or two about something.

Oh, and ServerMonkey (my tentative name for this monstrosity is coming along nicely).

**Update:** All this work may have benefits for other users of SpiderMonkey, because I think I found a [memory leak in the implementation of SpiderMonkey's native property getters](https://bugzilla.mozilla.org/show_bug.cgi?id=399218). Of course, I'm just as likely to be wrong as right. So if you'd like to check my work, please feel free to download the project attached to that bug.
