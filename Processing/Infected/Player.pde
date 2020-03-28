public class Player {

  String status = "healthy";

  public Player() {
    
  }
  
  public void display() {
  
  }
  
  public void move() {
    
  }
  
  

  public boolean isInfected() {
    switch(status) {
    case "healthy":
      return false;
    case "infected":
      return true;
    case "recovered":
      return false;
    default:
      return false;
    }
  }

  public void status() {
    println(status, isInfected());
  }
}
