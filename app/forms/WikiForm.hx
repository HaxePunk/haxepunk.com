package forms;

import core.form.Form;
import core.form.FormField;

class WikiForm extends Form
{

	public var title:FormField;
	public var content:FormField;
	public var publishDate:FormField;

	public function new(?post:Dynamic)
	{
		super(post == null ? "admin/posts/add" : "admin/posts/edit/" + post.id);

		title = addTextField("title", { label: "Title", value: post == null ? "" : post.title });
		publishDate = addTextField("time", { label: "Publish Time", value: post == null ? "" : post.publish_ts });
		content = addTextArea("content", { label: "Content", value: post == null ? "" : post.content });
		addSubmit(post == null ? "Add Post" : "Edit Post");
	}
}