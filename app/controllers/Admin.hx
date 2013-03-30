package controllers;

import core.Auth;
import core.form.Form;

class Admin extends core.Controller
{

	public function new()
	{
		auth = new Auth();
		super();
	}

	public function index()
	{
		if (!auth.loggedIn)
		{
			redirect('admin/login');
			return;
		}

		var content = view("admin/index", null, false);
		view("admin/template", {content: content});
	}

	public function posts(method:String)
	{
		switch (method)
		{
			case "new":
				add_post();
		}
	}

	private inline function add_post()
	{
		var form = new Form('admin/posts/new');
		form.addTextField("title").label = "Post Title";
		form.addTextArea("body");
		form.addSubmit("Create Post");

		if (form.validate())
		{
			view("admin/template", {content: "hiho"}, true);
		}
		else
		{
			view("admin/template", {content: form}, true);
		}
	}

	public function login()
	{
		if (auth.loggedIn)
		{
			redirect('admin/index');
			return;
		}

		var form = new Form("admin/login");
		var user = form.addTextField("username");
		user.label = "Username";
		var pass = form.addPassword("password");
		pass.label = "Password";
		form.addSubmit("Login");

		if (form.validate())
		{
			if (auth.login(user.value, pass.value))
			{
				redirect("admin/index");
				return;
			}
		}
		view("admin/template", {content: form}, true);
	}

	public function register()
	{
		if (auth.loggedIn)
		{
			redirect('admin/index');
			return;
		}

		var form = new Form("admin/posts/new");
		var user = form.addTextField("username");
		var pass = form.addPassword("password");
//		form.addPassword("passmatch").label("Re-enter Password").required().match("password");
		form.addSubmit("Register");

		if (form.validate())
		{
			auth.register(user.value, pass.value);
			redirect('admin/index');
		}
		else
		{
			view("admin/template", {content: form}, true);
		}
	}

	public function logout()
	{
		auth.logout();
		redirect('admin/login');
	}

	private var auth:Auth;

}