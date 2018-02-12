---
layout: tutorial
title: Shader Effects
permalink: documentation/tutorials/shader-effects/index.html
---

# Shader Effects

Starting in version 4.0, per-scene and per-graphic graphical effects are easy to use in HaxePunk.

![Post processing shaders](/documentation/tutorials/images/shaders.jpg)

### Scene Shaders

The easiest way to apply a shader to the entire scene contents is to use `haxepunk.graphics.shaders.SceneShader`. Simply create one or more SceneShader objects and set your scene's `shaders` field:

```haxe
import haxepunk.Scene;
import haxepunk.graphics.shader.SceneShader;

class MyScene extends Scene
{
	public function new()
	{
		super();

		var invertShader = SceneShader.fromAsset("shaders/invert.frg");
		shaders = [invertShader];
	}
}
```

Before we run anything, we need to add a shaders folder to assets and hook it into the `project.xml` file. Add the following line inside your `project.xml` after the other `<assets />` lines. This will let you import anything with a `.vert` or `.frag` extension.

```xml
	<assets path="assets/shaders" rename="shaders" include="*.vert|*.frag" />
```

Now comes the really fun part. Drop the following code in a file named `assets/shaders/invert.frag` and test it.

### assets/shaders/invert.frag

```glsl
#ifdef GL_ES
	precision mediump float;
#endif

varying vec2 vTexCoord;
uniform sampler2D uImage0;

void main(void)
{
	vec4 color = texture2D(uImage0, vTexCoord);
	gl_FragColor = vec4(vec3(1.0, 1.0, 1.0) - color.rgb, color.a);
}
```

Let's break this down. The `#ifdef GL_ES` lines are to specify the precision on mobile devices. We could set it to `highp` but `mediump` seems to work well in most cases. Then we have the `uniform` and `varying` lines which define variables passed to the shader from our `SceneShader` object. Finally we define the main function, which simply inverts the color values and retains the alpha.

What if you want to set your own uniform values though? You're in luck because `SceneShader` has a way to define them. At the moment it only supports single float values though so you may have to get creative. Take for example the `scanline.frag` shader. It includes a scale uniform that isn't defined by `SceneShader` and initially set to `1.0`.

### assets/shaders/scanline.frag

```glsl
#ifdef GL_ES
    precision mediump float;
#endif

varying vec2 vTexCoord;
uniform vec2 uResolution;
uniform sampler2D uImage0;

uniform float scale = 1.0;

void main()
{
    if (mod(floor(vTexCoord.y * uResolution.y / scale), 2.0) == 0.0)
        gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
    else
        gl_FragColor = texture2D(uImage0, vTexCoord);
}
```

To set the uniform's value from Haxe you can use the `SceneShader` object in your `Main.hx` file.

```haxe
var scanlineShader = new SceneShader("shaders/scanline.frag");
scanlineShader.setUniform("scale", 1.5);
```

## Graphic Shaders

Besides applying shaders to the entire scene, you can also use custom shaders to render individual graphics. An easy way to create a custom shader for graphics is to use `TextureShader` and pass in your own fragment shader:

```haxe
var customShader = new TextureShader.fromAsset("shaders/invert.frag");
```

Each graphic has a `shader` field which you can set to a custom shader:

```haxe
var img = new Image("graphics/my_image.png");
img.shader = customShader;
```