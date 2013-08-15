package core.db;

import sys.db.ResultSet;

interface Database implements Dynamic<Table>
{
	public function resolve(name:String):Table;
	public function close():Void;
	public function query(sql:String):ResultSet;
}