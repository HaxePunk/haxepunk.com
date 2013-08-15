package core.form;

class Password extends TextField
{

	private override function control():String
	{
		return '<input type="password" placeholder="' + placeholder + '" name="' + name + '" class="form-text" />';
	}

}