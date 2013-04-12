package controllers;

import core.Tracks;
import core.db.Table;

class Learn extends core.Controller
{

	public function index()
	{
		var tutorials = db.posts.find({
			publish_ts: { '$lt': Date.now() }
		}, ["id", "title", "slug", "category"]).sort({
			publish_ts: 1
		}).results();

		var categories = new Array<String>();
		for (tutorial in tutorials)
		{
			if (Lambda.indexOf(categories, tutorial.category) == -1)
			{
				categories.push(tutorial.category);
			}
		}
		categories.sort(function(a:String, b:String):Int {
			return a < b ? -1 : 1;
		});

		view("learn/home", {
			categories: categories,
			tutorials: tutorials
		});
	}

	public function tutorial(slug:String)
	{
		var tutorial = db.posts.findOne({
			slug: slug
		}, ["id", "title", "slug", "content"]);

		view("learn/view", { tutorial: tutorial });
	}

	public function feed()
	{
		var tutorials = db.posts.find({
			publish_ts: { '$lt': Date.now() }
		}, ["id", "title", "slug", "content", "publish_ts"], 10)
		.sort({ publish_ts: -1 });

		view("learn/feed", {
			build_dt: Date.now(),
			tutorials: tutorials.results()
		}, "text/xml");
	}

}