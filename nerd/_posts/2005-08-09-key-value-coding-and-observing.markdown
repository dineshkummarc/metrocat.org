---
layout: post
title: Key-Value Coding and Observing
date: 2005-08-09
author: Jeff Watkins
categories:
- Javascript
---

Those of you who have explored Apple's Cocoa technologies are probably already familiar with the second greatest advancement in UI programming I've seen in my 18+ years of writing software: [Key-Value Coding](http://developer.apple.com/documentation/Cocoa/Conceptual/KeyValueCoding/index.html) and [Observing](http://developer.apple.com/documentation/Cocoa/Conceptual/KeyValueObserving/index.html).

This technology is built into Apple's Objective-C runtime and forms the foundation of the greatest advancement in UI programming: [Cocoa Bindings](http://developer.apple.com/documentation/Cocoa/Conceptual/CocoaBindings/index.html).

I've heard Cocoa developers bemoan the lack of Cocoa Bindings as they branch out into the world of Web programming. Well, Key-Value Coding and Observing is the first step on the road to delivering DHTML Bindings.
<!--more-->
## Good To Have A Goal ##

I've set myself the goal of implementing the core functionality behind Cocoa Bindings in JavaScript. This isn't an easy task, because unlike Apple, I don't control the runtime library. I have to work within the scope of the JavaScript language.

In Objective-C there is no way to access an object's properties (known as ivars). You must use accessor and mutator methods. So your class might be declared as follows:

	@interface Cat : NSObject
	{
		NSString* _name;
	}
	
	- (id) initWithName: (NSString*) name;
	
	- (NSString*) name;
	- (void) setName: (NSString*) name;
	
	@end

> This isn't meant to be a tutorial on Objective-C -- you either already know it and are super-productive or you're resisting becoming super-productive (like I did for 2 years).

In Objective-C, only the Cat object's methods can actually access the `_name` member variable. Everyone else must use the `name` accessor or `setName:` mutator.

In JavaScript, while we *can* write accessors and mutators, there's no preventing someone from directly accessing a property on our objects (Well, no commonly known way. More on that later.) We could write a constructor for a Cat object in JavaScript as follows:

	function Cat( name )
	{
		this.name= name;
		this.getName= function () { return this.name; }
		this.setName= function (name) { this.name= name; };
	}
	
Allowing for differences in language syntax, this gives us roughly the same functionality as the accessors and mutators in Objective-C. Of course, in this example, the accessor and mutator are completely useless.

## A Brief Overview of Key-Value Coding ##

Key-Value Coding is an informal protocol which defines how to access an object's properties using textual names rather than hard-coded calls to accessors and mutators. For example, to access a Cat's name in Objective-C, I would type:

	//	Assume myCat is a previously instantiated Cat object
	NSString* nameOfMyCat= [myCat name];
	//	Give myCat a new name
	[myCat setName: @"Augustus"];
	
Using Key-Value Coding, I would have the following code:

	//	Retrieve the name from a previously instantiated Cat object
	NSString* nameOfMyCat= [myCat valueForKey: @"name"];
	//	Give myCat a new name
	[myCat setValue: @"Augustus" forKey: @"name"];
	
Not a huge difference. But what if you want to access the value of a property nested 3 objects deep? So, how about getting the age of the mother of Augustus' first kill? Without Key-Value Coding, this would be:

	//	Assuming a lot more meat to the Cat class and a Mouse class.
	int firstKillsMomsAge= [[[myCat firstKill] mother] age];

I'll agree, that isn't super ungainly. But with Key-Value Coding, it becomes:

	int firstKillsMomsAge= [myCat valueForKeyPath: "firstKill.mother.age"];

That's actually more typing. Yow! Why would anyone want to *use* Key-Value Coding?

## Observing Other Objects ##

Key-Value Coding is simply essential if you want to tie two objects together without those object having prior knowledge of the structure of each other: the glorious goal of loosely-coupled design.

This is where Key-Value Observing enters the picture. With a few lines of code, I can wire up two objects so that one responds to the property changes of another:

	[myCat addObserver: self forKeyPath: @"name"
		   options: NSKeyValueObservingOptionNew context: NULL];

Now, whenever `myCat's` `name` property changes, I'll be notified.

You can read Apple's documentation on [Key-Value Coding](http://developer.apple.com/documentation/Cocoa/Conceptual/KeyValueCoding/index.html) and [Observing](http://developer.apple.com/documentation/Cocoa/Conceptual/KeyValueObserving/index.html) at you're leasure. I'm interested in applying this to JavaScript.

## Key-Value Coding in JavaScript ##

Because I also write Mac software, I've tried to keep the API of Key-Value Coding as similar to the Objective-C version as JavaScript will allow. So consider the following:

	var myCat= new Cat( "Augustus" );
	var nameOfMyCat= myCat.getValueForKey( "name" );
	myCat.setValueForKey( "Madeline", "name" );
	
Like the Objective-C version of Key-Value Coding, you can slice Arrays too. Let's expand the definition of a Cat to see how this works:

	function Cat( name )
	{
		this.name= name;
		this.siblings= [];
	}
	
	var myCat= new Cat( "Augustus" );
	myCat.setValueForKey( [ new Cat("Tim"), new Cat("Magic"),
							new Cat("Madeline") ] );
	//	now "slice" the sibling array
	var namesOfSiblings= myCat.getValueForKeyPath( "siblings.name" );
	
The `namesOfSiblings` variable will now contain an array with the values: "Tim", "Magic", and "Madeline". To make this work, the Array object defines its own `getValueForKeyPath` and `getValueForKey` that return as an array the result of querying each element of the array for the same key or key path.

## Observing in JavaScript ##

Observing property changes in JavaScript is a little different than in Objective-C. In part because JavaScript gives us some nice additional features and also because I simply didn't need all the features of the Objective-C implementation.

	//	using the Cat definitions from above
	function CatObserver( cat )
	{
		function observeSiblingNameChangeForKeyPath( change, keyPath )
		{
			trace( "received change=" + change );
			trace( "    for keyPath=" + keyPath );
		}
	
		cat.addObserverForKeyPath( this, "siblings.name",
								   observeSiblingNameChangeForKeyPath, null );
	}
	
This declares a constructor for `CatObserver` objects which will report changes to the names of a cat's siblings.

### Structure of the ChangeNotification Object ###

The ChangeNotification has the following properties:

* **`changeType`** -- this property describes the type of change and can have one of the following values:
 * **`ChangeType.setting`** -- the value of the key path has changed. If the key path represents an array, this type is only used when the entire array value has changed.
 * **`ChangeType.insertion`** -- new values have been inserted into an array. The `newValue` property contains an array of the new elements and the `indexes` property contains the indexes at which those new elements were inserted.
 * **`ChangeType.deletion`** -- elements have been removed from the array. The `oldValue` property will contain the elements that were removed, and the `indexes` property will contain the locations of the elements.
 * **`ChangeType.replacement`** -- the value of an element or elements in the array has changed. The `newValue` property specifies the new element values and the `indexes` property specifies where those elements are.

* **`newValue`** -- the new value of the property associated with `keyPath`. If the property is an array, this will be an array containing the element or elements that have changed.

* **`oldValue`** -- the previous value of the property (if known). If the property is an array, this will be an array containing the previous values of the element or elements that have changed.

* **`indexes`** -- when `changeType` is either `insertion`, `deletion`, or `replacement` this property will contain an array of the indexes of the elements that have been inserted, deleted, or replaced. When `changeType` is `setting` this property is undefined.

* **`object`** -- a reference to the object that has changed. Should always be the same object on which `addObserverForKeyPath` was called.

Conveniently, the `ChangeNotification` object defines a `toString` method which will display the basics of the change notification.

## Problems with JavaScript ##

The JavaScript implementation of Key-Value Coding & Observing has one flaw, you can always access a property directly. And when you directly set a value for a property, I have no way of knowing it has changed.

Mozilla's latest JavaScript engine implements `getter` and `setter` methods for properties, but that doesn't really help. What I really want is the old `watch` method of the `Object` object. But that was only ever supported in Netscape (and possibly Mozilla). It was never supported by Microsoft Internet Explorer (or their JavaScript Windows Scripting Host). And I doubt it's supported in Safari.

This means you either have to exclusively use the key-value coding methods (`getValueForKeyPath` and `setValueForKeyPath`) or send the notifications yourself. Fortunately, you *can* send the notifications yourself.

Imagine we have the following code:

	function Cat( name, age )
	{
		function celebrateBirthday()
		{
			this.willChangeValueForKey( "age" );
			this.age++;
			this.didChangeValueForKey( "age" );
		}
		
		this.name= name;
		this.age= age;
	}
	
I've bracketted the modification of the age property with calls to `willChangeValueForKey` and `didChangeValueForKey`. I bet you can figure out what they do.

When you call `willChangeValueForKey`, the key-value coding implementation caches the previous value of the key. Later when you call `didChangeValueForKey`, it uses this cached value to notify all observers. Clean and simple.

## Dependant Properties ##

Sometimes a property is computed from the values of other properties. This is a *dependant* property, and key-value observing supports this just fine:

	function Person( firstName, lastName )
	{
		function getFullName()
		{
			if (this.firstName && this.lastName)
				return this.firstName + " " + this.lastName;
			else
				return this.firstName || this.lastName;
		}
		
		this.firstName= firstName;
		this.lastName= lastName;
		
		this.setKeysTriggerChangeNotificationForDependantKey( ["firstName",
															   "lastName"],
															  "fullName" );
	}
	
This constructor for a basic `Person` object declares in its final line that changes to either the `firstName` or `lastName` property should also notify any observers of the `fullName` property.

**Note:** the `fullName` property is read-only here, because I've declared an accessor but no mutator. Later when we look at DHTML Bindings, you'll see why that is important. For now, if you try to set a value for the `fullName` property, you'll get an exception.

## Code Coming Soon ##

The JavaScript code that implements Key-Value Coding and Key-Value Observing is nearly complete. I want to clean it up a bit more, add real support for Arrays, and write a couple examples. Expect it before the end of the week...