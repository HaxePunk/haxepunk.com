HaxePunk Website
=============================

The HaxePunk website is written in Haxe as an MVC framework.

Create a config file like the following and name it config.json in your www folder.

```
{
	"db": {
		"provider": "sqlite",
		"file": "db/haxepunk.db"
	},
	"dbPrefix": "hxp_",

	// set to true if using rewrite rules
	"rewrite": false,
	// full url including domain name, must include forward slash
	"baseUrl": "http://localhost/",

	// relative path to views folder or relative from index.n
	"viewsFolder": "../views/",

	// default routing info
	"defaultController": "Home",
	"defaultMethod": "index",
	"controllerPackage": "controllers"

}
```