(function(window) {
  function selectQuadrant($quadrant) {
    var index = $quadrant.index() + 1;
    // Remove the class of the current selection
    $(".seat-selected").removeClass("seat-selected");
    $quadrant.toggleClass("seat-selected");

    if ($quadrant.hasClass("seat-selected")) {
      $("#attendance_seat").attr("value", index);
      $("#profile-picture").show().appendTo($quadrant);
    } else {
      $("#attendance_seat").attr("value", "");
      $("#profile-picture").hide();
    }
  }

  // Trigger on DOM Ready 
  $(function() {
    $(".seats").on("click", ".seat", function(event) {
      selectQuadrant($(event.currentTarget));
    });

    // Read the current seat and update the DOM
    var currentQuadrant = $("#attendance_seat").attr("value");
    if (currentQuadrant!=="") {
      selectQuadrant($(".seats").children(":nth-child(" + currentQuadrant + ")"));
    }
  });
})(this);