---
layout: tutorial
title: HaxePunk 102 - Movement and Animation
---

# Movement and Animation

Welcome back to the next tutorial in the series! We will be covering animations in this section as well as some advanced movement.

First off let's start with a Player class. Like last time we will extend com.haxepunk.Entity so we can add it to the scene later. This may look daunting but I have added comments to make it easier to tell what is happening. You can use the player image below or create your own.

<img src="http://haxepunk.com/images/learn/player.png" alt="player.png" class="pixelated" width="128" height="32" />

### src/entities/Player.hx

```haxe
package entities;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;

class Player extends Entity
{

	public function new(x:Float, y:Float)
	{
		super(x, y);

		// create a new spritemap (image, frameWidth, frameHeight)
		sprite = new Spritemap("graphics/player.png", 16, 16);
		// define animations by passing frames in an array
		sprite.add("idle", [0]);
		// we set a speed to the walk animation
		sprite.add("walk", [1, 2, 3, 2], 12);
		// tell the sprite to play the idle animation
		sprite.play("idle");

		// apply the sprite to our graphic object so we can see the player
		graphic = sprite;

		// defines left and right as arrow keys and WASD controls
		Input.define("left", [Key.LEFT, Key.A]);
		Input.define("right", [Key.RIGHT, Key.D]);

		velocity = 0;
	}

	// sets velocity based on keyboard input
	private function handleInput()
	{
		velocity = 0;

		if (Input.check("left"))
		{
			velocity = -2;
		}

		if (Input.check("right"))
		{
			velocity = 2;
		}
	}

	private function setAnimations()
	{
		if (velocity == 0)
		{
			// we are stopped, set animation to idle
			sprite.play("idle");
		}
		else
		{
			// we are moving, set animation to walk
			sprite.play("walk");

			// this will flip our sprite based on direction
			if (velocity < 0) // left
			{
				sprite.flipped = true;
			}
			else // right
			{
				sprite.flipped = false;
			}
		}
	}

	public override function update()
	{
		handleInput();

		moveBy(velocity, 0);

		setAnimations();

		super.update();
	}

	private var velocity:Float;
	private var sprite:Spritemap;

}
```

Add a new Player to your GameScene and try it out!

As you can see, adding new animations is as simple as calling the sprite.add() method and calling sprite.play() when the time is right. What if we want the player to slide around a bit though? This is especially helpful if we want to create a platformer type game.

First we need to change the keyboard to apply acceleration instead of velocity. We will then add that acceleration every frame in update. Take a look at the code below.

### src/entities/Player.hx

```haxe
	private function handleInput()
	{
		acceleration = 0;

		if (Input.check("left"))
		{
			acceleration = -1;
		}

		if (Input.check("right"))
		{
			acceleration = 1;
		}
	}

	private function move()
	{
		velocity += acceleration;
		if (Math.abs(velocity) > 5)
		{
			velocity = 5 * HXP.sign(velocity);
		}

		moveBy(velocity, 0);
	}

	public override function update()
	{
		handleInput();

		move();

		setAnimations();

		super.update();
	}

	private var acceleration:Float;
	private var velocity:Float;
```

If you test this now you will notice that the player will never slow down automatically. Oops! Well I guess we should decrease the velocity over time. Add this before the call to moveBy().

### src/entities/Player.hx

```haxe
	if (velocity < 0)
	{
		velocity = Math.min(velocity + 0.4, 0);
	}
	else if (velocity > 0)
	{
		velocity = Math.max(velocity - 0.4, 0);
	}
```

Feel free to play around with the values to add more of a slick feeling or to make it more sticky. Imagine if you knew what type of surface the player was on we could change this dynamically! Even make the animation different depending on how slippery the level is. The possibilities are endless!