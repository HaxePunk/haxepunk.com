package core.sessions;

interface Session
{
	public function get(key:String):Dynamic;
	public function unset(key:String):Void;
	public function set(key:String, data:Dynamic):Void;
}