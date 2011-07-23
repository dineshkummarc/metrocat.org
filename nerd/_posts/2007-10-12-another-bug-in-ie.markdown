---
layout: post
title: Another Bug in IE
date: 2007-10-12
author: Jeff Watkins
tags:
- Uncategorized
---

So imagine you've got this image of two cats complete with a nice drop shadow. One half of the image has a white background, while the other half has no background (indicated by the standard Photoshop checkerboard background pattern).

<img src="http://nerd.metrocat.org/wp-content/uploads/2007/10/cat-source.png" alt="cat-source.png" border="0"    style="display: block; margin: 0 auto;"/>

You want to display these cats programmatically on your Web site in response to some user activity. Naturally, the most logical thing to do is to fade them in using the standard opacity=0 to opacity=1 animation.

In Safari or any other non-busted browser, you'd see the following: on the left is the image when `opacity= 1` and on the right is when `opacity= 0.5`.

<img src="http://nerd.metrocat.org/wp-content/uploads/2007/10/cat-safari.png" alt="cat-safari.png" border="0"    style="display: block; margin: 0 auto;"/>

But in IE7, which seems to be brain-dead is still so many ways, you see the following lovely example of Microsoft Quality: on the left is the image when `opacity= 1` and on the right is the nasty result of setting `opacity= 0.5` (using the stupid Internet Explorer technique of an alpha filter).

<img src="http://nerd.metrocat.org/wp-content/uploads/2007/10/cat-ie7.png" alt="cat-ie7.png" border="0"    style="display: block; margin: 0 auto;"/>

That's really not very helpful is it?

What does your browser display?

<div style="width: 400px; margin: 0 auto;">
    <div style="margin-left: 20px; float: left; border: 1px solid black;">
    <img src="http://nerd.metrocat.org/wp-content/uploads/2007/10/cat.png">
    </div>

    <div style="margin-left: 20px; float: left; border: 1px solid black;">
        <div style="zoom: 1; filter: progid:DXImageTransform.Microsoft.Alpha(opacity=50); opacity: 0.5;">
            <img src="http://nerd.metrocat.org/wp-content/uploads/2007/10/cat.png">
        </div>
    </div>
    <hr style="visibility: hidden; clear:both; margin-bottom: 1.5em;"/>
</div>

<small>**Note:** [Jina](http://jinabolton.com/) would kill me for having inline styles in the HTML above, but for some reason the `<style>` block I tried to add got munged by Markdown.</small>
