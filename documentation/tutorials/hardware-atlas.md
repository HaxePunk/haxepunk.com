---
layout: tutorial
title: Hardware Atlases
permalink: documentation/tutorials/hardware-atlases/index.html
---

# Hardware Atlases

One of the major differences between HaxePunk and FlashPunk is that it runs on multiple platforms. Unlike Flash which uses buffer rendering with BitmapData objects, HaxePunk targets take advantage of hardware accelerated rendering using OpenGL/WebGL.

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

AtlasData stores draw calls for an individual texture. Since it is better to only have a single AtlasData for each texture we keep a pool of AtlasData objects.

```haxe
var ad = AtlasData.getAtlasDataByName("assets/graphics/mytexture.png");
```

AtlasData also handles sprite batching so that OpenGL isn't flooded with draw calls. Any time a texture or layer changes the AtlasData object is flushed and rendering continues.

_Note: Prior to version 4.0, HaxePunk included a buffered rendering mode. This, and support for Flash as a target, was removed to make it easier to add hardware-accelerated features without worrying about Flash performance._
