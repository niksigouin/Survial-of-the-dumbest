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

        if (thisPlayer.pos.dist(thisRoll.loc) < thisPlayer.size / 2 + thisRoll.size / 2) { // SET PICKUP RADIUS AND DISPLAY THE ACTUAL RADIUS WITH A FUNCTION?
          thisPlayer.rolls.add(thisRoll);
          gameRollIter.remove();
        }
      }

      // MANIPULATES THE GERMS
      while (gameGermIter.hasNext()) {
        Germ thisGerm = gameGermIter.next();

        if (thisPlayer.pos.dist(thisGerm.loc) < thisPlayer.size / 2 + thisGerm.size / 2) { // SET PICKUP RADIUS AND DISPLAY THE ACTUAL RADIUS WITH A FUNCTION?
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
