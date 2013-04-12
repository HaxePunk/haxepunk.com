package controllers;

import core.Tracks;
import core.db.Table;
import sys.Web;

class Games extends core.Controller
{

	public function index()
	{
		// var result = gamesTbl.query("SELECT title, play_url, image_url,
		// 	CONCAT(first_name, ' ', last_name) AS name,
		// 	email, author_url, username
		// 	FROM games g
		// 	INNER JOIN authors a
		// 		ON a.id = g.author_id");

		var results = db.games.find(null, ["title", "play_url", "image_url", "author_id"]).results();
		var games = new Array<Dynamic>();
		for (game in results)
		{
			var author = db.authors.findOne({id: game.author_id}, ["first_name", "last_name", "email", "author_url", "username"]);
			if (author.first_name && author.last_name)
				game.author = author.first_name + " " + author.last_name;
			else
				game.author = author.username;
			games.push(game);
		}

		view("games", {
			games: games,
			gameForm: new forms.GameForm()
		});
	}

	public function submit()
	{
		var form = new forms.GameForm();

		if (form.validate())
		{
			var authorId = db.authors.insert({
				username: form.author.value
			});
			db.games.insert({
				title: form.title.value,
				play_url: form.playUrl.value,
				image_url: form.image.value,
				platform_id: form.platform.value,
				author_id: authorId,
				status: 3 // awaiting approval
			});
		}
		redirect('games/index');
	}

}