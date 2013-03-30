$(document).ready(function() {
	var slideTime = 8000;

	function advanceSlide() {
		var active = $('.slide.active'),
			next = active.next();

		active.removeClass('active');
		if (next.length === 0) {
			next = active.parent().find('.slide:first');
		}
		next.addClass('active');

		setTimeout(advanceSlide, slideTime);
	}

	var first = $('.slideshow .slide:first');
	first.addClass('active');

	setTimeout(advanceSlide, slideTime);

	$('header nav').click(function(e) {
		$('body').toggleClass('slide-menu');
	});
});
