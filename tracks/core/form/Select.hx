package core.form;

class Select extends FormField
{

	public function new(name:String, ?options:Dynamic, ?selected:String)
	{
		super(name, selected);
		this.options = options;
	}

	private override function control():String
	{
		var control:String = '<select name="' + name + '" class="form-select">';
		if (Std.is(options, Array))
		{
			for (i in 0...options.length)
			{
				control += '<option value="' + i + '">' + options[i] + '</option>';
			}
		}
#if haxe3
		else if (Std.is(options, Map))
		{
			var options:Map<String,Dynamic> = options;
#else
		else if (Std.is(options, Hash))
		{
			var options:Hash<Dynamic> = options;
#end
			for (key in options.keys())
			{
				control += '<option value="' + key + '">' + options.get(key) + '</option>';
			}
		}
		else
		{
			for (option in Reflect.fields(options))
			{
				control += '<option value="' + option + '">' + Reflect.field(options, option) + '</option>';
			}
		}
		control += '</select>';
		return control;
	}

	private var options:Dynamic;

}