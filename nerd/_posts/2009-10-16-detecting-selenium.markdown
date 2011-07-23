---
layout: post
title: Detecting Selenium
date: 2009-10-16
author: Jeff Watkins
tags:
- Javascript
---

I've been writing Selenium tests lately. It's not fun, but it's helped uncover a few bugs in our app. There are a number of places where Selenium doesn't shine: its CSS selector engine doesn't always find the node I'm looking for, server-based tests have a relatively anemic API, and it doesn't support native drag & drop.

I don't really agree with [PPK's assessment of HTML5's drag & drop API](http://www.quirksmode.org/blog/archives/2009/09/the_html5_drag.html): it's messy, but not impossible. I added support for HTML5 Drag & Drop to the Dashcode/Coherent library with little or no pain; I also added fallback support for Firefox 3.

By manually disabling the support for native drag & drop, all my Selenium tests pass, but that's not really a scalable solution. So I really needed to find some way to detect that I'm running within the Selenium test harness. Unfortunately, the library installs event handlers immediately, so I need to be able to detect whether Selenium is running before it injects it's alert handler (which creates the detectable `window.seleniumAlert` function).



The only thing I've found is that Selenium creates my window with the name `selenium_main_window` or something similar to that. Therefore, I've added the following to the `Browser` flags for Dashcode/Coherent:

    SeleniumActive: (-1!==window.name.indexOf('selenium'))

And then in the `Support` flags I have:

    /** Determine whether the browser supports Drag & Drop properly. Mozilla
        prior to 3.5 doesn't work correctly. When running under Selenium, native
        drag and drop is disabled.
     */
    DragAndDrop: !coherent.Browser.SeleniumActive &&
                 ((coherent.Browser.Safari && !coherent.Browser.MobileSafari) ||
                   coherent.Browser.IE ||
                  (coherent.Browser.Mozilla && !!window.localStorage))

Of course, this will completely fail if the window is opened via another method, but it's the best I could do.