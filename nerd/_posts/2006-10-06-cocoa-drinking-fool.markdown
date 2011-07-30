---
layout: post
title: Cocoa Drinking Fool
date: 2006-10-06
author: Jeff Watkins
categories:
- Macintosh
---

After spending most of my spare time building Web technologies lately, I'm
finally going to switch gears to building a Cocoa application.




I can't tell you much about the application -- yet -- but I do plan to present
weekly status-like reports. For example, do you know that Quartz uses floating
point coordinates? You probably did. But did you also know that the whole
number coordinates represent the point immediately between two screen pixels?
So in order to draw a single pixel line you actually have to offset your
coordinates by 0.5.

Consider the following example:

    - (void) drawRect: (NSRect) rect
    {
        float cellWidth= rect.size.width/7.0;
        float cellHeight= rect.size.height/5.0;

        [[NSColor blackColor] set];

        [NSBezierPath strokeRect: rect];

        NSBezierPath* path= [[[NSBezierPath alloc] init] autorelease];

        int column;
        int row;

        for (column=1; column<7; ++column)
        {
            [path moveToPoint: NSMakePoint( cellWidth * column + 0.5,
                                            0.5 )];
            [path lineToPoint: NSMakePoint( cellWidth * column + 0.5,
                                            rect.size.height - 0.5 )];
        }

        for (row=1; row<5; ++row)
        {
            [path moveToPoint: NSMakePoint( 0.5, cellHeight * row + 0.5 )];
            [path lineToPoint: NSMakePoint( rect.size.width - 0.5,
                                            cellHeight * row + 0.5 )];
        }

        [path stroke];
    }

Of course, I could make this considerably more efficient by only creating the
`NSBezierPath` once and then just scaling it to match the view's rectangle. And
of course, there are probably a hundred other little things I could be doing to
make this better.

That's part of the exercise: I'd like to expose what I'm working on so I can
learn from the feedback. I've learned a tremendous amount from the feedback on
my Javascript posts; so I'm eager to see what I'll learn now that I'm delving
into Objective C and Cocoa.

My next post will be about mimicing the recurring event logic of iCal. I've
built my own version of the `NSRecurrenceRule` class (which I've read will
debut in Leopard). This comes complete with unit tests -- well some, anyway.
