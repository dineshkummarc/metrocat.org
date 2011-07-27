---
layout: post
title: The Magic Eval
date: 2005-09-01
author: Jeff Watkins
categories:
- Javascript
---

One of the coolest aspects of Javascript is the `eval` function. It gives you
the option of executing code composed on the fly or received as the result
of an `XMLHttpRequest`.

But `eval` can be tricky and extremely frustrating. Let's dive into some of
the most critical aspects...
<!--more-->
## What is `eval`? ##

Most simply, `eval` is a method on the global object (AKA a global
function) accepting a single string argument which it executes as either a
statement (or block of statements) or an expression. If the argument
represents an expression, `eval` returns the result of the expression.
However, if the argument represents a statement or block of statements,
the return value is undefined (it might be literally the `undefined` value
or another value, it's undefined).

Common uses of `eval`:

1. **Storing the name of a function** -- in some cases, when writing
   reusable code you may know the name of the function you wish to call, but
   that function may not have been defined yet. Or the function may never be
   defined. This only becomes problematic when the name of the function is
   determined based on other conditions: concatenated based on element IDs
   or the value associated with a pop-up list option.

2. **Executing code supplied by a server** -- In the realm of Ajax, this is
   all the rage. In fact this entire article grew out of [limitations I was
   experiencing with
   Ajax](http://metrocat.org/nerd/2005/08/18/ajaxian-limitation). Most
   libraries that do this impose weird limitations on the coding style
   supported by the Javascript they eval. A good example is the Ajax library
   included in Apple's Dashboard Widget library.

3. **Executing user supplied code** -- Don't do this. It's a really bad idea
   because you have no way of vetting the code a user will give you. (Of
   course, my little debugger allows this...)

The first and second uses of `eval` are quite common, and I hope like hell
the third use is rare, but I wouldn't be surprised if it were common.

## Scoping of `eval`uated code ##

One of the interesting aspects of `eval` is that the executed code has
access to all the variables and functions defined in the enclosing scope.
The following example will display the value of the local `foo` variable.

    var foo="bar";

    eval( "alert(foo)" );

Isn't that interesting?

More interesting, you can declare variables and functions in the calling
scope using an `eval` statement:

    function go()
    {
        eval( "function bar() { return 'bar'; }" );
        alert( bar );
    }

This example will actually display the source code of the `bar` function.
And I could call the `bar` function just like I would any other. However,
the `bar` function is only valid during the execution context of the `go`
function. I can't call `bar` from anywhere else.

The functions and variables declared in the `eval` statement can live
beyond the execution context of the `eval` statement, but you have to stash
them somewhere. This is easy if you know the names of the functions and
variables, but impossible if you don't.

## Eval in the global scope ##

When Javascript code is `eval`uated in the global scope, the same rules of
scoping apply. But *the code exists in the global scope*. This means its
lasts forever. And fortunately, this is the desired behaviour for `script`
tags in HTML code received via `XMLHttpRequest`.

But how can you cause code to be evaluated in the global scope without
actually evaluating it in the global scope? Use the `setTimeout` method. In
Web browsers, the global scope is the same as the `window` object. Now
normally, the activation object (the local scope) is an entirely different
object from the object returned by the `this` operator, but when a function
is declared in the global scope, special rules apply.

Quoting from the Javascript spec:

> 10.2.1 Global Code
>
> * The scope chain is created and initialised to contain the global object and no others.
>
> * Variable instantiation is performed using the global object as the variable object and using property attributes { DontDelete }.
>
> * The this value is the global object. 

Thanks to a bug, you won't be able to [iterate global functions using
Internet
Explorer](http://blogs.msdn.com/ericlippert/archive/2005/05/04/414684.aspx).
Other browsers seem to work fine.

Consider the following example:

    function evalInGlobalScope()
    {
        var fn= "function bar() { return 'bar'; }";

        setTimeout( "eval('" + fn.replace( /'/g, "'" ) + "')", 0 );
    }

    function testFunction()
    {
        alert( bar );
    }

The function `evalInGlobalScope` calls the `window` object method
`setTimeout` and passes a Javascript expression containing a call to `eval`
and the code we'd like evaluated in the global scope. The timeout is set to
occur after 0 seconds have elapsed (basically, as soon as possible). Later,
when calling `testFunction`, the injected function is now available.


**Update:** The discussion continues in [Going Global](http://nerd.newburyportion.com/2006/07/going-global).