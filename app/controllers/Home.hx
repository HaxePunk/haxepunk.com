package controllers;

import sys.Web;

class Home extends core.Controller
{

	public function index()
	{
		var data = { showcase: null };
		var showcase = db.query("SELECT title, play_url, image_url, author_id
			FROM hxp_games
			WHERE id >= (SELECT FLOOR(MAX(id) * RAND()) FROM hxp_games)
			ORDER BY id LIMIT 1;").next();
		if (showcase != null)
		{
			showcase.author = db.authors.findOne({id: showcase.author_id}, ["username"]).username;
			data.showcase = showcase;
		}
		view("home", data);
	}

	public function info()
	{
		var header = Web.getClientHeader("REQUEST_METHOD");
		var headers = Web.getClientHeaders();
		Web.setHeader("Content-type", "text/html");
		Sys.print("\n<dl>");
		for (h in headers) {
			Sys.print('<dt>'+h.header+'</dt><dd>'+h.value+'</dd>');
		}
		Sys.print('</dl>');
		Sys.print(Web.getPostData());
	}

	public function install()
	{
		db.games.create([
			DInt("id"),
			DVarChar("title", 250),
			DVarChar("play_url", 250),
			DVarChar("image_url", 250),
			DInt("author_id"),
			DInt("platform_id"),
			DSmallInt("status")
		]);

		db.game_status.create([
			DInt("id"),
			DVarChar("status", 80)
		]);

		db.authors.create([
			DInt("id"),
			DVarChar("first_name", 60),
			DVarChar("last_name", 60),
			DVarChar("email", 80),
			DVarChar("author_url", 250),
			DVarChar("username", 80)
		]);

		db.platforms.create([
			DInt("id"),
			DVarChar("name", 80),
			DVarChar("icon_url", 250)
		]);

		db.posts.create([
			DInt("id"),
			DInt("user_id"),
			DDatetime("publish_ts"),
			DDatetime("update_ts"),
			DVarChar("thumb_url", 250),
			DVarChar("title", 150),
			DVarChar("slug", 150),
			DText("content")
		]);

		db.categories.create([
			DInt("id"),
			DInt("parent_id"),
			DVarChar("title", 120),
			DText("comments")
		]);
	}

}