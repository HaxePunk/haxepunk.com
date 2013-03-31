package controllers;

import core.Tracks;
import core.db.Table;

class Learn extends core.Controller
{

	public function index()
	{
		var tutorials = db.posts.find({
			publish_ts: { '$lt': Date.now() }
		}, ["id", "title", "slug", "content"]);

		view("learn/list", { tutorials: tutorials.results() });
	}

	public function feed()
	{
		var tutorials = db.posts.find({
			publish_ts: { '$lt': Date.now() }
		}, ["id", "title", "slug", "content", "publish_ts"], 10);

		view("learn/feed", {
			build_dt: Date.now(),
			tutorials: tutorials.results()
		}, "text/xml");
	}

}