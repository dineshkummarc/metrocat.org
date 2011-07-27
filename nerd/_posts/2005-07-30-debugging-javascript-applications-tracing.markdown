---
layout: post
title: Debugging JavaScript Applications  Tracing
date: 2005-07-30
author: Jeff Watkins
categories:
- Javascript
---

Displaying trace messages has always been an integral part of writing Web applications whether back in the days of C++ CGIs or today writing Java Servlets. Cracking open the debugger to step through your application just never seems to be as effective as the classic printf statement.

As we write more and more complex Web applications taking advantage of XMLHttpRequest, it's imperitive that our debugging tools advance along with our other tools.
<!--more-->
When I first started writing Web applications a decade ago (I had a pet dinosaur too), we couldn't be certain whether visitors would even have a browser that included JavaScript, much less enabled. The very first page of our application had a hidden field which would be populated by a submit handler on the form to indicate whether the visitor had JavaScript enabled. And all that meant is we could do the tiniest bit of helpful scripting: setting the focus to the correct field, button roll-over highlighting, and other small stuff.

Today every browser supports JavaScript and statistics indicate over 95% of all visitors have JavaScript enabled. Companies like [Google][] and [37 Signals][] have based entire products around JavaScript and dynamic HTML. Facilities like XMLHttpRequest have rekindled the excitement surrounding Web applications again. And everyone seems to be learning how to use JavaScript.

Unfortunately, most browsers provide astoundingly poor support for debugging JavaScript. I'll lump Mozilla into this category as well, because although there is a *debugger* for Mozilla, it is slow, clunky and extremely difficult to use. My favourite browser, Apple's Safari, is especially poor when it comes to debugging: it won't even tell you where in an included script file an error occurred. That's just lame.

Much as I love to criticise Microsoft, they are the only browser provider with a credible debugger -- although their stand-alone debugger hasn't been updated in years. If you have an installation of Visual Studio, you have a credible JavaScript debugger. It's clunky because it's shoehorned into the wacky Visual Studio environment, but it does work.

Both Apple and the Mozilla crew would do well to emulate Microsoft by releasing a debugger for their browsers. Apple already has a substantial lead over the Mozilla team because they have an incredible development environment available for free download. I don't know how difficult it would be to integrate Xcode and Safari, but someone should be looking into it. Mozilla should probably look into a plug-in for Eclipse to realise their goal of cross-platform support.

## Debugging Without A Debugger ##

If you're like me and don't have a JavaScript debugger at your disposal, you can still take advantage of some of JavaScript's inherent power to make your life easier. Even if you do have a debugger (you're forced to target legacy, non-compliant browsers like Internet Explorer), you may find it more productive to simply instrument your code with trace statements.

Unlike working with a debugger, code instrumentation doesn't allow you to inspect the state of your application adhoc, but when things aren't quite working the way you expect, tracing can give you a great deal of insight into the behaviour of your application. And because code with tracing runs only a little slower than code without tracing and considerably faster than single-stepping through code in the debugger, tracing is a valuable development tool whether you have a debugger at your disposal or not.

## Tracing in HTML Applications ##

Attached to this article you'll find a JavaScript file containing a basic trace function. This function will display its arguments to a div with the ID "trace". You can use the `trace` function like so:

	function sampleFunction( arg1 )
	{
		trace( "arg1=" + arg1 );
		// ...
	}

	sampleFunction( 1 );

On all browsers except Safari (woe is me), this will display the following in the trace div:

	sampleFunction: arg1=1

Safari can't figure out the name of the calling function, so it only displays:

	arg1=1

I've also included a function that will display all arguments passed to the function, `traceArgs`. You would use `traceArgs` like this:

	function animateElement( targetElementId, destinationLeft, destinationTop,
							 numberOfSteps, completeCallback )
	{
		traceArgs();
		//	...
	}

	animateElement( "searchForm", 0, 0, 5, searchFormMadeVisible );

This works for all browsers other than Safari (there is a workaround for Safari however), and will display the following:

	animateElement: targetElementId="searchForm",
					destinationLeft= 0,
					destinationTop= 0,
					numberOfSteps= 5,
					completeCallback= [Function searchFormMadeVisible]

Safari users should pass the *magical* `arguments` object to `traceArgs` and everything will work just fine.

## What's Next? ##

In future articles, I'll add to these meager debugging tools with a function that converts JavaScript objects into their literal string representations as well as some code timing and coverage functions.

Stay tuned.

[Google]: http://www.google.com/ "Makers of GMail"
[37 Signals]: http://www.37signals.com/ "Makers of Basecamp, Backpack, and Ta-da List"

downloadUrl=debugging1.zip
type=zip
download=Basic JavaScript Debugging Functions