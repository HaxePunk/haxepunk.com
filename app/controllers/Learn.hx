package controllers;

import core.Tracks;
import core.db.Table;

class Learn extends core.Controller
{

	public function index()
	{
		var tutorials = db.posts.find(null, ["id", "title", "slug", "content"]);

		view("learn", { tutorials: tutorials.results() });
	}

}