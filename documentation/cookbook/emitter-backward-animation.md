---
layout: cookbook
title: Emitter backward animation
version: 2.4.1
author: XXLTomate
---

```
import haxepunk.graphics.Emitter;
```

You can specify if you want your emitter to animate the particles backward,
for instance instead of going from the emitter in a circle they'll go from the circle toward the emitter.

```
emitter.setMotion(name:String, angle:Float, distance:Float, duration:Float, ?angleRange:Float = 0, ?distanceRange:Float = 0, ?durationRange:Float = 0, ?ease:EaseFunction = null, ?backwards:Bool = false);
```

(arguments preceded by a '?' can be omitted.)