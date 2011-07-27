---
layout: post
title: Selectors and Bindings
date: 2008-05-02
author: Jeff Watkins
categories:
- Coherent
---

One of the routine complaints about Coherent (yes, I'm talking about you Ryan) is the use of custom attributes. It seems that some people like their HTML pure, like it was back in the old days.
<!--more-->

I see nothing wrong with the following mark up:

    <div id="outer">
        <ul contentKeyPath="links.arrangedContent">
            <li><img srcKeyPath="*.iconHref"  >
                <em textKeyPath="*.title">The Title</em>
            </li>
        </ul>
    </div>

The offensive parts to the purists are `contentKeyPath`, `srcKeyPath`, and `textKeyPath`. Now browsers have always been _very_ forgiving when it comes to extra attributes on nodes, but the purists think it's sinful (or something) to take an expedient approach to adding useful information to the mark up.

I understand &mdash; really, I do &mdash; the whole separation of presentation from content and content from behaviour. However, in this particular case, I'm not actually marking up the content. I'm marking up the template for the content. To me, it makes a difference. But I understand I'll never convince you if you're already against custom attributes.

## An alternative to custom attributes ##

So the other day I was kicking around an idea for an alternative syntax for describing the bindings between elements and the data model. Ideally I could have a format similar to the following:

    ul: {
        contentKeyPath: links.arrangedContent
    },

    ul li img: {
		 srcKeyPath: *.iconHref
    },

    ul li em: {
        textKeyPath: *.title
    }

Gosh, that looks just like JSON... so how about this:

    {
        'ul': {
            contentKeyPath: 'links.arrangedContent'
        },

        'ul li img': {
    		 srcKeyPath: '*.iconHref'
        },

        'ul li em': {
            textKeyPath: '*.title'
        }
    }

Now all we need is a selector engine to hook this up to the nodes. It would be ideal if every browser supported `querySelectorAll`, but so far only Safari seems to have an implementation of `querySelectorAll`[^o] and FireFox 3 won't include it, which boggles the mind a bit. Fortunately, Diego Perini has written an excellent selector engine called [NWMatcher](http://javascript.nwbox.com/NWMatcher/) and has graciously permitted me to include it in Coherent. This gives me coverage for the vast majority of browsers that don't support `querySelectorAll`. And Diego's code is pretty fast too.

So now I'm thinking in terms of what the _right_ API should be for this. I'm thinking something like the following:

    coherent.setupNodeWithSelectors($('outer'), {
        'ul': {
            contentKeyPath: 'links.arrangedContent'
        },

        'ul li img': {
    		 srcKeyPath: '*.iconHref'
        },

        'ul li em': {
            textKeyPath: '*.title'
        }
    });

But imagine my surprise when I read about [the wacky behaviour of `querySelectorAll`](http://ejohn.org/blog/thoughts-on-queryselectorall/) this morning. This potentially explains some bugs I experienced the first time I tried to implement the selector API. I'm not entirely certain where I come down on the issue. But it sure _seems_ that if you're going to add a native feature to provide similar functionality to the numerous selector engines available, you should probably define the spec as closely as possible to the majority behaviour.

## Mimicking "standard" behaviour ##

I think my best bet is to mimic the standard behaviour of the prevailing libraries. My initial solution is to prefix the selector with the ID of the scope node. So in the call above, the selectors translate as follows:

<table style="margin: 20px auto;">
<tr><td style="text-align:right;padding-right:5px;">ul</td><td>&#x21D2;</td><td style="padding-left: 5px;">#outer ul</td></tr>
<tr><td style="text-align:right;padding-right:5px;">ul li img</td><td>&#x21D2;</td><td style="padding-left: 5px;">#outer ul li img</td></tr>
<tr><td style="text-align:right;padding-right:5px;">ul li em</td><td>&#x21D2;</td><td style="padding-left: 5px;">#outer ul li em</td></tr>
</table>

Fortunately, both Safari's implementation of `querySelectorAll` and Diego's code allow the first part of the selector to match the node itself. This solves my problem until the W3C api guys decide to change the API. Then I'll need to provide one behaviour for Safari 3.1 and another for future versions.

Joy.

On the other hand, this means that `PartList` will support selectors rather than the pseudo-selectors available in 1.0. I won't say there have been numerous occasions where I've wished for this feature, but that's only because I always had the option of tacking on a class to the target nodes. Now I won't have to.


[^o]: I'm sure someone will tell me that Opera supports `querySelectorAll`. And the truth is I could probably check in less time that it would take me to make fun of all three people who run Opera on a regular basis. But I'm still chuckling about how Andy compared Opera to the stinky kid in school who just wanted you to like him...