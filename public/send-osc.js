var socket = io();

$(function () {
  var timeOut;

  $(":button").on("mousedown vmousedown",function () {
    var type = $(this).attr('class');
    var  val = $(this).attr('id');
    timeout = setInterval(function () {
      sendosc(type, val);
    }, 10);

    console.log('Message from ' + val, "With value: " + val);
    return false;
  });

  $(document).on("mouseup vmouseup",function () {
    clearInterval(timeout);
    return false;
  });
});

function sendosc(type, val) {
  socket.emit("change:interval", type, val);
}
