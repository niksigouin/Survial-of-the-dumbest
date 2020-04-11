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

// HANDLES PLAYER MOVEMENTS
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

// HANDLES INITIAL
void sendSketchState() {
  OscMessage myMessage = new OscMessage("/sketch");

  // SENDS THE MESSAGE TO THE NODE.JS SERVER
  oscP5.send(myMessage, remote);
}
