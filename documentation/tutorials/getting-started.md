---
layout: tutorial
title: Getting Started
permalink: documentation/tutorials/getting-started/index.html
---

# Getting Started with HaxePunk

Before using HaxePunk you'll need to setup your development environment. This tutorial will guide you through the steps of getting everything installed and ready for HaxePunk development.


## Install Haxe

For Windows and Mac, download and install the latest Haxe from [http://www.haxe.org/download](http://www.haxe.org/download). These installers also includes the Neko VM which is necessary for several of Haxe's command line tools.


## Install a backend

#### Lime and OpenFL

To install OpenFL and Lime:

```bash
haxelib install openfl
```

OpenFL is a library that implements most of the Flash API for different platforms. Lime is a low level library used by OpenFL for native targets. It also contains the tools you'll be using to build and test projects.

Some targets need an additional step in order to compile. Use the lime commands below if you plan to target them.

```bash
# lime test cpp
lime setup windows
lime setup linux

# lime test android
lime setup android
```

#### NME

NME is an alternative to OpenFL and Lime. Currently, you can substitute NME for all supported targets except HTML5.

To install NME, run `haxelib install nme`. You can then build with `nme test neko`.


## Install HaxePunk

Run the following commands to install HaxePunk and setup your development environment.

```bash
haxelib install HaxePunk
haxelib run HaxePunk setup
```

If you downloaded a zip version of HaxePunk replace the first command with `haxelib local nameOfTheArchive.zip`.

You may need to run the second command as an administrator. It will prompt you to install the Lime tool which I suggest doing. This gives you the shortcut `lime` instead of having to type `haxelib run lime`.


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
