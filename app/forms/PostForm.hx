package forms;

import core.form.Form;
import core.form.FormField;

class PostForm extends Form
{

	public var title:FormField;
	public var slug:FormField;
	public var content:FormField;
	public var thumb:FormField;
	public var time:FormField;

	public function new(?post:Dynamic)
	{
		super(post == null ? "admin/posts/add" : "admin/posts/edit/" + post.id);

		title = addTextField("title", { label: "Title", value: post.title });
		slug = addTextField("slug", { label: "Slug", value: post.slug });
		time = addTextField("time", { label: "Publish Time", value: post.publish_ts });
		content = addTextArea("content", { label: "Content", value: post.content });
		thumb = addFile("thumbnail", { label: "Thumbnail" });
		addSubmit(post == null ? "Add Post" : "Edit Post");
	}
}