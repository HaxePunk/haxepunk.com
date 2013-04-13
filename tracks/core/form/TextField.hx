package core.form;

class TextField extends FormField
{

	public function new(name:String, ?options:FieldOptions)
	{
		super(name, options);
		this.placeholder = "";
		if (options != null)
		{
			if (options.placeholder != null) placeholder = options.placeholder;
		}
	}

	private override function control():String
	{
		return '<input type="text" placeholder="' + placeholder + '" value="' + value + '" name="' + name + '" class="form-text" />';
	}

	public var placeholder:String;

}