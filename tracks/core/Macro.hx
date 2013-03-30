package core;

import haxe.macro.Context;

class Macro
{
	public static function include(pack:String='controllers') {
		var classPaths = Context.getClassPath();
		// normalize class path
		for (i in 0...classPaths.length)
		{
			var cp = StringTools.replace(classPaths[i], "\\", "/");
			if (StringTools.endsWith(cp, "/"))
			{
				cp = cp.substr(0, -1);
			}
			// empty path should be current directory
			if (cp == '')
			{
				cp = '.';
			}
			classPaths[i] = cp;
		}
		for (cp in classPaths)
		{
			var path = cp + "/" + pack.split(".").join("/");
			if (!sys.FileSystem.exists(path) || !sys.FileSystem.isDirectory(path))
			{
				continue;
			}

			for (file in sys.FileSystem.readDirectory(path))
			{
				if (StringTools.endsWith(file, ".hx"))
				{
					Context.getModule(pack + '.' + file.substr(0, file.length - 3));
				}
				else if (sys.FileSystem.isDirectory(path + "/" + file))
				{
					Macro.include(pack + '.' + file);
				}
			}
		}
	}
}