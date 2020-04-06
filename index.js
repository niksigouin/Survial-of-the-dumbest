// var app = require('express')();
var express = require('express');
var app = express();
var http = require('http').createServer(app);
var io = require('socket.io')(http);
const internalIp = require('internal-ip');
const { Client, Message } = require('node-osc');

const httpPort = 8080;
const tcpPort = 3334;

var clientIp;

//Creates empty list of connected users
userList = [];

app.use(express.static(__dirname + '/public'));



io.on('connection', function (socket) {
    // starts new OSC client on local computer
    clientIp = "127.0.0.1";
    const client = new Client(clientIp, tcpPort);

    // Gets random ID for connected user
    var user = Math.floor(Math.random() * 90000) + 10000;


    //Adds user ID to list and prints it
    userList.push(user);
    console.log(user + " connected");
    console.log("Users:", userList);

    //Send the list of connected users to the OSC every second
    // client.send('/client', userList);
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
        var index = userList.indexOf(user);
        if (index > -1) {
            userList.splice(index, 1);
        }

        console.log(user + ' disconnected');
        console.log("Users:", userList);
    });
});

http.listen(httpPort, function () {
    console.log('Connect to:', internalIp.v4.sync() + ":" + httpPort);
});