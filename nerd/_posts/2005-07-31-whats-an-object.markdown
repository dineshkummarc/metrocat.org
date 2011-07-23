---
layout: post
title: What's an Object
date: 2005-07-31
author: Jeff Watkins
tags:
- Javascript
---

You probably think you know the answer to this one, but I'd bet you can't put it into words. Most developers use objects so frequently that they never stop to think about this basic issue. An object is represented differently in almost every language, and JavaScript is a little different from all the others.

Objects in JavaScript are associative arrays (such as in Perl). This opens up a number of powerful techniques to the daring JavaScript programmer. You are daring, aren't you?
<!--more-->
#### Accessing an Object's Attributes ####

We're all familiar with accessing an objects attributes via the dot operator (.), however, you may not be aware that you can also access an object's attributes using the array operator ([]). Here's an example:

	var name= "Jeff Watkins";
	var len= name["length"];

The `len` variable will be assigned the value 12 just as if I'd used `name.length` instead.

You can also test an object for the presence of a particular attribute using the `in` operator. The following example will display the name of an object provided a `name` attribute has been defined:

	if ("name" in person)
		alert( "This person is named "" + person.name + """ );
	else
		alert( "Poor guy doesn't have a name." );

Because JavaScript is a [dynamically-typed language](http://en.wikipedia.org/wiki/Dynamic_typing#Static_and_dynamic_typing), you can't specify what types you'll accept for your function's arguments. However, you can test to make certain the objects have the attributes you're expecting.

	function fullNameOfPerson( somePerson )
	{
		//	This function expects somePerson to have both firstName and
		//	lastName properties. Otherwise, I can't compute the full name.
		if (!"firstName" in somePerson || !"lastName" in somePerson)
			return null;

		return somePerson.firstName + " " + somePerson.lastName;
	}

You can also iterate over all the attributes of an object using the `in` operator. Consider the following example:

	/**	A really simple function to create a literal version of an object.
		@param obj	the object to convert to literal form
		@returns an (almost) literal value of the object
	 **/
	function literalValueOfObject( obj )
	{
		var attributeName;
		var attributeValue;
		var str= "";

		for (attributeName in obj)
		{
			attributeValue= obj[attributeName];

			if (str)
				str+= ", ";

			str+= attributeName + " = " + attributeValue;
		}

		if (str)
			return "{ " + str + " }";
		else
			return "{}";
	}
			
#### Object's Really Don't Have Methods ####

I know you've been told otherwise. And you've even called methods on objects. Or you think you have.

Actually, objects can store any value in any attribute. Therefore, you can store a reference to a function in an attribute just as you would store a reference to a String or Number. Assuming an object named `person` has previously been declared, the JavaScript environment interprets the following:

	function alertWithText( whatToDisplay )
	{
		alert( whatToDisplay );
	}

	person.speak = alertWithText;

to mean: *assign a reference to the function `alertWithText` to the `speak` attribute of the object `person`.*

When you call a function through a reference stored in an attribute, the JavaScript environment does a little translating under the covers for you. When you type this:

	person.speak( "Hello!" );

it is as if you had really typed:

	(person.speak).call( person, "Hello!" );

which is ultimately the same as:

	alertWithText.call( person, "Hello!" );

Remember, functions are objects too. And all functions have a *method* named `call` that accepts a reference to an object and a list of arguments. When invoked via the `call` method (yes, I know I said there were no methods), the code within the function has access to the `person` object via the `this` variable.

(Note: I don't think there are any implementations of JavaScript that really translate method invocations like this. But it helps to think about how this all works. I plan to cover the `call` method in depth in a later article.)

#### Objects Everywhere ####

Not only is everything an object (even string and numeric literals), but you can create your own objects. However, creating your own objects begins to expose some of the real complexity of JavaScript, and is best left for another article.