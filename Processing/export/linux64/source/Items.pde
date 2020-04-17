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
    fill(#00FF00);
    stroke(0);
    strokeWeight(this.size * 0.0002);
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
    strokeWeight(this.size * 0.0002);
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
