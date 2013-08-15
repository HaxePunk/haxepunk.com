import core.Router;
import core.Lib;

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
			Lib.init("config.json");

			var router = new Router();
			// router.add(~/^route\/([a-z]+)?$/, 'home/$1');
			router.route();
		}
		catch (e:Dynamic)
		{
			Lib.printErrorMsg(e);
		}
	}

}
