package core;

private enum Expression
{
	OpNone;
	OpVar(v:String);
	OpExpr(expr:Void->Dynamic);
	OpIf(expr:Void->Dynamic, eif:Expression, eelse:Expression);
	OpStr(str:String);
	OpBlock(l:List<Expression>);
	OpBlockRef(name:String);
	OpFilter(name:String, block:Expression);
	OpFor(v:String, expr:Void->Dynamic, loop:Expression, empty:Expression);
}

private enum Filter
{
	FAdd(p:String);
	FAddSlashes;
	FCapFirst;
	FCut(p:String);
	FEscape;
	FFirst;
	FJoin(p:String);
	FLast;
	FLength;
	FMarkdown;
	FStripTags;
	FDateTime(p:String);
	FUrlEncode;
}

private enum TokenType
{
	TknString;
	TknVar;
	TknBlock;
}

private typedef Token = {
	var t : TokenType;
	var p : String;
}

class Template
{
	public static var viewsFolder:String = "views";
	public static var globals:Dynamic = {};

	public function new(contents:String)
	{
#if haxe3
		blocks = new Map<String,Expression>();
#else
		blocks = new Hash<Expression>();
#end
		filters = new List<Filter>();

		var tokens = tokenize(contents);
		expr = parseBlock(tokens);
	}

	public function render(?context:Dynamic):String
	{
		this.context = context;
		this.buf = new StringBuf();
		run(expr);
		return buf.toString();
	}

	private function tokenize(contents:String)
	{
		// create the regular expression object if needed
		if (tag_re == null)
		{
			tag_re = new EReg("(" + BLOCK_TAG_START + TAG_CHARS + BLOCK_TAG_END + "|" +
				VARIABLE_TAG_START + TAG_CHARS + VARIABLE_TAG_END + "|" +
				COMMENT_TAG_START + TAG_CHARS + COMMENT_TAG_END + ")", "");
		}

		var tokens = new List<Token>();
		while (tag_re.match(contents))
		{
			var p = tag_re.matchedPos();

			if (p.pos > 0)
			{
				tokens.add({ p : tag_re.matchedLeft(), t : TknString });
			}

			var token = contents.substr(p.pos, p.len);
			if (StringTools.startsWith(token, BLOCK_TAG_START))
			{
				token = StringTools.trim(token.substr(2, token.length - 4));
				tokens.add({ p : token, t : TknBlock });
			}
			else if (StringTools.startsWith(token, VARIABLE_TAG_START))
			{
				token = StringTools.trim(token.substr(2, token.length - 4));
				tokens.add({ p : token, t : TknVar });
			}
			else if (StringTools.startsWith(token, COMMENT_TAG_START))
			{
				// toss the comment
			}

			contents = tag_re.matchedRight();
		}

		if (contents.length > 0)
		{
			tokens.add({ p : contents, t : TknString });
		}

		return tokens;
	}

	function resolve(v:String, ?ctx:Dynamic):Dynamic
	{
		if (ctx == null) ctx = context;

		var dot = v.split('.');

		// resolve dot access
		while (dot.length > 0)
		{
			var i = dot.shift();
			if (Reflect.hasField(ctx, i))
			{
				ctx = Reflect.field(ctx, i);
				// found a match
				if (dot.length == 0)
				{
					return ctx;
				}
				// hit a null variable, can't go any further
				if (ctx == null)
				{
					break;
				}
			}
		}

		// Checking the globals context is the last resort, exit from here
		if (ctx == globals)
		{
			return null;
		}
		else
		{
			if (v == "__context__")
			{
				return context;
			}

			return resolve(v, globals);
		}
	}

