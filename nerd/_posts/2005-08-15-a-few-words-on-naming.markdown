---
layout: post
title: A Few Words on Naming
date: 2005-08-15
author: Jeff Watkins
categories:
- Art-of-Coding
---

By now you may have noticed that I like long, descriptive names. Take an example from the Key-Value Coding/Observing library, `setKeysTriggerChangeNotificationForDependentKey`. That's quite a mouthful for anyone. But most editors will complete this automatically after typing only a few characters.

Most importantly, the name `setKeysTriggerChangeNotificationForDependentKey` leaves absolutely no doubt what the function does.

In the hopes that I might be able to influence your own naming scheme, I've set down my guidelines. If you don't already have a naming scheme, consider adopting one. It will make your life easier. That's what they're supposed to do.


To give credit where it is due, my naming guidelines are basically an adaptation of Apple's Objective-C naming guidelines. I've tried to make these guidelines work well with languages like JavaScript and C++.

## Purpose of Naming Guidelines ##

Why have a naming scheme? Why not just make it up as you go along? Heaps of software has followed this *process* for almost as long as there have been programmers. Developers frequently claim there just isn't enough time to plan out things like a naming scheme. Almost worse is when developers spend so much time arguing the nearly religious aspects of how functions and member variables should be named that they get nothing done.

At their best, naming guidelines are meant to help developers communicate with the other developers on the team and the developers that may join the team in the future. When carefully crafted, guidelines clearly differentiate between `getWindowFromHwnd` and `windowFromHwnd`.

Not all guidelines will apply to all languages, but a guideline helps developers understand what a function or variable does.

## 1. Identify a Function's Arguments ##

Don't be afraid to describe a function's arguments as part of the name. I know function overloading is all the rage these days, but I'm actually not arguing against this. By identifying the arguments, you offer a developer reading your code hints about what the values you're passing mean to the function. If you name your function correctly, you will leave virtual blanks that users of your function feel compelled to fill in. And a properly named function makes it clear what types of values go in these blanks.

Taking an example from the key-value library, `setValueForKeyPath`. This function takes two arguments: a value and a key path. Now you have to understand the context to know that a value can be anything and a key path is a string. But you'll never get anywhere if you don't understand the scope of the code.

Let's examine the example I used in the excerpt, `setKeysTriggerChangeNotificationForDependentKey`. First we come across `setKeys`. From this we can guess that the first argument is a collection of some sort, the keys, and that the second argument is a singular key based on `ForDependantKey`. We can also reason that conceptually the elements of the first argument are of the same type as the second argument, key. The function name also sets out the relationship between them: dependance.

Yes, this is a *really* long function name, but if our goal is clarity, it really couldn't be much shorter.

I could have two overloaded versions of this function with the following Java method signatures:

    setKeysTriggerChangeNotificationForDependentKey( String[] keys,
                                                     String dependantKey )
    setKeysTriggerChangeNotificationForDependentKey( Collection<String> keys,
                                                     String dependantKey )

This doesn't break the naming guideline.

It isn't necessary to name every single argument, especially if those arguments have default values.

## 2. Function or Accessor? ##

Functions which perform an action or calculate a value should begin with a verb. Hence we have `calculateAverageCostPerSeat` or `save` or `updateRowCount`. In this case, the return value of the function is likely to be less significant than the operation of the function.

If the function's operation is less significant than the return value (mostly the case for accessor functions), then name the function after the value it returns. This rule gives us function names like `childAtIndex` or `childWithWindowText`.

You may also differentiate the return values via adjectives. Remember adjectives? You might have a function `visibleChildWithWindowText` that complements `childWithWindowText` by only returning windows that are visible. This is actually preferable to passing an argument to `childWithWindowText` to determine whether to only process visible windows. If you were to pass an argument you might attempt to name the function `childWithWindowTextHavingVisibilityFlag`, which is rather ungainly.

> The key-value library uses `getValueForKeyPath` when according to my own guidelines, I should be using `valueForKeyPath`. Oddly enough, the equivalent method on `NSObject` is `valueForKeyPath` rather than `getValueForKeyPath`.

Notice that the accessor functions don't begin with `get`. My recommendation is that you use `get` only when you're returning a value indirectly. Consider the following C++ examples:

    void getWindowText( char* textBuffer, unsigned textBufferSize );
    std::string windowText();

Both functions retrieve the window text. The first function expects you to have pre-allocated a buffer, while the second function returns a Standard Library string object containing the window's text.

You may opt to use the `get` prefix for functions which access non-intrinsic properties where the cost of deriving the value is worth noting. But given that processors keep getting faster, it may not be worthwhile.

Of course, if you're using Java, your classes should be compliant with the prevailing Java practise of prefixing *all* accessors with `get`.

## 3. Don't Abbreviate ##

Unless you're absolutely certain that no one will ever be confused, don't abbreviate. Use `count` instead of `cnt`. Use `index` instead of `idx`. But definitely use `Html` instead of `HyperTextMarkupLanguage`.

## 4. Be Clear Who Owns What ##

If you're working in a language without Garbage Collection (you have my sympathy), you'll want to clarify ownership of created objects. Any function with `create`, `copy` or `new` in the name should confer ownership of the new resource to the caller. So if you have the following methods:

    Window* childWithId( unsigned controlId );
    Window* newWindowWithFrame( Rect& frameRectangle );

The first function, `childWithId` returns a pointer to the child window with the specified ID. If the caller wants to make certain the child window persists, he'd better call `retain` or `addReference` or whatever. The second function creates a new window with the given frame rectangle. The caller receives ownership of this new object and is responsible for releasing it when appropriate.

## 5. Naming Member Variables ##

Give up on the stupid Hungarian Notation already. It's hardly ever been used correctly and even Microsoft doesn't use it any more in their latest software. Along with this, throw out the stupid `m_` prefix. You shouldn't ever be refering to member variables directly. Therefore, you won't need to know 

But do make your member variables meaningful. Having a `count` variable really doesn't tell you as much as `numberOfWindows`.

## 6. Naming Variables ##

Everyone uses variables like `i` or `s` or `p`. That's just life. Most of the time those are actually meaningful names. Really. The following is actually good code:

    vector<WindowPtr>::iterator i;
    for (i=windowArray.begin(); i!=windowArray.end(); ++i)
    {
        //    ... Do something meaningful
    }

> If you were really a hardcore C++ STL jocky, you'd be using the algorithm libraries. But I have to confess, I hate those bloody generic algorithms. It's almost never worth the effort to figure out how to write a limited use *functor* or composite a function object.

Of course, you could bloat things out a bit by calling the iterator something like `windowIterator`. That would be more clear, but probably overkill. Developers understand loop variables.

## 7. Above All, Be Consistent ##

If you chose to start all your functions with uppercase letters, you'll probably be punished in the afterlife, but at least you should be consistent. Don't start some of your functions with lowercase letters and others with uppercase. Even if you think you've some clever scheme where lowercase denotes private or similar. Let the compiler be the final arbitrator of what's a private method. Furthermore, if you ever change your mind, you're stuck updating lots of code.