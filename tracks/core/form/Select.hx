package core.form;

class Select extends FormField
{

	public function new(name:String, values:Dynamic, defaultValue:Dynamic, ?options:FieldOptions)
	{
		super(name, options);
		this.options = values;
		this.defaultValue = defaultValue;
	}

	private override function control():String
	{
		var control:String = '<select name="' + name + '" class="form-select">';
		if (Std.is(options, Array))
		{
			for (key in 0...options.length)
			{
				control += '<option value="' + key + (key == defaultValue ? '" selected="selected' : "") + '">' + options[key] + '</option>';
			}
		}
#if haxe3
		else if (Std.is(options, Map))
		{
			var options:Map<String,Dynamic> = options;
#else
		else if (Std.is(options, Hash))
		{
			var options = cast(options, Hash<Dynamic>);
#end
			for (key in options.keys())
			{
				control += '<option value="' + key + (key == defaultValue ? '" selected="selected' : "") + '">' + options.get(key) + '</option>';
			}
		}
#if !haxe3
		else if (Std.is(options, IntHash))
		{
			var options = cast(options, IntHash<Dynamic>);
			for (key in options.keys())
			{
				control += '<option value="' + key + (key == defaultValue ? '" selected="selected' : "") + '">' + options.get(key) + '</option>';
			}
		}
#end
		else
		{
			for (key in Reflect.fields(options))
			{
				control += '<option value="' + key + (key == defaultValue ? '" selected="selected' : "") + '">' + Reflect.field(options, key) + '</option>';
			}
		}
		control += '</select>';
		return control;
	}

	private var defaultValue:Dynamic;
	private var options:Dynamic;

}