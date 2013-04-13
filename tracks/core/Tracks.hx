package core;

import core.db.Database;
import haxe.Json;
import sys.Lib;
import sys.Web;
#if haxe3
import haxe.CallStack;
typedef Stack = haxe.CallStack;
#else
import haxe.Stack;
#end

class Tracks
{
	public static var database:Database;
	public static var settings:Dynamic;

	public static function init(configFile:String="config.json")
	{
		try
		{
			var json = sys.io.File.getContent(configFile);
			settings = Json.parse(json);
		}
		catch (e:Dynamic)
		{
			throw "Failed to load configuration file: " + configFile;
		}

		loadMultipart();

		if (settings.dbPrefix == null) settings.dbPrefix = "";

		// if we have a database, set it up
		if (settings.db != null)
		{
			configureDatabase(settings.db);
		}
	}

	private static function loadMultipart()
	{
		var file:sys.io.FileOutput = null;
		var filename = null;
		Web.parseMultipart(function(pn:String, fn:String) {
			if (fn == "")
			{
				filename = null;
			}
			else
			{
				filename = fn;
				file = sys.io.File.write("/tmp/tracks_upload_" + filename);
			}
		}, function(data:haxe.io.Bytes, position:Int, length:Int) {
			if (null != filename)
			{
				file.write(data);
			}
		});
	}

	private static inline function configureDatabase(db:Dynamic)
	{
		switch (db.provider)
		{
			case "mysql":
				database = new core.db.mysql.Database(db.host, db.port,
												db.user, db.password,
												db.socket, db.database);
			case "mongo":
				var mongo = new org.mongodb.Mongo(db.host, db.port);
				//database = mongo.getDB(db.database);
			case "sqlite":
				database = new core.db.sqlite.Database(db.file);
			default:
				throw "Database provider '" + db.provider + "' not supported";
		}
	}

	/**
	 * Creates a url based on rewrite rules
	 * @param url the relative url to use "posts/new"
	 * @return the complete site url
	 */
	public static inline function siteUrl(url:String):String
	{
		// strip off existing url
		url = StringTools.replace(url, settings.baseUrl, "");
		if (settings.rewrite)
		{
			return settings.baseUrl + url;
		}
		else
		{
			return settings.baseUrl + "?uri=" + url;
		}
	}

	public static function printErrorMsg(e:Dynamic)
	{
		Web.setReturnCode(500);
		Web.setHeader("Content-type", "text/html");
		Lib.print("\n");
		Lib.print("<html><head><title>Error Encountered</title><style>
	body { width:80%;margin:0 auto;font-family:Helvetica,Arial,sans-serif }
	pre { margin: 0;font-family:Inconsolata,Consolas,monospace }
	.error { background:#FFC8C8;border:1px solid #FD4B4B;padding:1em;overflow:scroll }
	#stack { margin:1em;padding:1em;background:#333;color:#FFF }
</style><script>
	function toggle(id) {
		var e = document.getElementById(id);
		if (e.style.display == 'block')
			e.style.display = 'none';
		else
			e.style.display = 'block';
	}
</script></head><body>");
		Lib.print('<h1>An Error Occurred</h1>');
		Lib.print('<div class="error">');
#if php
		Lib.print('<pre class="msg">' + e + '</pre>');
#else
		Lib.print('<p class="msg">Message: ' + e + "</p>");
		Lib.print('<a href="#" onclick="toggle(\'stack\')">Click to see stack trace</a>');
		Lib.print('<div id="stack" style="display:none">');
		for (item in Stack.exceptionStack())
		{
			printStackItem(item);
		}
		Lib.print("</div>");
#end
		Lib.print("</div></body></html>");
	}

	private static function printStackItem(item:StackItem)
	{
		switch(item)
		{
			case CFunction:
				Lib.print('<pre class="function">' + item + '</pre>');
			case Module(module):
				Lib.print('<pre class="module">' + module + '</pre>');
			case Method(classname, method):
				Lib.print('<pre class="method">' + classname + ': ' + method + '</pre>');
			case Lambda(v):
				Lib.print('<pre class="lambda">' + v + '</pre>');
			case FilePos(s, file, line):
				Lib.print('<pre class="line">' + file + ': ' + line + '</pre>');
				if (s != null)
				{
					printStackItem(s);
				}
		}
	}
}