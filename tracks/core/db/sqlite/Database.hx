package core.db.sqlite;

import sys.db.Connection;
import core.db.Table;

class Database implements core.db.Database
{

	public function new(file:String)
	{
#if haxe3
		tablePool = new Map<String,Table>();
#else
		tablePool = new Hash<Table>();
#end
#if php
		cnx = php.db.PDO.open("sqlite:" + file);
#else
		cnx = sys.db.Sqlite.open(file);
#end
		if (cnx == null)
		{
			throw "Could not open database " + file;
		}
	}

	public function resolve(name:String):Table
	{
		if (tablePool.exists(name))
		{
			return tablePool.get(name);
		}
		else
		{
			var table = new Table(cnx, name);
			tablePool.set(name, table);
			return table;
		}
	}

	public function close()
	{
		cnx.close();
	}

	private var cnx:Connection;
#if haxe3
	private var tablePool:Map<String,Table>;
#else
	private var tablePool:Hash<Table>;
#end

}