package core.sessions;

import sys.Web;
import sys.io.File;
import sys.FileSystem;

class FileSession implements Session
{

	public function new()
	{
		if (expires == null)
		{
			var cookies = Web.getCookies();
			if (cookies.exists("sid"))
			{
				sessionId = cookies.get("sid");
				if (FileSystem.exists(filename))
				{
					readFromFile();
					return;
				}
			}

			init();
		}
	}

	public inline function remove()
	{
		if (FileSystem.exists(filename))
		{
			FileSystem.deleteFile(filename);
		}
	}

	public inline function get(key:String):Dynamic
	{
		return session.get(key);
	}

	public function unset(key:String)
	{
		session.remove(key);
		writeToFile();
	}

	public function set(key:String, data:Dynamic)
	{
		session.set(key, data);
		writeToFile();
	}

	private inline function readFromFile()
	{
		var input = File.read(filename);
		expires = Date.fromTime(input.readFloat());
#if haxe3
		var length = input.readInt32();
#else
		var length = input.readInt31();
#end
		session = haxe.Unserializer.run(input.readString(length));
		input.close();
	}

	private inline function writeToFile()
	{
		var data = haxe.Serializer.run(session);
		try
		{
			var out = File.write(filename);
			out.writeFloat(expires.getTime());
#if haxe3
			out.writeInt32(data.length);
#else
			out.writeInt31(data.length);
#end
			out.writeString(data);
			out.close();
		}
		catch(e:Dynamic)
		{
			throw 'Failed to write to the sessions folder. Permissions may need to be set or use a database instead.';
		}
	}

	private inline function init()
	{
		sessionId = createSessionId();
		expires = Date.now();
		writeToFile();
		Web.setCookie("sid", sessionId, expires);
	}

	private var filename(get_filename, never):String;
	private inline function get_filename():String
	{
		return "sessions/" + sessionId;
	}

	private static inline function createSessionId(length:Int = 32):String
	{
		var nchars = UID_CHARS.length;
		var id = "";
		for (i in 0 ... length){
			id += UID_CHARS.charAt( Std.int(Math.random() * nchars) );
		}
		return id;
	}

	private static var sessionId:String;
#if haxe3
	private static var session:Map<String,Dynamic> = new Map<String,Dynamic>();
#else
	private static var session:Hash<Dynamic> = new Hash<Dynamic>();
#end
	private static var expires:Date = null;

	private static var UID_CHARS = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
}