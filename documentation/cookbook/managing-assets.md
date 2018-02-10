---
layout: cookbook
title: Managing assets
version: 4.0.0
author: bendmorris
---

HaxePunk provides some simple abstractions over the underlying framework's asset loading system.

## AssetLoader

To load a new version of an asset by name, use `AssetLoader`:

```haxe
var logo = AssetLoader.getTexture("graphics/logo.png");
```

AssetLoader will always re-load an asset from scratch; it will bypass any caching.

([API docs](/documentation/api/haxepunk/assets/AssetLoader.html))

## AssetCache

`AssetCache` gives you control over how long your assets are cached in memory and when they're disposed.

If you're making a simple game you may not be worried about memory use; in that case, you can use String asset names and they'll be loaded into the global cache automatically:

```haxe
var img = new Image("graphics/img.png");
```

Each Scene also has its own AssetCache instance which will be destroyed when the Scene is removed from the stack, freeing any memory it had allocated. You can pre-cache assets in the Scene AssetCache when the Scene begins:

```haxe
class MyScene extends Scene
{
	override public function begin()
	{
		// load this texture into memory for the duration of this Scene
		assetCache.getTexture("graphics/img.png");

		// use the cached version
		var img = new Image("graphics/img.png");
	}
}
```

You can also create your own AssetCache instances and call their `enable` method for fine-grained control over the lifetime of your assets.

The AssetCache `get` methods (`getTexture`, `getSound`...) will return an asset from the cache if it has already been loaded. If not, it will use AssetLoader to load it, then store it in the cache and return it. If additional AssetCaches try to get the same asset before it has been disposed, it will add additional references in the other caches; the references won't use additional memory, but they will prevent the asset from being disposed until it is removed from every cache.

To load assets and make sure they're always cached, load them into the global AssetCache instance:

```haxe
AssetCache.global.getTexture("graphics/img.png");
```

([API docs](/documentation/api/haxepunk/assets/AssetCache.html))
