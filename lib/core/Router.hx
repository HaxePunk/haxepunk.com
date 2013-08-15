package core;

import sys.Web;

typedef Route = {
	var regex:EReg;
	var path:String;
};

class Router
{

	public function new()
	{
		_routes = new Array();
	}

	public function add(regex:EReg, path:String)
	{
		_routes.push({regex: regex, path: path});
	}

	public function route()
	{
		var params = Web.getParams();
		var controllerName:String = Tracks.settings.defaultController;
		var method:String = Tracks.settings.defaultMethod;

		var args:Array<String> = [], val:String;
		if (params.exists('uri'))
		{
			var uri = StringTools.rtrim(params.get('uri'));
			// remove trailing slash
			if (StringTools.endsWith(uri, "/"))
			{
				uri = uri.substr(0, uri.length - 1);
			}

			// search for user defined routes
			for (r in _routes)
			{
				if (r.regex.match(uri))
				{
					uri = r.regex.replace(uri, r.path);
				}
			}

			args = uri.split('/');

			// Controller
			if (args.length > 0)
			{
				controllerName = args.shift();
			}

			// Method
			if (args.length > 0)
			{
				method = args.shift();
			}
		}

		controllerName = controllerName.toLowerCase();

		// convert to haxe name (poSts = Posts)
		var controllerClass = Tracks.settings.controllerPackage + "." + controllerName.charAt(0).toUpperCase() + controllerName.substr(1);

		// Find the controller and run the appropriate method
		var proto = Type.resolveClass(controllerClass);
		if (proto == null)
		{
			throw "Could not find '" + controllerClass + "'. Make sure it is compiled.";
		}
		else
		{
			var inst = Type.createInstance(proto, []);
			if (inst == null || !Std.is(inst, core.Controller))
			{
				throw "Could not create an instance of " + controllerClass;
			}
			else
			{
				inst.name = controllerName;
				var func = Reflect.field(inst, method);
				if (func == null)
				{
					throw "Method does not exist " + method;
				}
				else
				{
					// get number of arguments for a function
					var numArgs:Int = args.length;
					#if neko
					numArgs = untyped $nargs(func);
					#end

					if (numArgs < args.length)
					{
						throw "Received too many arguments for '" + controllerClass + ":" + method + "()'";
					}

					// fill arguments array with nulls if nothing was passed
					while (args.length < numArgs)
					{
						args.push(null);
					}
					Reflect.callMethod(inst, func, args);
				}
			}
		}
	}

	private var _routes:Array<Route>;

}