package core.form;

import sys.Web;

class FormField
{

	public var name(default, null):String;
#if php
	public var value(default, null):Dynamic;
#else
	public var value(default, null):String;
#end

	public function new(name:String, ?options:FieldOptions)
	{
		this.name = name;
		this.value = this.label = "";
		validationRules = new Array<String>();
		if (options != null)
		{
			if (options.label != null) label = options.label;
			if (options.value != null) value = options.value;
			if (options.validate != null) validationRules = options.validate.split("|");
		}
		this.value = Tracks.getParam(name, value);
	}

	public function validate():Bool
	{
		for (rule in validationRules)
		{
			switch (rule)
			{
				case "required":
					if (value == null || value == "") return false;
				case "alpha":
					if (~/[a-zA-Z]*/.match(value) == false) return false;
				case "alpha_numeric":
					if (~/[a-zA-Z0-9]*/.match(value) == false) return false;
				case "alpha_dash":
					if (~/[a-zA-Z-]*/.match(value) == false) return false;
				case "numeric":
					if (~/[0-9]*/.match(value) == false) return false;
				case "valid_email":
					// www.ilovejackdaniels.com/php/email-address-validation
					if (~/^[^@]{1,64}@[^@]{1,255}$/.match(value) == false)
					{
						return false;
					}
					var emailArray:Array<String> = value.split("@");
					var localArray:Array<String> = emailArray[0].split(".");
					for (i in 0...localArray.length)
					{
						if (~/^(([A-Za-z0-9?^`{\|}~-=_!#$%&'\*+\/][A-Za-z0-9#&?^_`\\{|}''\.\*+\/=!$%~-]{0,63})|("[^(\\|"")]{0,62}"))$/.match(localArray[i]) == false)
						{
							return false;
						}
					}
					if (~/^\[?[0-9\.]+\]?$/.match(emailArray[1]) == false)
					{
						var domainArray:Array<String> = emailArray[1].split(".");
						if (domainArray.length < 2)
						{
							return false; // Not enough parts to domain
						}
						for (i in 0...domainArray.length)
						{
							if (~/^(([A-Za-z0-9][A-Za-z0-9-]{0,61}[A-Za-z0-9])|([A-Za-z0-9]+))$/.match(domainArray[i]) == false)
							{
								return false;
							}
						}
					}
					return true;
				default:
					throw "Unknown form validation rule: " + rule;
			}
		}
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
	private var validationRules:Array<String>;

}