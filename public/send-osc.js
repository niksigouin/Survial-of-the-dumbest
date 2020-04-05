var socket = io();
var joyStickInterval;
var intervalTime = 1 / 60 * 1000;

console.log("touchscreen is", VirtualJoystick.touchScreenAvailable() ? "available" : "not available");

// CREATES NEW JOYSTICK ON SCREEN
var joystick = new VirtualJoystick({
  container: document.getElementById('container'),
  mouseSupport: true,
  stationaryBase: true,
  baseX: 200,
  baseY: 200,
  limitStickTravel: true,
  stickRadius: 50
});

// WHEN USER MOVES START SENDING THE POSITION
joystick.addEventListener('touchStart', function () {
  // console.log('down');

  joyStickInterval = setInterval(() => {
    sendosc('joystick', [Number(joystick.deltaX().toFixed(2)), Number(joystick.deltaY().toFixed(2))]);
  }, intervalTime);
});

// WHEN USER LETS GO OF THE JOYSTICK WAIT AND STOP SENDING THE POSITION
joystick.addEventListener('touchEnd', function () {
  sendosc('joystick', [Number(Math.abs(joystick.deltaX().toFixed(2))-Math.abs(joystick.deltaX()).toFixed(2)), Number(Math.abs(joystick.deltaY().toFixed(2))-Math.abs(joystick.deltaY()).toFixed(2))]);
  clearInterval(joyStickInterval);
});

// SENDS OSC TO SERVER
// [TYPE: WHAT CONTROL, VAL: VALUE OF CONTROL]
function sendosc(type, val) {
  socket.emit('userInput', type, val);
  console.log(type, val);
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
