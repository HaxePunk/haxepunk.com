package controllers;

import core.Tracks;
import core.db.Table;
import sys.Web;

class Games extends core.Controller
{

	public function index()
	{
		var form = new forms.GameForm();

		if (form.validate())
		{
			var uploadUri = "uploads/" + form.image.value;
			var authorId = db.authors.insert({
				username: form.author.value
			});
			db.games.insert({
				title: form.title.value,
				play_url: form.playUrl.value,
				image_url: "/" + uploadUri,
				platform_id: form.platform.value,
				author_id: authorId,
				status: 3 // awaiting approval
			});
			Tracks.moveUploadedFile(form.image.value, uploadUri);
			redirect('games');
		}
		else
		{
			var results = db.games.find({
				status: {'$ne': 3}
			}, ["title", "play_url", "image_url", "author_id"]).sort({
				id: -1
			}).results();
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
	}

}