	private function run(e:Expression)
	{
		switch (e)
		{
			case OpNone:
				// do nothing
			case OpVar(v):
				var filterCount = 0;
				if (v.indexOf("|") > 0)
				{
					var parts = v.split("|");
					v = StringTools.trim(parts.shift());
					for (filter in parts)
					{
						filter = StringTools.trim(filter);
						if (filter_re.match(filter))
							addFilter(filter_re.matched(1), filter_re.matched(2));
						else
							addFilter(filter);
						filterCount += 1;
					}
				}
				buf.add(Std.string(applyFilters(resolve(v))));
				// pop any added filters
				for (i in 0...filterCount) { filters.pop(); }
			case OpExpr(e):
				buf.add(Std.string(e()));
			case OpIf(e,eif,eelse):
				var v : Dynamic = e();
				if (v == null || v == false)
				{
					if (eelse != null)
					{
						run(eelse);
					}
				}
				else
				{
					run(eif);
				}
			case OpStr(str):
				buf.add(str);
			case OpBlock(l):
				for (e in l)
				{
					run(e);
				}
			case OpBlockRef(name):
				run(blocks.get(name));
			case OpFilter(name, block):
				addFilter(name);
				run(block);
				filters.pop();
			case OpFor(v, e, loop, empty):
				var it:Dynamic = e();
				if (empty != null && it.length == 0)
				{
					run(empty);
				}
				else
				{
					try
					{
						var x:Dynamic = it.iterator();
						if (x.hasNext == null) throw null;
						it = x;
					}
					catch(e:Dynamic)
					{
						try
						{
							if (it.hasNext == null) throw null;
						}
						catch(e:Dynamic)
						{
							throw "Cannot iter on " + it;
						}
					}
					var it : Iterator<Dynamic> = it;
					for (ctx in it)
					{
						Reflect.setField(context, v, ctx);
						run(loop);
					}
				}
		}
	}

	private function addFilter(name:String, ?param:String)
	{
		switch (name)
		{
			case "add":        filters.push(FAdd(param));
			case "addslashes": filters.push(FAddSlashes);
			case "capfirst":   filters.push(FCapFirst);
			case "cut":        filters.push(FCut(param));
			case "escape":     filters.push(FEscape);
			case "first":      filters.push(FFirst);
			case "join":       filters.push(FJoin(param));
			case "last":       filters.push(FLast);
			case "length":     filters.push(FLength);
			case "markdown":   filters.push(FMarkdown);
			case "striptags":  filters.push(FStripTags);
			case "datetime":   filters.push(FDateTime(param));
			case "urlencode":  filters.push(FUrlEncode);
			default: throw "Filter '" + name + "' does not exist";
		}
	}

	private inline function applyFilters(val:Dynamic):Dynamic
	{
		if (val != null)
		{
			for (filter in filters)
			{
				switch (filter)
				{
					case FAdd(p):
						if (Std.is(val, List) || Std.is(val, Array))
						{
							val.push(p);
						}
						else if (Std.is(val, Int))
						{
							val = val + Std.parseInt(p);
						}
						else if (Std.is(val, Float))
						{
							val = val + Std.parseFloat(p);
						}
						else
						{
							val = val + p;
						}
					case FAddSlashes:
						if (Std.is(val, String))
						{
							for (esc in ['\\', '"', '\''])
							{
								val = StringTools.replace(val, esc, '\\' + esc);
							}
						}
					case FCapFirst:
						if (Std.is(val, String))
						{
							var str = cast(val, String);
							val = str.substr(0, 1).toUpperCase() + str.substr(1);
						}
					case FCut(p):
						if (Std.is(val, String))
						{
							val = val.split(p).join('');
						}
					case FEscape:
						if (Std.is(val, String))
						{
							val = StringTools.replace(val, "<", "&lt;");
							val = StringTools.replace(val, ">", "&gt;");
							val = StringTools.replace(val, "'", "&#39;");
							val = StringTools.replace(val, "\"", "&quot;");
							val = StringTools.replace(val, "&", "&amp;");
						}
					case FFirst:
						if (Std.is(val, Array))
						{
							val = val.shift();
						}
						else if (Std.is(val, List))
						{
							val = val.first();
						}
					case FJoin(p):
						if (Std.is(val, Array))
						{
							val = val.join(p);
						}
					case FLast:
						if (Std.is(val, Array))
						{
							val = val.pop();
						}
						else if (Std.is(val, List))
						{
							val = val.last();
						}
					case FLength:
						val = val.length;
					case FMarkdown:
						var blocks:Array<String> = val.split("</pre>");
						val = "";
						for (block in blocks)
						{
							var index = block.indexOf("<pre");
							if (index == 0)
							{
								val += block + "</pre>";
							}
							else if (index > 0)
							{
								val += Markdown.markdownToHtml(block.substr(0, index));
								val += block.substr(index, block.length - index) + "</pre>";
							}
							else
							{
								val += Markdown.markdownToHtml(block);
							}
						}
					case FStripTags:
#if haxe3
						val = html_tag_re.map(val, function(e:EReg) { return ""; });
#else
						val = html_tag_re.customReplace(val, function(e:EReg) { return ""; });
#end
					case FDateTime(p):
						var date:Date;
						if (Std.is(val, Date))
						{
							date = val;
						}
						else
						{
							date = Date.fromString(Std.string(val));
						}
						val = DateTools.format(date, p);
					case FUrlEncode:
						val = StringTools.urlEncode(val);
				}
			}
		}
		return val;
	}

