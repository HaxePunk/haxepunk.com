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

	public function find(?query:Dynamic, ?returnFields:Array<String>, skip:Int = 0, number:Int = 0):ResultSet
	{
		var fieldList = "", where = "", limit = "", fields = null;
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
			where = " WHERE ";
			fields = Reflect.fields(query);
			for (field in fields)
			{
				where += field + "='" + Reflect.field(query, field) + "' ";
			}
		}
		// limit clause
		if (number > 0)
		{
			limit = " LIMIT " + number + "," + skip;
		}
		return cnx.request("SELECT " + fieldList + " FROM " + table + where + limit);
	}

	public function findOne(?query:Dynamic, ?returnFields:Array<String>):Dynamic
	{
		var rows = find(query, returnFields);
		if (rows.length > 0) return rows.next();
		return null;
	}

	public inline function query(sql:String)
	{
		return cnx.request(sql);
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
		var where = " WHERE ", set = " SET ", fields = null;

		fields = Reflect.fields(select);
		for (field in fields)
		{
			where += field + "='" + Reflect.field(select, field) + "' AND ";
		}
		where = where.substr(0, where.length - 5);

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
			where = " WHERE ";
			var fields = Reflect.fields(select);
			for (field in fields)
			{
				where += field + "='" + Reflect.field(select, field) + "' ";
			}
		}
		cnx.request("DELETE FROM " + table + where);
	}

	private var table:String;
	private var cnx:Connection;

}