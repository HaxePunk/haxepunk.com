---
layout: tutorial
title: Post Processing
permalink: documentation/tutorials/post-process/index.html
---

# Post Processing using GLSL

Fullscreen post processing effects are possible in HaxePunk with two additional classes and some tweaking to your main class. A full example is on GitHub under the [post-process project](https://github.com/HaxePunk/post-process).

![Post processing shaders](/documentation/tutorials/images/shaders.jpg)

First grab the classes [PostProcess.hx](https://raw.github.com/HaxePunk/post-process/master/src/PostProcess.hx) and [Shader.hx](https://raw.github.com/HaxePunk/post-process/master/src/Shader.hx) from the GitHub project. Put these in the root of your project folder. Now we are going to add a few overrides to the main class in your project, normally called _Main.hx_.

### Main.hx

```haxe
import com.haxepunk.Engine;
import com.haxepunk.HXP;

class Main extends Engine
{

	override public function init()
	{
#if debug
		HXP.console.enable();
#end
		HXP.scene = new MainScene();

		// Change to the glsl file you want to use
		post = new PostProcess("shaders/invert.frag");
		post.enable(); // should be after HXP.console.enable
	}

	override public function resize()
	{
		super.resize();
		if (post != null) post.rebuild(); // must be after super.resize
	}

	override public function render()
	{
		post.capture(); // must be before super.render
		super.render();
	}

	private var post:PostProcess;

	public static function main() { new Main(); }

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

## Multi-pass techniques

Now you may be thinking, what if I want to have multiple shaders? The answer is more `PostProcess` objects! You can chain them together by using the framebuffers created on each pass. Here's how to do it with the two shaders we've created.

```haxe
import com.haxepunk.Engine;
import com.haxepunk.HXP;

class Main extends Engine
{

	override public function init()
	{
#if debug
		HXP.console.enable();
#end
		HXP.scene = new MainScene();

		invert = new PostProcess("shaders/invert.frag");
		scanline = new PostProcess("shaders/scanline.frag");
		scanline.setUniform("scale", 1.0);

		invert.enable(scanline); // pass scanline to invert as the "next" shader
		scanline.enable();
	}

	override public function resize()
	{
		super.resize();
		// must rebuild all framebuffers
		if (scanline != null) scanline.rebuild();
		if (invert != null) invert.rebuild();
	}

	override public function render()
	{
		// only capture on the first shader, in this case invert
		invert.capture();
		super.render();
	}

	private var invert:PostProcess;
	private var scanline:PostProcess;

	public static function main() { new Main(); }

}
```

The key is passing an object via the `enable` method. You can also set the `PostProcess.to` variable for the same effect. This connects the framebuffer from one `PostProcess` object to another. You'll also note that we only capture for the first shader. This is because we've chained the framebuffers and only want to render to the first while using the output from that for our `PostProcess` objects.
