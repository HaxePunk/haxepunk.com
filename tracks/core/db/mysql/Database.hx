package core.db.mysql;

import sys.db.Connection;
import core.db.Table;

class Database implements core.db.Database
{

	public function new(host:String="localhost", port:Int=3306, user:String="root", pass:String="", ?socket:String, database:String="mydb")
	{
#if haxe3
		tablePool = new Map<String,Table>();
#else
		tablePool = new Hash<Table>();
#end
#if php
		cnx = php.db.PDO.open('mysql:host=' + host + ';dbname=' + database, user, pass);
#else
		cnx = sys.db.Mysql.connect({
				host : host,
				port : port,
				user : user,
				pass : pass,
				socket : socket,
				database : database
			});
#end
		if (cnx == null)
		{
			throw "Could not connect to database " + database;
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