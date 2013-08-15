package core;

import sys.Web;
import sys.io.File;
import core.db.Database;

class Controller
{

	public var name:String;

	public function new()
	{
		db = Lib.database;
	}

	private function redirect(url:String)
	{
		url = Lib.siteUrl(url);
		Web.setReturnCode(303);
		Web.setHeader("Location", url);
	}

	private function createMacros():Dynamic
	{
		return {
			url: function(resolve:String->Dynamic, url:String):String {
				return Lib.siteUrl(url);
			}
		};
	}

	private function view(path:String, ?data:Dynamic, ?print:Bool = true, ?contentType:String = "text/html"):String
	{
		var tpl = null, out = "";

		Template.viewsFolder = Lib.settings.viewsFolder;
		if (templates.exists(path))
		{
			tpl = templates.get(path);
		}
		else
		{
			var tplFile = File.getContent(Lib.settings.viewsFolder + path + ".html");
			tpl = new Template(tplFile);
			templates.set(path, tpl);
		}

		if (data == null) data = {};
		data.name = name;
		out = tpl.render(data);

		if (print)
		{
			Web.setReturnCode(200);
			Web.setHeader("X-Powered-By", "Haxe");
			Web.setHeader("Content-type", contentType);
			if (contentType == "text/html")
				sys.Lib.print("\n");
			sys.Lib.print(out);
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