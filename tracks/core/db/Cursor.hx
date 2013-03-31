package core.db;

import sys.db.Connection;
import sys.db.ResultSet;

class Cursor
{

	public var length(get_length, never):Int;
	private function get_length():Int
	{
		return result.length;
	}

	public function new(cnx:Connection, sql:String, limit:String)
	{
		_cnx = cnx;
		_sql = sql;
		_limit = limit;
	}

	public function sort(obj:Dynamic):Cursor
	{
		var fields = new Array<String>();
		for (field in Reflect.fields(obj))
		{
			var value = Reflect.field(obj, field);
			fields.push(field + (value < 0 ? ' DESC' : ' ASC'));
		}
		_sql += ' ORDER BY ' + fields.join(' ');
		return this;
	}

	public function results()
	{
		return result.results();
	}

	public function next()
	{
		return result.next();
	}

	private var result(get_result, never):ResultSet;
	public function get_result():ResultSet
	{
		if (_result == null) _result = _cnx.request(_sql + _limit);
		return _result;
	}

	private var _result:ResultSet;
	private var _cnx:Connection;
	private var _sql:String;
	private var _limit:String;

}