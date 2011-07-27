---
layout: post
title: Javascript Has No Class
date: 2005-08-20
author: Jeff Watkins
categories:
- Javascript
---

Efforts underway for [JavaScript 2.0](http://www.mozilla.org/js/language/js20/ "JavaScript 2.0 from the Mozilla Foundation") (AKA [ECMAScript Edition 4](http://www.mozilla.org/js/language/es4/index.html "Netscape's proposal to ECMA for the next generation of JavaScript")) notwithstanding, JavaScript *doesn't* really have classes. Not classes like you're familiar with in Objective-C, C++, or Java.

Just because JavaScript doesn't support classes, doesn't mean you can't write really sophisticated object-oriented applications. You just have to understand the power of prototype inheritance and give up your fear that the other developers will look down on you because you're classless.
<!--more-->
Prototypes are an alternate form of inheritance that is every bit as powerful as classes, but not nearly as popular. Frequently developers who are only familiar with languages like C++, Java, or SmallTalk may look down on prototype inheritance. But the paradigm is *Object*-Oriented Programming, not *Class*-Oriented Programming.

## What's a Prototype ##

Well, duh. Outside of programming circles this is obvious:

> <big>pro&bull;to&bull;type |&#712;pr&#333;t&#601;&#716;t&#299;p |</big> noun

> a first or preliminary model of something, esp. a machine, from which
other forms are developed or copied : *the firm is testing a
prototype of the weapon.*

> 1. a typical example of something : *the prototype of all careerists
is Judas.*

> 2. the archetypal example of a class of living organisms,
astronomical objects, or other items : *these objects are the
prototypes of a category of rapidly spinning neutron stars.*

> 3. a building, vehicle, or other object that acts as a pattern for a
full-scale model.

(Definition from the [New Oxford American Dictionary](http://en.wikipedia.org/wiki/New_Oxford_American_Dictionary))

In Javascript, any object can serve as a prototype for another object. Really, this is important: a prototype is just an ordinary object.

If you've read [What's an Object](http://metrocat.org/nerd/2005/07/31/whats-an-object) you already know that objects are really associative arrays. In addition to all their other properties, objects have a special property, `prototype`, which works to provide inheritance in Javascript.

Hence, in Javascript the prototype is the pattern for the real object.

## Assigning a Prototype ##

You can't actually assign a value to the prototype property of an object, instead, you set a prototype as part of an object constructor function. Consider the following example:

	function Cat( name, age )
	{
		this.name= name;
		this.age= age;
	}
	Cat.prototype= new Object;

	var augustus = new Cat( "Augustus", 4 );
	
The constructor here is pretty obvious, however, the line immediately following the constructor is where the trick occurs. Although, you can't assign a value to the prototype property of an existing object, you can (seemingly) create a prototype property for a constructor (which is itself an object, so this syntax can be a little bit confusing). When I create a new Cat object, `augustus`, using this constructor, the new object's `prototype` property will have a reference to the same Object instance as every other Cat object.

## What Good Is A Prototype ##

Whenever you access either a property or a method of an object, Javascript first attempts to resolve the property or method directly on the object. If the object doesn't have a property or method with the name you've specified, Javascript will next look on the object's prototype object. Therefore, any properties and methods of an object's prototype *appear* to be properties and methods of the object itself.

Javascript keeps following the prototype chain until it finds the property or method or until the prototype is `null`.

This allows developers to share properties and methods between multiple instances of an object. If I expand the Cat definition to include shared properties, all Cat objects will have these properties. For example:

	Function Cat( name, age )
	{
		this.name= name;
		this.age= age;
	}
	Cat.prototype= new Object;
	Cat.prototype.species= "Felis silvestris";
	Cat.prototype.toString= function ()
		{
			return "[Cat name='" + this.name + "']";
		}

	var augustus= new Cat( "Augustus", 4 );
	var madeline= new Cat( "Madeline", 4 );
	
In the previous example, I've defined two properties on the Cat prototype object: `species` and `toString`. The `toString` property contains a method. It's always useful to declare a `toString` method for your objects. If nothing else, it helps when you're debugging. The `species` property declares the species of the Cat, [Felis silvestris](http://en.wikipedia.org/wiki/Wild_Cat).

If we were to ask the `augustus` object what its `species` property contains, we'd get the string `Felis silvestris`. If we asked the `madeline` object, we'd not only get the same answer, we'd get the exact same object (although there's no way in Javascript to test whether you have the same object, only whether objects are equivalent).

This is different from the `name` and `age` properties. Even if we use the same string for the `name`, we'll still have two instances of the name.

## Inheritence Chain ##

Of course, nothing stops you from building a deep inheritence hierarchy.

	function Felis( name, age )
	{
		this.name= name;
		this.age= age;
	}
	Felis.prototype= new Object;
	Felis.prototype.family= "Felidae";
	Felis.prototype.genus= "Felis";
	
	function Silvestris( name, age )
	{
		Felis.call( this, name, age );
	}
	Silvestris.prototype= new Felis;
	Silvestris.prototype.species= "silvestris";
	Silvestris.prototype.commonName= "wild cat";
	
	function Catus( name, age )
	{
		Silvestris.call( name, age );
	}
	Catus.prototype= new Silvestris;
	Catus.prototype.subspecies= "catus";
	Catus.prototype.commonName= "domestic cat";
	
	var augustus= new Catus( "Augustus", 4 );
	
There are two interesting things to note in this example. The first is the use of the prototype object's constructor and the second is the redefinition of the `commonName` property on the Silvestris and Catus prototypes.

> I plan to write an entire article on the wonders of the `call` method for functions at a later date. However, the short explanation is that `call` allows you to make believe a function is a method of the object passed as the first argument. The function is called with the remaining arguments, and within the function the `this` operator refers to the first argument to `call`.

Because each Silvestris object is also a Felis object, we need to set up all the properties of Felis each time we create a Silvestris. We could simply copy and paste the code, but an easier approach is to invoke the Felis constructor for the new object. We pass it the same arguments sent to the Silvestris constructor (although we could pass anything, like a computed value). In the Catus constructor we call the Silvestris constructor, because there's a little wild cat in every house cat.

The second interesting aspect of this example is I've added a `commonName` property to the prototype of both Silvestris and Catus. This means there's actually two different properties.

	augustus.commonName => "domestic cat"
	augustus.prototype.commonName => "domestic cat"
	augustus.prototype.prototype.commonName => "wild cat"
	
The `commonName` property on Silvestris is still there, but it's hidden by the `commonName` property on Catus. This is exactly what happened when I defined a `toString` method for Cat earlier. The default `toString` method of Object is still there, but when you ask for the `toString` method, Javascript finds the version on the Cat prototype and stops looking before finding the method on Object.

## A Difference In Style Makes A Difference in Memory ##

Consider the two constructors below. The first creates a method and assigns it within the constructor while the second creates a method and assigns it to the prototype.

	function MethodInConstructor()
	{
		this.someMethod= function () { return "a method"; }
	}
	
	function MethodInPrototype()
	{
	}
	MethodInPrototype.prototype= new Object;
	MethodInPrototype.prototype.someMethod= function () { return "a method"; }

If I were to create two instances of the MethodInConstructor object, `c1` and `c2`, they would each receive a unique function for their `someMethod` method.

	var c1= new MethodInConstructor();
	var c2= new MethodInConstructor();

	trace( "c1.someMethod==c2.someMethod: " +
		   (c1.someMethod==c2.someMethod) );

This yields:

	c1.someMethod==c2.someMethod: false
	
On the other hand, if I create two instances of the MethodInPrototype object, `p1` and `p2`, they share the same function for their `someMethod` method.

	var p1= new MethodInPrototype();
	var p2= new MethodInPrototype();

	trace( "p1.someMethod==p2.someMethod: " +
		   (p1.someMethod==p2.someMethod) );

This yields:

	p1.someMethod==p2.someMethod: true

Personally, I like defining my methods within the constructor. But from a memory efficiency standpoint, I probably shouldn't. I hadn't really thought about it that much until writing this article. Maybe I'll revisit some of the library code and revise it.