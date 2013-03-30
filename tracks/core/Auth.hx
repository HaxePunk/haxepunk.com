package core;

import core.sessions.Session;
import core.db.Table;

class Auth
{

	public function new()
	{
		if (Tracks.database == null)
		{
			session = new core.sessions.FileSession();
		}
		else
		{
			session = new core.sessions.DBSession();
			users = Tracks.database.users;
			users.create([
				DInt("id"),
				DVarChar("username", 80),
				DVarChar("password", 80)
			]);
		}
	}

	public function register(username:String, password:String):Bool
	{
		var user = users.findOne({username: username});
		if (user == null)
		{
			users.insert({
				username: username,
				password: securePassword(password)
			});
			return true;
		}
		else
		{
			return false;
		}
	}

	public function changePassword(username:String, password:String)
	{
		users.update({username: username}, {
			username: username,
			password: securePassword(password)
		});
	}

	public function login(username:String, password:String):Bool
	{
		var user = users.findOne({username: username});
		if (user == null || user.password != securePassword(password))
		{
			return false;
		}

		session.set("user", username);
		return true;
	}

	public function logout()
	{
		session.unset("user");
	}

	public var profile(get_profile, never):String;
	private inline function get_profile():String
	{
		return session.get("user");
	}

	public var loggedIn(get_loggedIn, never):Bool;
	private inline function get_loggedIn():Bool
	{
		return (session.get("user") != null);
	}

	private inline function securePassword(password:String):String
	{
#if haxe3
		return haxe.crypto.Sha1.encode(password);
#else
		return haxe.SHA1.encode(password);
#end
	}

	private var session:Session;
	private var users:Table;
}