package core.form;

import sys.Web;

class Form
{
	/**
	 * helper that generates form html
	 */
	public function new(?action:String="", multipart:Bool = false, ?method:String="POST")
	{
		this.fields = new Array<FormField>();
		this.action = Lib.siteUrl(action);
		this.method = method;
		this.multipart = multipart;
	}

	public inline function addTextField(name:String, ?options:FieldOptions):TextField
	{
		var field = new TextField(name, options);
		fields.push(field);
		return field;
	}

	public inline function addTextArea(name:String, ?options:FieldOptions):TextArea
	{
		var field = new TextArea(name, options);
		fields.push(field);
		return field;
	}

	public inline function addPassword(name:String, ?options:FieldOptions):Password
	{
		var field = new Password(name, options);
		fields.push(field);
		return field;
	}

	public inline function addSubmit(value:String):Submit
	{
		var field = new Submit(value);
		fields.push(field);
		return field;
	}

	public inline function addSelect(name:String, values:Dynamic, defaultValue:Dynamic, ?options:Dynamic):Select
	{
		var field = new Select(name, values, defaultValue, options);
		fields.push(field);
		return field;
	}

	public inline function addFile(name:String, ?options:Dynamic):FileInput
	{
		var field = new FileInput(name, options);
		fields.push(field);
		return field;
	}

	public function validate():Bool
	{
		// only run validation after we've submitted the form
		if (Web.getMethod() != this.method) return false;

		var status = true;
		for (field in fields)
		{
			if (field.validate() == false)
			{
				status = false;
			}
		}
		return status;
	}

	public function toString():String
	{
		var html = '<form method="' + method + '" action="' + action + (multipart ? '" enctype="multipart/form-data' : '') + '">';

		for (field in fields)
		{
			html += Std.string(field);
		}

		return html + '</form>';
	}

	private var fields:Array<FormField>;
	private var action:String;
	private var method:String;
	private var multipart:Bool;

}