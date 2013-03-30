/**
 * SyntaxHighlighter
 * http://alexgorbatchev.com/SyntaxHighlighter
 *
 * SyntaxHighlighter is donationware. If you are using it, please donate.
 * http://alexgorbatchev.com/SyntaxHighlighter/donate.html
 *
 * @version
 * 3.0.83 (July 02 2010)
 *
 * @copyright
 * Copyright (C) 2004-2010 Alex Gorbatchev.
 *
 * @license
 * Dual licensed under the MIT and GPL licenses.
 */
;(function()
{
	// CommonJS
	typeof(require) != 'undefined' ? SyntaxHighlighter = require('shCore').SyntaxHighlighter : null;

	function Brush()
	{
		var keywords =	'break callback case catch class continue default do else enum extends for function if implements ' +
						'import in interface new package return switch throw try typedef using var while null true false';
		var types =		'Void Int Float Dynamic Bool UInt Iterator Array List Hash IntHash Date String Xml dynamic extern '+
						'inline override private public static untyped cast trace super this arguments';
		var haxepunk =	'HXP World Entity Image Spritemap Mask Graphic Engine Tween Tweener Screen Input Key Draw Data Ease' +
						'Circle Grid Hitbox Masklist Pixelmask Polygon Backdrop Canvas Emitter Graphiclist Particle' +
						'PreRotation Text TiledImage TileSpritemap Tilemap Console Alarm AngleTween ColorTween MultiVarTween' +
						'NumTween Var Tween CircularMotion CubicMotion LinearMotion LinearPath Motion QuadMotion QuadPath' +
						'Fader SfxFader Sfx';

		this.regexList = [
			{ regex: SyntaxHighlighter.regexLib.singleLineCComments,	css: 'comments' },		// one line comments
			{ regex: SyntaxHighlighter.regexLib.multiLineCComments,		css: 'comments' },		// multiline comments
			{ regex: SyntaxHighlighter.regexLib.doubleQuotedString,		css: 'string' },		// double quoted strings
			{ regex: SyntaxHighlighter.regexLib.singleQuotedString,		css: 'string' },		// single quoted strings
			{ regex: new RegExp(this.getKeywords(keywords), 'gm'),		css: 'keyword' },		// keywords
			{ regex: new RegExp(this.getKeywords(types), 'gm'),			css: 'functions' },		// commands
			{ regex: new RegExp(this.getKeywords(haxepunk), 'gm'),		css: 'color3' },		// haxepunk
			{ regex: new RegExp('var', 'gm'),							css: 'variable' },		// variable
			{ regex: new RegExp('trace', 'gm'),							css: 'color1' }			// trace
			];
	}

	Brush.prototype	= new SyntaxHighlighter.Highlighter();
	Brush.aliases	= ['haxe'];

	SyntaxHighlighter.brushes.HaXe = Brush;

	// CommonJS
	typeof(exports) != 'undefined' ? exports.Brush = Brush : null;
})();
