import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.*; 
import java.io.*; 
import netP5.*; 
import oscP5.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Survival_of_the_dumbest extends PApplet {

/*
 * Titre: EDM4600 Travail final: "Survie des génies"
 * Auteur: Nikolas Sigouin
 * Version: 1.0
 * Instructions: [ADD INSTRUCTIONS ON HOW TO CONNECT PLAYER]
 * Description du projet
 * Notes: Quelques notes optionnelles à l'intention du correcteur.
 * Lien: Un lien vers votre page web bonus (optionnel).
 */






OscP5 oscP5;
NetAddress remote;

PlayerHandler playerHandler = new PlayerHandler();
ItemHandler itemHandler = new ItemHandler();

// NUMBER OF ITEMS TO SPAWN WHEN GAME STARTS
int numRolls = 10;
int numGerms = 10;

public boolean DEBUG = true; // SHOW DEBUG UI

public void setup() {
  frameRate(60);
  
  

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

public void draw() {
  background(106);

  // INTERGRATE DISPLAY IN UPDATE?
  itemHandler.displayRolls();
  itemHandler.displayGerms();

  itemHandler.update();

  playerHandler.update();

  debugUI();
}

public void mousePressed() {
  if (DEBUG) {
    itemHandler.spawnRolls(10);
    itemHandler.spawGerms(10);
  }
}

// WHEN HTTP  SERVER CONNECTS, CLEAR CLIENT ARRAYLIST
// THIS INSURES THAT ALL CLIENTS MATCH
public void rebaseClientArray(String _state) {
  if (_state.equals("READY")) {
    println("Node.js server", _state, "-> Clearing players ArrayList!");
    playerHandler.players.clear();
  }
}

public void oscEvent(OscMessage oscMessage) {
  //println("Type: " + oscMessage.typetag(), "Message: " + oscMessage);
}

// HANDLES INITIAL
public void sendSketchState() {
  OscMessage myMessage = new OscMessage("/sketch");

  // SENDS THE MESSAGE TO THE NODE.JS SERVER
  oscP5.send(myMessage, remote);
}

// DEBUG UI
public void debugUI() {
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
class ItemHandler {

  private ItemHandler() {
    // ADD LIMIT OF ITEMS TO THE CONSTRUCTOR?
  }

  public ArrayList<ToiletRoll> gameRolls = new ArrayList<ToiletRoll>();
  public ArrayList<Germ> gameGerms = new ArrayList<Germ>();

  //private Iterator<Player> playerIter = playerHandler.players.values().iterator();
  //private Iterator<ToiletRoll> gameRollIter = itemHandler.gameRolls.iterator();
  //private Iterator<Germ> gameGermIter = itemHandler.gameGerms.iterator();

  public void update() {
    Iterator<Player> playerIter = playerHandler.players.values().iterator();
    Iterator<ToiletRoll> gameRollIter = itemHandler.gameRolls.iterator();
    Iterator<Germ> gameGermIter = itemHandler.gameGerms.iterator();

    while (playerIter.hasNext()) { // && playerIter.hasNext()
      Player thisPlayer = playerIter.next();

      // MANIPULATES THE ToiletRolls
      while (gameRollIter.hasNext()) {
        ToiletRoll thisRoll = gameRollIter.next();
        
        // IF IN CONTACT WITH ROLL, COLLECT ROLL AND REMOVE IT FROM THE WORLD
        if (thisPlayer.loc.dist(thisRoll.loc) < thisPlayer.size / 2 + thisRoll.size / 2) { // SET PICKUP RADIUS AND DISPLAY THE ACTUAL RADIUS WITH A FUNCTION?
          thisPlayer.rolls.add(thisRoll);
          gameRollIter.remove();
        }
      }

      // MANIPULATES THE GERMS
      while (gameGermIter.hasNext()) {
        Germ thisGerm = gameGermIter.next();

        if (thisPlayer.loc.dist(thisGerm.loc) < thisPlayer.size / 2 + thisGerm.size / 2) { // SET PICKUP RADIUS AND DISPLAY THE ACTUAL RADIUS WITH A FUNCTION?
          thisPlayer.germs.add(thisGerm);
          gameGermIter.remove();
        }
      }
    }
  }
  
  
  
  public void spawGerms(int numGerms_) {
    for (int i=0; i < numGerms_; i++) {
      gameGerms.add(new Germ(new PVector(random(width), random(height))));
    }
  }

  public void displayGerms() {
    for (Germ germ : gameGerms) {
      germ.display();
    }
  }

  public void spawnRolls(int numRolls_) {
    for (int i=0; i < numRolls_; i++) {
      gameRolls.add(new ToiletRoll(new PVector(random(width), random(height))));
    }
  }

  public void displayRolls() {
    for (ToiletRoll toiletRoll : gameRolls) {
      toiletRoll.display();
    }
  }
}
class Germ {
  private PVector loc;
  private float size;
  private boolean isUsable;

  Germ(PVector loc_) {
    this.loc = loc_;
    this.size = 10;
    this.isUsable = true;
  }

  public void display() {
    pushMatrix();
    pushStyle();
    //ellipseMode(RADIUS);
    translate(this.loc.x, this.loc.y);
    fill(0xff00FF00);
    stroke(0);
    strokeWeight(this.size * 0.0002f);
    circle(0, 0, this.size);
    popStyle();
    popMatrix();
  }
}

class ToiletRoll {
  private PVector loc;
  private float size;
  private boolean isUsable;

  //public ArrayList<ToiletRoll> gameRolls = new ArrayList<ToiletRoll>();

  ToiletRoll(PVector loc_) {
    this.loc = loc_;
    this.size = 20;
    this.isUsable = false;
  }

  public void display() {
    pushMatrix();
    pushStyle();
    //ellipseMode(RADIUS);
    translate(this.loc.x, this.loc.y);
    fill(255);
    stroke(0);
    strokeWeight(this.size * 0.0002f);
    circle(0, 0, this.size);
    popStyle();
    popMatrix();
  }

  //public void spawnRolls(int numRolls_) {
  //  for (int i=0; i < numRolls_; i++) {
  //    gameRolls.add(new ToiletRoll(new PVector(random(width), random(height))));
  //  }
  //}

  //public void displayRolls() {
  //  for (ToiletRoll toiletRoll : gameRolls) {
  //    toiletRoll.display();
  //  }
  //}
}
class Player {
  private Integer UID; // Player Identifier variable
  private PVector loc; // Player location
  private PVector vel; // Player velocity
  private PVector acc; // Player velocity
  private float mass;
  private float size; // Player size vars.
  private PVector dirForce; // Player directional force [x, y]
  private float rot;
  private float attRange;
  private int initColor = color( random(0, 360), 100, random(75, 100)); // GENERATES RANDOM COLOR FOR USER
  private int pColor;
  private ArrayList<ToiletRoll> rolls = new ArrayList<ToiletRoll>();
  private ArrayList<Germ> germs = new ArrayList<Germ>();


  // CHANGE PARAMS ORDER TO MATCH CONSTRUCTOR
  Player(float _x, float _y, float _size, int _id) {
    this.UID = _id;
    this.loc = new PVector(_x, _y);
    this.vel = new PVector(0, 0);
    this.acc = new PVector(0, 0);
    this.size = _size;
    this.mass = 1;
    this.dirForce = new PVector(0, 0);
    this.attRange = this.size * 2.5f;
    this.pColor = this.initColor;
  }

  // DISPLAYS PLAYER
  // Change player to new game
  public void display() {
    if (DEBUG) {
      displayAttRad();
      displayPlayerInfo();
    }

    pushMatrix();
    pushStyle();
    //ellipseMode(RADIUS);
    colorMode(HSB, 360, 100, 100);
    translate(this.loc.x, this.loc.y);
    rotate(this.rot + radians(90)); // SETS CORRECT ORIENTATION 
    fill(this.pColor);
    stroke(0);
    strokeWeight(this.size * 0.05f);
    circle(0, 0, this.size);
    fill(255);
    noStroke();
    rect((-this.size * 0.2f) / 2, -this.size/2, this.size * 0.2f, this.size * 0.4f);
    popStyle();
    popMatrix();
  }

  // APPLYS FRICTION TO THE PLAYER
  public void applyFriction() {
    PVector friction = this.vel.get();
    friction.normalize();
    float c = -0.08f; // COEFICIENT OF FRICTION
    friction.mult(c);
    this.acc.add(friction);
  }

  public void update() {
    this.vel.add(this.acc);
    this.vel.limit(5); // VELOCITY LIMIT
    this.loc.add(this.vel);
    this.acc.mult(0);

    // WHEN PLAYER IS MOVING, APPLY THE FORCE
    if (!this.dirForce.equals(new PVector(0, 0))) {
      this.acc.set(this.dirForce);
    }

    applyFriction();

    this.loc.x = constrain(this.loc.x, (this.size/2), width-(this.size/2)); 
    this.loc.y = constrain(this.loc.y, (this.size/2), height-(this.size/2));
  }

  public void setDirForce(PVector force) {
    force.normalize();
    force.mult(0.5f);  // TAKE MASS INTO ACCOUNT?? MORE TP = MORE MASS THUS HARDER TIME NAVIGATING
    this.dirForce = force; 
    this.rot = this.dirForce.heading();
  }

  public void displayAttRad() {
    pushMatrix();
    pushStyle();
    translate(this.loc.x, this.loc.y);
    noStroke();
    fill(0xff00AA00, 58);
    circle(0, 0, this.attRange);
    popStyle();
    popMatrix();
  }

  // HANDLES THE PLAYER ATTACK
  public void attack() {
    //Iterator<Player> playerIter = playerHandler.players.values().iterator();
    //Iterator<Player> otherPlayerIter = playerHandler.players.values().iterator();


    // CHECKS IF PLAYER HAS GERM AND IN CONTACT WITH OTHER
    if (this.hasGerm()) {
      println(this, "attacked!");
      //  for (Player otherPlayer : playerHandler.players.values()) {
      //    if (this.loc.dist(otherPlayer.loc) < 50) { // SET PICKUP RADIUS AND DISPLAY THE ACTUAL RADIUS WITH A FUNCTION?
      //      println(this, "attacked:", otherPlayer);
      //      this.useGerm(); // REMOVE LAST GERM COLLECTED
      //      otherPlayer.setColor(#FFFFFF);
      //    } else {
      //println(this, "tried to attack but has new germs!");
      //    }
      //  }
    } else {
      println(this, "tried to attack but has new germs!");
    }
  }

  public int rollCount() {
    return this.rolls.size();
  }

  public int germCount() {
    return this.germs.size();
  }

  // PLAYER METHODS
  public String toString() {
    return str(this.UID);
  }

  public Integer getUID() {
    return this.UID;
  }

  public PVector getLoc() {
    return this.loc;
  }

  public float getAttackRange() {
    return this.attRange;
  }

  public void setPosition(float _x, float _y) {
    this.loc.set(_x, _y);
  }

  public int getColor() {
    return this.pColor;
  }

  public void setColor(int _newColor) {
    this.pColor = _newColor;
  }

  public void setInitColor() {
    this.pColor = this.initColor;
  }

  public void useGerm() {
    this.germs.remove( this.germs.size() -1);
  }

  public boolean hasGerm() {
    return (this.germs.size() > 0);
  }

  public float getSize() {
    return this.size;
  }

  // USER ID
  public void displayUID() {
    pushMatrix();
    translate(this.loc.x, this.loc.y);
    fill(0);
    textAlign(CENTER, BOTTOM);
    text(str(getUID()), 0, -this.size/2);
    popMatrix();
  }

  // USER INFO
  public void displayPlayerInfo() {
    pushMatrix();
    pushStyle();
    translate(this.loc.x, this.loc.y);
    fill(0);
    textSize(15);
    textAlign(CENTER, BOTTOM);
    text("UID: " + getUID(), 0, -this.size / 2);
    textAlign(CENTER, TOP);
    String items = "\nRolls: " + rollCount() + 
      "\nGerms: " + germCount();
    text(items, 0, this.size / 4);
    popStyle();
    popMatrix();
  }
}
class PlayerHandler {
  // ARRAY OF CONNECT PLAYERS
  public HashMap<Integer, Player> players = new HashMap<Integer, Player>();

  private PlayerHandler() {
  }

  public void createLocalPlayer() {
    players.put(127, new Player(width/2, height/2, 65, 127));
  }

  public void plugPlayerMessages() {
    oscP5.plug(this, "connectClient", "/connect");
    oscP5.plug(this, "disconnectClient", "/disconnect");
    oscP5.plug(this, "movePlayer", "/joystick");
    oscP5.plug(this, "attack", "/btn1");
  }

  public void update() {
    Iterator<Player> playerIter = players.values().iterator();
    //Iterator<Player> otherPlayerIter = players.values().iterator();

    
    while (playerIter.hasNext()) { // && playerIter.hasNext()
      Player thisPlayer = playerIter.next();
      thisPlayer.display();
      thisPlayer.update();
      
      //if (DEBUG) {
      //  players.get(127).setPosition(mouseX, mouseY);
      //}

      // CHECKS FOR ATT ON OTHER PLAYER
      //while(otherPlayerIter.hasNext()){
      //   Player otherPlayer = otherPlayerIter.next();
      //   if (thisPlayer.loc.dist(otherPlayer.loc) < thisPlayer.attRange / 2 + otherPlayer.attRange / 2 && thisPlayer.hasGerm()) { // SET PICKUP RADIUS AND DISPLAY THE ACTUAL RADIUS WITH A FUNCTION?

      //    thisPlayer.useGerm(); // REMOVE LAST GERM COLLECTED
      //    otherPlayer.setColor(#FF0000);

      //  }
      //}
    }
  }

  // ADDS CONNECTED USER
  public void connectClient(int _id) {
    Integer _UID = new Integer(_id); // CONVERTS INT TO PRIMITIVE INTERGER

    println("Joined:", _UID);
    players.putIfAbsent(_UID, new Player(width/2, height/2, 65, _id));
    println(players.values());
  } 

  // REMOVES DISCONNECTED USER
  public void disconnectClient(int id_) { 
    Integer UID_ = new Integer(id_); // CONVERTS INT TO PRIMITIVE INTERGER
    Iterator<Integer> playerIDIterator = players.keySet().iterator(); // ITERATOR FOR PLAYER KEYS

    // ITERATES THROUGH THE UIDs
    while (playerIDIterator.hasNext()) {
      Integer UID = playerIDIterator.next();

      // IF THE UID EQUALS THE CURENT ITERATION, REMOVE IT AND PRINT TO CONSOLE
      if (UID.equals(UID_)) {
        playerIDIterator.remove();
        println("Left:", UID_);
        println(players.values());
      }
    }
  }

  // HANDLES PLAYER MOVEMENTS
  public void movePlayer(int _id, String _x, String _y) {
    Integer _UID = new Integer(_id); // CONVERTS INT TO PRIMITIVE INTERGER
    PVector force = new PVector(Float.parseFloat(_x), Float.parseFloat(_y));

    if (players.containsKey(_UID)) {
      players.get(_UID).setDirForce(force); // GETS THE KEY OF THE PLAYER ANV MOVE
    }
  }

  //HANDLES PLAYER ATTACK
  public void attack(int _id, int state_) {
    Integer _UID = new Integer(_id); // CONVERTS INT TO PRIMITIVE INTERGER

    if (players.containsKey(_UID)) {
      players.get(_UID).attack(); // GETS THE KEY OF THE PLAYER ANV MOVE
    }
  }
}
  public void settings() {  size(1280, 720, P2D);  smooth(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--present", "--window-color=#666666", "--hide-stop", "Survival_of_the_dumbest" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
