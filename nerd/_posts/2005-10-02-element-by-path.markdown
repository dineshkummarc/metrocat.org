---
layout: post
title: Element By Path
date: 2005-10-02
author: Jeff Watkins
categories:
- Javascript
---

For a project I'm working on for my employer, I need to be able to back-track my way up the DOM and store a *path* to a particular element. Because the resulting path will be used in either JavaScript or VBScript (a really terrible language), I can't really rely on just building a sequence of DOM method calls.

What I'd like to be able to use is something like:

    var e= elementByPath( "div#foo.a[4]" );

Given that browsers *have* to implement this sort of thing for CSS (well, maybe not the indexing), I'm surprised it isn't in the DOM.

It isn't too hard to build some JavaScript which will parse this.
<!--more-->
## Traversing the DOM ##

First I need to break up the path into its components. A simple `split` will suffice. Then I'll need a regular expression to match the various components of the element reference: tag name, id (or name), and index.

Unless you're really familiar with Regular Expressions, this may be a little challenging. Believe it or not, I find [Microsoft's Regular Expression Syntax Reference to be invaluable](http://msdn.microsoft.com/library/default.asp?url=/library/en-us/script56/html/js56jsgrpregexpsyntax.asp). After a little trial and error -- I use regular expressions frequently, but I'm certainly no wizard -- I came up with the following:

	var pathElementRegex= /(\w*)?(?:#(\w*))?(?:\[(\w*)\])?/;

When matched against a string in the form `tagName#id[index]`, this regex pulls out all the necessary parts (and all parts are optional). The rest of the `elementByPath` function is simply looping over all the path entries and finding each element by its reference. That's where the `elementByReference` function comes in.

	function elementByReference( parent, tagName, id, index )
	{
		var elements;
		
		if (tagName)
			elements= parent.getElementsByTagName( tagName );
		else
			elements= parent.getElementsByTagName( "*" );

		elements= filterElements( elements, tagName, id );
		
		if (index)
			return elements[index];
		else
			return elements[0];
	}

This function actually does most of the real work. Since I can't *really* be certain that there's only one element with a particular `id` and multiple tags are allowed to use the same `name` attribute, I can't use `getElementById` -- which only returns one element. Therefore, if there's no tag name specified, I have to check *all* elements within the parent element.

The `filterElements` function merely loops through all the elements and removes any that don't match the `tagName` or `id` specified.

If you're using this code on only your own HTML, you can replace the call to `parent.getElementsByTagName("*")` with `document.getElementById(id)`. Of course, you'll lose the ability to directly access named elements (mostly INPUT elements, which I add IDs to anyway). And we could short-circuit some of the processing by only allowing an ID in the first position: `#groups.a[4]` instead of `table.td#groups.a[4]`. But given the constraint that this solution has to work with *other people's* HTML, I don't want to make the assumption that there's only one element with a particular ID.

Finally, because `elementByPath` is a long name for something I'll probably use frequently, I'm going to map it to the underscore. That means I can use:

	_("div#groups.a[4]")

Nifty! Check out the sample script for [`elementByPath`](http://metrocat.org/scripts/element-by-path.js).