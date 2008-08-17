function switch_to_next(current) {
	var next_img = (current+1) % 4;

	crossfade(
		document.getElementById('slideshow-image'),
		'/assets/images/slideshow/' + next_img + '.png',
		'2',
		'Slideshow image ' + (next_img+1)
	);

	window.setTimeout(
		switch_to_next,
		5000,
		next_img
	);
}

window.onload = function() {
	window.setTimeout(
		switch_to_next,
		5000,
		0
	);
}
