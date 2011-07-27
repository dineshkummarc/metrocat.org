---
layout: post
title: Declarative Syntax for Child Widgets
date: 2008-05-21
author: Jeff Watkins
categories:
- Coherent
---

One of my goals for Coherent 1.1 is the option of using a declarative syntax to set up child widgets. This would greatly simplify the average `init` method and make the code a bit clearer and easier to understand.
<!--more-->

Essentially, I'm thinking of something like the following:

    sample.MyWidget= Class.create(coherent.Widget, {

        init: function()
        {},

        title: TextWidget('div.header em', {

                    htmlKeyPath: '*.selection.title',

                    onclick: function(event)
                    {
                        ... handle clicking on the title ...
                    },

                    ... etc ...

                }),

        nextButton: Widget('div.controls button.next', {

                        onclick: function(event)
                        {
                            ... go to the next image ...
                        }

                    }),

        ... etc ...
    });

Just before calling `init`, the Widget framework should create sub-widgets for `title` and `nextButton`. For the `title`, its `html` binding would be connected to the key path `selection.title` from the outer widget. Additionally, a click handler would be created with the given method. The scope of the `onclick` method for `title` would be `MyWidget` rather than the actual `TextWidget`.

Using the new Selector library, you could create widgets based on any CSS query rather than just a direct descendant or ID. I don't think there's any need to have sub-widgets within the sub-widgets. If that's what you're looking for, you _probably_ want to look at creating a widget rather than declaring the structure.

To be backward compatible, the node specifier (`div.header em`) should be checked to see whether it is an ID. This means that `#foo` would be equivalent to simply `foo`. Because presently, Coherent allows you to specify the ID of the node as a string without the preceding hash. Perhaps I can generate a deprecation warning...

## Bindings and event handlers on sub-widgets ##

The second parameter to the widget declarations is how you may specify bindings for the sub-widget as well as events to handle. This hash should contain either key path entries (e.g. `htmlKeyPath`) or event handler entries (e.g. `onclick`). Essentially, after finding the node via a selector query, Coherent will enumerate the keys in this hash and for keys with a string value, call `setAttribute` on the node with the key and value. For keys with a function value, Coherent will observe the event of the same name as the key after stripping the `on` prefix (e.g. `onclick` &#x21D2; `click`).

This is roughly similar to how the [`setupNodeWithSelectors` method](/2008/05/selectors-and-bindings) works. So this seems like a reasonable approach.

## Changes to Coherent's OOP model ##

In order to make this work, I'd need to tweak Coherent's OOP model a bit. Essentially, JavaScript assigns special meaning to using a function as the target of the `new` operator. What I'd be doing it taking advantage of this to branch and execute different code depending on how the _constructor_ was invoked.

Instead of allowing the constructor to perform this double duty, what if Coherent shunted off non-constructor invocations of the constructor to a factory method? This factory method would be expected to return another function which could be invoked to create an instance of the class.

So consider the following class definition:

    sample.MyClass = Class.create({

        constructor: function(arg1, arg2)
        {
            this.prop1= arg1;
            this.prop2= arg2;
        },

        __factory__: function(arg2)
        {
            var klass= this;

            return function(arg1)
            {
                return new klass(arg1, arg2);
            }
        },

        // ... etc ...
    });

Because the factory method would be inherited by sub-classes, there will have to be some slight magic under the covers. Basically, Coherent will invoke the factory method in the scope of the class itself, therefore `this` will be equal to the class on which the factory method was invoked rather than the class on which the factory method was defined.

This allows you to write code like the following:

    var foo= sample.MyClass('abc');
    // ... later ...
    var bar= foo('def');

If a class doesn't define a `__factory__` member, I think Coherent should simply throw an Error. After all, you almost never get what you're expecting in that case.

There's no getting around the fact that writing a `__factory__` method will be something of a pain. But for the primary use of creating declarative sub-widgets, there need only be one factory on the base `Widget` class. All sub-classes of Widget will be able to use the default factory method, unless the sub-class has defined its own constructor with additional/different arguments.

Now all I need to do is code it...