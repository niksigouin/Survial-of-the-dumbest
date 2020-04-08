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

    //Send the connected user
    client.send("/connect", user);

    //Adds user ID to list and prints it
    console.log(user, "connected");
    clientList.push(user);
    console.log("Users:", clientList);

    // Gets the input from the webpage and sends it through OSC
    socket.on('userInput', function (type, val) {
        // Ships the Message over OSC
        client.send("/" + type, user, val);
    });

    // Disconnects player when the leave the web page
    socket.on('disconnect', function () {
        //  Sends OSC packet containing the disconnected user ID
        client.send("/disconnect", user);

        // Removes disconnected user from list
        console.log(user, "disconnected");
        clientList.pop(user);
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

// Listen on the port [HTTPPORT] for requests
http.listen(HTTP_PORT, function () {
    // Sends a message to the processing sketch when server start
    client.send("/start", "READY");
    console.log('Connect to:', internalIp.v4.sync() + ":" + HTTP_PORT);
});

