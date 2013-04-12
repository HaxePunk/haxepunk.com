package core.form;

class FileInput extends FormField
{

	public function new(name:String, ?options:Dynamic)
	{
		super(name, options);
	}

	private override function control():String
	{
		return '<input type="file" name="' + name + '" class="form-file" />';
	}

}