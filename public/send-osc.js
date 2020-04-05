var socket = io();
var joyStickInterval;

console.log("touchscreen is", VirtualJoystick.touchScreenAvailable() ? "available" : "not available");

// CREATES NEW JOYSTICK ON SCREEN
var joystick = new VirtualJoystick({
  container: document.getElementById('container'),
  mouseSupport: true,
});


// PRINTS THE POSITION ON SCREEN
setInterval(function () {
  var outputEl = document.getElementById('result');
  outputEl.innerHTML = '<b>Result:</b> '
    + ' dx:' + joystick.deltaX()
    + ' dy:' + joystick.deltaY();

}, 1 / 30 * 1000); // 


// WHEN USER MOVES START SENDING THE POSITION
joystick.addEventListener('touchStart', function () {
  // console.log('down');
  
  joyStickInterval = setInterval(() => {
    sendosc('joystick', [joystick.deltaX(), joystick.deltaY()])
  }, 1 / 30 * 1000);
});

// WHEN USER LETS GO OF THE JOYSTICK WAIT AND STOP SENDING THE POSITION
joystick.addEventListener('touchEnd', function () {
  // console.log('up')

  setTimeout(() => {
    clearInterval(joyStickInterval);
  }, 1 / 30 * 1000);

});

// SENDS OSC TO SERVER
// [TYPE: WHAT CONTROL, VAL: VALUE OF CONTROL]
function sendosc(type, val) {
  socket.emit(type, val );
  console.log('joystick', [joystick.deltaX(), joystick.deltaY()]);
}

// OLD BUTTON THING

// // SEND JOYSTICK VAL
// $(function () {
  // var type = 'joystick';
  // let  val = [joystick.deltaX(), joystick.deltaY()];

  // sendosc(type, val);

  // var timeOut;
  // Make new system to interprate virtualJoystick

  // $(":button").on("mousedown vmousedown",function () {
  //   var type = $(this).attr('class');
  //   var  val = $(this).attr('id');
  //   timeout = setInterval(function () {
  //     sendosc(type, val);
  //   }, 10);

  //   console.log('Message from ' + val, "With value: " + val);
  //   return false;
  // });

  // $(document).on("mouseup vmouseup",function () {
  //   clearInterval(timeout);
  //   return false;
  // });
// });
