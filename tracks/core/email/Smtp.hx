package core.email;

#if haxe3
import haxe.crypto.Md5;
#else
import haxe.Md5;
#end
import core.util.Base64;
import sys.net.Socket;
import sys.net.Host;

class Smtp
{
	/**
	 * Default SMTP server port
	 */
	public var port:Int = 25;

	/**
	 * Sets VERP use on/off (default is off)
	 */
	public var doVERP:Bool = false;

	/**
	 * Holds the last server reply
	 */
	public var reply(default, null):String;

	public function new()
	{
		cnx = new Socket();
	}

	public function connect(host:String, ?port:Int, timeout:Float = 15):Bool
	{
		if (port == null)
		{
			port = this.port;
		}

		//cnx.setTimeout(timeout);
		cnx.connect(new Host(host), port);
		expectedReply(220, "Expected an SMTP announcement");
		return true;
	}

	public function quit()
	{
		cnx.write("QUIT" + CRLF);
		expectedReply(221, "SMTP server rejected QUIT command");
		close();
	}

	public function close()
	{
		cnx.close();
	}

	public function authenticate(username:String, password:String, authtype:String="LOGIN", realm:String="", workstation="")
	{
		switch (authtype)
		{
			case "PLAIN":
				cnx.write("AUTH PLAIN" + CRLF);
				if (!expectedReply(334, "AUTH not accepted from server"))
					return false;

				cnx.write(Base64.encode(String.fromCharCode(0) + username + String.fromCharCode(0) + password) + CRLF);
				if (!expectedReply(235, "Authentication not accepted from server"))
					return false;
			case "LOGIN":
				cnx.write("AUTH LOGIN" + CRLF);
				if (!expectedReply(334, "AUTH not accepted from server"))
					return false;

				cnx.write(Base64.encode(username) + CRLF);
				if (!expectedReply(334, "Username not accepted from server"))
					return false;

				cnx.write(Base64.encode(password) + CRLF);
				if (!expectedReply(235, "Password not accepted from server"))
					return false;
			default:
				throw "Not supported";
		}

		return true;
	}

	public function hello(?host:String)
	{
		if (host == null) host = "localhost";

		if (!sendHello("EHLO", host))
			if (!sendHello("HELO", host))
				return false;

		return true;
	}

	public function startTLS()
	{
		cnx.write("STARTTLS" + CRLF);
		expectedReply(220, "STARTTLS not accepted by the server");

		// TODO: enable crypto
	}

	public function data(message:String)
	{
		cnx.write("DATA" + CRLF);
		if (!expectedReply(354, "DATA command not accepted from server"))
			return false;

		message = StringTools.replace(message, "\r\n", "\n");
		message = StringTools.replace(message, "\r", "\n");
		var lines:Array<String> = message.split("\n");

		var field = lines[0].substr(0, lines[0].indexOf(':'));
		var inHeaders = false;
		if("" != field && "" == field.substr(field.indexOf(' '))) {
			inHeaders = true;
		}

		var maxLineLength = 998;

		for (line in lines)
		{
			var linesOut = new Array<String>();
			if (line == "" && inHeaders)
			{
				inHeaders = false;
			}
			// ok we need to break this line up into several smaller lines
			while (line.length > maxLineLength)
			{
				var position:Int = line.substr(0, maxLineLength).lastIndexOf(' ');

				// Patch to fix DOS attack
				if (position < 0)
				{
					position = maxLineLength - 1;
					linesOut.push(line.substr(0, position));
					line = line.substr(position);
				}
				else
				{
					linesOut.push(line.substr(0, position));
					line = line.substr(position + 1);
				}

				/* if processing headers add a LWSP-char to the front of new line
				* rfc 822 on long msg headers
				*/
				if (inHeaders)
				{
					line = "\t" + line;
				}
			}
			linesOut.push(line);

			// send the lines to the server
			for (lineOut in linesOut) {
				if (lineOut.length > 0)
				{
					if (lineOut.substr(0, 1) == ".")
					{
						lineOut = "." + lineOut;
					}
				}
				cnx.write(lineOut + CRLF);
			}
		}

    	// message data has been sent
	    cnx.write(CRLF + '.' + CRLF);
	    return expectedReply(250, "DATA not accepted from server");
	}

	public function recipient(to:String)
	{
		cnx.write("RCPT TO:<" + to + ">" + CRLF);
		var code = getReply();
		if (code < 250 || code > 251)
		{
			#if debug trace(reply); #end
			trace("RCPT not accepted from server");
			return false;
		}
		return true;
	}

	public function verify(address:String)
	{
		cnx.write("VRFY " + address + CRLF);
		return expectedReply(250, "VRFY not accepted from server");
	}

	public function reset()
	{
		cnx.write("RSET" + CRLF);
		return expectedReply(250, "RSET failed");
	}

	public function mail(from:String)
	{
    	cnx.write("MAIL FROM:<" + from + ">" + (doVERP ? " XVERP" : "") + CRLF);
    	return expectedReply(250, "MAIL not accepted from server");
	}

	public function sendAndMail(from:String)
	{
		cnx.write("SAML FROM:" + from + CRLF);
		return expectedReply(250, "SAML not accepted from server");
	}

	private function sendHello(hello:String, host:String):Bool
	{
		cnx.write(hello + " " + host + CRLF);
		return expectedReply(250, hello + " not accepted from the server");
	}

	private function getReply():Int
	{
		var input = cnx.input;
		reply = "";
		try {
			while (true)
			{
				var str = input.readLine();
				reply += str + CRLF;
				if (str.substr(3, 1) == ' ') { break; }
			}
		} catch (e:haxe.io.Eof) {

		}
		return Std.parseInt(reply.substr(0, 3));
	}

	private function expectedReply(expected:Int, expectedMessage:String):Bool
	{
		var code = getReply();
		#if debug trace(reply); #end
		if (code != expected)
		{
			trace(expectedMessage);
			return false;
		}
		return true;
	}

	/**
	 * SMTP socket connection
	 */
	private var cnx:Socket;

	/**
	 * SMTP reply line ending
	 */
	private static inline var CRLF:String = "\r\n";

}