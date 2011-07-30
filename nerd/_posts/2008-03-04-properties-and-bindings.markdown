---
layout: post
title: Properties And Bindings
date: 2008-03-04
author: Jeff Watkins
categories:
- Coherent
- Overview
---

Possibly the two most important concepts in the Coherent library are properties and bindings. If you're familiar with modern programming languages, you've probably run across properties before, but bindings may be new unless you've worked with Apple's Cocoa library. In order to get the most out of Coherent, you'll need to understand these two facilities.





## Properties ##

In object oriented programming, a property is any attribute of an object. Technically properties might be public or private, but principally, I usually think of properties as publicly accessible values. Any bit of code may query the value of a property or set its value.

Most modern object-oriented programming languages have some concept of properties. Some older languages like Java and C++ fake it via getter and setter methods. But some languages like Python, Ruby, and C# have native properties. JavaScript in Class A browsers[^classA] also supports properties using the following syntax:

    var someObject= {

        get foo()
        {
            return this.theValueOfFoo;
        },

        set foo(newFoo)
        {
            this.theValueOfFoo= newFoo;
        }

    };

It's not the ideal syntax, but it's quite a bit better than the alternative:

    var someObject= {};
    someObject.__defineGetter__('foo', function() {
        return this.theValueOfFoo;
    });
    someObject.__defineSetter__('foo', function(newFoo) {
        this.theValueOfFoo=newFoo;
    });

You can then access this property directly and under the covers, JavaScript will call the correct methods.

    someObject.foo="I am Foo!";
    window.alert(someObject.foo);

That's all great so long as none of your visitors uses Internet Explorer. The barnacle encrusted JavaScript engine employed by Internet Explorer saw its last significant feature improvement nearly a decade ago. So it doesn't have any of the shiny new features found in Class A browsers. It's the killjoy of the browser community.

So unless you're certain all your visitors have modern browsers, you're stuck writing getter and setter methods like in Java or C++[^objCstyle]. So the example above becomes:

    var someObject= {

        getFoo: function()
        {
            return this.theValueOfFoo;
        },

        setFoo: function(newFoo)
        {
            this.theValueOfFoo= newFoo;
        }

    };

This may not seem like a big difference, but you'll notice it when you go to use `someObject`:

    someObject.setFoo('I am Foo!');
    window.alert(someObject.getFoo());

This may feel natural if you're a C++ or Java programmer, but then you're also probably accustomed to chewing broken glass, sticking needles in your eyes, and other painful party tricks.[^cpp]

### Observing properties ###

One feature built into Coherent is the ability to observe the changes made to an object's properties. For any KVO-compliant[^kvoCompliant] object, you may add an observer via a call to:

    someObject.addObserverForKeyPath(observerObj, observerObj.observeFooChange,
                                     "foo");

Whenever the `foo` property of `someObject` changes, the `observeFooChange` method of `observerObj` will be called with the previous and new value. Exactly what `observerObj` chooses to do with the change information is up to you the developer.

For properties you implement via getter and setter methods, there's nothing you need to do to notify observers that the property has changed. However, if your property is just a regular value on your object, you'll need to use one of two methods to notify observers that the value has changed.

The first technique is to wrap modification of the property with calls to `willChangeValueForKey` and `didChangeValueForKey`. So to keep with the previous observer example, lets look at some code in `someObject` that updates the `foo` property:

        addOneToFoo: function()
        {
            this.willChangeValueForKey('foo');
            ++this.foo;
            this.didChangeValueForKey('foo');
        },

This technique allows you to make numerous modifications to the `foo` property and only signal the observers when you're good and ready. Additionally, you can use `willChange`/`didChange` to wrap calls to a number of methods which all trigger changes to the same property. These changes will be delayed and coalesced into a single update.

The second technique is to modify your properties by calling `setValueForKey` or `setValueForKeyPath`. This is a _pseudo_-atomic operation that updates the property value and notifies observers all at once. Of course, under the covers, `setValueForKey` calls `willChange` and `didChange` for you. The `addOneToFoo` method could then be written as:

        addOneToFoo: function()
        {
            this.setValueForKey(this.foo+1, 'foo');
        },

Not substantially different, but if you call `setValueForKey` more than once, you (might) get more than one change notification.

### Coalesced property changes ###

One of the important responsibilities of the `willChangeValueForKey` and `didChangeValueForKey` pair is to coalesce property changes. If you plan to call multiple methods that might trigger changes for a particular property, you can wrap those calls with a `willChange`/`didChange` pair. The change notification will only be triggered when the final `didChangeValueForKey` method is called.

