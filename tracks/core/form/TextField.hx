package core.form;

class TextField extends FormField
{

	public function new(name:String, ?options:Dynamic)
	{
		super(name, options);
		this.placeholder = "";
		if (options != null)
		{
			if (Reflect.hasField(options, 'placeholder')) placeholder = options.placeholder;
		}
	}

	private override function control():String
	{
		return '<input type="text" placeholder="' + placeholder + '" value="' + value + '" name="' + name + '" class="form-text" />';
	}

	public var placeholder:String;

}