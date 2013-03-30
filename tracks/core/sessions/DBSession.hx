package core.sessions;

import sys.Web;
import core.db.Table;

class DBSession implements Session
{

	public function new()
	{
		sessionTbl = Tracks.database.sessions;
		sessionTbl.create([
			DChar("_id", 32),
			DText("data"),
			DDate("expires")
		]);

		if (expires == null)
		{
			var cookies = Web.getCookies();
			if (cookies.exists("sid"))
			{
				sessionId = cookies.get("sid");
				var sess = sessionTbl.findOne({_id: sessionId});
				if (sess == null)
				{
					init();
				}
				else
				{
					session = haxe.Unserializer.run(sess.data);
					expires = sess.expires;
				}
			}
			else
			{
				init();
			}
		}
	}

	public inline function remove()
	{
		sessionTbl.remove({_id: sessionId});
	}

	public inline function get(key:String):Dynamic
	{
		return session.get(key);
	}

	public function unset(key:String)
	{
		session.remove(key);
		sessionTbl.update({_id: sessionId}, {
			_id: sessionId,
			data: haxe.Serializer.run(session),
			expires: expires
		});
	}

	public function set(key:String, data:Dynamic)
	{
		session.set(key, data);
		sessionTbl.update({_id: sessionId}, {
			_id: sessionId,
			data: haxe.Serializer.run(session),
			expires: expires
		});
	}

	private function init()
	{
		sessionId = createSessionId();
		sessionTbl.insert({
			_id: sessionId,
			data: haxe.Serializer.run(session),
			expires: Date.now()
		});
		Web.setCookie("sid", sessionId, expires);
	}

	private static inline function createSessionId(length:Int = 32):String
	{
		var nchars = UID_CHARS.length;
		var id = "";
		for (i in 0 ... length)
		{
			id += UID_CHARS.charAt( Std.int(Math.random() * nchars) );
		}
		return id;
	}

	private var sessionTbl:Table;

	private static var sessionId:String;
#if haxe3
	private static var session:Map<String,Dynamic> = new Map<String,Dynamic>();
#else
	private static var session:Hash<Dynamic> = new Hash<Dynamic>();
#end
	private static var expires:Date = null;

	private static var UID_CHARS = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
}