package core.form;

import sys.Web;

class FormField
{

	public function new(name:String, ?options:Dynamic)
	{
		var params = Web.getParams();
		this.name = name;
		this.value = this.label = "";
		if (options != null)
		{
			if (Reflect.hasField(options, 'label')) label = options.label;
			if (Reflect.hasField(options, 'value')) value = options.value;
		}
		this.value = params.exists(name) ? params.get(name) : value;
	}

	public function validate():Bool
	{
		return true;
	}

	private function control():String
	{
		return value;
	}

	public function toString():String
	{
		if (label != "")
		{
			return '<label>' + label + control() + '</label>';
		}
		else
		{
			return control();
		}
	}

	private var label:String;
#if php
	public var value(default, null):Dynamic;
#else
	public var value(default, null):String;
#end
	public var name(default, null):String;

}