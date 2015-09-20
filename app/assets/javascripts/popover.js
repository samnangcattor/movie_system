$(document).ready(function(){
  $("img.resize-img-thumbnail").popover();

  $("img.resize-img-thumbnail").on("show.bs.popover", function () {
    var movie_title = $(this).data("title");
    var movie_description = $(this).data("description");
    var label_publish_date = $(".label-publish-date").text();
    var movie_publish_date = $(this).data("publish-date");

    $(this).attr("data-original-title", "<strong>" + movie_title + "</strong>" +
      "<img src='" + $(this).data("image") + "' class='image-hd-movie img-responsive img-thumbnail'>");
    if (movie_description.length > 150) {
      var new_content = movie_description.substr(0, 150) + "...";
      $(this).attr("data-content",  new_content +
        "<hr>"  + "<strong>" + label_publish_date + "</strong>" + movie_publish_date);
    }
    else{
      $(this).attr("data-content",  movie_description +
        "<hr>"  + "<strong>" + label_publish_date + "</strong>" + movie_publish_date);
    }
  });
});
