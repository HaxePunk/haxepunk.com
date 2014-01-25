---
layout: hxp
title: HaxePunk 101 - Getting Started
---

# Getting Started

This tutorial assumes you have gone through the [Getting Started](/learn/tutorial/getting-started) tutorial.

Now that you have HaxePunk installed it is time to start making a game. We will start with a new project to keep things simple.

<pre class="brush: bash">
haxelib run HaxePunk new Tut01
</pre>

Now we need to make our main game scene. Create a folder and name it scenes and put a file named GameScene.hx into that folder. You will also need to copy this block graphic and put in assets/graphics.

<img src="http://haxepunk.com/images/learn/block.png" alt="Block" class="pixelated" width="64" height="64" />

### src/scenes/GameScene.hx

<pre class="brush: haxe">
package scenes;

import com.haxepunk.Scene;
import com.haxepunk.graphics.Image;

class GameScene extends Scene
{

	public function new()
	{
		super();
	}

	public override function begin()
	{
		addGraphic(new Image("graphics/block.png"));
	}

}
</pre>

Notice that we added a function `begin` by overriding it. This will get called when the scene is added in HaxePunk. We've also called the addGraphic function to add a new image to the scene. We do this by passing in the path to our asset file.

If we tested the project now, nothing would happen. So in order for everything to work we need to hook up the scene to our Main class.

### src/Main.hx

<pre class="brush: haxe">
HXP.scene = new scenes.GameScene();
</pre>

We are setting HXP.scene to a new instance of GameScene. This creates the scene and starts it up, calling the begin function we previously created.

Everything is in place so let's test out the project.

<pre class="brush: bash">
lime test flash
</pre>

If everything builds you should see an image of a block in the upper left hand corner of the screen. Let's make this a little more interesting by moving the block around. The following changes should be made to the GameScene class.

### src/scenes/GameScene.hx

<pre class="brush: haxe">
package scenes;

import com.haxepunk.Entity;
import com.haxepunk.Scene;
import com.haxepunk.graphics.Image;

class GameScene extends Scene
{

	public function new()
	{
		super();
	}

	public override function begin()
	{
		block = addGraphic(new Image("graphics/block.png"));
	}

	public override function update()
	{
		block.moveBy(2, 1);

		super.update();
	}

	private var block:Entity;

}
</pre>

Notice that we added an update function which applies changes to the block entity on every frame. The moveBy function takes an x and y value to move an entity. You could also apply the movement using:
<pre class="brush: haxe">block.x += 2;</pre>
but we'll see why moveBy is useful in a bit.

This example isn't very interesting yet and it would be better if we could control the object. Let's create another class and put it in a new folder named entities. For lack of a better name I'm going to call the class Block.

### src/entities/Block.hx

<pre class="brush: haxe">
package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;

class Block extends Entity
{
	public function new(x:Int, y:Int)
	{
		super(x, y);

		graphic = new Image("graphics/block.png");
	}
}
</pre>

To define a new entity we will always extend the com.haxepunk.Entity class. Notice that I am creating the image inside the Block's constructor and applying it to graphic variable. This will cause the Block to show up on the screen once we add it to the scene. Let's go ahead and do that now. Replace the GameScene code with the following:

### src/scenes/GameScene.hx

<pre class="brush: haxe">
package scenes;

import com.haxepunk.Scene;
import entities.Block;

class GameScene extends Scene
{

	public function new()
	{
		super();
	}

	public override function begin()
	{
		add(new Block(30, 50));
	}

}
</pre>

If you test now, you should now see a block positioned at (30, 50). This is how you will add most entities to the scene. Although I promised that we would be able to move this block ourselves and I didn't lie. Onward!

You will need to add an update function to the Block class and import the Input/Key classes. Then all we have to do is check every frame if the left or right arrows are pressed and move the block.

### src/entities/Block.hx

<pre class="brush: haxe">
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;

...

	public override function update()
	{
		if (Input.check(Key.LEFT))
		{
			moveBy(-2, 0);
		}

		if (Input.check(Key.RIGHT))
		{
			moveBy(2, 0);
		}

		super.update();
	}
</pre>

So now you have learned how to add graphics, create entities, and move them around on the screen. Challenge yourself to update the code so that the block can move vertically. Happy coding!