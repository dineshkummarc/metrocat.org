---
layout: post
title: Debugging JavaScript Applications  Inspecting Objects
date: 2005-08-03
author: Jeff Watkins
tags:
- Javascript
---

If you're like me, your JavaScript objects can get pretty complex. It can be a real drag to write separate trace statements for lots of different properties. I find it very convenient to be able to dump an object's representation out to the trace *window*.
<!--more-->
Attached to this article you'll find an updated version of the debugging library. This copy includes the `toLiteral` function which will convert any value into its JavaScript literal version. This allows you to write code like the following:

	function Cat( name, age, numberOfLivesRemaining )
	{
		this.name= name;
		this.age= age;
		this.numberOfLivesRemaining= numberOfLivesRemaining || 9;
	}

	function somethingClever()
	{
		var oneCat= new Cat( "augustus", 4 );

		trace( "oneCat=" + toLiteral(oneCat) );
	}

when you call `somethingClever` the following will be added to the log:

	oneCat={ name: "augustus", age: 4, numberOfLivesRemaining: 9 }

For the debugging library, functions are omitted from the literal versions of objects, because they seldom change and are seldom what you're interested in when you're debugging.

#### Requirements ####

Like the previous version of the debugging library, this version requires you to create a `pre` element with the id "trace".

downloadUrl=debugging2.zip
type=zip
download=Expanded JavaScript Debugging Functions