---
layout: post
title: DHTML Binding Example
date: 2005-08-17
author: Jeff Watkins
tags:
- Javascript
---

I'm having trouble catching up after my mini-vacation, but I cleaned up the key-value coding/observing code enough to post an example.
<!--more-->
This example also uses my DHTML Bindings library (a blatant <strike>rip off</strike> adaptation of Apple's Cocoa Bindings). The bindings library really isn't ready for prime-time; it's still missing features like binding to tables and other HTML elements, but I think it gives you a good idea of how the library will ultimately work.

And talk about unobtrusive.

This is about as unobtrusive as you can get. Check out the HTML:

	<form>
		<select id="peopleList" size="4" contentKeyPath="people"
			displayValuesKeyPath="people.fullName"
			selectedIndexKeyPath="selectedIndex"
			selectedObjectKeyPath="selectedPerson"></select>
			
		<fieldset>
			<legend>Person Detail</legend>
			First Name: <input valueKeyPath="selectedPerson.firstName"/><br />
			Last Name: <input valueKeyPath="selectedPerson.lastName"/><br />
			Email: <input valueKeyPath="selectedPerson.email"/><br />
			URL: <input valueKeyPath="selectedPerson.url"/>
		</fieldset>
		
		<input type="button" onclick="addPerson(); return false;" value="Add Person"/>
		<input type="button" onclick="deleteSelection(); return false;"
			value="Delete Person" enabledKeyPath="selectedIndex(SelectedIndexToBoolean)"/>
		
	</form>

Of course, the additional attributes means this really won't validate as XHMTML. But I'm OK with that. And if you really must validate, you can use a [custom DTD as explained in *A List Apart*](http://www.alistapart.com/articles/customdtd/).

So go check out the [DHTML Bindings example](http://nerd.newburyportion.com/examples/bindings-example.html).