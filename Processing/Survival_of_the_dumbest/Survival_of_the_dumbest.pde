import java.util.*;
import java.io.*;
import netP5.*;
import oscP5.*;

OscP5 oscP5;
NetAddress remote;

// ARRAY OF CONNECT PLAYERS
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
  for (Player player : players.values()) {
    player.display();
  }
}

// ADDS CONNECTED USER
void connectClient(int _id) {
  Integer _UID = new Integer(_id); // CONVERTS INT TO PRIMITIVE INTERGER

  println("Joined:", _UID);
  players.putIfAbsent(_UID, new Player(width/2, height/2, 65, _id));
  printArray(players);
} 

// REMOVES DISCONNECTED USER
void disconnectClient(int _id) { 
  Integer _UID = new Integer(_id); // CONVERTS INT TO PRIMITIVE INTERGER
  Iterator<Integer> iterator = players.keySet().iterator(); // ITERATOR FOR PLAYER KEYS

  // ITERATES THROUGH THE UIDs
  while (iterator.hasNext()) {
    Integer player = iterator.next();

    // IF THE UID EQUALS THE CURENT ITERATION, REMOVE IT AND PRINT TO CONSOLE
    if (player.equals(_UID)) {
      iterator.remove();
      println("Left:", _UID);
      printArray(players);
    }
  }
}


void movePlayer(int _id, String _x, String _y) {
  Integer _UID = new Integer(_id); // CONVERTS INT TO PRIMITIVE INTERGER
  players.get(_UID).move(Float.parseFloat(_x), Float.parseFloat(_y)); // GETS THE KEY OF THE PLAYER ANV MOVE
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
  //println("Type: " + oscMessage.typetag(), "Message: " + oscMessage);
}

void sendSketchState() {
  OscMessage myMessage = new OscMessage("/sketch");
  
  // SENDS THE MESSAGE TO THE NODE.JS SERVER
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
