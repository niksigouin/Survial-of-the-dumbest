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

ItemHandler items = new ItemHandler();

// ARRAY OF CONNECT PLAYERS
HashMap<Integer, Player> players = new HashMap<Integer, Player>();

// TP Rolls
int numRolls = 10;
int numGerms = 10;

String client;
public boolean DEBUG = true; // SHOW DEBUG UI

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

  //for (int i=0; i < numRolls; i++) {
  //  gameRolls.add(new ToiletRoll(new PVector(random(width), random(height))));
  //}

  items.spawnRolls(numRolls);
  items.spawGerms(numGerms);

  if (DEBUG) {
    players.put(127, new Player(width/2, height/2, 65, 127));
  }


  // SENDS A MESSAGE TO THE NODE.JS SERVER TO GRAB CONNECTED CLIENTS
  sendSketchState();
}

void draw() {
  background(106);

  // INTERGRATE DISPLAY IN UPDATE?
  items.displayRolls();
  items.displayGerms();

  items.update();

  // DISPLAYS ALL CONNECTED PLAYERS ON SCREEN
  for (Player player : players.values()) {
    player.display();
    //player.update();
  }

  // Draws the UI
  if (DEBUG) {
    debugUI();
    players.get(127).setPosition(mouseX, mouseY);
  }
}

void mousePressed() {
  if (DEBUG) items.spawnRolls(10);
}

// DEBUG UI
void debugUI() {
  fill(255);

  // Num clients
  textAlign(LEFT, BOTTOM);
  textSize(20);
  text(players.size() + " clients: " + players.values(), 5, height-5);

  //FrameRate
  textAlign(LEFT, TOP);
  text((int) frameRate, 0, 0);
}
