---
layout: tutorial
title: Getting Started
permalink: getting-started/index.html
---

# Getting Started with HaxePunk

Before using HaxePunk you'll need to setup your development environment. This tutorial will guide you through the steps of getting everything installed and ready for HaxePunk development.

## Install Haxe

Download Haxe from [http://www.haxe.org/download](http://www.haxe.org/download). Make sure to install 3.0.1 instead of 2.10. The installer also includes the Neko vm which is necessary for several of Haxe's command line tools.

## Install HaxePunk

Run the following commands to install HaxePunk and setup your development environment.

```bash
haxelib install HaxePunk
haxelib run HaxePunk setup
```

You may need to run the second command as an administrator. It will prompt you to install the Lime tool which I suggest doing. This gives you the shortcut `lime` instead of having to type `haxelib run lime`.

## Upgrading haxelib

HaxePunk installs specific versions of its dependencies on setup. The reason is to provide a stable environment for development. Sometimes haxelib will install newer versions of OpenFL if you run <code>haxelib upgrade</code>. You can see a list of all the installed libraries using `haxelib list`. To revert to a previous version of a library you can run this:

```bash
haxelib set openfl [version] # change [version] to something like 1.2.5
```

Often reverting a library may not even be necessary but if you're noticing bugs after upgrading haxelib it's a good thing to know how to do.

## Lime and OpenFL

OpenFL is a library that implements most of the Flash API for different platforms. Lime, on the other hand, is a low level library used by OpenFL for native targets. It also contains the tools you'll be using to build and test projects.

Some targets need an additional step in order to compile. Use the lime commands below if you plan to target them.

```bash
# lime test cpp
lime setup windows
lime setup linux

# lime test android
lime setup android
```

## GitHub <i class="icon-github"></i>

Once you've been using HaxePunk for a while you may want install the bleeding edge version to test new features. You can install HaxePunk from GitHub using the following commands:

```bash
haxelib git HaxePunk https://github.com/HaxePunk/HaxePunk.git
haxelib run HaxePunk setup
```

To revert back to the latest stable version you'll need to disable the development version.

```bash
haxelib dev HaxePunk
```

## Create a new project

The final step is to create a test project to make sure everything is in working order. By running the following commands you should be presented with a blank window.

```bash
haxelib run HaxePunk new MyProject
cd MyProject
lime test neko # build and run
```

You now have HaxePunk installed and are ready to start developing games! Start with [the basics](/documentation/tutorials/haxepunk-basics) which will teach you how to add entities and move them in the scene.
