---
layout: post
title: Spooky Code or How to Make Animations Run Smoother
date: 2007-11-11
author: Jeff Watkins
tags:
- Art-of-Coding
- Featured
- Javascript
---

So I've been [thinking about JavaScript performance](http://nerd.metrocat.org/2007/11/whos-faster-function-or-object), because I'm hoping to make my animations run smoother. The actual animation steps (changing position, opacity, or size of a node) can't be improved by anyone other than the browser vendor. So what can I do to optimise my code and allow me to get more raw horsepower out of the same browser?

The problem isn't the simple case where I want multiple animation steps to occur either simultaneously or in sequence but when I want to compose complex animations by chunks of code that know nothing about each other. There's no way for the various chunks of code to co-operate to prepare an optimised animation. For example, say chunk A creates an animation segment to fade out a number of nodes:

	function fadeOutNode(node)
	{
		return new Fade(node, 0, 1);
	}

	var nodes= functionToRetrieveNodesToAnimate();
	var actions= nodes.map(fadeOutNode);
	return Blend(actions);

Blend is a simple action that steps each component action each time it is called:

    function Blend()
    {
        var actions;

        if (1==arguments.length)
            return arguments[0];
        
        if (1==arguments.length && arguments[0] instanceof Array)
            actions= arguments[0];
        else
            actions= Array.from(arguments);

        //  remove nulls & undefined values
        actions= actions.filter(function(v) { return null!==v; });

        var len= actions.length;

        return {
            step: function(t)
            {
                for (var i=0; i<len; ++i)
                    actions[i].step(t);
            },
            
            setup: function()
            {
                for (var i=0; i<len; ++i)
                    if ('setup' in actions[i])
                        actions[i].setup();
            },
            
            finish: function(complete)
            {
                for (var i=0; i<len; ++i)
                    if ('finish' in actions[i])
                        actions[i].finish(complete);
            }
        };
    }

That's not so bad, is it? But what if chunk B creates another animation segment to move a bunch of nodes simultaneously. Finally, I want to combine chunk A's animation (actionA) and chunk B's animation (actionB) and run them both simultaneously. The execution looks a little like this:

* Loop over the actions actionA and actionB and call them
* For each call to actionA, loop over the fade out actions and call them
* For each call to actionB, loop over the move actions and call them

That's a lot of looping. And there's a totally unnecessary loop over actionA and actionB.

Wouldn't it be great if there were an optimising JavaScript compiler to make this pain go away?

### Enter self-modifying code