	private function parseBlock(tokens:List<Token>):Expression
	{
		var l = new List();
		while (true)
		{
			var t = tokens.first();
			if (t == null)
			{
				break;
			}

			if (t.p == "end" || t.p == "else" || t.p == "empty" || t.p.substr(0,7) == "elseif ")
				break;

			l.add(parse(tokens));
		}

		if (l.length == 1)
		{
			return l.first();
		}

		return OpBlock(l);
	}

	function getFileContents(filename:String):String
	{
		var path = viewsFolder + filename;
		if (sys.FileSystem.exists(path))
		{
			return sys.io.File.getContent(path);
		}
		else
		{
			throw "Include '" + path + "' does not exist";
		}
	}

	function parse(tokens:List<Token>)
	{
		var t = tokens.pop();
		var p = t.p;
		if (t.t == TknString)
		{
			return OpStr(p);
		}
		else if (t.t == TknVar)
		{
			return OpVar(p);
		}

		// 'end' , 'else', 'elseif' can't be found here
		if (StringTools.startsWith(p, "if "))
		{
			p = p.substr(3);
			var e = parseExpr(p);
			var eif = parseBlock(tokens);
			var t = tokens.first();
			var eelse = null;
			if (t == null)
			{
				throw "Unclosed 'if' statement";
			}

			if (t.p == "end")
			{
				tokens.pop();
			}
			else if (t.p == "else")
			{
				tokens.pop();
				eelse = parseBlock(tokens);
				t = tokens.pop();
				if (t == null || t.p != "end")
				{
					throw "Unclosed 'else' statement";
				}
			}
			else
			{
				t.p = t.p.substr(4, t.p.length - 4);
				eelse = parse(tokens);
			}
			return OpIf(e, eif, eelse);
		}

		if (StringTools.startsWith(p, "for "))
		{
			if (for_re.match(p))
			{
				var v = for_re.matched(1);
				var e = parseExpr(for_re.matched(2));
				var efor = parseBlock(tokens);
				var empty = null;
				var t = tokens.pop();
				if (t.p == "empty")
				{
					empty = parseBlock(tokens);
					t = tokens.pop();
				}
				if (t == null || t.p != "end")
				{
					throw "Unclosed 'for' statement";
				}
				return OpFor(v, e, efor, empty);
			}
			else
			{
				throw "Invalid 'for' statement";
			}
		}

		if (StringTools.startsWith(p, "url "))
		{
			var uri = p.substr(4);
			if (!Lib.settings.rewrite) uri = "?uri=" + uri;
			return OpStr(Lib.settings.baseUrl + uri);
		}

		if (StringTools.startsWith(p, "block "))
		{
			var name = p.substr(6);
			var block = parseBlock(tokens);
			var t = tokens.pop();
			if (t == null || t.p != "end")
			{
				throw "Unclosed 'block' statement";
			}
			var exists = blocks.exists(name);
			blocks.set(name, block);
			return exists ? OpNone : OpBlockRef(name);
		}

		if (StringTools.startsWith(p, "include "))
		{
			return OpStr(getFileContents(p.substr(8)));
		}

		if (StringTools.startsWith(p, "extends "))
		{
			var tokens = tokenize(getFileContents(p.substr(8)));
			return parseBlock(tokens);
		}

		if (StringTools.startsWith(p, "filter "))
		{
			var name = p.substr(7);
			var block = parseBlock(tokens);
			var t = tokens.pop();
			if (t == null || t.p != "end")
			{
				throw "Unclosed 'block' statement";
			}
			return OpFilter(name, block);
		}

		if (expr_re.match(p))
		{
			return OpExpr(parseExpr(p));
		}

		return OpNone;
	}

	private function makeConst(v:String):Void->Dynamic
	{
		v = StringTools.trim(v);
		if (v.charCodeAt(0) == 34)
		{
			var str = v.substr(1, v.length - 2);
			return function() { return str; }
		}
		if (expr_int_re.match(v))
		{
			var i = Std.parseInt(v);
			return function() { return i; };
		}
		if (expr_float_re.match(v))
		{
			var f = Std.parseFloat(v);
			return function() { return f; };
		}
		var me = this;
		return function() { return me.resolve(v); };
	}

	private function makePath(e:Void->Dynamic, l:List<Token>)
	{
		var p = l.first();
		if (p == null || p.p != ".")
			return e;
		l.pop();
		var field = l.pop();
		if (field == null || field.t != TknString)
			throw field.p;
		var f = StringTools.trim(field.p);
		return makePath(function() { return Reflect.field(e(), f); }, l);
	}

