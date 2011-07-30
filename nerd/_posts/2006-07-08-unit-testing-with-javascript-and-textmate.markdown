---
layout: post
title: Unit Testing with JavaScript and TextMate
date: 2006-07-08
author: Jeff Watkins
categories:
- Featured
- Javascript
---

If you write lots of JavaScript -- and boy, do I write a bit of JavaScript -- you might be interested in a nice little unit testing library I've put together. There are several other JavaScript unit testing libraries out there, but they all assume you want to execute your scripts in a browser. For gnarly library code, like my implementation of Apple's Cocoa Bindings for the DOM, running from the command line is much more conducive to integration into a _real_ development process.




If everything goes well, you get output like the following:

    9 tests: 9 passed, 0 failed

Of course, half the fun of unit tests is when they fail. And to be really useful and promote writing tests, the output should be useful. I modelled the output on the syntax from a compiler, so you can plug it into your favourite development environment and be able to jump directly to the offending test:

    base-test.js:11: titleCase(fooBar)==FooBar
    base-test.js:33: clone.foo == obj.foo
    9 tests: 7 passed, 2 failed

I've wrapped all of this into a command for [TextMate](http://www.macromates.com/) which I've placed in my tweaked JavaScript bundle (I fixed the patterns for function definitions so they work across multiple lines). Now I can simply hit Cmd-T to run all the tests associated with my project. Or if there's no `tests` folder, the command runs just the tests in the current file.

## Assertions ##

I've included most of the default assertion types that I'm familiar with.

* `assertEqual( msg, value1, value2 )`
* `assertNotEqual( msg, value1, value2 )`
* `assertTrue( msg, value )`
* `assertFalse( msg, value )`
* `assertNull( msg, value )`
* `assertNotNull( msg, value )`
* `assertUndefined( msg, value )`
* `assertNotUndefined( msg, value )`
* `fail( msg )`

Unlike many libraries, I've chosen to place the message first. This wasn't an arbitrary decision. I actually use the message to locate the line number of the test should it fail, because JavaScript doesn't include line numbers in thrown exceptions. So it's important that your failure messages be unique. If two tests have the same message or if there's no message (you bad developer, you), the library simply reports the line number of the test function and lets you figure it out.

## Testing for Exceptions ##

Just like in JUnit, you use a `try`/`catch` block to test for situations where an exception _should_ be thrown. For example:

    try
    {
        titleCase( 50 );
        fail( "Shouldn't have been able to complete titleCase with non-string values" );
    }
    catch (e)
    {
        //  I was expecting an exception.
    }

I suppose I could come up with a more clever solution than this, but I didn't want to spend all my time on building the library. If you have any thoughts, don't hesitate to let me know.

## Writing a Test ##

Tests are pretty simple. They self-register, so all you need to do is create one. For example, here's the first few tests of the base code for my DOM Bindings library:

    load( "../base.js" );
    load( "../keyvalue.js" );

    var base= new Test();
    base.setup= function()
    {
    }

    base.testTitleCase= function()
    {
        assertEqual( "titleCase(fooBar)==FooBar", titleCase('fooBar'), "FooBar" );
        assertEqual( "titleCase(null)==null", titleCase(null), null );
    
        //  passing anything but a string to titleCase should throw some sort of
        //  exception, which exception depends on your JavaScript engine.
        //  @TODO: 0 seems to work OK. I'm not certain whether this should be fixed.
        try
        {
            titleCase( 50 );
            fail( "Shouldn't have been able to complete titleCase with non-string values" );
        }
        catch (e)
        {
            //  I was expecting an exception.
        }
    }

    base.testClone= function()
    {
        var obj= { foo: 1, bar: "baz" };
        var c= clone(obj);
    
        assertNotEqual( "clone should create a new object", obj, c );
        assertEqual( "clone.foo == obj.foo", obj.foo, c.foo );
        assertEqual( "clone.bar == obj.bar", obj.bar, c.bar );
    
        //  clone only works with 1 argument
        c= clone(obj, obj);
        assertUndefined( "clone shouldn't return a value for two arguments", c );
    }

At the moment, I don't have a particularly good solution for including other library files. I'm using the SpiderMonkey load function, but I plan to provide my own. The trick is to create a new `Test` object and then add functions to it that start with `test`. Any function that starts with `test` will get executed.

In addition to test functions, you can write a `setup` and `teardown` function for your test fixture. When run, the tests actually execute on a cloned instance of your fixture. The order of operations for each test function is:

1. Clone your fixture
2. Invoke the cloned fixture's `setup` function (or the default, empty `setup` function)
3. Invoke the test function on the cloned fixture
4. Invoke the cloned fixture's `teardown` function (again, there's an empty default defined on the `Test` class)

## Supported Environments ##

At the moment, the unit testing library supports SpiderMonkey (and the TextMate bundle includes the SpiderMonkey JavaScript shell to execute it). However, I've got preliminary support for the Microsoft Windows Scripting Host -- I just need to do some more testing when I get a PC (like at work).

The [TextMate JavaScript bundle](http://nerd.newburyportion.com/downloads/JavaScriptBundle.zip) is available for download. In addition to unit testing, it includes a command to execute [the excellent JavaScript Lint tool](http://javascriptlint.com) which is also based on SpiderMonkey. I think you'll need to copy this Bundle into your `~/Library/Application Support/TextMate/Bundles` folder directly, because that's where it came from on my system. I don't think it's a full fledged Bundle.

Finally, the binaries for SpiderMonkey and JavaScriptLint are PowerPC only. I've only built them from their makefiles; so they won't work as speedily on Intel Macs.

## Update ##

I had to fix the original code that determined the line numbers for assert messages. It turns out that SpiderMonkey reformats the script significantly so what you get back from `fn.toString()` is _very_ different from what you originally wrote. The solution was to search the original source code. It's not terribly efficient, but the function only executes on an error anyway.