$(document).ready(function() {
  highlight();

  if(window.addEventListener) {
    window.addEventListener("hashchange", highlight, false);
  }

  function highlight() {
    var fragID = document.location.toString().split("#")[1]; // TODO: use `location.hash`?
    if(fragID) {
      var cls = "is-focused";
      $(".comment." + cls).removeClass(cls);
      $("#" + fragID).addClass(cls);
    }
  }
});
