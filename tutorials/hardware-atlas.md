---
layout: tutorial
title: HaxePunk 201 - Hardware Atlases
---

# Hardware Atlases

One of the major differences between HaxePunk and FlashPunk is that it runs on multiple platforms. Many of these platforms work differently than Flash/HTML5 which use buffer rendering using BitmapData objects. On desktop and mobile targets HaxePunk uses hardware acceleration through OpenGL which use Atlas objects. The reason for this is buffer rendering is simply too slow for most desktop/mobile targets.

### Atlas Classes

Imagine an Atlas as an image with multiple regions cut out of it. If you've worked on mobile you may be familiar with texture packing. This is essentially the same concept except each Atlas class sees the texture in different ways.

#### TileAtlas
* Defines regions based on columns/rows
* Get regions by tile index

#### TextureAtlas
* Defines regions based on a TexturePacker xml format
* Get regions by name

#### Atlas
* Defines the entire image as a single region

TileAtlas and TextureAtlas return AtlasRegion objects, using getRegion(), that define a rectangular section of the Atlas. Each AtlasRegion contains a reference to an AtlasData object and the rectangular area to draw. A region can also be clipped which makes a copy of the AtlasRegion containing a new rectangular area.

### AtlasData

Now this is where it gets a bit tricky. OpenGL performs better when it's state doesn't change constantly. This means that all objects should be grouped by texture, however FlashPunk had objects grouped by layer. But there's a catch... OpenFL doesn't have a z value in drawTiles so in order to maintain layering HaxePunk needs to use the display list by creating a separate sprite for each layer. So every object is grouped by texture then rendered to separate sprites based on the layer it is on. This is where the AtlasData object comes into play.

AtlasData stores draw calls for an individual texture. Since it is better to only have a single AtlasData for each texture we keep a pool of AtlasData objects. This also handles special rendering flags such as transparency, tinting, and blending. So blending is specific to a texture and not an object, like it is in Flash. Here's an example:

```haxe
var ad = AtlasData.getAtlasDataByName("assets/graphics/mytexture.png");
ad.blend = AtlasData.BLEND_NONE; // no blending
ad.alpha = false; // turn off transparency
```

### Sprite Layers

As I mentioned before, each layer is rendered to a separate sprite that has been added to the display list. So what if you want to add an element onto a layer such as video? Well, it's actually pretty simple. Scene keeps track of each sprite layer so you can just call a method to get the appropriate Sprite object.

```haxe
var sprite = scene.getSpriteByLayer(this.layer);
sprite.addChild(myDisplayObject);
```

### Just Give Me Buffer Rendering!

If you're not happy with hardware rendering, or have used BitmapData to do some fancy effects, you can force HaxePunk to use buffer rendering. This is not suggested for mobile devices as you will most likely get around 5fps, if you're lucky.

```haxe
import com.haxepunk.RenderMode;
import com.haxepunk.Engine;

class MyEngine extends Engine
{
	function new(rate:Int = 60, fixed:Bool = false)
	{
		// width/height set to zero to automatically fill the window
		super(0, 0, rate, fixed, RenderMode.BUFFER);
	}
}
```

_Note: This mode is not guaranteed to work in all cases as there are some minor differences between OpenFL and Flash._
