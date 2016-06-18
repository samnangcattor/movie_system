$(function() {
  $(document).on("change", ".filter-quality", function(e){
    var filter_quality = $(".filter-quality option:selected").text();
    var movie_id = $(".filter-quality").attr("id");
    $.ajax({
      type: "get",
      data:{"filter_quality": filter_quality},
      success: function(response){},
      error: function(xhr){}
    });
  });
});
