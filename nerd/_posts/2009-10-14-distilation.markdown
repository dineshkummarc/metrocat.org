---
layout: post
title: Distilation
date: 2009-10-14
author: Jeff Watkins
categories:
- Javascript
- distil
---

Like most build systems, Distil requires a build file. This is similar to a `build.xml` file from Ant[^xml] or a rake file, however, Distil uses a YAML file rather than XML or Ruby. This means its files are simple and easier to understand. This is in keeping with the goal to keep Distil simple and easy to understand.

**Distil is not a general purpose build system.** Its only purpose in life is to create deployment versions of your Javascript and CSS files and their associated asset files.

The Distil project should be named `distil.yml` and be placed in the root of your project. If you don't want a different name for your project file, you'll need to invoke distil with the `-buildfile` option like this:

    distil -buildfile=project.yml

You can also abbreviate `-buildfile` as `-file` or simply `-f`.

## An Example Distil File##

The following is a **very** simple distil project file. It has two targets: `all` and `login`.

    name: sample
    version: 1.0
    notice: src/NOTICE

    all:
        - src/file1.js
        - src/file2.js
        - src/dir1
        - src/dir2

    login:
        include:
            - src/dir3
        exclude:
            - src/dir3/i-hate-this-file.js

Assuming there are only Javascript files in this project, when built distil will generate the following files:

    build/sample-debug.js
    build/sample-uncompressed.js
    build/sample.js
    build/sample.js.gz
    build/sample-login-debug.js
    build/sample-login-uncompressed.js
    build/sample-login.js
    build/sample-login.js.gz

Additionally, when built in debug mode (the default), distil will create a symbolic link in the `build` folder to the `src` folder. This means you can simply serve up the build folder via Apache and everything will just work. When build in release mode, distil will actually copy the source and asset files.

Any top-level key/value pair that isn't an option is a target. While YAML will permit you to define your options anywhere in the file, you'll find it easier to understand your build file.

## Target ##

A target inherits all of the global options and may define its own. The name of the target is used to form the name of the output files for this target. The standard format is:

    <project-name>-<target-name>.[css|jss]

The debug and uncompressed versions of the target's output files are similar:

    <project-name>-<target-name>-debug.[css|jss]
    <project-name>-<target-name>-uncompressed.[css|jss]

The `all` target is assumed to be your primary target &mdash; and for simple projects, your only target &mdash; so the name of its output files do not include the target name.

## Options ##

These options may be defined either for the entire project or only for a specific target.

name
:    This is the name of your project. This is the only required option and should be defined at the top of the project file.

version
:    What version is your project? You can insert this into your output files using the sequence `@VERSION@`.

mode
:    Anything other than `release` triggers debug/development mode.

tasks
:    What tasks should execute. Defaults to `js`, `css`, `html`. Basically everything.

targets
:    What targets should be built. I almost never use this one.

remove prefix
:    When source and asset file references get rewritten, it's sometimes necessary to remove part of the path. For example, if all your Javascript and CSS reside within the `src` folder, but you **don't** want a `src` folder in your output tree, you can remove it using this option.

output folder
:    Where should the build product go? The default is `build`.

external projects
:    What does your project depend upon? This is an array where the values may be either a folder containing another distil project or a structure defining how to build the external project.

        external projects: ../coherent

    is the same as:

        external projects:
            - ../coherent

    which is the same as:

        external projects:
            - folder: ../coherent
            - build: distil
            - include: ../coherent/build

    **External projects may only be defined at the project level.**

notice
:    It's your code, this is your copyright statement. Or your manifesto. Or whatever. This notice will be prepended as a comment to every output file.

bootstrap file
:    When building the debug version of your Javascript library, this is the template for the Javascript file that will load each of your sources. Distil provides a default bootstrap file, but you can replace it if you _really_ want to.

jsl conf
:    Where is your configuration file for Javascript Lint located. You don't need to specify this unless you _have_ a config file and you've put it in a clever location. By default, Distil will look for a `jsl.conf` file in the same folder as the build file then a `.jsl.conf` file in your home folder. If neither of those exist, the stock `jsl.conf` file included with Distil will be used.

jsdoc template
:    Have you created a custom template for JSDoc Toolkit? Great, put a reference to the template folder here and your docs will use your template rather than the default one included with Distil.

doc folder
:    Where do you want your docs to live? The default value is `docs`.

generate docs
:    Building Javascript documentation takes serious time. So the default value for this option is `false`. To build documentation, I use the following command line:

        distil -target=webkit -generate-docs

    This will build only the specified target (`webkit`) and turn on documentation for this build.

## Conclusion ##

Although Distil is a work in progress, I'm using it to build a production system containing 130 Javascript files and 20 CSS files.
