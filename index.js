var express = require('express');
var app = express();
var http = require('http').createServer(app);
const io = require('socket.io')(http);
const internalIp = require('internal-ip');
const { Client, Server } = require('node-osc');
// var { Client, Server } from 'node-osc';

const HTTP_PORT = 8080;
const EMIT_PORT = 3334;
const RECEIVE_PORT = 3335;

const CLIENT_IP = "127.0.0.1";

//Creates empty list of connected users
clientList = [];

// Listen and Emit client and server connection
var server = new Server(RECEIVE_PORT, '0.0.0.0');
var client = new Client(CLIENT_IP, EMIT_PORT);

app.use(express.static(__dirname + '/public'));

io.on('connection', function (socket) {
    

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
        // var msg = new Message('/' + type, user, val);

        // Ships the Message over OSC
        client.send("/" + type, user, val);
        // console.log(msg);
        // client.close();
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

// Send connected clients when message received
server.on('message', (msg) => {
    if (msg[0] == "/sketch") {
        console.log("Sketch is running -> Sending connected users", msg);
        
        clientList.forEach(thisClient => {
            client.send("/connect", thisClient);
        });
    }
});

// Listen on the port [HTTPPORT] for http requests
http.listen(HTTP_PORT, function () {
    // client = new Client(CLIENT_IP, EMIT_PORT);
    client.send("/start", "READY");
    console.log('Connect to:', internalIp.v4.sync() + ":" + HTTP_PORT);
});

// // Binds the port to the UDP server
// server.bind(RECEIVE_PORT);

