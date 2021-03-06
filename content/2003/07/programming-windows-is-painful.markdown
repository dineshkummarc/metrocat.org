--- 
layout: post
author: Jeff Watkins
title: Programming Windows Is Painful
date: 2003-07-09
categories: 
- Work
---

It's been a very long time since I've had to write Windows software in C++. My last several projects have been C#, Java, and JavaScript based web applications. Therefore, I was insulated from the pain of having to deal with Microsoft's bizarre shared library system (AKA DLL-hell) which causes untold pain when trying to implement C++-based plug in modules.

A friend in Seattle once postulated that most of Windows was designed by drunken or stoned interns. Based on my recent experience, I can believe it. The whole idea of having to explicitly export functions, classes and templates from a DLL is ridiculous. My most recent painful experience was with an inner class to a template. For example:

    template <class T>
    class Iterator
    {
        public:
             class IteratorRep
             {
                  public:
                        virtual ~IteratorRep() {}
                        virtual bool hasNext() = 0;
                        virtual T next() = 0;
             };

             Iterator( IteratorRep* TheRep );
             ~IteratorRep();

             bool hasNext()   { return rep->hasNext(); }
             T next()         { return rep->next(); }
        private:
             IteratorRep* rep;
    };

You would think this would be an easy scheme to implement. But once you through Microsoft's lame implementation of shared libraries into the mix, you get the following:

    template <class T>
    class EXPORT Iterator
    {
        public:
             class EXPORT IteratorRep
             {
                  public:
                        virtual ~IteratorRep() {}
                        virtual bool hasNext() = 0;
                        virtual T next() = 0;
             };

             Iterator( IteratorRep* TheRep );
             ~IteratorRep();

             bool hasNext()   { return rep->hasNext(); }
             T next()         { return rep->next(); }
        private:
             IteratorRep* rep;
    };

The <code>EXPORT</code> macro handles the nasty Microsoft specific keywords necessary to export the class from the DLL. The <code>EXPORT</code> is where I made my mistake. Naturally, if I have to export the outer class, it is reasonable for me to think I'd need to export the inner class. However, this causes very weird problems when implementing an IteratorRep class. Essentially, the linker is trying to import the implementation of the new IteratorRep-derived class despite having just compiled the implementation. It's all very silly.

I accidentally removed the <code>EXPORT</code> macro and everything worked correctly.

Were Bill Gates here, I'd punch him in the nose.