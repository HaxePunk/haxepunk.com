package forms;

import core.form.Form;
import core.form.FormField;

class GameForm extends Form
{

	public var title:FormField;
	public var playUrl:FormField;
	public var author:FormField;
	public var platform:FormField;
	public var image:FormField;

	public function new()
	{
		super("games", true);

		title = addTextField("title", {
				label: "Game Title",
				placeholder: "The title of the game.",
				tabIndex: 1,
				validate: "required"
			});

		playUrl = addTextField("play_url", {
				label: "Play URL",
				placeholder: "Where can we play the game?",
				tabIndex: 3,
				validate: "required"
			});

		author = addTextField("author", {
				label: "Author",
				placeholder: "Name or internet handle of the game's author.",
				tabIndex: 2,
				validate: "required"
			});

		image = addFile("image_url", {
				label: "Image",
				validate: "required"
			});

		var result = core.Tracks.database.platforms.find(null, ["id", "name"]).results();
#if haxe3
		var platforms = new haxe.ds.IntMap<String>();
#else
		var platforms = new IntHash<String>();
#end
		for (platform in result)
		{
			platforms.set(platform.id, platform.name);
		}
		platform = addSelect("platform", platforms, 1, {
			label: "Platform",
			validate: "required|alpha"
		});

		addSubmit("Add Game");
	}
}