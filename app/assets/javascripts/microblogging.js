(function($) {

var msgField = $("form.navbar-search .search-query"); // XXX: hard-coded
msgField.data("originalWidth", msgField.width());

var onFocus = function(ev) {
	$(this).animate({ width: "30em" });
};

var onBlur = function(ev) {
	var el = $(this);
	el.animate({ width: el.data("originalWidth") }, function() {
		el.removeAttr("style"); // XXX: unnecessary!?
	});
};

msgField.focus(onFocus).blur(onBlur);

}(jQuery));
