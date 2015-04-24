$(document).ready(function() {
  moment.lang("de");
  $(".comment-timestamp time[datetime]").each(function(idx, item) {
      var time = moment($(item).attr("datetime")).local();
      $(item).attr("title", time.format("dddd, Do MMMM YYYY [um] HH:mm:ss")).text(time.fromNow());

      // show title (absolute time) as a bootstrap tooltip
      $(item).data({
        "toggle": "tooltip",
        "placement": "top"
      });
      $(item).tooltip();
  });
});
