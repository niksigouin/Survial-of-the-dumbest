var express = require('express');
var app = express();
var http = require('http').createServer(app);
const io = require('socket.io')(http);
const dgram = require('dgram');
const server = dgram.createSocket('udp4');
const internalIp = require('internal-ip');
const { Client, Message } = require('node-osc');

const HTTP_PORT = 8080;
const EMIT_PORT = 3334;
const RECEIVE_PORT = 3335;

const CLIENT_IP = "127.0.0.1";

//Creates empty list of connected users
clientList = [];

app.use(express.static(__dirname + '/public'));

io.on('connection', function (socket) {
    // // starts new OSC client on local computer
    const client = new Client(CLIENT_IP, EMIT_PORT);

    // Send connected clients when message received
    server.on('message', (msg, rinfo) => {
        console.log("Sketch is running -> Sending connected users");
        for (let clients = 0; clients < clientList.length; clients++) {
            client.send("/connect", clientList[clients]);
        }
    });

    // Gets random ID for connected user
    var user = Math.floor(Math.random() * 90000) + 10000;

    //Adds user ID to list and prints it
    clientList.push(user);
    console.log(user, "connected");
    console.log("Users:", clientList);

    //Send the list of connected users to the OSC every second
    client.send("/connect", user);

    // Gets the input from the webpage and sends it through OSC
    socket.on('userInput', function (type, val) {
        // Prepares the Message to ship over OSC
        var msg = new Message('/' + type, user, val);

        // Ships the Message over OSC
        client.send(msg);
        // console.log(msg);
    });

    // Gets every connected client and send a list
    socket.on('disconnect', function () {
        //  Sends OSC packet conataining the disconnected user ID
        client.send("/disconnect", user);

        // Removes disconnected users from list
        var index = clientList.indexOf(user);
        if (index > -1) {
            clientList.splice(index, 1);
        }

        console.log(user, "disconnected");
        console.log("Users:", clientList);
    });
});

// Listen on the port [HTTPPORT] for http requests
http.listen(HTTP_PORT, function () {
    client = new Client(CLIENT_IP, EMIT_PORT);
    client.send("/start", " ");
    console.log('Connect to:', internalIp.v4.sync() + ":" + HTTP_PORT);
});

// Binds the port to the UDP server
server.bind(RECEIVE_PORT);