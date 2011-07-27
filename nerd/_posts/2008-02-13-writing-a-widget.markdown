---
layout: post
title: Writing a Widget
date: 2008-02-13
author: Jeff Watkins
categories:
- Tutorials
---

Coherent strives to present a sane Model View Controller paradigm for client-side Web development. So writing a Widget using the Coherent library may be a bit different from what your accustomed to. However, if you've ever written desktop software, this should feel right at home.

For this tutorial, we're going to build a simple photo gallery to display a static list of images with captions. In a future tutorial, we'll see how we can expand this sample to pull image information from Flickr or other sources.
<!--more-->

<link rel="stylesheet" href="http://localhost:8888/js/coherent/demo/widget/widget.css" media="screen">

<script src="http://localhost:8888/js/coherent/demo/widget/PhotoGallery.js"></script>

<a name="demo"></a>
<div id="photo-gallery" markdown="0">
    <img src="/js/coherent/demo/widget/photos/molly-1.jpg">
    <p>Caption</p>
    <a href="#" class="next">Next</a>
    <a href="#" class="prev">Previous</a>
</div>

<script markdown="0">
var galleryData= {
    selected: 0,
    photos: [
        {
            caption: "Molly on the slide.",
            href: "http://localhost:8888/js/coherent/demo/widget/photos/molly-1.jpg"
        },
        {
            caption: "Monkey in training",
            href: "http://localhost:8888/js/coherent/demo/widget/photos/molly-2.jpg"
        },
        {
            caption: "Spaz attack!",
            href: "http://localhost:8888/js/coherent/demo/widget/photos/molly-3.jpg"
        },
        {
            caption: "Ride `Em, Molly!",
            href: "http://localhost:8888/js/coherent/demo/widget/photos/molly-4.jpg"
        },
        {
            caption: "Don't mess with my zebra.",
            href: "http://localhost:8888/js/coherent/demo/widget/photos/molly-5.jpg"
        }
    ]
};
new PhotoGallery('photo-gallery', galleryData, {
                    images: '*.photos',
                    selectedIndex: '*.selected'
                 });
</script>

The buttons at the bottom allow visitors to cycle forward and backwards through the list of available photos. In this case, wrapping around is not supported, but would be easy to implement.

Go ahead, try it. It just works.

## Parts is parts ##

Obviously, our widget is nothing without some HTML to hook it up to. Let's create the bare minimum of markup: we need an image to display the current photo, a paragraph to present the photo's caption, and two links to serve as our next and previous button. We'll rely on Safari's top-notch CSS support to make it all look pretty.

    <div id="photo-gallery">
        <img src="/photos/molly-1.jpg">
        <p>Caption</p>
        <a href="#" class="next">Next</a>
        <a href="#" class="prev">Previous</a>
    </div>

That's simple. Our markup maps to our widget through `Parts` (and `PartList`s not seen here). A `Part` is a lightweight stand in for a DOM node (often called a flyweight). All a `Part` contains is the ID of the DOM node, and if the node doesn't have one, it will be assigned one. This alleviates a lot of headaches for the server side of things, because you don't have to write code to generate unique IDs. In addition, because you won't have DOM node references in your local variables, you reduce the risk of memory leaks in Internet Explorer when creating closures. To retrieve the DOM node, you simply invoke the `Part` as if it were a function (which it is) and if the node exists, you'll get back a reference to it.

