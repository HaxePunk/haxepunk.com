[![Build Status](https://img.shields.io/travis/HaxePunk/haxepunk.com/gh-pages.svg?style=flat)](https://travis-ci.org/HaxePunk/haxepunk.com)

## About

This is the source of [haxepunk.com](http://haxepunk.com). It is hosted on GitHub Pages using [jekyll](http://jekyllrb.com/). You can compile and test this website on your computer with a local install of jekyll, pull requests are welcome.

1. [Install jekyll](http://jekyllrb.com/docs/installation/)

2. Clone, build and run the server

	```bash
	git clone https://github.com/HaxePunk/haxepunk.com.git
	cd haxepunk.com
    make
    make serve
	```

3. Open [http://localhost:4000](http://localhost:4000)

4. Start hacking on the site. The `--watch` parameter will live reload the site every time a file is changed and saved.

## Demos and Documentation

The demos and API documentation are generated automatically using the installed version of HaxePunk with `make demos` and `make docs`.

Demos are stored in [HaxePunk-examples](https://github.com/HaxePunk/HaxePunk-examples). Each demo should have a data.md file and a thumb.jpg thumbnail which will be used to generate the Demos page.

## Contributing

If you want to contribute and improve our website please work on a [fork](https://github.com/HaxePunk/haxepunk.com/fork). Only working and tested changes will be merged. Use the [issue system](https://github.com/HaxePunk/haxepunk.com/issues) for developer support and approval on your changes.

### Adding a Game

Once you've made something in HaxePunk you can submit it to be showcased on the website.

1. Create a `.md` file inside the `games` folder following this example:

	```markdown
	---
	layout: game
	title: My Game Title
	play_url: http://mygamesite.com/play/
	author: My Name
	---

	This is a description of my **really** great game! You can use Markdown to format the description.
	```

2. Add a 220x124 jpeg screenshot using the same filename of your `.md` file to the `img/games` folder with the `.jpg` extension.
