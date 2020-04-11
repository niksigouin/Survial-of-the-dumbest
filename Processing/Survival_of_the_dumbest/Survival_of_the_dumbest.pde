/*
 * Titre: EDM4600 Travail final: "Survie des génies"
 * Auteur: Nikolas Sigouin
 * Version: 1.0
 * Instructions: [ADD INSTRUCTIONS ON HOW TO CONNECT PLAYER]
 * Description du projet
 * Notes: Quelques notes optionnelles à l'intention du correcteur.
 * Lien: Un lien vers votre page web bonus (optionnel).
 */

import java.util.*;
import java.io.*;
import netP5.*;
import oscP5.*;

OscP5 oscP5;
NetAddress remote;

// ARRAY OF CONNECT PLAYERS
HashMap<Integer, Player> players = new HashMap<Integer, Player>();

// TP Rolls
int numRolls = 10;
ArrayList<ToiletRoll> gameRolls = new ArrayList<ToiletRoll>();

String client;
boolean debug = true; // SHOW DEBUG UI

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

  for (int i=0; i < numRolls; i++) {
    gameRolls.add(new ToiletRoll(new PVector(random(width), random(height)), 20));
  }

  if (debug) {
    players.put(127, new Player(width/2, height/2, 65, 127));
  }


  // SENDS A MESSAGE TO THE NODE.JS SERVER TO GRAB CONNECTED CLIENTS
  sendSketchState();
}

void draw() {
  background(106);
  for (ToiletRoll toiletRoll : gameRolls) {
    toiletRoll.display();
  }

  // DISPLAYS ALL CONNECTED PLAYERS ON SCREEN
  for (Player player : players.values()) {
    player.display();
    player.update();
  }

  // Draws the UI
  if (debug) {
    debugUI();
    players.get(127).setPosition(mouseX, mouseY);
  }
}

//PVector randomLocation(){
//  return PVector();
//}

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

  if (players.containsKey(_UID)) {
    players.get(_UID).move(Float.parseFloat(_x), Float.parseFloat(_y)); // GETS THE KEY OF THE PLAYER ANV MOVE
  }
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
  
  // Local player roll count
  textAlign(LEFT, BOTTOM);
  textSize(20);
  text("Rolls: " + players.get(127).rollCount(), 5, height-30);
  
  // Num clients
  textAlign(LEFT, BOTTOM);
  textSize(20);
  text("Clients: " + players, 5, height-5);
  
  //FrameRate
  textAlign(LEFT, TOP);
  text((int) frameRate, 0, 0);
}
