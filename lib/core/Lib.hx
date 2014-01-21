package core;

import core.db.Database;
import haxe.Json;
import sys.Web;
#if haxe3
import haxe.CallStack;
typedef Stack = haxe.CallStack;
#else
import haxe.Stack;
#end

class Lib
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

		loadParameters();

		if (settings.dbPrefix == null) settings.dbPrefix = "";

		// if we have a database, set it up
		if (settings.db != null)
		{
			configureDatabase(settings.db);
		}
	}

	public static function getParam(name:String, ?defaultValue:Dynamic):Dynamic
	{
		return params != null && params.exists(name) ? params.get(name) : defaultValue;
	}

	public static function moveUploadedFile(name:String, newPath:String):Bool
	{
		var oldPath = "/tmp/tracks_upload_" + name;
		if (sys.FileSystem.exists(oldPath))
		{
			sys.FileSystem.rename(oldPath, newPath);
			return true;
		}
		return false;
	}

	private static function loadParameters()
	{
		var file:sys.io.FileOutput = null;
		var name = "", filename = "";
		params = Web.getParams();
		Web.parseMultipart(function(pn:String, fn:String) {
			name = pn;
			filename = fn;
			if (filename == "")
			{
				if (file != null)
				{
					file.close();
					file = null;
				}
			}
			else
			{
				file = sys.io.File.write("/home/ccc/haxepunk_html/uploads/" + filename);
				params.set(name, filename);
			}
		}, function(data:haxe.io.Bytes, position:Int, length:Int) {
			if (filename != "")
			{
				file.write(data);
			}
			else
			{
				// TODO: concatenate post data if it extends max data length
				params.set(name, data.toString());
			}
		});
		if (file != null) file.close();
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
		var print = sys.Lib.print; // shorten print code
		print("\n");
		print("<html><head><title>Error Encountered</title><style>
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
		print('<h1>An Error Occurred</h1>');
		print('<div class="error">');
#if php
		print('<pre class="msg">' + e + '</pre>');
#else
		print('<p class="msg">Message: ' + e + "</p>");
		print('<a href="javascript:void(0);" onclick="toggle(\'stack\')">Click to see stack trace</a>');
		print('<div id="stack" style="display:none">');
		for (item in Stack.exceptionStack())
		{
			printStackItem(item);
		}
		print("</div>");
#end
		print("</div></body></html>");
	}

	private static function printStackItem(item:StackItem)
	{
		switch(item)
		{
			case CFunction:
				sys.Lib.print('<pre class="function">' + item + '</pre>');
			case Module(module):
				sys.Lib.print('<pre class="module">' + module + '</pre>');
			case Method(classname, method):
				sys.Lib.print('<pre class="method">' + classname + ': ' + method + '</pre>');
			case LocalFunction(v):
				sys.Lib.print('<pre class="lambda">' + v + '</pre>');
			case FilePos(s, file, line):
				sys.Lib.print('<pre class="line">' + file + ': ' + line + '</pre>');
				if (s != null)
				{
					printStackItem(s);
				}
		}
	}

#if haxe3
	private static var params:Map<String,String>;
#else
	private static var params:Hash<String>;
#end
}