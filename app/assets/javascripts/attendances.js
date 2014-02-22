(function(window) {
  function selectSeat($seat) {
    $(".seats .seat").removeClass("seat-selected");
    $seat.addClass("seat-selected");
    $("#attendance_seat").attr("value", $seat.index() + 1);
  }

  // Trigger on DOM Ready
  $(function() {
    $(".editable-seats .seat").on("click", function(event) {
      selectSeat($(this));
    });

    $("input[name=date]").on("change", function(e) {
      var $form = $(this).parent('form');
      if ($form[0]) {
        $form.submit();
      }
    });
  });
})(this);