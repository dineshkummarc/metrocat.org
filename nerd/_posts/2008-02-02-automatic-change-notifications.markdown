---
layout: post
title: Automatic Change Notifications
date: 2008-02-02
author: Jeff Watkins
tags:
- Coherent
---

One of the problems with using Coherent in the past has been making certain you fire change notifications at the correct times. To do this you either needed to modify your properties via `setValueForKey` or bracket the property change with `willChangeValueForKey` and `didChangeValueForKey`. It always seemed pretty dumb that when you're writing a mutator method you always needed to have `willChangeValueForKey` and `didChangeValueForKey` at the beginning and end of your method.

<!--more-->

For example:

	var MyClass= Class.create(coherent.KVO, {

		name: function()
		{
			return this.__name;
		},

		setName: function(newName)
		{
			this.willChangeValueForKey('name');
			this.__name= newName;
			this.didChangeValueForKey('name');
		}

	});

That's not terribly convenient. It's also not particularly efficient, because if there are no observers for the `name` property, you have an extra two function calls -- never mind what those functions actually do.

With recent builds of Coherent, you can now simply have:

	var MyClass= Class.create(coherent.KVO, {

		name: function()
		{
			return this.__name;
		},

		setName: function(newName)
		{
			this.__name= newName;
		}

	});

Of course, this is an example of a pointless use of getter/setters in JavaScript, but nevertheless...

So how do change notifications get sent if there's no call to `willChange` and `didChange`? Under the covers, `infoForKey` wraps `setName` with the following:

	function wrappedMutator(newValue)
	{
		this.willChangeValueForKey(key);
		originalMutator.call(this, newValue);
		this.didChangeValueForKey(key);
	}

Where `key` and `originalMutator` are variables inherited from a closure. At the moment, this mutator swizzling occurs on the class rather than simply on the instance. So in the future all instances of `MyClass` will trigger change notifications. It turns out the secret to making this work lies at the heart of `addObserverForKeyPath`: if there are no prior observers for the key path, Coherent will request the key info for the key path via `infoForKeyPath`. That causes any currently existing mutator methods to get wrapped. But if an object along the key path isn't present, the mutators will still get wrapped when values along the path are changed.

    var Person= Class.create(coherent.KVO, {

        cellphone: function()
        {
            return this.__cellphone;
        },

        setCellphone: function(newCellphone)
        {
            this.__cellphone= newCellphone;
        }

    };

    var jeff= new Person();

    jeff.addObserverForKeyPath(this, this.observeCellphoneChange,
                               'cellphone.name');

Consider the code above, when `addObserverForKeyPath` is called, the `cellphone` property is `null`, however, the call to `infoForKeyPath` will wrap `setCellphone` to automatically trigger a change notification. If the application later executes the following code:

    jeff.setCellphone(new iPhone());

Although there are no observers specifically for the `cellphone` property, part of `notifyObserversOfChangeForKeyPath` triggers change notifications for partial keys, like `cellphone.name`. Because the value of `cellphone` has changed, it seems likely that the value of `cellphone.name` has also changed. **Here's where the magic happens:** in order to determine the new value of `name`, Coherent calls `valueForKey` which in turn calls `infoForKey`. And it's `infoForKey` that wraps the mutator.

Where things get _really_ cool is when your application only needs to support Class A browsers (like Safari 3 and Firefox 2), because then you can use properties. That means you need to write less code. The example above translates into the following:

    var Person= Class.create(coherent.KVO, {
        //  nothing needed here, although you could have a constructor
        //  to initialise properties if you need to.
    });

    var jeff= new Person();

    jeff.addObserverForKeyPath(this, this.observeCellphoneChange,
                               'cellphone.name');

    jeff.cellphone= new iPhone();

All the property magic happens under the covers. Now _that's_ how we should be writing our applications.