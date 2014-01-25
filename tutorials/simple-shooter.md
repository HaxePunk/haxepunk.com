---
layout: hxp
title: HaxePunk 103 - A Simple Shooter
---

# A Simple Shooter

Now that we know how to add entities to the scene and move them around we can learn about collisions. This tutorial will cover how to make a simple space shooter with enemies. I will also talk a little about game prototyping.

Let's start out with a Ship class which holds the basic mechanics for our game.

### src/entities/Ship.hx

<pre class="brush: haxe">
package entities;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;

class Ship extends Entity
{
	public function new(x:Float, y:Float)
	{
		super(x, y);

		graphic = Image.createRect(32, 32, 0xDDEEFF);
		setHitbox(32, 32);

		Input.define("up", [Key.UP, Key.W]);
		Input.define("down", [Key.DOWN, Key.S]);

		velocity = 0;
		type = "player";
	}

	private function handleInput()
	{
		acceleration = 0;

		if (Input.check("up"))
		{
			acceleration = -1;
		}

		if (Input.check("down"))
		{
			acceleration = 1;
		}
	}

	private function move()
	{
		velocity += acceleration * speed;
		if (Math.abs(velocity) > maxVelocity)
		{
			velocity = maxVelocity * HXP.sign(velocity);
		}

		if (velocity < 0)
		{
			velocity = Math.min(velocity + drag, 0);
		}
		else if (velocity > 0)
		{
			velocity = Math.max(velocity - drag, 0);
		}
	}

	public override function update()
	{
		handleInput();
		move();
		moveBy(0, velocity);
		super.update();
	}

	private var velocity:Float;
	private var acceleration:Float;

	private static inline var maxVelocity:Float = 8;
	private static inline var speed:Float = 3;
	private static inline var drag:Float = 0.4;
}
</pre>

This should look very familiar to you since it is essentially the same code from 102. The one major difference is that we are using Image.createRect for the graphic. This will allow you to build out the mechanics without having to worry about graphics. We gave it a color so we can tell the difference between the enemies and the player.

The other addition to this class is the call to setHitbox. This will add a bounding box to your entity so that it can collide with other objects. We also set the type to "player" so that we can reference it by type later on.

An easy way to tell if you have your hitboxes setup correctly is to use the debug console. Build your project by typing in <code>lime test flash -debug</code> and you will see the console. Pressing tilde "~" by default will display all the entities hitbox outlines in red. Handy!

Well, movement is great but we really need to add some action. Let's make a new class and call it Bullet. I think you know where we're going from here. :)

### src/entities/Bullet.hx

<pre class="brush: haxe">
package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;

class Bullet extends Entity
{
	public function new(x:Float, y:Float)
	{
		super(x, y);

		graphic = Image.createRect(16, 4);
		setHitbox(16, 4);
		type = "bullet";
	}

	public override function moveCollideX(e:Entity)
	{
		scene.remove(e);
		scene.remove(this);
		return true;
	}

	public override function update()
	{
		moveBy(20, 0, "enemy");
		super.update();
	}
}
</pre>

Pretty simple right? But what about the moveCollideX function you say? Well, that is simply called from the moveBy function any time there is a collision on the x axis. We added a type to the moveBy function call to specify what type of entity we want to collide with.

So if we build this now, what happens? Nothing! Oh yeah, we need to create an instance of the bullet every time the player press the shoot key. Drop this little snippet into the bottom of handleInput.

### src/entities/Ship.hx

<pre class="brush: haxe">
	if (Input.pressed("shoot"))
	{
		scene.add(new Bullet(x + width, y + height / 2));
	}
</pre>

So cool! All we need now is some enemy ships and we'll have the start of an awesome game.

We're going to make another class called Enemy which is basically a Bullet in reverse. Note the difference in type and what it collides with.

### src/entities/Enemy.hx

<pre class="brush: haxe">
package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;

class Enemy extends Entity
{
	public function new(x:Float, y:Float)
	{
		super(x, y);

		graphic = Image.createRect(32, 32);
		setHitbox(32, 32);
		type = "enemy";
	}

	public override function moveCollideX(e:Entity)
	{
		scene.remove(e);
		scene.remove(this);
		return true;
	}

	public override function update()
	{
		moveBy(-5, 0, "player");
		super.update();
	}
}
</pre>

Well the Enemy class is done but we have no way of spawning new ones. So let's build a spawn timer in GameScene.

### src/scenes/GameScene.hx

<pre class="brush: haxe">
package scenes;

import com.haxepunk.Scene;
import com.haxepunk.HXP;

class GameScene extends Scene
{
	public function new()
	{
		super();
	}

	public override function begin()
	{
		add(new entities.Ship(16, HXP.halfHeight));
		spawn(); // create our first enemy
	}

	public override function update()
	{
		spawnTimer -= HXP.elapsed;
		if (spawnTimer < 0)
		{
			spawn();
		}
		super.update();
	}

	private function spawn()
	{
		var y = Math.random() * HXP.height;
		add(new entities.Enemy(HXP.width, y));
		spawnTimer = 1; // every second
	}

	private var spawnTimer:Float;
}
</pre>

Notice how the timer gets set every time something spawns and counts down until the next one. Play around with randomizing spawn times and enemy movement. Experimenting with different values is the best way to learn.

That's all for this tutorial but look out for more coming in the future.