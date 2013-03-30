package core.db;

interface Database implements Dynamic<Table>
{
	public function resolve(name:String):Table;
	public function close():Void;
}