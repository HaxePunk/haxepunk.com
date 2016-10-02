---
layout: tutorial
title: Handling Collisions
permalink: documentation/tutorials/handling-collisions/index.html
---

# Handling Collisions

One of the most useful things to be able to do in a game is make Entities interact with each other in different ways, and HaxePunk has a set of useful collision functions for this purpose that will be explained in this tutorial.

## Assigning Hitboxes

HaxePunk uses rectangles for all base-level collision between Entities. You define a rectanular collision area for your Entity, called its **hitbox**, and then you can use HaxePunk's functions to test if an Entity's hitbox intersects with anothers'. So if we have an Entity called **Player**, in it we can define hitbox parameters like this:

```haxe
import com.haxepunk.Entity;

class Player extends Entity
{
	public function new()
	{
		super();

		// Here I set the hitbox width/height with the setHitbox function.
		setHitbox(50, 50);

		// Here I do the same thing by just assigning Player's properties.
		width = 50;
		height = 50;
	}
}
```

I set the hitbox values two different ways here. Both ways work the same, so you can do it whichever way you prefer. Now that we have one Entity with a 50x50 hitbox, let's create another Entity to collide with our Player object. We'll call our other Entity **Bullet**, and then we'll check to see if Player is colliding with it.

So our Bullet Entity will look like this:

```haxe
import com.haxepunk.Entity;

class Bullet extends Entity
{
	public function new()
	{
		super();
		setHitbox(10, 10);
	}
}
```

## Collision Types

So we created the bullet Entity and gave it a 10x10 hitbox, but there's one more line we need to add before we can check if they intersect:

```haxe
import com.haxepunk.Entity;

class Bullet extends Entity
{
	public function new()
	{
		super();
		setHitbox(10, 10);
		type = "bullet";
	}
}
```

Here, I assign a type to the Bullet Entity, and give it the value "bullet". What this does is categorizes the object under the "bullet" type in HaxePunk, because when you want to check for collision against another Entity, you have to provide a type to check against.

> Entity types must be a string value, and do not have to share a name with their corresponding object. You could have multiple different Classes all under the "solid" type, but keep in mind that type-checking is case-sensitive (eg. "solid" is not the same as "Solid" or "SOLID"). So when a Bullet instance is added to the Scene, it will be added to the "bullet" group.

In the next step, I'll show you how to check if our Player is colliding with a Bullet object by using this assigned type.

## Colliding Entities

Now that we have our Bullet Entity classified under the "bullet" group, we can go back to our Player and use Entity's handy collide() function to check if our Player is intersecting with any instances of the "bullet" type in the Scene:

```haxe
import com.haxepunk.Entity;

class Player extends Entity
{
	public function new()
	{
		super();
		setHitbox(50, 50);
	}

	public override function update()
	{
		if (collide("bullet", x, y) != null)
		{
			// Player is colliding with a "bullet" type.
		}
	}
}
```

So here, we use collide() to check if the Player will collide with any "bullet" objects when placed at its current location (x, y). If you wanted to check 10 pixels ahead, you could do so as well:

```haxe
import com.haxepunk.Entity;

class Player extends Entity
{
	public function new()
	{
		super();
		setHitbox(50, 50);
	}

	public override function update()
	{
		if (collide("bullet", x + 10, y) != null)
		{
			// Player will intersect a "bullet" at (x + 10, y).
		}
	}
}
```

But HaxePunk also supports more specific collision behavior as well. Let's say we created our Bullet with a function to destroy the Entity, removing it from the Scene, like so:


```haxe
import com.haxepunk.Entity;
import com.haxepunk.FP;

class Bullet extends Entity
{
	public function new()
	{
		super();
		setHitbox(10, 10);
		type = "bullet";
	}

	public function destroy()
	{
		// Here we could place specific destroy-behavior for the Bullet.
		scene.remove(this);
	}
}
```

So now, what if we want the Bullet to be destroyed when the Player collides with it? For this, we can use the collide() function in Player again, and do this:

```haxe
import com.haxepunk.Entity;

class Player extends Entity
{
	public function new()
	{
		super();
		setHitbox(50, 50);
	}

	public override function update()
	{
		var e:Entity = collide("bullet", x, y);
		if (e != null)
		{
			var b:Bullet = cast(e, Bullet);
			b.destroy();
		}
	}
}
```

This time, instead of putting collide() in the statement, we just assign its return value to a variable. What the collide() function will do is check the Scene for any intersecting instances of "bullet", and if it finds one, it will return the value of that Entity object. If it doesn't find any intersections, it will return as null.

With this knowledge, we can then use that assigned variable in the if-statement, since the statement will only evaluate true for a non-null value. Then, I simply cast the entity to a Bullet type and call the Bullet's destroy() function.