There's no optimising JavaScript compilers yet (and JScript.NET doesn't count because it's not JavaScript). So what if we wrote our own _self optimising_ code? There's some good [information on Wikipedia about self-modifying code](http://en.wikipedia.org/wiki/Self-modifying_code), but that's not exactly what I'm suggesting.

What I'm thinking is a pre-processing step that would look at a declarative form of the animation (do this to these nodes under these conditions) and optimise it by unrolling loops and intelligently combining steps. So if we consider the previous example, instead of having three loops for each step of the animation, we could have just one to loop over each of the component actions.

But I don't always run animation steps simultaneously. Sometimes I create an array of sequential steps and want them executed one after each other. How could self-modifying or self-generating code help here? Actually, this is probably the best example of where self modifying code would be appropriate. Consider the guts of the `Chain` function which composes animation steps into a sequential animation:

    function Chain()
    {
        var actions;

        if (1==arguments.length)
            return arguments[0];

        if (1==arguments.length && arguments[0] instanceof Array)
            actions= arguments[0];
        else
            actions= Array.from(arguments);

        //  remove nulls & undefined values
        actions= actions.filter(function(v) { return null!==v; });
    
        var len= actions.length;
        var index=0;
        var duration= 0;
        var pos= 0;
        var startT= [];
    
        //  compute the duration of the animation
        for (var i=0; i<len; ++i)
        {
            startT[i]= duration;
            if (!('duration' in actions[i]))
                actions[i].duration=1;
            duration+= actions[i].duration;
        }
    
        return {
            step: function(t)
            {
                if (index==len)
                    return;

                var stepT= ((t*duration) - startT[index])/actions[index].duration;
                if (stepT>1)
                    stepT= 1;
            
                actions[index](stepT);
        
                if (stepT<1)
                    return;

                if ('finish' in actions[index])
                    actions[index].finish(stepT);
            
                index++;
                if (index==len)
                    return;
            
                if ('setup' in actions[index])
                    actions[index].setup();
            
                this.step(t);
            },
            
            setup: function()
            {
                index= 0;

                if ('setup' in actions[index])
                    actions[index].setup();
            },
            
            finish: function(complete)
            {
            }
        };
    }

This is pretty gnarly code. Of course, I'm certain I could optimise this a bit to make it run faster, but what if I had a JavaScript animation generator that created the following for a chain of three actions:

    function chainGang(actions)
    {
        return {
            step: function(t)
            {
                t= t*1000/400;
                if (t>1)
                    t= 1;
                actions[0].step(t);
                if (t<1)
                    return;
                actions[0].finish(1);
                actions[1].setup();
                this.step= this.step1;
            },
        
            step1: function(t)
            {
                t= (t*1000-400)/500;
                if (t>1)
                    t= 1;
                actions[1].step(t);
                if (t<1)
                    return;
                actions[1].finish(1);
                actions[2].setup();
                this.step= this.step2;
            },
        
            step2: function(t)
            {
                t= (t*1000-900)/100;
                if (t>1)
                    t= 1;
                actions[1].step(t);
                if (t<1)
                    return;
                this.step= this.stepNOP;
            },

            stepNOP: function(t)
            {},

            setup: function()
            {
                actions[0].setup();
            },
        
            finish: function(complete)
            {
                actions[2].finish(complete);
            }
        };
    }

This function would be created using the form `new Function('actions', body)` to prevent creating a closure on the current scope. Then the function would be immediately executed to return the new animation object. The constants (total duration = 1000, duration of action[0] = 400, duration of action[1] = 500, start of action[2] = duration of action[0] + duration of action[1] = 900, duration of action[2] = 100) are the values that get calculated in the previous function `Chain`, but they can be literals now, because I'm only dealing with one action at a time. This shaves a few property accesses off the top during the tight part of the animation loop.

### Complicating factors

Both of the previous examples were basically pretty simple: the first one limited the animation to actions running simultaneously but grouped logically, and the second one only examined a single sequence of actions. Naturally, a little more logic would be required to handle sequential actions and simultaneous actions or two simultaneous sequences of actions. But then the declarative syntax for the animation will have to be fairly flexible to begin with.

In addition, the _compiler_ will need to be able to probe down into an animation action to determine whether it is a composite animation. That way the compiler can work with _all_ the information at its disposal. It might even be advantageous to do away with the dichotomy of simultaneous vs. sequential actions and simply mark each action with a begin and end point (between 0 and 1).

However, because that may make composing a sequence of actions slightly more difficult, it makes sense to have helper functions still (like `Chain` and `Blend`) but instead of generating new action functions, these helper functions would merely mark the actions with the appropriate begin and end points.

    var animation= {
        actions: Sequence(step1, step2, step3),
        setup: function()
        {
            //  custom setup code
        },
        finish: function(complete)
        {
            //  custom finish code
        }
    };

If you assume that `step1`, `step2`, and `step3` all have duration 1 (which all steps should default to), `Sequence` would assign `step1` a begin point of 0 and an end point of 0.333, `step2` a begin point of 0.333 and an end point of 0.666, and `step3` a begin point of 0.666 and an end point of 1.

The following is a bit more complicated:

    var complexAnimation= {
        actions: [Sequence(step1, step2, step3),
                  step4,
                  Sequence(step5, step6)],
        setup: function()
        {
            //  custom setup code
        },
        finish: function(complete)
        {
            //  custom finish code
        }
    };

In this example, there are a total of 6 animation steps which will execute sort of like this:

<div class="figure"><img src="http://nerd.metrocat.org/wp-content/uploads/2007/11/complex.png" alt="complex.png" border="0"   ></div>

The compiler will generate four step functions similar to the sequential example above. The first step function will handle the interval t= [0, 0.333], the second step function will handle t= (0.333, 0.5], the third step function handles t= (0.5, 0.666], and finally the fourth step function handles t= (0.666, 1.0]. Let's look at the code:

    function decomplexifier(actions)
    {
        return {
            step: function(t)
            {
                //  handle step1
                var t1= t*3;
                if (t1>1)
                    t1= 1;
                actions[0].step(t1);
                
                //  handle step4
                actions[3].step(t);
                
                //  handle step5
                var t5= t*2;
                if (t5>1)
                    t5= 1;
                actions[4].step(t5);
                
                if (t0<1)
                    return;
                
                //  finish step1 and start step2    
                actions[0].finish(1);
                actions[1].setup();
                this.step= this.step1;
            },
        
            step1: function(t)
            {
                //  handle step2
                var t2= t*3-1;
                if (t2>1)
                    t2= 1;
                actions[1].step(t2);
                
                //  handle step4, still
                actions[3].step(t);
                
                //  handle step5, still
                var t5= t*2;
                if (t5>1)
                    t5=1;
                actions[4].step(t5);
                
                if (t5<1)
                    return;
                    
                //  finish up step5 and start step6
                actions[4].finish(1);
                actions[5].setup();
                this.step= this.step2;
            },
        
            step2: function(t)
            {
                //  handle step2, still
                var t2= t*3-1;
                if (t2>1)
                    t2= 1;
                actions[1].step(t2);
                
                //  handle step4, still
                actions[3].step(t);
                
                //  handle step6
                var t6= t*2-1;
                if (t6>1)
                    t6= 1;
                actions[5].step(t6);
                
                if (t2<1)
                    return;
                
                //  finish up step2 and start step3
                actions[1].finish(1);
                actions[2].setup();
                this.step= this.step3;
            },
            
            step3: function(t)
            {
                //  handle step3
                var t3= t*3-2;
                if (t3>1)
                    t3=1;
                actions[2].step(t3);
                
                //  step4 is still going
                actions[3].step(t);
                
                //  handle step6, still
                var t6= t*2-1;
                if (t6>1)
                    t6= 1;
                actions[5].step(t6);
        
                if (t<1)
                    return;
                this.step= this.stepNOP;
            },
            
            stepNOP: function(t)
            {},
        
            setup: function()
            {
                actions[0].setup();
                actions[3].setup();
                actions[4].setup();
            },
        
            finish: function(complete)
            {
                actions[2].finish(complete);
                actions[3].finish(complete);
                actions[5].finish(complete);
            }
        };
    }

Because I've normalised the duration of the _total_ animation to 1.0, the math to calculate the appropriate t value for each step is a bit simpler. And simpler is faster.

Now there are some things I'm leaving out of this. What happens when the _first_ execution specifies t=1.0? Um... basically all hell breaks loose, because not all the parts are executed correctly. The compiler really ought to generate code for these sort of boundary cases, but I couldn't be bothered because the code was already pretty long for an example.
 
### Is it worth the effort?

So it's pretty clear that a lot can be done to generate code that will run faster than my existing code. Obviously, if you can generate your animation at page load and cache it, you can reap tremendous benefit if you reuse the animation many times. But overall, will it be worth the effort? Is the trade off of a longer set up worth faster executing animation loops? I don't know. In order to find out, I'll have to implement the compiler...

Stay tuned.

