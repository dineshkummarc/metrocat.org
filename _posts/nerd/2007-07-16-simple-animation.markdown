---
layout: post
title: Simple Animation
date: 2007-07-16
author: Jeff Watkins
categories:
- Featured
- Javascript
---

Most JavaScript libraries support some animation of one variety or another. Nothing new there. I'd like to share the animation framework I've been developing for my HTML Bindings library. It builds on some of the lessons I've learned about developing animations for the iPhone.


<!--more-->

All animations are essentially functions of time: Where is the object at a given time? What is the object's opacity at a given time? What is the object's size at a given time?

So consider the following definitions for animation factory functions to fade nodes in and out:

	nerd.fx.FadeIn= function(curve, node) {
		function animate(t) {
			node.setOpacity(curve(t));
		}
		animate.setup= function() {
			node.setOpacity(0);
			node.setDisplay='';
		}
		animate.finish= function(pos) {
			node.style.display= (pos?'':'none');
			node.setOpacity('');
		}
	
		return animate;
	}

	nerd.fx.FadeOut= function(curve, node) {
		function animate(t) {
			node.setOpacity(curve(1-t));
		}
		animate.setup= function() {
			node.style.display='';
			node.setOpacity(1);
		}
		animate.finish= function(pos) {
			node.style.display= (pos?'none':'');
			node.setOpacity('');
		}
	
		return animate;
	}

The factory functions (`FadeIn` or `FadeOut`) accept two arguments: `curve` and `node`. The `node` parameter is obvious, but the `curve` parameter might not be so obvious. When animating, it is often helpful to accelerate and decelerate smoothly to better simulate motion. The `curve` parameter is a function that fits the time values 0 through 1 to an acceleration curve and returns a value between 0 and 1. This is often called an easing function.

These examples take advantage of closures to return a function (`animate`) that actually performs the animation. The `animate` function is about as simple as you can possibly get: given a value between 0 (start) and 1 (finish), adjust the opacity of the node. Fortunately for this example, opacity also ranges between 0 and 1.

Additionally, each returned `animate` function has an optional `setup` and `finish` method. These methods allow the `Animator` to make certain the node or nodes are in the correct configuration before beginning. And in the case of the `finish` method for `FadeOut`, the node is hidden and its opacity is cleared. This leaves the node in a standard state.

### Get Animated ###

At this point, we have functions that will either fade in or fade out a node. All we need to do is step over the values between 0 and 1 and our nodes will fade like mad.

Let's take a look at a naive implementation:

	function animator(fn, duration) {
		var stepDuration= 1000/kFramesPerSecond;
		var now;
		var t;
		
		function animate() {
			now+= stepDuration;
			t= now/duration;
			
			if (t>1)
				t=1;

			fn(t);
			
			if (1==t) {
				if ('finish' in fn)
					fn.finish(t);
				return;
			}
			
			window.setTimeout(animate, stepDuration);
		}
		
		if ('setup' in fn)
			fn.setup();
		now= 0;
		window.setTimeout(animate, stepDuration);
	}

This animator function accepts an animation function (returned by one of the factory functions above) and a duration. It will invoke the animation function at a constant frame-per-second rate (I typically use 60 as my frames per second). For each invocation, it increments the current time (`now`) by the duration of the step (`stepDuration`) and converts that to a value between 0 and 1.

The inner animation function will never be called with the value 0, because the first thing `animate` does is increment `now` by the step duration. But the animation function will _always_ be called with the final value of 1. This is fine, because 0==t represents the initial state of the node (or _should_).

When the animation reaches the end (1==t), we call the `finish` method if one is defined, and terminate the animation by returning without resetting the timeout.

### Get Smart ###

