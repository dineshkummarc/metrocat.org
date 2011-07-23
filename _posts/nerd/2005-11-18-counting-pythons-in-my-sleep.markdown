---
layout: post
title: Counting Pythons In My Sleep
date: 2005-11-18
author: Jeff Watkins
categories:
- TurboGears
---

In my professional life, I work with COM (pity me). One of the things I *really* like about JavaScript and Java is the fact that they use garbage collection rather than reference counting.

I just discovered that Python also uses reference counting, but includes a garbage collector. From my primitive tests, the garbage collector doesn't seem to be turned on by default.

    class RefCountTester(object):
        def __del__(self):
            print "Goodbye, cruel world: %r" % self
    
    >>> r1= RefCountTester()
    >>> r2= RefCountTester()
    >>> r1.r2= r2
    >>> r2.r1= r1
    >>> del r1
    >>> del r2
    
The code above is what I used to test the basic reference counting. I deliberately set up a cycle in the hopes that the garbage collector would kick in, but no!

I checked to see whether the garbage collector is enabled, and Python reports that it is. However, I haven't seen either of these objects get collected yet.

Will the garbage collector call the `__del__` method?

For modules which may rely on garbage collection, is it likely that I'll run into systems (Python 2.4 and above only) which might have garbage collection turned off?