package core.form;

class Submit extends FormField
{

	public function new(value:String)
	{
		super("", value);
	}

	private override function control():String
	{
		return '<input type="submit" value="' + value + '" />';
	}
}