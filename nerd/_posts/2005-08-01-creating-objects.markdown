---
layout: post
title: Creating Objects
date: 2005-08-01
author: Jeff Watkins
tags:
- Javascript
---

At some point, you'll tire of JavaScript's built in objects and want to create an object to call your own. This is what object-oriented programming is all about.
<!--more-->
There are three primary ways to create new types of objects:

1. Ad-hoc Composition
2. Literal Objects
3. Declaring a Constructor and using operator `new`

If you're familiar with other object-oriented languages, you may be tempted to dive directly into constructors and miss all the excitement.

#### Ad-hoc Composition ####

Perhaps the easiest way to create a new object is to build it as you go along. Consider the following code:

    var person= new Object();
    person.name= "Arnold J. Washington";
    person.emailAddress= "ajwashington@example.com";

This example creates a new object and specialises it with two additional properties: `name` and `emailAddress`.

This is probably not a technique you'll use every day, but it highlights an important feature of JavaScript: object are dynamic. You can add new properties and methods to any object at any time.

This is a concept with which programmers with experience using less dynamic languages like Java or C++ will probably be uncomfortable. In these static languages, objects don't change. If you have an object `foo` in C++, the value of `sizeof(foo)` will not change over the course of your program's execution. Likewise, without messing around with the class files, the number of fields returned from `foo.getClass().getDeclaredFields()` will never change.

An excellent example of how ad-hoc composition makes programming easier can be found in the client side of Web applications. Because we didn't create the HTML elements we must manipulate, we don't have the option of creating subclasses to extend their functionality. The solution C++ and Java programmers have adopted is to create a table that maps a reference to the element to a structure with additional information. Unfortunately, this creates problems when you want to efficiently manage the life-cycle of the additional data.

It's so much cleaner and easier simply to tack the additional data onto the actual object via ad-hoc composition. For example:

    var searchForm= document.getElementById();
    if (!searchForm)
        return;
    searchForm.originalDisplayStyle= searchForm.style.display;
    searchForm.hideElement= function ()
                            {
                                this.style.display="none";
                            };
    searchForm.displayElement= function ()
                               {
                                   this.style.display=this.originalDisplayStyle;
                               }
    searchForm.hideElement();

The previous example stashes the original value of the `display` attribute of the element's style in an ad-hoc property `originalDisplayStyle`. Then creates two methods, `hideElement` and `displayElement`. The `displayElement` restores the element's original display mode (either block or inline).

How would you do this in Java or C++? (It's not hard in Objective-C by the way.)

#### Literal Objects ####

All languages allow you to declare literal strings and numbers, but you might not expect that JavaScript allows you to declare a literal object. The syntax is a little strange, but you'll get accustomed to it quickly. Reproducing the person example from the previous section, we have:

    var person= {
                    name: "Arnold J. Washington",
                    emailAddress: "ajwashington@example.com"
                };

Other languages with associative arrays have similar constructs. So this sort of thing should be familiar if you write Perl or Python code.

A property can have any value, including a function. Let's expand the definition of the `person` object to include a first and last name property, and a method that computes the full name.

    var person= {
                    firstName: "Arnold",
                    lastName: "Washington",
                    emailAddress: "ajwashington@example.com",
                    getFullName: function ()
                        {
                            return this.firstName + " " + this.lastName;
                        }
                };

The definition of the `getFullName` method uses an anonymous function. According to the JavaScript specification, I could have specified a name, but not all browsers (Safari is one) preserve the name. So I usually don't bother.

I frequently use object literals when I'd like to return multiple values from a function or when I have *somewhat* static objects that I'd like to declare without the overhead of constructors.

#### Constructors ####

One drawback to both ad-hoc composition and literal objects is that they create Objects. That is, you don't get any default properties or methods other than those defined on the Object object (which are almost worthless). This is where a constructor comes to the rescue.

Some people will tell you that constructors add classes to JavaScript. But this isn't really true. By definition, JavaScript has no class. A constructor is merely a special function that stamps out new objects.

Like all methods, constructors have access to the special `this` variable. Except, unlike other methods, the `this` variable represents an entirely blank object. The only values it has are inherited from its prototype (more on this in a later Article).

Everyone has seen the clich&eacute; constructor for a circle:

    function Circle( x, y, radius )
    {
        this.x= x;
        this.y= y;
        this.radius= radius;
        
        this.computeArea= circle_computeArea;
        this.computeCircumference= circle_computeCircumference;
    }

	function circle_computeArea()
	{
		return Math.pi*this.radius*this.radius;
	}

	function circle_computeCircumference()
	{
		return 2*Math.pi*this.radius;
	}
	
This declares a constructor which stamps out Circle objects with X and Y coordinates for the center of the circle, a radius, and two methods, `computeArea` and `computeCircumference`. However, the drawback to this constructor is that it polutes the global namespace with two unnecessary functions: `circle_computeArea` and `circle_computeCircumference`.

A more advanced constructor hides the definition of the `computeArea` and `computeCircumference` functions within the constructor itself:

	function Circle( x, y, radius )
	{
		function computeArea()
		{
			return Math.pi*this.radius*this.radius;
		}
		
		function computeCircumference()
		{
			return 2*Math.pi*this.radius;
		}
		
		this.x= x;
		this.y= y;
		this.radius= radius;
		
		this.computeArea= computeArea;
		this.computeRadius= computeRadius;
	}

#### More To Come ####

There's a lot more that can be written about constructors and that doesn't even begin to cover prototypes. For example, did you know JavaScript can have both private methods and private properties?