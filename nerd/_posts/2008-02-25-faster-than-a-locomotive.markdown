---
layout: post
title: Faster than a Locomotive?
date: 2008-02-25
author: Jeff Watkins
categories:
- Coherent
---

After squashing a couple nasty bugs this weekend, I got to thinking about the performance implications of my solution. In a nutshell, the solution required wrapping getter methods with code to establish the ownership link between the value and the object. This wrapping only occurs for properties that are observed or part of a dependent key relationship, but still, we're talking an extra layer of code.
<!--more-->

## It's UI code

Fundamentally, the purpose of Coherent is to make writing the UI of Web applications more like writing the UI of desktop applications. And when you really think about the top needs for UI code, blinding speed just isn't one of them.

For high-level code, I'd much rather trade off a little bit of speed in favour of a more flexible, de-coupled implementation. For low-level code, like CSS Selector engines, you absolutely _must_ have the fastest you can get. Until your browser supports the [W3C Selectors API](http://www.w3.org/TR/selectors-api/), like nightly WebKit builds, you want your JavaScript implementation to be as fast as possible. But for high-level APIs intended to speed application development, a few extra cycles lost here and there won't hurt.

## Trade-offs

One of the trade-offs that I'm making revolves around when to perform the method wrapping. If this were desktop software, the model objects might live a life partially independent of the UI. It's conceivable your code might perform some sort of background processing and fill in your model objects. In that case, you don't necessarily want to be calling wrapped methods, you want every last drop of processor power at your disposal. In that case, you'd only want to wrap methods when the object becomes the target of an observer.

But for Web applications, the presumption I'm making is that the data wouldn't be on the client in the first place if it weren't taking part in the UI. Therefore, let's spend the minimum amount of time creating wrapped methods (they don't grow on trees, you know) and most likely, once a property gets observed, the rest of the instances of that class are also likely to get observed as well.

So the trade off in this case is less time spent wrapping methods in exchange for a few more change notifications sent when no one cares.

## Writing the code for you

It's been suggested that Coherent could use a facility to automatically generate getter and setter methods. The syntax I'm thinking would be something like the following:

    var MyClass= Class.create(coherent.Bindable, {

        exposedBindings: ['content'],

        properties: ['name', 'description'],

        ...

    });

If you leave out any implementation of the `content` binding Coherent would automatically generate the following:

        ...

        observeContentChange: function(change, keyPath, context)
        {
            this.setContent(change.newValue);
        },

        setContent: function(newContent)
        {
            this.__content= newContent;
        },

        getContent: function()
        {
            return this.__content||null;
        },

        ...

And if you didn't implement methods for the `name` and `description` properties, Coherent would generate the following methods to implement them:

        ...
        
        setName: function(newName)
        {
            this.__name= newName;
        },

        getName: function()
        {
            return this.__name||null;
        },

        setDescription: function(newDescription)
        {
            this.__description= newDescription;
        },

        getDescription: function()
        {
            return this.__description||null;
        },

        ...

I'm not certain how valuable this really is. Is it that much better than calling `this.setValueForKey("Bob", "name")` when you need to set the object's name? It would be a bit more clear, and I could generate the wrapped versions at the same time to reduce one layer of indirection.

There might be additional benefits to knowing in advance the list of properties a class exposes, but I don't know whether limiting you to only the properties you declare is right in such a dynamic language as JavaScript. Still, it's something to think about post 1.0.