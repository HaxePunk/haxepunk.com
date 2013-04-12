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
		super("games/submit");

		title = addTextField("title", {
				label: "Game Title",
				placeholder: "The title of the game.",
				tabIndex: 1
			});

		playUrl = addTextField("play_url", {
				label: "Play URL",
				placeholder: "Where can we play the game?",
				tabIndex: 3
			});

		author = addTextField("author", {
				label: "Author",
				placeholder: "Name or internet handle of the game's author.",
				tabIndex: 2
			});

		image = addFile("image_url", {
				label: "Image"
			});

		var result = core.Tracks.database.platforms.find(null, ["id", "name"]);
		var platforms = new IntHash<String>();
		for (platform in result.results())
		{
			platforms.set(platform.id, platform.name);
		}
		platform = addSelect("platform", platforms, 1, { label: "Platform" });

		addSubmit("Add Game");
	}
}