---
layout: tutorial
title: Hardware Atlases
permalink: hardware-atlases/index.html
---

# Hardware Atlases

One of the major differences between HaxePunk and FlashPunk is that it runs on multiple platforms. Many of these platforms work differently than Flash/HTML5 which uses buffer rendering with BitmapData objects. On desktop and mobile targets HaxePunk uses hardware acceleration through OpenGL which use Atlas objects. The reason for this is buffer rendering is simply too slow native targets.

### Atlas Classes

Imagine an Atlas as an image with multiple regions cut out of it. If you've worked on mobile you may be familiar with texture packing. This is essentially the same concept except each type of Atlas class sees the texture in different ways.

<dl>
	<dt>TileAtlas</dt>
	<dd>Defines regions based on columns and rows</dd>
	<dd>Get regions by tile index</dd>

	<dt>TextureAtlas</t>
	<dd>Defines regions based on a TexturePacker xml format</dd>
	<dd>Get regions by name</dd>

	<dt>BitmapTextAtlas</dt>
	<dd>Based off TextureAtlas but used for the BitmapText graphic</dd>

	<dt>Atlas</t>
	<dd>Defines the entire image as a single region</dd>
</dl>

TileAtlas and TextureAtlas return AtlasRegion objects, using getRegion(), that define a rectangular section of the image. Each AtlasRegion contains a reference to an AtlasData object and the rectangular area to draw. A region can also be clipped which makes a copy of the AtlasRegion containing a new rectangular area.

### AtlasData

AtlasData stores draw calls for an individual texture. Since it is better to only have a single AtlasData for each texture we keep a pool of AtlasData objects. This also handles special rendering flags such as transparency, tinting, and blending. So blending is specific to a texture and not an object, like it is in Flash. Here's an example:

```haxe
var ad = AtlasData.getAtlasDataByName("assets/graphics/mytexture.png");
ad.blend = AtlasData.BLEND_NONE; // no blending
ad.alpha = false; // turn off transparency
```

If you're looking for a way to increase performance, turning off blending and alpha on images will help. This is a global change so use it on images like tilemaps that might not need transparency.

AtlasData also handles sprite batching so that OpenGL isn't flooded with draw calls. Any time a texture or layer changes the AtlasData object is flushed and rendering continues.

### Just Give Me Buffer Rendering!

If you're not happy with hardware rendering, or have used BitmapData to do some fancy effects, you can force HaxePunk to use buffer rendering. This is not suggested for mobile devices as you will most likely get around 5fps, if you're lucky.

You can set buffer rendering on initialization like this:

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

Or you can toggle between the different modes like this:

```haxe
// set to buffer mode
HXP.renderMode = RenderMode.BUFFER;
// set to hardware mode
HXP.renderMode = RenderMode.HARDWARE;
```

_Note: This mode is not guaranteed to work in all cases as there are some minor differences between OpenFL and Flash._