The previous animator function was very naive. Why? Because it doesn't account for the speed of the machine performing the animation. If the delay between steps winds up being greater than the computed `stepDuration` value, your animation will lag. To see how this can be a problem, point your iPhone browser at the [online Apple store's iPhone Gallery page](http://store.apple.com/1-800-MY-APPLE/WebObjects/AppleStore.woa/wa/RSLID?nnmm=browse&tg_tabcontroller=tab5&mco=80BBAD87&node=home/iphone/iphone). The animations are very chunky, because the iPhone's JavaScript engine runs slower than the JavaScript engine on my MacBook Pro.

What we need is something that is responsive to the speed of the JavaScript engine. Consider this version of the animator function:

	function animator(fn, duration) {
		var stepDuration= 1000/kFramesPerSecond;
		var start;
		var now;
		var t;
		
		function animate() {
			now= (new Date()).getTime();
			t= (now-start)/duration;
			
			if (t>1)
				t=1;

			fn(t);
			
			if (1==t) {
				if ('finish' in fn)
					fn.finish(t);
				return;
			}
			
			window.setTimeout(animate, stepDuration);
		}
		
		if ('setup' in fn)
			fn.setup();
		start= (new Date()).getTime();
		window.setTimeout(animate, stepDuration);
	}

What's the difference? Well, for starters, we've got a new variable `start` which records the time at which the animation began. More importantly, rather than simply incrementing the time (`now+= stepDuration;`) we're actually determining the current time (`now= (new Date()).getTime();`). This is hugely important, because if your browser's JavaScript engine is slow, it might actually take longer than `stepDuration` milliseconds between each animation frame. This animator function will compensate for that by dropping frames.

### Get Fast ###

You may have been wondering why the animation functions are structured like they are. All animation functions follow the same structure:

	function AnimationType(curve, <other arguments>) {
		function animate(t) {
			//	do something clever
		}
		animator.setup = function() {
			//	set up the arguments for animation
		}
		animator.finish = function(pos) {
			//	finalise the animation, reset nodes to their original states
			//	when 0==pos or their final states when 1==pos.
		}
		
		return animator;
	}
	
Why didn't I use real JavaScript objects instead of returning a whacky function that has other functions attached to it? It's all about performance.

Remember back in the `animator` function how we call the `animate` method returned from the factory function: `fn(t)`. If we'd returned an object from the factory instead of a function, this call would have looked like the following instead: `animate.run(t)`. The problem is this would have required an additional property look up before calling the function. Of course, I could have pulled out the `run` function and called it via its `call` method. But why? The `animate` functions don't have any state. Why should they be objects.

### Get Clever ###

I can think of one last improvement for our `animator` function: playing multiple animations at the same time. Let's say you want to fade in an object while moving it from left to right, our current `animator` function would leave you cold.

You could create a factory function that combines several `animate` functions into a single `animate` function. But that's lame. Instead we'll accept an array of `animate` functions.

	function animator(actions, duration) {
		var stepDuration= 1000/kFramesPerSecond;
		var len= actions.length;
		var start;
		var now;
		var t;
		var i;
		var a;
		
		function finish() {
			for (i=0; i<len; ++i) {
				a= actions[i];
				if ('finish' in a)
					a.finish(t);
			}
		}
		
		function animate() {
			now= (new Date()).getTime();
			t= (now-start)/duration;
			
			if (t>1)
				t=1;

			for (i=0; i<len; ++i)
				actions[i](t);
			
			if (1==t) {
				finish();
				return;
			}
			
			window.setTimeout(animate, stepDuration);
		}
		
		for (i=0; i<len; ++i) {
			a= actions[i];
			if ('setup' in a)
				a.setup();
		}
		start= (new Date()).getTime();
		window.setTimeout(animate, stepDuration);
	}

This function will execute any number of `animate` functions. It does it _rather_ efficiently -- this is why it was critical to remove the extra property look up an object would have imposed.

This is why I didn't use either prototype's `Enumerable.each` or `Array.forEach`. Either one would have incurred considerable overhead. Prototype's `each` method would have imposed 3 additional function calls, while `forEach` imposes 2 additional function calls (although for FireFox and Safari 3 one of those calls would be to native code). For native code implementations of `forEach` it _might_ be worth the additional function call. Otherwise, there's no way it would be faster than an inline `for` loop.

### Get Going ###

Just a few thoughts on animation before I get around to writing about the joy of QuickTime. I haven't forgotten.