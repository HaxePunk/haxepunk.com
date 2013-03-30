package core.form;

class TextArea extends FormField
{

	public function new(name:String, value:String="")
	{
		super(name, value);
	}

	private override function control():String
	{
		return '<textarea name="' + name + '" class="form-text-area">' + value + '</textarea>';
	}

}