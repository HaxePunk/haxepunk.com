package core.form;

class TextField extends FormField
{

	public function new(name:String, value:String="")
	{
		super(name, value);
		this.placeholder = "";
	}

	private override function control():String
	{
		return '<input type="text" placeholder="' + placeholder + '" value="' + value + '" name="' + name + '" class="form-text" />';
	}

	public var placeholder:String;

}