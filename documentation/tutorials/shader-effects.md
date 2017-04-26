---
layout: tutorial
title: Shader Effects
permalink: documentation/tutorials/shader-effects/index.html
---

# Shader Effects

Staring in version 4.0, per-scene and per-graphic graphical effects are easy to use in HaxePunk.

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

		var blurShader = SceneShader.fromAsset("shaders/invert.frg");
		shaders = [blurShader];
	}
}
```

Before we run anything we need to add a shaders folder to assets and hook it into the `project.xml` file. Add the following line inside your `project.xml` after the other `<assets />` lines. This will let you import anything with a `.vert` or `.frag` extension.

```xml
	<assets path="assets/shaders" rename="shaders" include="*.vert|*.frag" />
```

Now comes the really fun part, shaders. You'll notice in the GitHub project there are a bunch of example shaders you can use right off the bat. A few of them require some additional effort to get working but let's start with the `invert.frag` shader since that's what we added above. Drop the following code in a file named `assets/shaders/invert.frag` and test it using neko or cpp (Flash doesn't support glsl).

### assets/shaders/invert.frag

```glsl
#version 120

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

So we can see that the first line specifies the glsl version we want to use, `version 120` is default for OpenGL ES which is what OpenFL uses. The `#ifdef GL_ES` lines are to specify the precision on mobile devices. We could set it to `highp` but `mediump` seems to work well in most cases. Then we have the uniform and varying lines which define variables passed to the shader from the `PostProcess` class. Finally the main function is defined and we are simply inverting the color values and retaining alpha.

What if you want to set your own uniform values though? You're in luck because PostProcess has a way to define them. At the moment it only supports single float values though so you may have to get creative. Take for example the `scanline.frag` shader. It includes a scale uniform that isn't defined by `PostProcess` and initially set to `1.0`.

### assets/shaders/scanline.frag

```glsl
#version 120

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

To set the uniform's value from Haxe you can use the `PostProcess` object in your `Main.hx` file.

```haxe
post = new PostProcess("shaders/scanline.frag");
post.setUniform("scale", 1.5);
```

## Graphic Shaders

Besides applying shaders to the entire scene, you can also use custom shaders to render individual graphics. Each graphic has a `shader` field which you can set to a custom shader:

```haxe
var img = new Image("graphics/my_image.png");
img.shader = customShader;
```

An easy way to create a custom shader for graphics is to use TextureShader and pass in your own fragment shader:

```haxe
var customShader = new TextureShader(Assets.getText("shaders/invert.frag"));
```
