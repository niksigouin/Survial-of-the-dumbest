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
  }

  public void update() {
    Iterator<Player> playerIter = players.values().iterator();


    while (playerIter.hasNext()) { // && playerIter.hasNext()
      Player thisPlayer = playerIter.next();
      thisPlayer.display();
      
      if (DEBUG) {
        players.get(127).setPosition(mouseX, mouseY);
      }
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
  void movePlayer(int _id, String _x, String _y) {
    Integer _UID = new Integer(_id); // CONVERTS INT TO PRIMITIVE INTERGER

    if (players.containsKey(_UID)) {
      players.get(_UID).move(Float.parseFloat(_x), Float.parseFloat(_y)); // GETS THE KEY OF THE PLAYER ANV MOVE
    }
  }
}
