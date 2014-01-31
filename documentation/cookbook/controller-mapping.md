---
layout: cookbook
title: Joystick Button Mapping
version: 2.4.0
author: MattTuttle and bendmorris
---

```
import com.haxepunk.utils.Joystick;
```

PS3, XBOX and OUYA controller mappings are available for HaxePunk. They will work on native targets that support joysticks (desktop and Ouya).

The GAMEPAD classes are used with `Joystick` similar to the way key presses work with `Input`.

```haxe
if (Input.joystick(0).pressed(XBOX_GAMEPAD.A_BUTTON))
{
	// handle button press
}
```

For a complete list of available variables take a look at [com/haxepunk/utils/Joystick.hx](https://github.com/HaxePunk/HaxePunk/blob/master/com/haxepunk/utils/Joystick.hx).
