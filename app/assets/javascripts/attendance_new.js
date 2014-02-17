(function(window) {
  function selectSeat($seat) {
    $(".seats .seat").removeClass("seat-selected");
    $seat.addClass("seat-selected");
    $("#attendance_seat").attr("value", $seat.index() + 1);
  }

  // Trigger on DOM Ready
  $(function() {
    $(".seats .seat").on("click", function(event) {
      selectSeat($(this));
    });
  });
})(this);