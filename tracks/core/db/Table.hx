package core.db;

import sys.db.Connection;
import sys.db.ResultSet;

enum ColumnDataType
{
	DInt(n:String);
	DTinyInt(n:String);
	DSmallInt(n:String);
	DChar(n:String, len:Int);
	DVarChar(n:String, len:Int);
	DText(n:String);
	DDate(n:String);
	DDatetime(n:String);
	DBlob(n:String);
	DDecimal(n:String, len:Int, dec:Int);
}

/**
 * Simplified database queries similar to Mongo driver
 */
class Table
{

	public function new(connection:Connection, name:String)
	{
		table = Tracks.settings.dbPrefix + name;
		cnx = connection;
	}

	public function create(types:Array<ColumnDataType>)
	{
		var defs = new Array<String>();

		for (type in types)
		{
			switch(type)
			{
				case DInt(n):
					defs.push(n + " INTEGER");
				case DTinyInt(n):
					defs.push(n + " TINYINT");
				case DSmallInt(n):
					defs.push(n + " SMALLINT");
				case DDate(n):
					defs.push(n + " DATE");
				case DDatetime(n):
					defs.push(n + " DATETIME");
				case DChar(n, len):
					defs.push(n + " CHAR(" + len + ")");
				case DVarChar(n, len):
					defs.push(n + " VARCHAR(" + len + ")");
				case DText(n):
					defs.push(n + " TEXT");
				case DBlob(n):
					defs.push(n + " BLOB");
				case DDecimal(n, len, dec):
					defs.push(n + " DECIMAL(" + len + ", " + dec + ")");
			}
		}
		cnx.request("CREATE TABLE IF NOT EXISTS " + table + " (" + defs.join(",") + ")");
	}

	private inline function whereFromObject(query:Dynamic):String
	{
		function compare(field:String, operator:String, value:Dynamic):String
		{
			if (Std.is(value, String))
			{
				value = "'" + value + "'";
			}
			else if (Std.is(value, Date))
			{
				value = "'" + DateTools.format(value, '%F %T') + "'";
			}
			return field + operator + value;
		}
		var where = new Array<String>();
		var fields = Reflect.fields(query);
		for (field in fields)
		{
			var value = Reflect.field(query, field);
			if (Std.is(value, String) || Std.is(value, Int))
			{
				where.push(compare(field, '=', value));
			}
			else
			{
				for (comparison in Reflect.fields(value))
				{
					var v = Reflect.field(value, comparison);
					switch (comparison)
					{
						case '$gt': where.push(compare(field, ' > ', v));
						case '$gte': where.push(compare(field, ' >= ', v));
						case '$lt': where.push(compare(field, ' < ', v));
						case '$lte': where.push(compare(field, ' <= ', v));
						case '$eq': where.push(compare(field, ' = ', v));
						case '$ne': where.push(compare(field, ' != ', v));
						default: throw "comparison not supported";
					}

				}
			}
		}
		return " WHERE " + where.join(' AND ');
	}

	public function find(?query:Dynamic, ?returnFields:Array<String>, number:Int = 0, skip:Int = 0):ResultSet
	{
		var fieldList = "", where = "", limit = "";
		if (returnFields == null)
		{
			fieldList = "*";
		}
		else
		{
			fieldList = returnFields.join(",");
		}
		// where clause
		if (query != null)
		{
			where = whereFromObject(query);
		}
		// limit clause
		if (number > 0)
		{
			limit = " LIMIT " + skip + "," + number;
		}
		var sql = "SELECT " + fieldList + " FROM " + table + where + limit;
		return cnx.request(sql);
	}

	public function findOne(?query:Dynamic, ?returnFields:Array<String>):Dynamic
	{
		var rows = find(query, returnFields);
		if (rows.length > 0) return rows.next();
		return null;
	}

	public inline function insert(fields:Dynamic)
	{
		var fieldNames = Reflect.fields(fields);
		var fieldList = " (", fieldValues = "";
		for (field in fieldNames)
		{
			fieldList += field + ", ";
			fieldValues += "'" + Reflect.field(fields, field) + "', ";
		}
		fieldList = fieldList.substr(0, fieldList.length - 2);
		fieldList += ") VALUES (" + fieldValues.substr(0, fieldValues.length - 2) + ")";
		cnx.request("INSERT INTO " + table + fieldList);
	}

	public inline function update(select:Dynamic, setFields:Dynamic)
	{
		var set = " SET ", fields = null;

		var where = whereFromObject(select);

		fields = Reflect.fields(setFields);
		for (field in fields)
		{
			set += field + "='" + Reflect.field(setFields, field) + "', ";
		}
		set = set.substr(0, set.length - 2);

		cnx.request("UPDATE " + table + set + where);
	}

	public inline function remove(select:Dynamic)
	{
		var where = "";
		if (select != null)
		{
			where = whereFromObject(select);
		}
		cnx.request("DELETE FROM " + table + where);
	}

	private var table:String;
	private var cnx:Connection;

}