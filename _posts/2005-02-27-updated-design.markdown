---
layout: post
title: Updated Design
date: 2005-02-27
author: Jeff Watkins
tags:
- Technology
---

I've finished redesigning our Web site. There are a few things I'd still like to tweak, but overall, I'm done. At least for another couple months. My one complaint is that I'm not a graphic artist: I'd love to have some stylised drawings of Newburyport in the blue bar at the top.

At the top of my list of tweaks and improvements:

1. Fix position of navigation elements in Firefox. Currently the navigation links have popped out of the bounding banner and are at the bottom right corner of the window. Not so cool.
2. Validate all pages as proper XHTML. This is really important. If the pages hadn't been valid XHTML in the previous design, I wouldn't have been able to reconstitute our database after those [bozos at Mesopia corrupted our previous site][rebuild].
3. Lots of image-based content seems to drop out when using MSIE 6. Although Internet Explorer has poor CSS support, if I can fix these problems with a minimum amount of work, I will.

I know our site doesn't look right when viewed with Internet Explorer, but MSIE has too many bugs in its support of CSS for me to bother working around all of them. I'm not quite at the point where I'll hide all styling from 5.x versions of MSIE, but then I don't have any machines with older versions of Internet Explorer I can test on.

[rebuild]: /2005/02/26/rebuilding-from-static-files "Why XHTML is your friend"