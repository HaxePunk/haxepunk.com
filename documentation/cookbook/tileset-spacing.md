---
layout: cookbook
title: Tileset spacing
version: 2.4.4
author: elnabo
---

```
import haxepunk.graphics.Tilemap;
```

If your tileset has some space between the tiles you can now specify it when constructing your tilemap. The tileSpacingWidth and tileSpacingHeight arguments are optional.

```
new Tilemap(tileset:Dynamic, width:Int, height:Int, tileWidth:Int, tileHeight:Int, ?tileSpacingWidth:Int=0, ?tileSpacingHeight:Int=0);
```