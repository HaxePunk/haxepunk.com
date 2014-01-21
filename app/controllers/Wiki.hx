package controllers;

import core.db.Table;

class Wiki extends core.Controller
{

	public function index()
	{
		page("Home");
	}

	public function page(title:String)
	{
		var page = getRecentPage(title);
		var content:String = null;
		if (page != null)
		{
			// match wikipedia [[page|display text]] format
			var link_re = ~/\[\[([^\]\|]+)(|[^\]]+)?\]\]/g;
			content = page.content;

			while (link_re.match(content))
			{
				var page = link_re.matched(1);
				var text = link_re.matched(2);
				if (text == null || text == "")
				{
					text = page;
				}
				else
				{
					text = text.substr(1);
				}

				text = StringTools.trim(text);
				page = StringTools.replace(StringTools.trim(page), " ", "_");
				// TODO: improve url format
				var link = '[' + text + '](/wiki/page/' + page + ')';
				content = link_re.matchedLeft() + link + link_re.matchedRight();
			}

			var code_re = ~/```[ \t]*([a-z]+)?[\r\n]*([^(?:```)]+)```[\r\n]*/g;
			while (code_re.match(content))
			{
				var language = code_re.matched(1);
				if (language == null || language == "") language = "plain";
				var block = code_re.matched(2);
				block = StringTools.replace(block, "<", "&lt;");
				block = StringTools.replace(block, ">", "&gt;");
				var code = '<pre class="brush: ' + language + '">' + block + '</pre>';
				content = code_re.matchedLeft() + code + code_re.matchedRight();
			}
		}
#if php
		var smf = new php.SMF();
		var loggedIn = smf.loggedIn;
#else
		var loggedIn = false;
#end
		view("wiki/page", {
			content: content,
			title: StringTools.replace(title, "_", " "),
			link: title,
			loggedIn: loggedIn
		});
	}

	public function edit(title:String)
	{
		var page = getRecentPage(title);
		var form = new forms.WikiForm(page);
#if php
		var smf = new php.SMF();
		if (!smf.loggedIn)
		{
			redirect('wiki/page/' + title);
			return;
		}
#end
		if (form.validate())
		{
#if php
			var user_id = smf.id;
			db.pages.insert({user_id: user_id, title: title, content: form.content.value});
#end
			redirect("wiki/page/" + title);
		}
		else
		{
			view("wiki/edit", {
				page: page,
				title: StringTools.replace(title, "_", " "),
				link: title
			});
		}
	}

	private inline function getRecentPage(title:String)
	{
		var page = db.pages.find({title: title}, ["content"]).sort({creation_ts: -1});
		if (page.length > 0)
		{
			return page.next();
		}
		else
		{
			return null;
		}
	}

}