---
layout: cookbook
title: Multi-platform input
version: 4.0.0
author: bendmorris
---

HaxePunk supports easily combining multiple types of input depending on your target platform.

## Defining input types

Instead of polling for specific key or button presses, you can define named actions and the inputs that trigger them:

```
Key.define("confirm", [Key.ENTER]);
Mouse.define("confirm", MouseButton.LEFT);
```

## Polling-based input

During the update loop, you can check whether an action was triggered, is currently active, or was released this frame:

```
if (Input.pressed("confirm"))
{
	// do something...
}

if (Input.released("charge_shot"))
{
	// do something...
}

if (Input.check("left"))
{
	// do something...
}
```

## Signal-based input

As an alternative, you can bind callback functions that will be invoked when an action starts or finishes. Input signals exist both on each Scene (for scene-specific controls that are only valid when this scene is active) and the Engine (for global controls):

```
HXP.engine.inputPressed.confirm.bind(function() trace("confirm was pressed!"));
HXP.scene.inputReleased.left.bind(function() trace("left was released!"));
```

The name of the `inputPressed` or `inputReleased` field is the string you used to define it earlier.

## Gamepads

```
import haxepunk.input.Gamepad;
```

PS3 and XBOX controller mappings are available for HaxePunk. They will work on any target that supports controllers.

Gamepad input is handled similarly to other types of input:

```haxe
// whenever a gamepad is connected, register controls
gamepad.onConnect.bind(function(gamepad) {
	gamepad.defineButton("left", XboxGamepad.DPAD_LEFT);
	gamepad.defineAxis("left", XboxGamepad.LEFT_ANALOGUE_X, -0.1, -1)
});

HXP.engine.inputPressed.left.bind(function() {
	trace("The player pressed left or moved the left analog stick left");
});
```

For a complete list of available variables take a look at [haxepunk/input/Gamepad.hx](https://github.com/HaxePunk/HaxePunk/blob/master/haxepunk/input/Gamepad.hx).
