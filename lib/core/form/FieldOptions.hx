package core.form;

typedef FieldOptions = {
	@:optional var value:String;
	@:optional var label:String;
	@:optional var placeholder:String; // used for text/password
	@:optional var validate:String;
	@:optional var tabIndex:Int;
};