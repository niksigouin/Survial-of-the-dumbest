import java.util.*;
import java.io.*;
import netP5.*;
import oscP5.*;

OscP5 oscP5;
NetAddress remote;

// ARRAY OF CONNECT PLAYERS
//ArrayList<Player> players = new ArrayList<Player>();
HashMap<Integer, Player> players = new HashMap<Integer, Player>();

String client;
boolean debug = false; // SHOW DEBUG UI

void setup() {
  frameRate(60);
  size(1280, 720, P2D);
  smooth();

  oscP5 = new OscP5(this, 3334);
  remote = new NetAddress("127.0.0.1", 3335);

  // TRANSFERS THE "/client" MESSAGES TO clientList MATHOD FOR PROCESSING
  oscP5.plug(this, "rebaseClientArray", "/start");
  oscP5.plug(this, "connectClient", "/connect");
  oscP5.plug(this, "disconnectClient", "/disconnect");
  oscP5.plug(this, "movePlayer", "/joystick");


  debug = true;

  // SENDS A MESSAGE TO THE NODE.JS SERVER TO GRAB CONNECTED CLIENTS
  sendSketchState();
}

void draw() {
  background(106);

  // Draws the UI
  if (debug) {
    debugUI();
  }

  // DISPLAYS ALL CONNECTED PLAYERS ON SCREEN
  //for (Player player : players) {
  //  player.display();
  //}
}

// ADDS CONNECTED USER
void connectClient(int _id) {
  Integer _UID = new Integer(_id);
  // ADDS NEW PLAYER TO THE ARRAY IF NOT ALREADY IN
  //if (players.contains(playerIndex(_id))) {
  //  println("User", _id, "already connected!");
  //} else {
  //  players.add(new Player(width/2, height/2, 65, _id));
  //  println("Joined:", _id);
  //  printArray(players);
  //}
  players.put(_UID, new Player(width/2, height/2, 65, _id));
} 

// REMOVES DISCONNECTED USER
void disconnectClient(int _id) { 
  Integer _UID = new Integer(_id);
  // REMOVES PLAYER FROM ARRAY
  //if (players.size() > 0 && players.contains(playerIndex(_id)) == false) {
  //  players.remove(playerIndex(_id));
  //  println("Left:", _id);
  //  printArray(players);
  //} else {
  //  println("User", players.get(playerIndex(_id)), "tried to leave!");
  //}
}


void movePlayer(int _id, String _x, String _y) {
  players.get(playerIndex(_id)).move(Float.parseFloat(_x), Float.parseFloat(_y)); // Move player
}

// WHEN HTTP  SERVER CONNECTS, CLEAR CLIENT ARRAYLIST
// THIS INSURES THAT ALL CLIENTS MATCH
void rebaseClientArray(String _state) {
  if (_state.equals("READY")) {
    println("Node.js server", _state, "-> Clearing players ArrayList!");
    players.clear();
  }
}

void oscEvent(OscMessage oscMessage) {
  //String address = oscMessage.addrPattern();
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

void sendSketchState() {
  OscMessage myMessage = new OscMessage("/sketch");
  //myMessage.add(""); /* add an String to the osc message */
  /* send the message */
  oscP5.send(myMessage, remote);
}


// DEBUG UI
void debugUI() {
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
    if (players.get(i).getUID() == _id) {
      playerIndex = i;
    }
  }
  return playerIndex;
}
