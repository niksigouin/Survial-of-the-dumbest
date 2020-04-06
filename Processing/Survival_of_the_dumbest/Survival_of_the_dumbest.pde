import java.util.*;
import java.io.*;
//import netP5.*;
import oscP5.*;

OscP5 oscP5;
//NetAddress remote;

// ARRAY OF CONNECT PLAYERS
ArrayList<Player> players = new ArrayList<Player>();
Iterator<Player> connectedPlayers = players.iterator();

String client;
boolean debug = false; // SHOW DEBUG UI

void setup() {
  size(1280, 720, P2D);
  smooth();
  oscP5 = new OscP5(this, 3334);
  //remote = new NetAddress("127.0.0.1", 3334);

  //probServer();

  // TRANSFERS THE "/client" MESSAGES TO clientList MATHOD FOR PROCESSING
  oscP5.plug(this, "connectClient", "/connect");
  oscP5.plug(this, "disconnectClient", "/disconnect");
  oscP5.plug(this, "movePlayer", "/joystick");

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

// ADDS CONNECTED USER
void connectClient(int _id) {
  // LOGISTIQUE
  println("Joined:", _id);

  // ADDS NEW PLAYER TO THE ARRAY
  players.add(new Player(width/2, height/2, 65, 130, _id));

  printArray(players);
} 

// REMOVES DISCONNECTED USER
void disconnectClient(int _id) {
  // LOGISTIQUE  
  println("Left:", playerIndex(_id));
  
  // REMOVES PLAYER FROM ARRAY
  players.remove(playerIndex(_id));
  
  printArray(players);
}


//void movePlayer(String _id, float _x, float _y){

//    int index = clientList.indexOf(client); // Gets the index of the client transmitting

//    players.get(index).move(dirX, dirY); // Move player
//}


void oscEvent(OscMessage oscMessage) {
  String address = oscMessage.addrPattern();
  //// Gets the first value of the osc message (Use of idex is for an array of values
  //// EX: 
  //// OSC MESSAGE OBJECT -> {IP ADDRESS}/XYPAD [12, 19]
  //// int x = theOscMessage.get(0).intValue();
  //// int y = theOscMessage.get(1).intValue();

  // // MOVES THE PLAYER 
  //if (address.equals("/joystick")) {

  //  // LOGISTIQUE
  //  client = m.get(0).stringValue(); // Grabs the client IP
  //  float dirX = m.get(1).floatValue();
  //  float dirY = m.get(2).floatValue();

  //  int index = clientList.indexOf(client); // Gets the index of the client transmitting

  //  players.get(index).move(dirX, dirY); // Move player
  //} 

  //String addr = m.addrPattern();
  ////////int first = m.get(0).intValue();
  ////////int second = m.get(1).intValue();
  ////println(addr, m.get(0).stringValue(), m.get(1).floatValue(), m.get(2).floatValue());
  ////////println(addr, first, second);

  //println(oscMessage.typetag());
}

//void mousePressed() {
//  /* in the following different ways of creating osc messages are shown by example */
//  OscMessage myMessage = new OscMessage("/test");

//  myMessage.add(123); /* add an int to the osc message */

//  /* send the message */
//  oscP5.send(myMessage, remote); 
//}

void UI() {
  fill(255);
  textAlign(LEFT, BOTTOM);
  textSize(20);
  text("Clients: " + players, 5, height-5);
  textAlign(LEFT, TOP);
  text((int) frameRate, 0, 0);
}


// LOOPS THROUGH THE CONNECT CLIENT LIST AND RETURNS INDEX OF USER BASEDON ITS USERID
int playerIndex(int _id) {
  int playerIndex = -1;
  for (int i=0; i < players.size(); i++) {
    if (players.get(i).getID() == _id) {
      playerIndex = i;
    }
  }
  return playerIndex;
}
