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

PlayerHandler playerHandler = new PlayerHandler();
ItemHandler itemHandler = new ItemHandler();

// NUMBER OF ITEMS TO SPAWN WHEN GAME STARTS
int numRolls = 10;
int numGerms = 10;

public boolean DEBUG = true; // SHOW DEBUG UI

void setup() {
  frameRate(60);
  size(1280, 720, P2D);
  smooth();

  oscP5 = new OscP5(this, 3334);
  remote = new NetAddress("127.0.0.1", 3335);

  // TRANSFERS THE "/client" MESSAGES TO clientList MATHOD FOR PROCESSING
  oscP5.plug(this, "rebaseClientArray", "/start");
  playerHandler.plugPlayerMessages();

  itemHandler.spawnRolls(numRolls);
  itemHandler.spawGerms(numGerms);

  if (DEBUG) {
    //playerHandler.createLocalPlayer();
  }

  // SENDS A MESSAGE TO THE NODE.JS SERVER TO GRAB CONNECTED CLIENTS
  sendSketchState();
}

void draw() {
  background(106);

  // INTERGRATE DISPLAY IN UPDATE?
  itemHandler.displayRolls();
  itemHandler.displayGerms();

  itemHandler.update();

  playerHandler.update();

  debugUI();
}

void mousePressed() {
  if (DEBUG) {
    itemHandler.spawnRolls(10);
    itemHandler.spawGerms(10);
  }
}

// WHEN HTTP  SERVER CONNECTS, CLEAR CLIENT ARRAYLIST
// THIS INSURES THAT ALL CLIENTS MATCH
void rebaseClientArray(String _state) {
  if (_state.equals("READY")) {
    println("Node.js server", _state, "-> Clearing players ArrayList!");
    playerHandler.players.clear();
  }
}

void oscEvent(OscMessage oscMessage) {
  //println("Type: " + oscMessage.typetag(), "Message: " + oscMessage);
}

// HANDLES INITIAL
void sendSketchState() {
  OscMessage myMessage = new OscMessage("/sketch");

  // SENDS THE MESSAGE TO THE NODE.JS SERVER
  oscP5.send(myMessage, remote);
}

// DEBUG UI
void debugUI() {
  if (DEBUG) {
    fill(255);

    // Num clients
    textAlign(LEFT, BOTTOM);
    textSize(20);
    text(playerHandler.players.size() + " clients: " + playerHandler.players.values(), 5, height-5);

    //FrameRate
    textAlign(LEFT, TOP);
    text((int) frameRate, 0, 0);
  }
}
