package php;

class SMF
{

	public static function __init__() untyped
	{
		__call__("require_once", "/home/ccc/haxepunk_html/forum/SSI.php");
		__php__("$_SESSION['login_url'] = 'http://haxepunk.com' . $_SERVER['PHP_SELF']");
		__php__("$_SESSION['logout_url'] = 'http://haxepunk.com' . $_SERVER['PHP_SELF']");
	}

	public function new()
	{
	}

	public var loggedIn(get_loggedIn, never):Bool;
	private inline function get_loggedIn():Bool
	{
		return checkUserInfo("is_logged") && checkUserInfo("is_admin");
	}

	public function checkUserInfo(name:String):Bool
	{
		if (untyped __var__("GLOBALS", "context", "user", name))
			return true;
		else
			return false;
	}

	public function groups():Array<Int>
	{
		return untyped __php__("$user_info['groups']");
	}

	public function login()
	{
		untyped __call__("ssi_login");
	}

	public function logout()
	{
		untyped __call__("ssi_logout");
	}
}