The real work happens in our widget's `init` method. After initialising its `images` and `selectedIndex` properties to reasonable default values, the widget creates two widgets of its own. The first is an image widget and the second is a text widget. The first parameter to each constructor is the node that will be managed by the widget. The second and third parameters are the relative data source for the widget and a map describing where the widget can find its data; we'll get to this in the section on [Data Binding](#data-binding).

We also add listeners for the click event on both the next and previous buttons. At the moment, Coherent depends on some methods having an API similar to the Prototype library, but expect this dependency to go away in the future.

    var PhotoGallery= Class.create(coherent.Widget, {

        ...

        init: function()
        {
            this.images= null;
            this.selectedIndex= -1;

            new coherent.ImageWidget(this.image(), this, {
                                        src: '*.selectedImage.href'
                                     });
            new coherent.TextWidget(this.caption(), this, {
                                        text: '*.selectedImage.caption'
                                    });

            Event.observe(this.nextButton(), 'click',
                          this.nextButtonClicked.bindAsEventListener(this));
            Event.observe(this.prevButton(), 'click',
                          this.prevButtonClicked.bindAsEventListener(this));
        },

        image: Part('img'),
        caption: Part('p'),
        nextButton: Part('a.next'),
        prevButton: Part('a.prev'),

        ...
    
    });

For widgets like our photo gallery, it really is this simple. As your widgets get more complex, of course, your `init` logic will get a bit more complex. But by using sub-widgets, `Part`s and `PartList`s, your work can be less onerous.

## Handling events ##

At the moment, our photo gallery isn't very interesting, but before we get into stuff that's specific to the Coherent library, let's implement the click event handlers to allow the visitor to switch between the available images.

The logic for both `nextButtonClicked` and `prevButtonClicked` is basically the same: stop the DOM event from invoking the anchor, return if there are no images or if we're at the beginning or end of the list (for previous and next respectively), otherwise, update the `selectedIndex` property to reflect either the previous or next index. And finally, update the navigation controls.

Updating the navigation controls is similarly very simple: if we're at the beginning of the list, add the `disabled` class to the previous link, otherwise remove it; and if we're at the end of the list, add the `disabled` class to the next link, otherwise remove it. If there are no images at all, disable both buttons.

    var PhotoGallery= Class.create(coherent.Widget, {
        ...

        nextButtonClicked: function(event)
        {
            Event.stop(event);
            if (!this.images)
                return;

            var newIndex= this.selectedIndex+1;
            if (newIndex>=this.images.length)
                return;

            this.setValueForKey(newIndex, 'selectedIndex');
            this.updateNavigation();
        },

        prevButtonClicked: function(event)
        {
            Event.stop(event);
            if (!this.images)
                return;

            var newIndex= this.selectedIndex-1;
            if (newIndex<0)
                return;

            this.setValueForKey(newIndex, 'selectedIndex');
            this.updateNavigation();
        }

        updateNavigation: function()
        {
            if (!this.images || !this.selectedIndex)
                Element.addClassName(this.prevButton(), 'disabled');
            else
                Element.removeClassName(this.prevButton(), 'disabled');

            if (!this.images || this.selectedIndex+1>=this.images.length)
                Element.addClassName(this.nextButton(), 'disabled');
            else
                Element.removeClassName(this.nextButton(), 'disabled');
        },

        ...
    });

That's it. Again, this is a pretty simple widget, but you'll find that using `Part`s and sub-widgets makes your event handlers considerably simpler.

## Widget Properties ##

In the previous code fragment, you may have noticed two calls to an unfamiliar method: `setValueForKey`. This method is declared on the `coherent.KVO` class which is an ancestor of `coherent.Widget`. Essentially, calling `setValueForKey(newValue, keyName)` is equivalent to the following code:

    this.willChangeValueForKey(keyName);
    this[keyName]= newValue;
    this.didChangeValueForKey(keyName);

Of course, _that_ clears things up, doesn't it? The call to `willChangeValueForKey` lets observers know that you intend to change the value of a particular property. After you change it, calling `didChangeValueForKey` alerts observers that the value has actually changed. Under the covers, `didChangeValueForKey` will check to make certain that the value actually _has_ changed before invoking the observers' change notification handlers. Calling `setValueForKey` does this for you.

Now you might be wondering whether you need to add calls to `willChangeValueForKey` and `didChangeValueForKey` to all your setter methods. Good news! The answer is no. Coherent will automatically wrap your setter with calls to `willChangeâ€¦` and `didChangeâ€¦` so you don't need to worry about it.[^1]

[^1]: And if you're only targeting class A browsers, you don't even have to call `setValueForKey` or `willChange&hellip;`/`didChange&hellip;` because Coherent will automatically wrap your properties with getter and setter methods that make the calls for you. Just one more reason to long for Internet Explorer 8.

In addition to the list of images and the index of the selected image, our photo gallery widget needs a property to reflect the selected image itself. We'll define an accessor method, because its value is computed rather than set.[^2] The method checks first to make certain the `images` property has a value and that an image is actually selected, returning `null` if either condition is false. Otherwise, it returns the object in the `images` array at the index determined by `selectedIndex`.

[^2]: Accessor methods can either use the Java-esque style of `get` and `set` followed by the capitalised name of the property or the Objective-C style where the getter method is named the same as the property and the setter is named with `set` followed by the capitalised name of the property. Use whichever style is most comfortable for you.

Next we need to determine how the properties interact. In this case, the `selectedImage` property is dependent on the value of `selectedIndex` and `images`. So we declare this dependency relationship in `keyDependencies` &mdash; a special property you can add to your class definition and is processed via the `__subclassCreated` method of the Widget class. Each entry in the `keyDependencies` map is the name of a property and its value is an array of other properties upon which the property value depends.

    var PhotoGallery= Class.create(coherent.Widget, {
        ...

        getSelectedImage: function()
        {
            if (!this.images || -1===this.selectedIndex)
                return null;
            return this.images[this.selectedIndex];
        },

        keyDependencies: {
            'selectedImage': ['selectedIndex', 'images']
        },

        ...
    });

Normally, widgets will have considerably more properties than our photo gallery, but each property will be implemented roughly like `selectedImage`.

## Data Binding ## {#data-binding}

Most widgets need to interact with the data from your application. (If not, what the heck do they do?) Widgets need to declare these data connection points, called bindings, so that Coherent can manage notifying the widget when a bound value changes. Widgets can also push changes out to the bound data as well, and Coherent will notify the owner of the data via a change notification.

There are two places that Widgets can look to resolve their bindings: in the global data model and in their relative data source (parameter #2 to the constructor). In the `init` method, we encountered two bindings: the `src` for the `ImageWidget` and the `text` for the `TextWidget`. The third argument to the constructors specifies a map in which the keys are the names of the widget's exposed bindings and the values are paths to where the widgets should look for their data. Paths that begin with `*` are assumed to be relative to the data source provided as parameter #2 to the constructor. Other paths are to objects that live in the global data model, which we'll explore in a future tutorial.

For our photo gallery, the first step is to define the external data our widget is expecting. In order for our widget to respond to changes to the external data, we must define observer methods for each exposed binding. Coherent will automatically call our widget's observer method when external data changes.

We'll expose bindings for the list of images and the index of the selected image. Because this is such a simple example, when these values change in the data model, we'll just update a local property with the new value.

    var PhotoGallery= Class.create(coherent.Widget, {
        ...

        exposedBindings: ['images', 'selectedIndex'],

        observeImagesChange: function(change, keyPath, context)
        {
            if (coherent.ChangeType.setting!==change.changeType)
                return;

            this.setValueForKey(change.newValue, 'images');
            this.updateNavigation();
        },

        observeSelectedIndexChange: function(change, keyPath, context)
        {
            this.setValueForKey(change.newValue, 'selectedIndex');
            this.updateNavigation();
        },

        ...
    });

Through the magic occurring behind the scenes, these two observer methods will cause a change notification for the photo gallery's `selectedImage` property, which in turn will generate change notifications for the `src` and `text` bindings of the image widget and text widget. Your UI will update automatically.

In most cases, your observer methods will not usually be this simple. However, you can often factor out some logic like the call to the method `updateNavigation` &mdash; which enables and disables the next and previous buttons.

## Create the Widget ##

The data for our photo gallery could come from any where, but for now, we'll just hard-code some photos and captions into our HTML document. Our `galleryData` structure contains an entry for the index of the selected photo as well as an array of photos. These don't have to both be in the same place, in fact, a future tutorial will demonstrate using an `ArrayController` to manage the selection and an `AjaxController` to fetch the photos from Flickr.

    var galleryData= {
        selected: 0,
        photos: [
            {
                caption: "Molly on the slide.",
                href: "photos/molly-1.jpg"
            },
            {
                caption: "Monkey in training",
                href: "photos/molly-2.jpg"
            },
            {
                caption: "Spaz attack!",
                href: "photos/molly-3.jpg"
            },
            {
                caption: "Ride `Em, Molly!",
                href: "photos/molly-4.jpg"
            },
            {
                caption: "Don't mess with my zebra.",
                href: "photos/molly-5.jpg"
            }
        ]
    };

Now that we have data, we can create our widget. All that's needed is to instantiate a `PhotoGallery` object. Just like when we created the `ImageWidget` and `TextWidget`, we pass the DOM node for the widget (as an ID this time), the object that will be the source of the widget's data, and a map indicating how the exposed bindings hook up to the data source.

    new PhotoGallery('photo-gallery', galleryData, {
                        images: '*.photos',
                        selectedIndex: '*.selected'
                     });

## See it in action ##

If this sounds simple, it really is. In case you didn't notice, the [photo gallery](#demo) at the top of the page was live. And if you'd like to see how it works, why not [download the source](http://localhost:8888/download/) and check it out?

The next tutorial (stay tuned) will cover having multiple widgets accessing the same data model. I'm thinking of having the same simple photo gallery, but adding widgets to allow managing the list of photos.