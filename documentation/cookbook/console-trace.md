---
layout: cookbook
title: Trace capture in console
version: 2.4.0
author: ibilon
---

```
import haxepunk.debug.Console;
```

By default HaxePunk log all trace() calls into the debug console (when enabled), if you don't want that you can disable it.

```
HXP.console.enable(TraceCapture.No);
```
