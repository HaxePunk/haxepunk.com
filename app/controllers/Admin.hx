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

		var posts = db.posts.find(null, ["id", "title", "publish_ts"]).sort({ publish_ts: -1 });

		view("admin/index", { posts: posts.results() });
	}

	public function email()
	{
		new core.email.Smtp();
	}

	public function posts(method:String, ?id:Int)
	{
		switch (method)
		{
			case "new":
				addPost();
			case "edit":
				editPost(id);
			case "preview":
				previewPost(id);
		}
	}

	private inline function previewPost(id:Int)
	{
		view("admin/post/preview", {
			post: db.posts.findOne({id: id}, ["content"])
		});
	}

	private inline function editPost(id:Int)
	{
		var post = db.posts.findOne({ id: id }, ["id", "slug", "title", "publish_ts", "content"]);
		var form = new forms.PostForm(post);

		if (form.validate() && false)
		{
			db.posts.update({ id: id }, {
				slug: form.slug.value,
				title: form.title.value,
				content: form.content.value
				// publish_ts: form.publish_ts.value
			});
			// redirect("admin");
		}
		else
		{
			view("admin/post/form", { post: post, postForm: form });
		}
	}

	private inline function addPost()
	{
		var form = new Form('admin/posts/new');
		form.addTextField("title", { label: "Post Title" });
		form.addTextArea("body");
		form.addSubmit("Create Post");

		if (form.validate())
		{
			view("admin/post/form", {content: "hiho"}, true);
		}
		else
		{
			view("admin/post/form", {content: form}, true);
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