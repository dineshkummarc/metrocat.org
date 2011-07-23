---
layout: post
title: Difficulty Supporting Drag & Drop and Cut & Paste
date: 2006-07-16
author: Jeff Watkins
categories:
- Web
---

One of the official goals for my DOM Bindings framework (think Cocoa Bindings for the DOM), is to make Web applications as close to first class citizens as possible on your desktop. That means supporting both drag & drop and cut & paste.


<!--more-->

Now, ideally these would be inter-application (as they are meant to be), however, the big stumbling block seems to be support for accessing the world outside the browser. Each browser has different levels of support for these data transfer technologies. [Safari is the best with complete support for drag & drop and the clipboard](http://www.devworld.apple.com/documentation/AppleApplications/Conceptual/SafariJSProgTopics/Tasks/DragAndDrop.html#//apple_ref/doc/uid/30001233). [Internet Explorer limits the data formats you can use to either plain text or a URL](http://msdn.microsoft.com/workshop/author/dhtml/reference/methods/setdata.asp). And surprisingly, Firefox doesn't support drag & drop or cut & paste at all (except if you're writing a XUL application).

I'm a little uncertain what to do in this situation: I'd like to support the greatest possible functionality, but I don't really want to leave anyone out in the cold. Providing a fall-back to in-browser drag & drop for Firefox isn't so bad (although how I'm going to implement my own clipboard I don't know). But I'm uncertain how to support Internet Explorer.

Should I cripple data transfer in Internet Explorer by limiting your format choices to plain text? Or should I use the same fallback method as Firefox? It's such a shame that one can't specify other formats to the `setData` method. Safari's ability to specify any mime-type is just wonderful and a model for how data transfer _should_ work.

**Update**: Unfortunately, there seems to be a [bug in Safari's implementation of drag & drop support](http://bugzilla.opendarwin.org/show_bug.cgi?id=9960) that makes it unlikely that I'll be able to use it. When you call `Event.dataTransfer.setDragImage` to specify the element to use for the drag image, unless you specify the element that was actually clicked on, you get an empty element. It might have styles (my test case used a red background), but it won't have any text. Grr...