	private function makeExpr(l)
	{
		return makePath(makeExpr2(l), l);
	}

	function makeExpr2(l:List<Token>):Void->Dynamic
	{
		var p = l.pop();
		if (p == null)
		{
			throw "<eof>";
		}
		if (p.t == TknString)
		{
			return makeConst(p.p);
		}
		switch(p.p)
		{
			case "(":
				var e1 = makeExpr(l);
				var p = l.pop();
				if (p == null || p.t == TknString)
					throw p.p;
				if (p.p == ")")
					return e1;
				var e2 = makeExpr(l);
				var p2 = l.pop();
				if (p2 == null || p2.p != ")")
				{
					throw p2.p;
				}
				return switch (p.p)
				{
					case "+": function() { return cast e1() + e2(); };
					case "-": function() { return cast e1() - e2(); };
					case "*": function() { return cast e1() * e2(); };
					case "/": function() { return cast e1() / e2(); };
					case ">": function() { return cast e1() > e2(); };
					case "<": function() { return cast e1() < e2(); };
					case ">=": function() { return cast e1() >= e2(); };
					case "<=": function() { return cast e1() <= e2(); };
					case "==": function() { return cast e1() == e2(); };
					case "!=": function() { return cast e1() != e2(); };
					case "&&": function() { return cast e1() && e2(); };
					case "||": function() { return cast e1() || e2(); };
					default: throw "Unknown operation "+p.p;
				}
			case "!":
				var e = makeExpr(l);
				return function() {
					var v:Dynamic = e();
					return (v == null || v == false);
				};
			case "-":
				var e = makeExpr(l);
				return function() { return -e(); };
		}
		throw p.p;
	}

	private function parseExpr(data:String)
	{
		var l = new List<Token>();
		var expr = data;
		while (expr_re.match(data))
		{
			var p = expr_re.matchedPos();
			var k = p.pos + p.len;
			if (p.pos != 0)
			{
				l.add({ p : data.substr(0, p.pos), t : TknString });
			}
			var p = StringTools.trim(expr_re.matched(0));
			l.add({ p : p, t : p.indexOf('"') >= 0 ? TknString : TknVar});
			data = expr_re.matchedRight();
		}

		// add left over string
		if (data.length != 0)
		{
			l.add({ p : data, t : TknString });
		}

		var e;
		try
		{
			e = makeExpr(l);
			if( !l.isEmpty() )
				throw l.first().p;
		}
		catch(s:String)
		{
			throw "Unexpected '" + s + "' in " + expr;
		}

		return function() {
			try
			{
				return e();
			}
			catch(exc:Dynamic)
			{
				throw "Error : " + Std.string(exc) + " in " + expr;
			}
		}
	}

	private static inline var TAG_CHARS = '[A-Za-z0-9_ ()%&|!+=/><*,.:"-]+';
	private static inline var BLOCK_TAG_START = '{%';
	private static inline var BLOCK_TAG_END = '%}';
	private static inline var VARIABLE_TAG_START = '{{';
	private static inline var VARIABLE_TAG_END = '}}';
	private static inline var COMMENT_TAG_START = '{#';
	private static inline var COMMENT_TAG_END = '#}';

	private static var tag_re = null;
	private static var var_re = ~/([A-Za-z][A-Za-z0-9_\.]*)(?:\|([a-z]+)(?::"(.*)")?)?/;
	private static var filter_re = ~/([a-z]+):"(.*)"/;
	private static var for_re = ~/for ([A-Za-z][A-Za-z0-9_]*) in (.*)/;
	private static var expr_re = ~/([ \r\n\t]*\([ \r\n\t]*|[ \r\n\t]*\)[ \r\n\t]*|[ \r\n\t]*"[^"]*"[ \r\n\t]*|[!+=\/><*.&|-]+)/;
	private static var expr_int_re = ~/^[0-9]+$/;
	private static var expr_float_re = ~/^([+-]?)(?=\d|,\d)\d*(,\d*)?([Ee]([+-]?\d+))?$/;
	private static var html_tag_re = ~/(<[\/A-Za-z0-9="' ]+>)/;

	private var filters:List<Filter>;
	private var context:Dynamic;
	private var buf:StringBuf;
	private var expr:Expression;
#if haxe3
	private var blocks:Map<String,Expression>;
#else
	private var blocks:Hash<Expression>;
#end

}