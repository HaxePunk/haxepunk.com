import core.Router;
import core.Tracks;

class Index
{

	public static function main()
	{
		// Web.cacheModule(run);
		run();
	}

	public static function run()
	{
		try
		{
			Tracks.init("config.json");

			var router = new Router();
			// router.add(~/^route\/([a-z]+)?$/, 'home/$1');
			router.route();
		}
		catch (e:Dynamic)
		{
			Tracks.printErrorMsg(e);
		}
	}

}
