---
title: The Importance of Equality
date: 2012-01-29
categories:
- Technology
layout: post
author: Jeff Watkins
---

I've been working on a converter from Markdown to `NSAttributedString` and while running my unit tests against John Gruber's Markdown test suite, I couldn't understand why one specific test was failing[^1]. Here's the test Markdown source:

    Just a [URL](/url/).
    
    [URL and title](/url/ "title").
    
    [URL and title](/url/  "title preceded by two spaces").
    
    [URL and title](/url/	"title preceded by a tab").
    
    [Empty]().

What was confusing me was that the `NSAttributedString` that resulted from calling `+[NSAttributedString attributedStringByConvertingMarkdown:test withStyles:styles]` seemed to repeat the first four links and follow up with the correct fifth link. This didn't make any sense.

My first thought was that maybe `NSAttributedString` wasn't retaining the `MCLink` instances (which are a subclass of `NSLink`). And sure enough, after putting some logging into `-dealloc`, the evidence was clear: the second, third and fourth links were not retained. Only the first and fifth were retained.

I'm not certain why it took me so long to realise that `NSAttributedString` was probably comparing the new URLs against those already in the string and when it discovered a match, it reused an existing one.

After a quick implementation of `-isEqual:` and `-hash`, all was working gloriously.

[^1]: Just to be clear, I currently have fifteen failing tests, but this **particular** failure was very confusing.