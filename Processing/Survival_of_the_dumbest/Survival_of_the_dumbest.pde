import java.util.*;
import java.io.*;
import netP5.*;
import oscP5.*;

OscP5 oscP5;
NetAddress remote;

ArrayList clientList = new ArrayList();
ArrayList<Player> players = new ArrayList<Player>();


String client;
boolean debug = false; // SHOW DEBUG UI

void setup() {
  size(1280, 720, P2D);
  smooth();
  oscP5 = new OscP5(this, 3334);
  remote = new NetAddress("127.0.0.1", 3334);
  
  //probServer();

  
  debug = true;
}

void draw() {
  background(106);

  // Draws the UI
  if (debug) {
    UI();
  }

  for (int i=0; i < players.size(); i++) {
    players.get(i).display();
  }
}

void oscEvent(OscMessage m) {
  String address = m.addrPattern();
  // Gets the first value of the osc message (Use of idex is for an array of values
  // EX: 
  // OSC MESSAGE OBJECT -> {IP ADDRESS}/XYPAD [12, 19]
  // int x = theOscMessage.get(0).intValue();
  // int y = theOscMessage.get(1).intValue();

  // #### Appends new client to clientList ### //
  if (address.equals("/clientJoin")) {

    // LOGISTIQUE
    client = m.get(0).stringValue();
    println("Joined: " + client);
    clientList.add(client);

    // ADDS NEW PLAYER TO THE SCENE
    players.add(new Player(width/2, height/2, 65, 130, client));

    //printArray(players);
    printArray(clientList);
  } 

  // #### Removes the diconnected client from clientList ### //
  else if (address.equals("/clientLeft")) {

    // LOGISTIQUE
    client = m.get(0).stringValue(); // Grabs the client IP
    int index = clientList.indexOf(client); // Gets the index of the disconnected client
    clientList.remove(index); // Removes the client from the connected client list
    players.remove(index); // Removes the player with the index of the disconnected client



    // DEBUG PRINTSSSSSSSS
    println("Left: " + client);
    printArray(clientList);
    //printArray(players);
  } 

  //if (address.equals("/button")) {

  //  // LOGISTIQUE
  //  client = m.get(0).stringValue(); // Grabs the client IP
  //  String dir = m.get(1).stringValue();

  //  int index = clientList.indexOf(client); // Gets the index of the client transmitting

  //  players.get(index).move(dir); // Move player
  //} 

  if (address.equals("/joystick")) {

    // LOGISTIQUE
    client = m.get(0).stringValue(); // Grabs the client IP
    float dirX = m.get(1).floatValue();
    float dirY = m.get(2).floatValue();

    int index = clientList.indexOf(client); // Gets the index of the client transmitting

    players.get(index).move(dirX, dirY); // Move player
  } 

  String addr = m.addrPattern();
  //int first = m.get(0).intValue();
  //int second = m.get(1).intValue();
  println(addr, m.get(0).stringValue(), m.get(1).floatValue(), m.get(2).floatValue());
  //println(addr, first, second);

  //println(m);
}

void probServer() {
  OscMessage ping = new OscMessage("/ping");
  ping.add(true);
  oscP5.send(ping,remote);
  println("SERVER PROBED!");
}

void UI() {
  fill(255);
  textAlign(LEFT, BOTTOM);
  textSize(20);
  text("Clients: " + clientList, 5, height-5);
  textAlign(LEFT, TOP);
  text((int) frameRate, 0, 0);
}
