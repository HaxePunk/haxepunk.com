---
layout: cookbook
title: Drawing multiple scenes
version: 2.6.0
author: bendmorris
---

Usually scenes are switched by setting HXP.engine.scene:

```haxe
HXP.engine.scene = new MenuScene();
```

Starting in 2.6.0, you can use an alternative method to draw a temporary scene 
over the previous scene. Set your Scene's `alpha` to a value less than 1:

```haxe
class MenuScene extends Scene
{
    public function new()
    {
        super();
        alpha = 0.5;
    }

    public function close()
    {
        HXP.engine.popScene();
    }
}
```

Then use `pushScene` to push your scene on top of the scene stack:

```haxe
HXP.engine.pushScene(new MenuScene());
```

The parent scene will no longer be active (update won't be called) but it will 
be visible underneath your MenuScene.

When you call `HXP.engine.popScene()`, your scene will be removed from the 
stack, setting the previous scene active again.
