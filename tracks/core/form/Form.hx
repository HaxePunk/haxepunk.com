package core.form;

import sys.Web;

class Form
{
	/**
	 * helper that generates form html
	 */
	public function new(?action:String="", ?method:String="POST", ?fields:Array<FormField>)
	{
		if (fields == null)
		{
			this.fields = new Array<FormField>();
		}
		else
		{
			this.fields = fields;
		}
		this.action = Tracks.siteUrl(action);
		this.method = method;
	}

	public inline function addTextField(name:String, placeholder:String=""):TextField
	{
		var field = new TextField(name);
		field.placeholder = placeholder;
		fields.push(field);
		return field;
	}

	public inline function addTextArea(name:String):TextArea
	{
		var field = new TextArea(name);
		fields.push(field);
		return field;
	}

	public inline function addPassword(name:String, placeholder:String=""):Password
	{
		var field = new Password(name);
		field.placeholder = placeholder;
		fields.push(field);
		return field;
	}

	public inline function addSubmit(value:String):Submit
	{
		var field = new Submit(value);
		fields.push(field);
		return field;
	}

	public inline function addSelect(name:String, ?options:Dynamic):Select
	{
		var field = new Select(name, options);
		fields.push(field);
		return field;
	}

	public function validate():Bool
	{
		for (field in fields)
		{
			if (field.validate() == false)
			{
				return false;
			}
		}
		return true;
	}

	public function toString():String
	{
		var html = '<form method="' + method + '" action="' + action + '">';

		for (field in fields)
		{
			//html += '<div class="form-field">';
			html += Std.string(field);
			// if (field.label != null && field.label != "")
			// {
			// 	html += '<label for="field-' + field.name + '">' + field.label + '</label>';
			// }
			// switch (field.type) {
			// 	case FormType.Text:
			// 		html += '<input type="text" value="' + field.value + '" name="' + field.name + '" class="form-text" id="field-' + field.name + '" />';
			// 	case FormType.Password:
			// 		html += '<input type="password" value="' + field.value + '" name="' + field.name + '" class="form-password" id="field-' + field.name + '" />';
			// 	case FormType.Submit:
			// 		html += '<input type="submit" value="' + field.value + '" class="form-submit" />';
			// 	case FormType.TextArea:
			// 		html += '<textarea name="' + field.name + '" class="form-textarea" id="field-' + field.name + '">' + field.value + '</textarea>';
			// 	case FormType.Select:
			// 		html += htmlSelect(field);
			// 	case FormType.Checkbox:
			// 		html += '<input type="checkbox" name="' + field.name + '" class="form-checkbox" id="field-' + field.name + '" />';
			// 	case FormType.Radio:
			// 		html += '<input type="radio" name="' + field.name + '" class="form-radio" id="field-' + field.name + '" />';
			// }
			//html += '</div>';
		}

		return html + '</form>';
	}

	private var fields:Array<FormField>;
	private var action:String;
	private var method:String;

}