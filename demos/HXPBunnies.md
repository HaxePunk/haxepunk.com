---
layout: demo
title: HXPBunnies
width: 720
height: 405
source: https://github.com/Beeblerox/HXPBunnies
---

HaxePunk port of BunnyMark Benchmark. Click the stage to add bunnies and test performance.

The initial BunnyMark was created by [Iain Lobb](http://blog.iainlobb.com/2010/11/display-list-vs-blitting-results.html) (code) and [Amanda Lobb](http://amandalobb.com/) (art), then ported to haxe-NME by [Joshua Granick](http://www.joshuagranick.com/blog/?p=508), then enhanced by [Philippe Elsass](https://github.com/elsassph/nme-bunnymark), now ported to HaxePunk by [Beeblerox](https://github.com/Beeblerox).

Flash is limited to software rendering so there is a significant performance improvement when you use cpp targets. Cpp targets make use of drawTiles() GPU Acceleration and on a desktop it can display 10 000's of bunnies with additional variations of alpha and scaling. On the Flash target however, rendering with alpha and scaling means a severe performance decrease.