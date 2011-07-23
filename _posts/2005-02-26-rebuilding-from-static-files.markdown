---
layout: post
title: Rebuilding from Static Files
date: 2005-02-26
author: Jeff Watkins
tags:
- Technology
---

Our previous Web-site hosting company, [Mesopia.com][mesopia], corrupted our [MovableType][mt] database during a recent server relocation. Our only choice was to recreate the database based on static HTML files I downloaded from our Web site.

This has taught me several lessons:

1. Always generate a backup version of every posting in XML format with all the data necessary to regenerate the post.

2. XHTML is your friend. Because our posts all validated as strict XHTML, I was able to use XSL transformations to convert from the static post to an XML representation, which I later used to generate an MT import file.

I'll be redesigning the site in the next week or two, and I'll be keeping these hard learned lessons in mind.

[mesopia]: http://mesopia.com "Stupid fucking idiots who corrupted our MovableType database"
[mt]: http://movabletype.org