---
layout: cookbook
title: Haxedef flags
version: 4.0.0
author: bendmorris
---

HaxePunk supports several optional flags that can be passed in using `-Dhxp_XXX`:

| Flag                      | Effect |
|---------------------------|--------|
| `-Dhxp_debug`             | turn on debug info and logs. |
| `-Dhxp_loglevel=info`     | set the log level; can be one of (debug, info, warning, error, critical). Defaults to debug. |
| `-Dhxp_debug_console`     | enables the debug console, which displays application metrics and allows pausing/manipulating the game. |
| `-Dhxp_gl_debug`          | adds additional OpenGL debugging messages, and throws exceptions on GL errors. |
| `-Dhxp_no_render_batch`   | disables the draw call batching optimization. |
