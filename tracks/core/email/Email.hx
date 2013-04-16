package core.email;

import sys.Web;

class Email
{

	public function new()
	{
		var settings = Tracks.settings.email; // grab email settings
		if (settings == null) throw "Email settings not in config file";

		_hostname = settings.host;
		if (settings.username != null)
		{
			_authenticate = true;
			_username = settings.username;
			_password = settings.password;
		}
		// TODO: handle "Content-type: text/html" in header
		reset();
	}

	public function reset()
	{
		_to = new Array<String>();
		_cc = new Array<String>();
		_bcc = new Array<String>();
		_from = "";
	}

	public function send(subject:String, message:String):Bool
	{
		var badRecipients = new Array<String>();
		var header = "Date: " + DateTools.format(Date.now(), "%a, %e %b %Y %T %Z") + CRLF;
		if (_smtp == null) _smtp = new Smtp();

		_smtp.connect(_hostname);
		_smtp.hello(Web.getHostName());
		if (_authenticate && !_smtp.authenticate(_username, _password))
		{
			return false;
		}
		_smtp.mail(_from);
		header += "From: " + _from + CRLF;

		for (to in _to)
		{
			if (_smtp.recipient(to))
				header += "To: " + to + CRLF;
			else
				badRecipients.push(to);
		}
		for (cc in _cc)
		{
			if (_smtp.recipient(cc))
				header += "Cc: " + cc + CRLF;
			else
				badRecipients.push(cc);
		}
		for (bcc in _bcc)
		{
			if (_smtp.recipient(bcc))
				header += "Bcc: " + bcc + CRLF;
			else
				badRecipients.push(bcc);
		}

		header += "Subject: " + subject + CRLF;
		_smtp.data(header + CRLF + message);
		_smtp.quit();
		reset(); // clear fields for next message
		return true;
	}

	public function from(from:String) { _from = from; }
	public function to(to:String) { _to.push(to); }
	public function cc(cc:String) { _cc.push(cc); }
	public function bcc(bcc:String) { _bcc.push(bcc); }

	private var _to:Array<String>;
	private var _cc:Array<String>;
	private var _bcc:Array<String>;

	private var _hostname:String = "";
	private var _from:String = "";
	private var _title:String = "";
	private var _body:String = "";

	private var _authenticate:Bool = false;
	private var _username:String = "";
	private var _password:String = "";

	private var _smtp:Smtp;

	private static inline var CRLF:String = "\r\n";
}