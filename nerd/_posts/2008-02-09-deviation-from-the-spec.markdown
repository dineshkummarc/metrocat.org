---
layout: post
title: Deviation from the Spec
date: 2008-02-09
author: Jeff Watkins
categories:
- Coherent
---

As I'm writing the documentation for various parts of the library, I've come across several places where I'm not adhering to the Cocoa spec exactly. In some cases, I think my implementation makes better sense for JavaScript. But in others, it's clear in hind sight why Apple chose to design the API the way it did.
<!--more-->

### Deviant arrays ###

A good example of the differences between JavaScript and Cocoa can be seen with how the two environments handle arrays. In Cocoa, arrays are separated in the mutable and immutable instances, while, in JavaScript we only have mutable arrays. Additionally, in Cocoa, all access to arrays is via messages like `objectAtIndex:` and `insertObject:atIndex:`. In JavaScript, access to array elements is not constrained to methods we can override; developers can use direct element access to change the contents of the array without letting us know. Furthermore, you can't reliably create a subclass of JavaScript's Array.

In Cocoa, it makes good sense to keep change notifications out of NSMutableArray, because it maximises speed and efficiency. For convenience, you can ask an object for a mutable array that fires KVO change notifications by calling `mutableArrayValueForKey:`. Any changes you make to the array returned will be passed to observers of the array. In Coherent, I chose to extend the Array protoype with additional methods (like `objectsAtIndexes` and `insertObjectAtIndex`) patterned after the similar named methods of NSArray and NSMutableArray, however, because JavaScript lacks the ability to make a subclass of its Array and developers are free to access elements without calling methods, I chose to have the extended methods trigger KVO change notifications directly. The following code will fire two change notifications: one for removing the element and a second for inserting two elements.

	var images= this.images();
	images.removeObjectAtIndex(5);
	images.insertObjectsAtIndexes([image1, image2], [2,5]);

In Cocoa the equivalent code would be:

    NSMutableArray* images= self.images;
    NSMutableIndexSet* indexes= [NSMutableIndexSet indexSetWithIndex:2];
    [indexes addIndex:5];
    [images removeObjectAtIndex:5];
    [images insertObjects:[NSArray arrayWithObjects: image1, image2, nil]
                atIndexes:indexes];

(Of course, there may be an easier way to do this, but it mimics the call used on the JavaScript side.)

### To throw, or not to throw ###

One more deviation I've noticed surrounds what to do when `valueForKey` encounters a missing property. In Cocoa, the documentation for `valueForKey:` states:

> If neither an accessor method nor an instance variable is found, the default implementation invokes `valueForUndefinedKey:`.

The default implementation of `valueForUndefinedKey:` throws an `NSUndefinedKeyException`. In Coherent, calling `valueForKey` with a key that does not specify either an accessor or instance property simply returns `undefined`. There is no `valueForUndefinedKey` method. There is no exception, because I figured that in JavaScript there's no guarantee that the next time you look the property won't exist.

But I think I've implemented this wrong. As a result of my decision there is no distinction between a missing property and a missing value.

On the other hand, Cocoa makes no distinction between a null value caused by an object not having a value for a particular key and a null value caused by an ancestor being AWOL along a key path. Let me illustrated this with some example code:

#### Foo.h ####

	@interface Foo : NSObject
	{
		Bar* bar;
	}

	@property (readwrite, assign) Bar* bar;
	@end

#### Bar.h ####

	@interface Bar : NSObject
	{
		NSString* name;
	}

	@property (readwrite, copy) NSString* name;
	@end

#### Foo.m ####

	@implementation Foo
	@synthesize bar;

	-(id)init
	{
		if (![super init])
			return nil;
		bar= nil;
	}

Perhaps you already see where I'm going with this: if you have an NSTextField in your UI and its value is bound to `Foo.bar.name` (where `Foo` is an instance of the Foo class created in Interface Builder) there is no way to distinguish between the Foo missing a Bar object and the Bar object not having a name value. The only clue the user gets is that things don't update correctly.

Coherent makes a distinction between a missing leaf and a missing branch in the object graph. JavaScript conveniently has two values which basically mean "nothing": `null` and `undefined`. So if an object is missing along the object graph, `valueForKeyPath` returns `undefined` rather than `null`. Widgets like `InputWidget` key off this value and completely disable the input control, because there's no reason to allow editing -- the value won't go anywhere.

While I _really_ like this behaviour, I'm very uncomfortable with making a distinction between `null` and `undefined`. It just seems wrong.