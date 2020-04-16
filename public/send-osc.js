var socket = io();
var x;
var y;

var manager = nipplejs.create({
  zone: document.getElementById('zone_joystick'),
  color: 'red',
  mode: 'static',
  position: { left: '25%', top: '50%' },
  restJoystick: true,
  threshold: 1,
  size: 200
});

function notSame(arr1, arr2) {
  for (let i = 0; i < arr1.length; i++) {
    if (arr1[i] !== arr2[i]) {
      return true
    } else {
      return false
    }
  }
}

function limit(num) {
  if (num <= 100) {
    return parseInt(num);
  } else {
    return 100;
  }
}



manager.on('start', (evt, nipple) => {
  console.log("STARTED");
  var lastDir = []; // STORE LAST VALUES
  nipple.on('move', (evt, data) => {
    // angle = parseInt(data.angle.degree); 
    // force = limit(data.force * 100);
    // let angleForce = [angle, force];
    // console.log(angle, force);

    x = (data.vector.x);
    y = -(data.vector.y);

    let dir = [x.toFixed(2), y.toFixed(2)];

    // COMPARES NEW VALUES TO LAST VALUES AND SENDS IF DIFFERENT
    // ##### MAYBE GET MORE INCREMENT OF DEGREE ??? ####
    if (notSame(dir, lastDir)) {
      sendosc('joystick', dir);
      lastDir = dir.slice(0);
    }
  });
}).on('end', function (evt, nipple) {
  // console.log(nipple);
  sendosc('joystick', ["0.0", "0.0"]);
  nipple.off('move');
  console.log("ENDED");
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
