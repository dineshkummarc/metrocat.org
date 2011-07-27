---
layout: post
title: Pitting JavaScript Against Objective-C
date: 2008-02-11
author: Jeff Watkins
categories:
- Coherent
---

In many ways, the API of Coherent is drawn from various Cocoa APIs: [NSKeyValueCoding](http://developer.apple.com/documentation/Cocoa/Reference/Foundation/Protocols/NSKeyValueCoding_Protocol/Reference/Reference.html), [NSKeyValueObserving](http://developer.apple.com/documentation/Cocoa/Reference/Foundation/Protocols/NSKeyValueObserving_Protocol/index.html), [NSKeyValueBindingCreation](http://developer.apple.com/documentation/Cocoa/Reference/ApplicationKit/Protocols/NSKeyValueBindingCreation_Protocol/Reference/Reference.html), [NSArrayController](http://developer.apple.com/documentation/Cocoa/Reference/ApplicationKit/Classes/NSArrayController_Class/Reference/Reference.html) and others. Of course, some allowances have to be made for the syntax differences between Objective-C and JavaScript. So methods like `setValue: forKey:` from `NSKeyValueCoding` become `setValueForKey` on `coherent.KVO`. But where possible, I've tried to adhere to the same or similar API.

I'm not certain that's such a great idea. After all, the target market for Coherent is _JavaScript_ programmers not Objective-C programmers. So just how important is it to mimic the API that Objective-C programmers will feel comfortable with?

## Getters & Setters ##

In Cocoa, classes declare getters and setters to access instance properties. The property getter is named the same as property, while the setter is prefixed with `set`. You might have the following code to access the name property of a class:

	-(NSString*) name;
	-(void) setName: (NSString*)newName;

These methods are invoked as follows:

	NSString* theName= [someObject name];
	[someObject setName: aNewName];

On the other hand, the idiom in JavaScript is to mimic the Java Beans style of getter and setter methods: the getter is prefixed with `get` and the setter with `set`. The same code might be written in JavaScript as:

	getName: function()
	{
		...
	},

	setName: function()
	{
		...
	}

(Presuming this is inside an Object literal...) And these methods would be invoked as follows:

	var theName= someObject.getName();
	someObject.setName(aNewName);

Prior to r146, Coherent required getters to follow the Objective-C idiom. However, now Coherent will check first for a getter with the `get` prefix before looking for a getter with the same name as the property.

Ultimately, it would be nice if every browser supported JavaScript properties, but until Microsoft catches up with FireFox and Safari, we'll have to make do with explicit getters & setters.