Additionally, the first time `willChangeValueForKey` is called, it will retrieve the current value of the property. When the final `didChangeValueForKey` method is called, the change notification will only be triggered when the previous value and new value are different. This is important to keep the number of change notifications down to a manageable level.

Property change coalescing occurs no matter how you update your properties. So whether you call `setValueForKey`, `willChangeValueForKey`/`didChangeValueForKey`, or write your own getter/setter methods (e.g. `getFoo` and `setFoo`), if the _new_ value isn't any different than the existing value, no change notification will occur.

## Bindings ##

At their most simple, bindings are a two way method of keeping objects synchronised without having to write an enormous amount of glue code. Through a binding, you are creating a mediated connection between a view or controller and your data model. Changes to one are reflected in the other automatically.

<div class="figure">
<img src="http://localhost:8888/wp/wp-content/uploads/2008/03/binding1.png" alt="binding1.png" border="0"   >
</div>

This can be reflected in your UI with the following mark up:

{% highlight html linenos %}

<div class="inline-demo">
<fieldset id="properties-bindings-demo1">
    <label>Name:</label>
    <div><input type="text" valueKeyPath="person.name"
                nullPlaceholder="Your Name"></div>
    <label>Greeting:</label>
    <div>Hello, <span textKeyPath="person.name"
                      nullPlaceholder="Your Name"></span>.</div>
</fieldset>
</div>

<script>
    coherent.DataModel('person', {name: 'Bozo the Clown'});
    coherent.setupNode($('properties-bindings-demo1'));
</script>

{% endhighlight %}

And ultimately, this yields the following interaction:

<style>
.inline-demo fieldset div
{
    line-height:24px;
    margin-left: 9em;
    margin-top: 3px;
}
.inline-demo fieldset div input
{
    margin-top:4px;
}
.inline-demo fieldset label
{
    float:left;
    clear:both;
    line-height: 24px;
    width: 8em;
    text-align: right;
}
.inline-demo .nullValue
{
    font-style: italic;
    color: #ccc;
}
</style>
<div class="inline-demo">
<fieldset id="properties-bindings-demo1">
    <label>Name:</label>
    <div><input type="text" valueKeyPath="person.name" nullPlaceholder="Your Name"></div>
    <label>Greeting:</label>
    <div>Hello, <span textKeyPath="person.name" nullPlaceholder="Your Name"></span>.</div>
</fieldset>
</div>
<script>
    coherent.DataModel('person', {name: 'Bozo the Clown'});
    coherent.setupNode($('properties-bindings-demo1'));
</script>

As you modify the value in the input field, the values are pushed into your data model. First the `InputWidget` calls `setValueForKeyPath` to update the data model with the current value of the input field. The `Person` object triggers a change notification, which is observed by the `TextWidget`. The `TextWidget` updates its associated DOM node with the new value.

<div class="figure"><img src="/wordpress/wp-content/uploads/2008/03/binding21.png" alt="binding2.png" border="0"   ></div>

### Bindings can be properties too ###

It isn't necessary to expose your bindings as properties, but it can be useful. For example, the `InputWidget` exposes a `value` binding, however, the `value` binding isn't also exposed as a property: you can't call `setValue` and `getValue` to retrieve the current widget value. On the other hand, the `ObjectController` exposes the `editable` binding and also has an `editable` property.

Typically, when a property is also exposed as a binding, setting the property should immediately set the binding. So, in the case of the `ObjectController`, setting the value of the `editable` property will automatically update the object at the other end of its `editable` binding.

## Wrapping it up ##

An understanding of properties and bindings is essential to making effective use of Coherent. With luck, this overview has shed light on some of the essential details and given you confidence to dive in and write some code. It won't hurt. I promise.


[^classA]: Class A browsers include Safari and FireFox. Both of Opera's users assure me it should be considered a Class A browser, and I'm certain they're right. Microsoft Internet Explorer &mdash; if we're charitable &mdash; is a class B browser.

[^objCstyle]: You may also write your getter and setter methods using the Objective-C style. So you save three characters. Still, you wind up calling functions rather than accessing properties, so the purist cries.

[^cpp]: Just to be clear, I _am_ a C++ programmer. So I know intimately the joy of being able to exclaim "Hey! I actually made the compiler do what I want!" after a marathon 36 hour session. And I've written enough Java to understand that its obsession with factories is nothing short of obscene.

[^kvoCompliant]: An object is KVO compliant if it is an instance of a class derived from `coherent.KVO` or has been adapted via a call to `coherent.KVO.adapt` or `coherent.KVO.adaptTree`. This means it has all the goodness Coherent has to offer.