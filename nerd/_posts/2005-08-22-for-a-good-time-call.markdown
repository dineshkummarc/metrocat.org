---
layout: post
title: For a Good Time, Call
date: 2005-08-22
author: Jeff Watkins
tags:
- Javascript
---

One of the more interesting methods of the Function object is `call`. This allows you to invoke a function. "Oh Joy!" I hear you exclaim, "Now I can invoke functions!"

Yes, yes, nobody likes a Smart Ass more than me, but this really *is* interesting. You'll see...
<!--more-->
#### Functions Are Objects Too ####

Before explaining the `call` method of the Function object, it might make some sense to explain that in Javascript, functions are objects just like everything else. When you write the following code:

	function meaninglessValue()
	{
		return 2;
	}
	
This is semantically the same as writing:

	var meaninglessValue = new Function( "return 2;" );
	
So you've created a global variable containing a reference to a function object. Javascript makes your life easier by allowing you to execute any variable or object property via the *function* operator (parenthesis surrounding parameters).

Because functions are objects, they have properties and methods -- just like other objects. The most interesting property of a function is the `arguments` property (from which you can construct a stack trace if you're not running Safari using the `caller` property of `arguments`). I think the `call` method is the most interesting method of the function object.

#### Every Function Is A Method ####

Every function is a method and has access to the `this` operator. In a global function, the `this` operator refers to the Global object (hence the global in global function). The Global object is where functions like `eval`, `parseInt`, and `parseFloat` are defined. And of course, where all your global functions are defined.

So every function has access to `this`. In other languages like C++ and Java, the value of the `this` operator is passed as a hidden parameter (parameter 0 in C++). I'm not certain how Javascript implements this, and it really isn't important, but the `this` operator is passed along in some hidden fashion.

	function fullName()
	{
		return this.firstName + " " + this.lastName;
	}
	
	obj1.fullName= fullName;
	obj2.fullName= fullName;
	
In the code above, there's nothing about the implementation of `fullName` connecting it to the two objects. Provided both objects have `firstName` and `lastName` properties, `fullName` will execute without error.

#### Calling a Function Sets the `this` Object ####

The first parameter of the `call` method is an object which will be the value returned by the `this` operator in the function.

	function fullName()
	{
		return this.firstName + " " + this.lastName;
	}
	
	var obj3= { firstName: "Jeff", lastName: "Watkins" };
	
	var name= fullName.call( obj3 );
	
In this example, the `obj3` object will be returned by the `this` operator inside the `fullName` function. It's almost as if `fullName` were a method of `obj3` for the duration of the call.

You can pass additional parameters to call; each parameter will be passed in turn to the function.

#### What Good Is It? ####

You may well ask why the `call` method is important. When used in the key-value library, it allows me to extend objects with additional methods (in this case, event handlers) without poluting the namespace of the object. The observer list is a good example. Using the `call` method allows me to add behaviour specific to the keyPath I'm observing, when this behaviour may not be used in any other place. Because the function isn't made a method of the observing object, noone else can call it with potentially incorrect parameters. Only the observed object has access to this hidden function.

	function ValueBinding( element, source, keyPath )
	{
		function observeChangeForKeyPath( change, keyPath )
		{
			//	hidden method can manipulate the ValueBinding
		}
		
		source.addObserverForKeyPath( source, keyPath,
									  observeChangeForKeyPath );
	}
	
	var valueBindingExample= new ValueBinding( someSpan, globalState,
											   "selectedPerson.fullName" );
											   
The example above creates a new `ValueBinding` object which registers for change notifications using a *hidden* method, `observeChangeForKeyPath`. Noone can call this *hidden* method (because it's hidden), but the observed object, `source`, has been given a reference to it for the purpose of the change notification.

Deep inside the guts of the key-value observing code, you'll find the following line:

	this.callback.call( this.observer, changeNotification, keyPath,
						this.context );

This code is nestled deep in the implementation of an object used to keep track of each observer for a key path. Notice, the first parameter, `this.observer`, will be the object returned by the `this` operator in the callback method.

#### Dynamic Objects Means You'll Never Know What They'll Do Next ####

Javascript is an incredibly dynamic language. By combining `eval` with creating functions and methods on the fly, you can develop extremely flexible solutions. It's precisely this flexibility that makes code like the key-value library and ultimately the DHTML bindings library viable.