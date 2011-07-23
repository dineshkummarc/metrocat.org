---
layout: post
title: Ajaxian Limitation
date: 2005-08-18
author: Jeff Watkins
tags:
- Ajax
- Javascript
---

I was just thinking about adding another Ajax-y feature to the site when it occurred to me: I can either return JavaScript **or** HTML but not both.

Typically when returning HTML using an XMLHttpRequest object I set the `innerHTML` property of a div on the page with the result (provided the operation was successful). But I'm willing to bet that any scripts contained in that HTML doesn't get interpreted.

Let's find out...
<!--more-->
#### Ajax Is All About Rich Content ####

When I first started writing Web applications back in 1995, "rich content" meant anything with images, sound, and words. Behaviour didn't enter into it because scripting wasn't really possible, and even when it became possible with the first generation of Javascript, there wasn't really much you could accomplish with it.

Today, "rich content" is almost synonymous with dynamic content. Behaviour is almost a required feature of rich content. So it seems reasonable that you might want to return rich content from your XMLHttpRequest.

#### Problems Returning DHTML from XMLHttpRequest ####

Most of my early uses of XMLHttpRequest simply return HTML. No script elements. No behaviour. Static, non-rich content. But that means the behaviour of your Web application is fixed. You must load all the Javascript include files you *might ever need* when the browser first parses your HTML file. That's not a good recipe for modular software design.

In the past, when the XMLHttpRequest completed, I would take the `responseText` and assign that to the `innerHTML` of a div on my page. Like so:

	function requestComplete( request )
	{
		var results= document.getElementById( "htmlResult" );
		if (!results)
			return;
			
		results.innerHTML=request.responseText;
	}

Unfortunately, this will not process any `script` tags contained within the `responseText`. Check out this [example](http://metrocat.org/nerd/examples/ajax-scripting-test1.html) of storing an HTML fragment with a `script` tag to the `innerHTML` property. Were the `script` tag processed, we'd see an alert box. No alert box, therefore, `script` tag not processed.

#### Alternatives to Fetching DHTML ####

There are two simple alternatives that will solve this problem admirably.


* **Don't worry about it.** Maybe your Web application just isn't complicated enough to warrant a modular approach. Most aren't that complicated. There's no sense building a solution to a problem you don't have. I really mean this.

* **Separate your behaviour.** You can easily fetch just a Javascript file to expand your application's behaviour. It won't have HTML content, but you can always fetch that separately. Two calls to XMLHttpRequest means two chances for failure and additional latency. So this might only be a good solution over a robust, high-speed network (not the Internet).

I'm not known for taking the easy way out. I want to solve this problem.

#### Evaluating `script` Tags ####

It would seem the answer is to evaluate the `script` tags in the response from XMLHttpRequest. This shouldn't be too hard. The first step is to evaluate each `script` tag in the response:

	function requestComplete( request )
	{
		var results= document.getElementById( "htmlResult" );
		if (!results)
			return;
			
		results.innerHTML=request.responseText;
		var children= results.children;
		var child;
		var index;
		
		for (index=0; index<children.length; ++index)
		{
			child= children[index];
			if (child.tagName && "SCRIPT"==child.tagName)
			{
				eval( child.innerHTML );
			}
		}
	}

Unfortunately, this doesn't propagate functions defined in the fetched DHTML to the global scope. That's an unacceptable limitation.

#### Giving Up, For Now... ####

I've tried numerous ways to massage the script tags into something that will work correctly, but the only solutions mean writing weird and wacky Javascript. I hate weird and wacky syntax.

Worse, the weird and wacky syntax doesn't really address the following example:

	<script type="text/javascript">
		function tabLabelWasClicked()
		{
			alert( "The tab label was clicked!" );
		}
	</script>
	<span id="tabLabel" onclick="tabLabelWasClicked()">Tab 1</span>
	
Yes, I can transform the code in the `script` tag so that it will return an object that includes the `tabLabelWasClicked` function, but then I'll have to transform the `onclick` handler to call the same function. But that means every `script` tag will need a unique container object. That's just a pain.

So, I'm going to give up on this problem for now. It's just a problem. This doesn't mean you can't expand the behaviour of your Web application by dynamically loading Javascript, but it does mean you'll have to separate your behaviour and content. The unobtrusive Javascripter guys will be delighted.

**Update:** The discussion continues in [Going Global](http://nerd.newburyportion.com/2006/07/going-global).