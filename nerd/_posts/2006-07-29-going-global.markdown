---
layout: post
title: Going Global
date: 2006-07-29
author: Jeff Watkins
categories:
- Ajax
- Featured
- Javascript
---

So far, the most popular posts I've written (if you discount the [rant about syncing my mobile phone on Windows](http://nerd.newburyportion.com/2005/12/searing-pain)) are the two about getting dynamically loaded JavaScript code to execute in the global context.





## A Bit of History ##
Just to recap, in [Ajaxian Limitation](http://nerd.newburyportion.com/2005/08/ajaxian-limitation) I complained about the difficulty I encountered trying to get the JavaScript returned from an `XmlHttpRequest` to function correctly. After poking around a bit, I encountered a clever solution to this problem which I documented in [The Magic Eval](http://nerd.newburyportion.com/2005/09/the-magic-eval). Thanks to the help of lots of people, I think I can offer a final reduction of the problem and solution.

When you're building an Ajax application, it can be _extremely_ convenient to generate HTML on the server which gets sent back to the client. This is often faster and certainly more convenient, because you can share the same content templates as well as leverage the data in its native format rather than converted into JavaScript objects. But I often find that I want to send some code back in addition to the HTML. When you update the `innerHTML` attribute of an element, any `script` tags are not evaluated. So you have to manually evaluate the scripts.

## Installing a Script Globally ##
When you receive your HTML snippet, you'll need to extract the scripts -- I typically use the `String` method `extractScripts` from [prototype](http://prototype.conio.net/), but you can use whatever you'd like. Actually, `extractScripts` isn't exactly perfect for the job, because it doesn't seem to work with scripts with a `src` attribute. But that's OK for this example.

Once I have the JavaScript that I'd like to add to the current browser context, I need to evaluate it. Unfortunately, while calling `eval` with the text of the script will execute the code, it won't work quite as you expect: the code will execute in the scope of the `eval` statement and any functions you define won't be available in the global page scope. There are some clever tricks around this, but they all require you to write your scripts in a slightly funky way. There's one _really_ clever trick that allows you to write your scripts just like you always do, but have everything work.

    /** Execute a script in the global context. This installs all functions
        defined in this script into the global scope, unless they are
        explicitly created in different scopes.
        
        @param script   the source of the JavaScript to evaluate
     **/    
    function installScript( script )
    {
        if (!script)
            return;
        //  Internet Explorer has a funky execScript method that makes this easy
        if (window.execScript)
            window.execScript( script );
        else
            window.setTimeout( script, 0 );
    }
    
This function takes advantage of a proprietary extension to the `window` object in Internet Explorer: the `execScript` method. There's not much information on [Microsoft's MSDN page for the `execScript` method](http://msdn.microsoft.com/library/default.asp?url=/workshop/author/dhtml/reference/objects.asp). But it seems to execute the script in the global scope and installs new functions into that scope, which is fortunate, because the approach used for every other browser _doesn't_ work in Internet Explorer.

For other browsers, the `installScript` function uses the `setTimeout` method of the `window` object to execute the script. Essentially, when `setTimeout` executes, it will evaluate the JavaScript in its first parameter. Fortunately, it evaluates the script in the global (or window) scope. This allows any functions you defined in that script to be available throughout the rest of the page.

## Handling Script Tags with `src` Attributes ##
Sometimes returning inline JavaScript just isn't the right solution. That means you'll need to deal with `script` tags that include a `src` attribute. The gist of the solution is to pull out the value of the `src` attribute (either using regular expressions or straight string parsing) and load the JavaScript using an XmlHttpRequest. Once you have the script source, pass it to `installScript` and you're done.