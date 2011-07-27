---
layout: post
title: Search via Ajax
date: 2005-08-05
author: Jeff Watkins
categories:
- Ajax
- Javascript
---

Thanks to a kind mention by [Josh Porter](http://www.bokardo/), I've seen something of a spike in traffic. And a lot of it has come from links relating to AJAX.

I'm actually working on a cool AJAX demo and the search tool on this site was just a quick hack. In case you're interested in how it works, here's a quick tutorial.
<!--more-->
First of all, I'm using [MovableType](http://www.sixapart.com/movabletype/) for my content management system (I know there are cooler systems out there, I just happen to know MT pretty well. And the new Beta is shaping up nicely -- although I couldn't upgrade the 3.2b2 database to 3.2b3, grrr...). So I created a module to add search functionality to every page.

The first thing the template module does is include a javascript, [`scripts/search.js`](http://metrocat.org/nerd/scripts/search.js). then it lays out the search window. By default the search window is hidden via the `#searchWindow` css rule. This prevents it from appearing incorrectly before the `load` event handler can fire.

There's some icky (and poorly coded I must admit) animation code to make the window slide out from the top of the page when you click the tab. Any good DHTML resource has that sort of thing available by the truck load.

When the user clicks the search button or presses return, I create an `XMLHttpRequest` object and ask it to fetch the standard MovableType search CGI using the search string specified in the form. When the request completes, I hide replace the content of the results div with the full text of the search, hide the progress bar and show the results.

Simple.

Feel free to steal it.