---
layout: tutorial
title: Sound Effects
permalink: documentation/tutorials/sound-effects/index.html
---

# Sound Effects

In this tutorial, I will teach you how to embed and play sound effects in your game, as well as how to alter their volume and panning

## Playing sounds

Sounds in HaxePunk are created and played using Sfx objects. Here, I'll create a Sfx object and assign it to a variable in our Player class:

```haxe
import com.haxepunk.Entity;
import com.haxepunk.Sfx;

class Player extends Entity
{
	public var shoot:Sfx;

	public function new()
	{
		super();
		// audio files are placed in the assets/audio folder
		shoot = new Sfx("audio/shoot.mp3");
	}
}
```

So now, our Player can access this sound effect at any time to play() the sound, like this:

```haxe
import com.haxepunk.Entity;
import com.haxepunk.Sfx;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;

class Player extends Entity
{
	public var shoot:Sfx;

	public function new()
	{
		super();
		// audio files are placed in the assets/audio folder
		shoot = new Sfx("audio/shoot.mp3");
	}

	public override function update()
	{
		if (Input.pressed(Key.SPACE))
		{
			// Play the sound when the spacebar is pressed.
			shoot.play();
		}
	}
}
```

That will play the sound once. If you want the sound effect to loop (for example, background music or perhaps a running motor), you can use the loop() function instead, like this:

```
shoot.loop();
```

And stopping a sound effect that is playing simply requires the stop() function:

```
shoot.stop();
```

## Volume & Panning

HaxePunk allows you to change the global volume and panning factor of sound effects by assigning the HXP.volume and HXP.pan properties, like this:

```haxe
// Sets the volume to 50%.
HXP.volume = 0.5;
// Pans all sounds to the left speaker.
HXP.pan = -1;
```

But sometimes you want to change the volume or panning factor of an individually playing sound effect, which is also possible using the Sfx class. If you have a Sfx object, you can assign a volume and panning factor to the sound when you call its play() or loop() function, by passing in the desired parameters:

```haxe
// Play the sound with 50% volume and no panning.
mySfx.play(0.5);
// Play the sound with 100% volume, panned to the right speaker.
mySfx.play(1, 1);
```

And if you want to alter the volume or panning factor of a sound effect during playback, you can just assign the Sfx object's volume and pan properties like so:

```haxe
// Set the sound's volume to 25%.
mySfx.volume = 0.25;
// Pan the sound to the left speaker by 50%.
mySfx.pan = -0.5;
```
