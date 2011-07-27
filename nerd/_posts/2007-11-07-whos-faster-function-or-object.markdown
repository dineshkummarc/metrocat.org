---
layout: post
title: Who's Faster  Function or Object
date: 2007-11-07
author: Jeff Watkins
categories:
- Javascript
---

A little while ago, I wrote about a [simple animation package](http://nerd.metrocat.org/2007/07/simple-animation) I was working on. I made the following wondrous claim:

> You may have been wondering why the animation functions are structured like they are. All animation functions follow the same structure:
> 
>     function AnimationType(curve, <other arguments>) {
>         function animate(t) {
>             //  do something clever
>         }
>         animator.setup = function() {
>             //  set up the arguments for animation
>         }
>         animator.finish = function(pos) {
>             //  finalise the animation, reset nodes to their original states
>             //  when 0==pos or their final states when 1==pos.
>         }
> 
>         return animator;
>     }
> 
> Why didn't I use real JavaScript objects instead of returning a whacky function that has other functions attached to it? It's all about performance.
> 
> Remember back in the animator function how we call the animate method returned from the factory function: fn(t). If we'd returned an object from the factory instead of a function, this call would have looked like the following instead: animate.run(t). The problem is this would have required an additional property look up before calling the function. Of course, I could have pulled out the run function and called it via its call method. But why? The animate functions don't have any state. Why should they be objects.

Of course, being bad nerd, I didn't back this claim up with any proof. Just today I happened to be rethinking this assertion, not because I thought I was wrong (just ask my wife, I never _think_ I'm wrong), but because I was wondering just _how_ much slower using objects might be.

As the framework has grown, it becomes more and more clear that using an object to specify the animation might make things more flexible. This would probably require some sort of pre-processing of the animation sequence, but that's not too much overhead. So just _how_ much slower is calling a method on an object than calling a function directly?

<table style="width:75%; margin:20px auto;">
<tr>
<th style="font-weight: bold; border-bottom: 1px solid #eee; text-align:left">Browser</th>
<th style="font-weight: bold; border-bottom: 1px solid #eee; text-align:right">Direct Function</th>
<th style="font-weight: bold; border-bottom: 1px solid #eee; text-align:right">Object Method</th>
</tr>

<tr>
<td style="padding-top: 5px;">Safari 3</td>
<td style="padding-top: 5px; text-align:right">135ms</td>
<td style="padding-top: 5px; text-align:right">134ms</td>
</tr>

<tr>
<td style="padding-top: 5px;">Firefox 2</td>
<td style="padding-top: 5px; text-align:right">555ms</td>
<td style="padding-top: 5px; text-align:right">361ms</td>
</tr>

<tr>
<td style="padding-top: 5px;">Firefox 1.5</td>
<td style="padding-top: 5px; text-align:right">561ms</td>
<td style="padding-top: 5px; text-align:right">366ms</td>
</tr>

<tr>
<td style="padding-top: 5px;">Internet Explorer 6</td>
<td style="padding-top: 5px; text-align:right">321ms</td>
<td style="padding-top: 5px; text-align:right">273ms</td>
</tr>

<tr>
<td style="padding-top: 5px;">Internet Explorer 7</td>
<td style="padding-top: 5px; text-align:right">350ms</td>
<td style="padding-top: 5px; text-align:right">291ms</td>
</tr>
</table>

This is pretty much the exact opposite of what I was expecting. Just take a look at the numbers:

<div class="figure">
<img src="http://nerd.metrocat.org/wp-content/uploads/2007/11/timing1.png" alt="timing.png" border="0"   >
</div>

That's just crazy. I never would have thought that calling a method would outperform calling a function directly. If anyone has any ideas why this might be the case, I'd love to know.

(Note: I'll upload my test file shortly.)
