---
layout: post
title: Ajaxy Goodness
date: 2006-04-29
author: Jeff Watkins
tags:
- Ajax
- Design
---

Back a million years ago, I wrote about using [Ajax to allow visitors to search my site](http://nerd.newburyportion.com/2005/08/search-via-ajax). When I ported the Web site from MovableType to WordPress, I had to give up this feature because I didn't know PHP or WordPress well enough to make it work.

This weekend, I put the finishing touches on a [new design for the site I share with my wife](http://newburyportion.com) and I was finally able to bring back the Ajaxy goodness.

<div class="figure">
<img class="photo" id="image77" src="http://nerd.newburyportion.com/wp-content/uploads/2006/04/screen1.jpg" alt="New Design">
</div>

In addition to making the Web site a little more visually interesting (after a *long* period of boring design), the new theme supports my lightbox library for forms. Lightboxes seem to be all the rage for displaying popup enlargements of thumbnails on a Web page. The idea is so terrific that I had to apply it to popup forms (AKA dialog boxes) that communicate back to the server using Ajax. Below is the search box:

<div class="figure">
<img class="photo" id="image77" src="http://nerd.newburyportion.com/wp-content/uploads/2006/04/screen2.jpg" alt="Search Dialog">
</div>

You'll note the translucent overlay that's the hallmark of the lightbox technique, however, instead of displaying an image, I'm displaying an Ajax-enabled search dialog box. Type your search terms and hit enter. You'll get the now ubiquitous Apple spinning marker followed by (we hope) some relevant search results.

This is all so easy to do that I quickly popup a contact form together to take further advantage of the library:

<div class="figure"><img id="image77" src="http://nerd.newburyportion.com/wp-content/uploads/2006/04/screen3.jpg" alt="Contact Form"></div>

Of course, this wouldn't be that *nerdy* if I were only going to brag about some new features. Let's look at what's required to make the lightbox go.

First you'll want to include all the necessary scripts in your page:

    <script src="helpers.js" type="text/javascript">
    </script>
    <script src="lightbox.js" type="text/javascript">
    </script>
    <script src="scriptaculous/prototype.js" type="text/javascript">
    </script>
    <script src="scriptaculous/scriptaculous.js" type="text/javascript">
    </script>

These should be included in the page that contains the lightbox (although it should be safe to include them in the lightbox content page as well, which makes the dialog work stand alone). Then add a `rel="lightbox"` attribute to any links which should open in the lightbox.

The page that displays in the lightbox needs a little tweaking to work perfectly. If you want the dialog page to work as an independent page, you should consider adding an ID of `lightboxContent` to the body tag. This tells the lightbox library that when it loads the page via a prototype `Ajax.Request` call, it should discard everything but the body (and any custom scripts you've declared).

Next, you should tell the lightbox to manage your form. In this case, we're working with the search dialog's form `searchForm`.

    lightbox.manageForm( "searchForm", searchComplete, beforeSearch );
    lightbox.setMayClose( true );

The call to `manageForm` includes the name of the form (because it may not have been created yet depending on how your browser renders content) and several event handlers: one for when the form is submitted and a response is received, and the other for setting up and validating the data just prior to submitting the form.

The second call is to `setMayClose` which tells the lightbox to display the little close box in the top right corner of the dialog. This should only be enabled if it is safe to dismiss the dialog box at all times. If you're asking the visitor to make a choice between a 15" MacBook Pro or a 17" MacBook Pro, it doesn't make sense to include a close button, because what's the choice then? Instead include a button to cancel the entire process.

Of course, what you do with this technique is up to you. For a site I'm designing for my employer, we're tossing JSON formatted data around. But for Newburyportion.com, I'm just passing HTML.

Feel free to download the source and play with it. You'll want the latest Scriptaculous library to make it all work.