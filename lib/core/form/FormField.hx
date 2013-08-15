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
		errors = new Array<String>();
		for (rule in validationRules)
		{
			switch (rule)
			{
				case "required":
					if (value == null || value == "") errors.push("This field is required");
				case "alpha":
					if (~/[a-zA-Z]*/.match(value) == false) errors.push("Expected alphabetic values only");
				case "alpha_numeric":
					if (~/[a-zA-Z0-9]*/.match(value) == false) errors.push("Expected alphanumeric values only");
				case "alpha_dash":
					if (~/[a-zA-Z-]*/.match(value) == false) errors.push("Expected alphabetic and dash values only");
				case "numeric":
					if (~/[0-9]*/.match(value) == false) errors.push("Expected numeric values only");
				case "valid_email":
					if (validateEmail(value) == false)
						errors.push("Invalid email");
				default:
					throw "Unknown form validation rule: " + rule;
			}
		}
		return (errors.length == 0);
	}

	private function validateEmail(value:String):Bool
	{
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
	}

	private function control():String
	{
		return value;
	}

	public function toString():String
	{
		var str = "";
		if (errors != null && errors.length > 0)
		{
			str = '<div class="error">' + errors.join('</div><div class="error">') + '</div>';
		}

		if (label != "")
		{
			str += '<label>' + label + control() + '</label>';
		}
		else
		{
			str += control();
		}
		return '<div class="form-field">' + str + '</div>';
	}

	private var errors:Array<String>;
	private var label:String;
	private var validationRules:Array<String>;

}