---
layout: tutorial
title: Installing HaxePunk
---

# Installing HaxePunk and Setting up a Dev Environment

Before using HaxePunk you'll need to setup your development environment. This tutorial will guide you through the steps of getting everything installed and ready for HaxePunk development.

## Install Haxe

Download Haxe from [http://www.haxe.org/download](http://www.haxe.org/download). Make sure to install 3.0 instead of 2.10.

<hr />

## Install Lime/OpenFL

Lime and [OpenFL](http://www.openfl.org/) are used by HaxePunk to simplify project management and hardware acceleration. You'll need to install and set it up using the commands below.

```bash
haxelib install openfl
haxelib install lime
haxelib install lime-tools
haxelib install openfl-native # needed for native development
haxelib run lime setup
```

### HTML5

HTML5 support is still in the works but if you want to test it out you can install openfl-bitfive from GitHub.

```bash
haxelib git openfl-bitfive https://github.com/YellowAfterlife/openfl-bitfive.git
```

### Setup

Some OpenFL targets need additional setup in order to compile. Use the lime commands below if you plan to target them.

```bash
lime setup windows
lime setup linux
lime setup android
```

<hr />

## Install HaxePunk

After OpenFL is installed and setup you can finally install HaxePunk. You can choose to install the latest stable version or the bleeding edge from GitHub.

### Stable version

```bash
haxelib install HaxePunk
```

This version of HaxePunk requires a specific version of OpenFL to work. The reason is to provide a more stable environment for development. Sometimes haxelib will install newer versions of OpenFL if you run <code>haxelib upgrade</code>. To revert to a previous version of a library you can run the following command.

```bash
haxelib set openfl [version] # change [version] to something like 1.2.5
```

You can find the dependency version by looking at the haxelib.json file inside the HaxePunk project.

### Development version

```bash
haxelib git HaxePunk https://github.com/HaxePunk/HaxePunk.git
```

This frequently will have bug fixes but may also introduce new bugs. If you are looking for a way to contribute code back to HaxePunk this is a good place to start.

### Create a new project

The final step is to create a test project to make sure everything is in working order. By running the following commands you should be presented with a blank window.

```bash
haxelib run HaxePunk new MyProject
cd MyProject
lime test neko # build and run
```

You now have HaxePunk installed and are ready to start developing games! Start with [the basics](http://haxepunk.com/learn/tutorial/haxepunk-101-basics) which will teach you how to add entities and move them in the scene.