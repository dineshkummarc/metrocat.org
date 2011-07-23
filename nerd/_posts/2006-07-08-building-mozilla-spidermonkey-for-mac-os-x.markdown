---
layout: post
title: Building Mozilla SpiderMonkey for Mac OS X
date: 2006-07-08
author: Jeff Watkins
tags:
- Javascript
---

As part of my development of a JavaScript implementation of Apple's Cocoa Bindings technology, I've been keen to implement a unit testing framework. There are several JavaScript unit testing libraries that run in the browser, but I'm  most interested in something that runs from the command line. That way it can be part of my _build_ process -- including [JavaScript Lint](http://www.javascriptlint.com/).

The Mozilla project has packaged their reference implementation of JavaScript, SpiderMonkey, which compiles just fine on Mac OS X. But the default configuration of the JavaScript shell doesn't include file operations (other than the ability to load scripts). This is a pretty severe limitation, but fortunately, there's an extension for file support.

The file extension requires the Netscape Portable Runtime library (NSPR). I wasn't able to find any documentation on how to build SpiderMonkey with NSPR to enable file support. So after a few aborted attempts, I've finally documented everything I needed to do.

At the end of this, you should have a SpiderMonkey JavaScript shell that includes file operations.

0. Create a folder to contain everything. I called it mozilla.

0. Get the 4.4.1 release of NSPR from the Mozilla Web site.

    The libraries don't actually work on OS X 10.4, but we can steal the binary from Firefox. So we're only using the release for the headers.
    Put the NSPR release in the mozilla folder. You should now have `~/mozilla/nspr-4.4.1`.

0. Get the [latest SpiderMonkey source code](http://www.mozilla.org/js/spidermonkey/).

    Unpack the source into the mozilla folder. You'll now have the `~/mozilla/js` folder which contains the `src` folder.

0. Tweak the Makefile

    If you're building the standalone JavaScript shell, you'll be using the `Makefile.ref` makefile. This needs some slight tweaking before it's ready. When you define `JS_THREADSAFE` SpiderMonkey will use the NSPR runtime, except the standalone makefile doesn't know where the runtime lives.
    
    Add `-I../../nspr-4.4.1/include` to the `INCLUDES` definition and `-L../../nspr-4.4.1/lib` to the `OTHER_LIBS` definition:
    
        ifdef JS_THREADSAFE
        DEFINES += -DJS_THREADSAFE
        INCLUDES += -I../../dist/$(OBJDIR)/include -I../../nspr-4.4.1/include
        ifdef USE_MSVC
        OTHER_LIBS += ../../dist/$(OBJDIR)/lib/libnspr${NSPR_LIBSUFFIX}.lib
        else
        OTHER_LIBS += -L../../dist/$(OBJDIR)/lib -lnspr${NSPR_LIBSUFFIX} -L../../nspr-4.4.1/lib
        endif
        endif

0. Enable file support.

    You'll need to make a couple changes to the source in order to get file support in SpiderMonkey. First, comment out the definition of `LAZY_STANDARD_CLASSES`, which appears on line 1975 in `js.c`. This seems to tell SpiderMonkey that it can initialise the standard classes in a lazy fashion. Unfortunately, the `File` object never gets initialised. So we comment this out.
    
    Next, there's a slight bug in the file library itself. In the `js_fileDirectoryName` function in `jsfile.c` (around line 380), you'll see the following:
    
        /* add terminating separator */
        index = strlen(result)-1;
        result[index] = FILESEPARATOR;
        result[index+1] = '\0';

    The problem is this will overwrite the last character in the directory name; simply removing the `-1` will solve the problem. You should end up with:

        /* add terminating separator */
        index = strlen(result);
        result[index] = FILESEPARATOR;
        result[index+1] = '\0';
    
    There's one more bug in the file library's routine to read a line that we need to fix. In the `file_readln` function in `jsfile.c` (around line 1717), you'll see the following:

        if ((endofline==JS_TRUE)) {
            str = JS_NewUCStringCopyN(cx, JS_GetStringChars(file->linebuffer),
                                      offset);
            *rval = STRING_TO_JSVAL(str);
            return JS_TRUE;
        }else{
            goto out;
        }

    Now aside from the ghastly coding style, this check doesn't allow for reading the final line in the file where there's no trailing linefeed. So we can simply slip in a check to see whether any characters were read in addition to whether a newline was encountered.

        if ((endofline==JS_TRUE)||(offset>0)) {
            str = JS_NewUCStringCopyN(cx, JS_GetStringChars(file->linebuffer),
                                      offset);
            *rval = STRING_TO_JSVAL(str);
            return JS_TRUE;
        }else{
            goto out;
        }
    
0. Build SpiderMonkey.

    After making the changes above, you should be ready to build the SpiderMonkey JavaScript shell. Type the following at the command line:

        make -f Makefile.ref JS_THREADSAFE=1 JS_HAS_FILE_OBJECT=1

0. Copy the NSPR dynamic library from Firefox.

    The shell won't run without `libnspr4.dylib`. But the dynamic library included with the NSPR 4.4.1 library won't work on Tiger. So the answer is to steal the library that's compiled into Firefox. If you've installed Firefox in your `/Applications` folder, you should be able to type:
    
        ~/mozilla/js/src> cp /Applications/Firefox.app/Contents/MacOS/libnspr4.dylib Darwin_DBG.OBJ
        
    This will copy the dynamic library from the Firefox application to SpiderMonkey's build folder.