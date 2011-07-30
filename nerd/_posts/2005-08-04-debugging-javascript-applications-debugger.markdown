---
layout: post
title: Debugging JavaScript Applications  Debugger
date: 2005-08-04
author: Jeff Watkins
categories:
- Javascript
---

Once you've got your finely crafted design all ready, and you're layering on a little [unobtrusive JavaScript](http://domscripting.webstandards.org/?page_id=2), you'll hesitate to toss a big ugly `pre` element in there just so you can do some debugging.

What if you didn't have to?

What if you only had to include a JavaScript file and call one method to get a pop-up trace window complete with a built in JavaScript evaluator?


When I was adding the search window to this site, not everything worked as expected -- this shouldn't come as a shock to anyone. I really wanted to use my own debugging library but I didn't want to clutter things up with an ugly `pre` element slapped in the middle of the page.

That got me thinking: why couldn't I create a JavaScript debugging environment that pops up like the search window pulls down?

I mocked everything up in HTML to make certain it worked correctly, then I translated it into calls to the DOM to create the entire debugger and automatically append it to your document. All you need to do is include the following in your page:

    <script type="text/javascript" src="debugger.js"></script>
    <script type="text/javascript">
        enableDebugging();
    </script>

Obviously when you've got all the kinks worked out, delete all that.

## Interoperability with Debugging Library ##

I've modified the debugging library to make certain it is compatible with the debugger library. However, you need to make certain you include the debugger after the debugging library, because the debugger redefines a function previously defined in the debugging library.

To give you an opportunity to play with the debugger, I've put up a page that demonstrates the [JavaScript Debugger](http://metrocat.org/nerd/examples/debugger-test.html). Click on the **Debugger** tab at the bottom of the page and you're in business.
