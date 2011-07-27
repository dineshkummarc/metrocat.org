---
layout: post
title: Making Javascript
date: 2009-10-07
author: Jeff Watkins
categories:
- Javascript
- Web
- distil
---

Every development environment has its build tools: C and C++ have [Make](http://www.gnu.org/software/make/), Java has [Ant](http://ant.apache.org/), and Ruby has [Rake](http://rake.rubyforge.org/). There are probably lots of other tools out there which I've never heard of, which is no slight to those tools, I just don't get out much. But there aren't many good tools for building Javascript projects[^sprockets]. And when you toss CSS and HTML into the mix, you're pretty much on your own.

I expect a Javascript/CSS build tool to do all of the following:

* Check the syntax of my Javascript code and point out common mistakes ([Lint Checking](#lint-checking))
* Combine multiple Javascript and CSS files into one download package ([File Concatenation](#file-concat))
* Determine the dependencies of my files ([Dependency Management](#dependency-mgmt))
* Manage extra files associated with my project ([Asset Management](#asset-mgmt))
* Extract documentation from my Javascript files ([Documentation](#jsdoc))
* Build optimised distribution packages ready for deployment ([Deployment](#deployment))
* Facilitate active development & debugging ([Development & Debugging](#development))

My obsession with build tools started when I needed something for the Coherent javascript library. I wanted to automate running [Javascript Lint](http://javascriptlint.com/) against my source and package everything into a single file for efficient downloads. I admit the scope has increased considerably, but that was the original goal.

I'm taking advantage of several tools to make all this possible:

* [Javascript Lint](http://sourceforge.net/projects/javascriptlint/) by Matthias Miller
* [JSDoc Toolkit](http://code.google.com/p/jsdoc-toolkit/) by Michael Mathews
* [Y!UI Compressor](http://developer.yahoo.com/yui/compressor/) by the excellent Yahoo! UI developer team

Of course, I've added a bit of code myself.

## Lint Checking ## {#lint-checking}

When I was in college the world was young and dinosaurs roamed the Earth. One day, I'd just dashed into the lecture hall with a tyrannosaur hot on my heals, when the professor declared: "Lint is your best friend." Of course, in those days, actually compiling your code took time &mdash; go get a coke from the machine down the hall kind of time &mdash; so using a tool that worked a bit quicker meant you could write better code.

Of course it's ironic that we now have blazing fast computers, but a lint checker is still my best friend. In this case it's the Javascript Lint checker by Matthias Miller. Because Javascript is interpreted, there's no way to know whether you have a syntax error deep in the bowels of your code until you actually execute it. That's where Matthias' excellent tool comes in. He took the Mozilla Spidermonkey engine and added lots and lots of important checks for common coding mistakes. 

> &ldquo;This is an INDISPENSIBLE tool for Javascript development! It beats the pants off of Crockford's JSLint, and catches most dumb errors before you get a runtime error.&rdquo;<br>
> &mdash; reviewer on the SourceForge home page for Javascript Lint

I'd definitely second this assessment. I didn't like Crockford's tool simply because it wasn't really configurable (when I evaluated it) and I don't need Crockford preaching at me through his tools.

## File Concatenation ## {#file-concat}

When building complicated Web applications, you'll find yourself with quite a few lines of code that need to be deployed. To give this some scope, the Coherent library runs over 18,000 lines of code in 80 Javascript files. And my latest project runs close to 10,000 lines in 50 files plus the Dashcode library. This is great for development &mdash; where the files all live locally &mdash; but it starts to cause problems when you go to deploy.

Even with a Content Delivery Network (CDN) like Akamai or Amazon Cloudfront, you're still looking at about 70ms latency for each file. If you have 50 Javascript files, that adds up to 3.5 seconds. If you have 50 files of your own and your library has 80, you'll spend almost 10 seconds just downloading Javascript files. Of course, this holds true for CSS too -- you pay a latency tax for each file you download.

The simple solution is to concatenate your Javascript and CSS files into fewer but larger files. This won't reduce the number of bytes you have to ship down the wire, but we'll solve that problem in a moment.

## Dependency Management ## {#dependency-mgmt}

You can't just jam your CSS and Javascript files together and hope they work. In the case of CSS, your rules won't cascade correctly and in Javascript, you'll have undefined classes or variables. Therefore, it's important to properly order your Javascript and CSS files.

For CSS files, the dependency mechanism relies on the CSS `@import` rule and the import rules are removed from the concatenated output. For Javascript files, I use the import declarations used by Javascript Lint (jsl) to control parsing of your Javascript files. For example, to include another Javascript file, use the comment:

    /*jsl:import yourfile.js*/

This syntax isn't ideal, but the real crime is that Javascript _still_ lacks the basic ability to import other files. I've added code to jsl that will support finding imports outside of your current project tree &mdash; this works just like the include option to a C/C++ compiler or the CLASSPATH option to a Java compiler. This means imports that once looked like:

    /*jsl:import ../../coherent/release/coherent-uncompressed.js*/

Are now a bit tidier:

    /*jsl:import coherent-uncompressed.js*/

You won't need to update a bunch of source files if you're working in a branch and other projects aren't in the same location.

## Asset Management ## {#asset-mgmt}

There's more to a project than just Javascript and CSS files. Your CSS files reference GIFs, JPGs, and PNGs; your Javascript files reference HTML templates. All these files need to be collected and copied to the build folder in order to package up the distribution. The build tool will issue a warning if it encounters a reference to an asset it can't find. This is a huge help for those of us who _occassionally_ forget to add files to the SVN repository.

For Javascript files, the assets are the HTML template files used to instantiate views. This might be somewhat specific to the library we're using, but it's probably not that unusual.

Each asset for an included file will be copied to the distribution folder. All references to the assets will be re-written to use paths relative to the distribution folder.

## Documentation ## {#jsdoc}

As a Javascript developer, I've always envied the JavaDoc tool that Java developers get to use[^C#doc]. Of course, Java developers have to use Java, so they have troubles all their own. Javascript is a particularly difficult language to document, because it's so dynamic. But Michael Mathews took on the challenge and produced [JSDoc Toolkit](http://code.google.com/p/jsdoc-toolkit/).

Because Javascript doesn't officially have classical inheritance with classes, Coherent-based projects use the following abstraction to define their classes:

    project.MyView= Class.create(coherent.View, { ... });

Unfortunately, since this isn't standard Javascript, JSDoc Toolkit has no way of understanding it. Fortunately, there's a plug-in mechanism that's more than up to the challenge. So with a little magic, documentation is a snap.

For the most part, JSDoc Toolkit uses a syntax just like JavaDoc. There are some extensions to handle the fact that there are no explicit types, but it's all pretty simple.

## Deployment ## {#deployment}

When deploying my application's resources, I want the following:

* **Small files** &mdash;&#160;by removing all the extra whitespace and comments, the Coherent library shrinks from 532K to 184K. My current project shrinks from 755K to 304K, which includes the variant of the Coherent library shipped with Apple's Dashcode tool.
* **Compressed versions** &mdash;&#160;although Web servers _can_ compress my files on the fly, there's no good reason to do that for static files. So by generating pre-gzipped versions of the output files, I increase response time by just a bit more.
* **A single folder** &mdash; I want to be able to create a gzipped tar archive of my output folder and copy that to the debug, staging or production servers. Everything should be as easy as possible.

Ideally, each version of my static assets will have a unique URL: `http://example.com/res/v1.2/myproject.js` would be newer than `http://example.com/res/v1.1/myproject.js`. Using [mod_expires](http://httpd.apache.org/docs/2.2/mod/mod_expires.html), I can set the expiry date on the entire `v1.2` folder to 1/1/2025 or something equally far in the future, because I know I'll be changing the URL when I release a new version. This means that after the visitor has primed his browser cache, he'll make no more network requests on future pages to fetch the same static resource.

To facilitate versioned static resources, I set my `output-folder` to `~/build/res/latest`. That way the `latest` folder becomes a placeholder that can be generated by the server.

## Development & Debugging ## {#development}

All of this is pointless if it makes development unpleasant. Really, who wants to rebuild between every little code change? If that's what you want, go write Java or C# code.

The first helpful feature for active development is the debug version of the output files: `target-debug.js` or `target-debug.css`. If you include this file instead of the optimised version (`target.js` or `target.css`), you'll get a file that will bootstrap all your original source files. For CSS, the debug version has one `@import` rule for each original source file. For Javascript, there's some trickery to load each individual Javascript file. Performance will suffer, but it will make debugging possible.

In **release** mode, all your source files and assets are copied to the output folder. This means you can just tar-gzip the folder and push it out to the server. You can even add a little hook to your server that will switch over to the debug version of the output files 

In **dev** mode, instead of copying all your source files, the build tool will create symlinks to the original source folders. This means when you're loading the debug version of the output files, you can change the original files without worrying about having to rebuild. Of course, if you add a file or delete a file, you'll need to re-run the build process, but that's a heck of a lot better than running the build after each change.

## Status ##

I'll be wrapping up the code in the next few days. Provided I don't get distracted playing [Lego Star Wars](http://starwars.lego.com/en-us/VideoGame/Default.aspx) with my daughter, you should be able to download something in a week or so...

## Update <em style="color:#999;font-style:normal;font-size:0.8em">10/12/2009</em>## {#update}

The project is now called Distil[^name] and you can download the Ruby Gem from the [Distil project on Google Code](http://code.google.com/p/distil-js/). I know Git and GitHub is more popular these days, especially with the Ruby crowd, but I just don't get Git. Not yet anyway. Hey, give me some credit, I actually built a Gem...

Coming soon, 


[^sprockets]: A notable exception is [Sprockets](http://www.getsprockets.com) which is tailored for building the Prototype and Scriptaculous Javascript libraries. In addition to expecting you to write ruby scripts to configure your build, Sprockets doesn't incorporate lint checking and it makes demands on how you use comments that I don't particularly like.

[^C#doc]: On the other hand, the inline documentation tool for C# and .Net makes my eyes bleed. Since when has **anyone** considered XML a good tool for anything? Do you really **need** to do more XML push ups or [pay the angle bracket tax](http://www.codinghorror.com/blog/archives/001114.html)?

[^name]: Picking a project name is a real challenge. You want something that represents the project, but that isn't either taken or stupid. There's already a distil project on Google Code, but it's empty at the moment. Of course, in spite of my google searches, I'm just as likely to discover a similarly named project that's been around for ages.