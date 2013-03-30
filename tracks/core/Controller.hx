package core;

import sys.Web;
import sys.Lib;
import sys.io.File;
import core.db.Database;

class Controller
{

	public var name:String;

	public function new()
	{
		db = Tracks.database;
	}

	private function redirect(url:String)
	{
		url = Tracks.siteUrl(url);
		Web.setReturnCode(303);
		Web.setHeader("Location", url);
	}

	private function createMacros():Dynamic
	{
		return {
			url: function(resolve:String->Dynamic, url:String):String {
				return Tracks.siteUrl(url);
			}
		};
	}

	private function view(path:String, ?data:Dynamic, ?print:Bool = true):String
	{
		var tpl = null, out = "";

		Template.viewsFolder = Tracks.settings.viewsFolder;
		if (templates.exists(path))
		{
			tpl = templates.get(path);
		}
		else
		{
			var tplFile = File.getContent(Tracks.settings.viewsFolder + path + ".html");
			tpl = new Template(tplFile);
			templates.set(path, tpl);
		}

		if (data == null) data = {};
		data.name = name;
		out = tpl.render(data);

		if (print)
		{
			Web.setReturnCode(200);
			Web.setHeader("X-Powered-By", "Tracks");
			Web.setHeader("Content-type", "text/html");
			Lib.print("\n");
			Lib.print(out);
		}
		return out;
	}

#if haxe3
	private static var templates:Map<String,Template> = new Map<String,Template>();
#else
	private static var templates:Hash<Template> = new Hash<Template>();
#end

	private var db:Database;

}