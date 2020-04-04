var socket = io();

console.log("touchscreen is", VirtualJoystick.touchScreenAvailable() ? "available" : "not available");
	
var joystick	= new VirtualJoystick({
  container	: document.getElementById('container'),
  mouseSupport	: true,
});
joystick.addEventListener('touchStart', function(){
  console.log('down')
})
joystick.addEventListener('touchEnd', function(){
   console.log('up')
})

setInterval(function(){
  var outputEl	= document.getElementById('result');
  outputEl.innerHTML	= '<b>Result:</b> '
    + ' dx:'+joystick.deltaX()
    + ' dy:'+joystick.deltaY()
    + (joystick.right()	? ' right'	: '')
    + (joystick.up()	? ' up'		: '')
    + (joystick.left()	? ' left'	: '')
    + (joystick.down()	? ' down' 	: '')	
}, 1/30 * 1000);

// $(function () {
//   var timeOut;
//   // Make new system to interprate virtualJoystick

//   $(":button").on("mousedown vmousedown",function () {
//     var type = $(this).attr('class');
//     var  val = $(this).attr('id');
//     timeout = setInterval(function () {
//       sendosc(type, val);
//     }, 10);

//     console.log('Message from ' + val, "With value: " + val);
//     return false;
//   });

//   $(document).on("mouseup vmouseup",function () {
//     clearInterval(timeout);
//     return false;
//   });
// });

function sendosc(type, val) {
  socket.emit("change:interval", type, val);
}
