package controllers;

import core.form.Form;
#if php
import php.SMF;
typedef Auth = SMF;
#else
import core.Auth;
#end

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

		var posts = db.posts.find(null, ["id", "title", "publish_ts"]).sort({ publish_ts: -1 });

		view("admin/index", { posts: posts.results() });
	}

	public function email()
	{
		new core.email.Smtp();
	}

	public function posts(?method:String, ?id:Int)
	{
		switch (method)
		{
			case "new":
				postForm();
			case "edit":
				postForm(id);
			default:
				redirect("admin");
		}
	}

	private inline function postForm(?id:Int)
	{
		if (id == null) id = -1;
		var post = db.posts.findOne({ id: id }, ["id", "slug", "title", "publish_ts", "content"]);
		var form = new forms.PostForm(post);

		if (form.validate())
		{
			db.posts.update({ id: id }, {
				slug: form.slug.value,
				title: form.title.value,
				content: form.content.value,
				publish_ts: form.publishDt.value
			});
			redirect("admin/posts/edit/" + id);
		}
		else
		{
			view("admin/post/form", { post: post, postForm: form });
		}
	}

	public function login()
	{
		if (auth.loggedIn)
		{
			redirect('admin/index');
			return;
		}

#if php
		auth.login();
#else
		var form = new Form("admin/login");
		var user = form.addTextField("username", { label: "Username" });
		var pass = form.addPassword("password", { label: "Password" });
		form.addSubmit("Login");

		if (form.validate())
		{
			if (auth.login(user.value, pass.value))
			{
				redirect("admin/index");
				return;
			}
		}
		view("admin/login", {loginForm: form});
#end
	}

#if !php
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
#end

	public function logout()
	{
		auth.logout();
		redirect('admin/login');
	}

	private var auth:Auth;

}