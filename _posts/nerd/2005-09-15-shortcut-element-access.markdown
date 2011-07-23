---
layout: post
title: Shortcut Element Access
date: 2005-09-15
author: Jeff Watkins
categories:
- Javascript
---

Typing out `document.getElementById` can get a little tedious after a while. One of the best alternatives I've seen takes advantage of a little known feature of Javascript (and oddly enough C/C++ and possible Java): the dollar sign ($) is a valid identifier character.

Consider the following code:

    function searchWasSubmitted()
	{
		var e= $("searchField");
		//  launch Ajaxy search using value of search field
		var url= this.searchUrl + "?search=" + escape(e.value);
		this.request= openRequest( url, searchDidComplete.bindToObject(this) );
		return false;
	}
	
Libraries like [Prototype](http://prototype.conio.net/) provide this functionality -- and a whole lot more -- but you can take advantage of it in your code without these libraries.

	function $( elementId )
	{
		return document.getElementById( elementId );
	}
	
Of course, Prototype's version allows you to also request multiple elements, which it returns in an array. But this is good enough for my needs.