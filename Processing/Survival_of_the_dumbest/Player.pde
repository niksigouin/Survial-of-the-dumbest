class Player {
  private Integer UID; // Player Identifier variable
  private PVector pos; // Player location
  private PVector vel; // Player velocity
  private PVector acc; // Player velocity
  private float size; // Player size vars.
  private final float DEFAULT_SPEED = 1.0;
  private float speed = DEFAULT_SPEED;
  private color pColor = color( random(0, 360), 100, random(75, 100)); // GENERATES RANDOM COLOR FOR USER

  private ArrayList<ToiletRoll> rolls = new ArrayList<ToiletRoll>();


  // CHANGE PARAMS ORDER TO MATCH CONSTRUCTOR
  Player(float _x, float _y, float _size, int _id) {
    this.UID = _id;
    this.pos = new PVector(_x, _y);
    this.vel = new PVector(0, 0);
    this.acc = new PVector(0, 0);
    this.size = _size;
  }

  // DISPLAYS PLAYER
  // Change player to new game
  void display() {
    pushMatrix();
    pushStyle();
    //ellipseMode(RADIUS);
    colorMode(HSB, 360, 100, 100);
    translate(this.pos.x, this.pos.y);
    fill(this.pColor);
    stroke(0);
    strokeWeight(this.size * 0.05);
    circle(0, 0, this.size);
    popStyle();
    popMatrix();
  }

  void move(float _x, float _y) {
    PVector reference = new PVector(0, 0);
    //this.velocity.set(map(_x, -50, 50, -this.speed, this.speed), map(_y, -50, 50, -this.speed, this.speed));
    //println(_x, _y);
    //PVector joystick = new PVector(_x, _y);
    //println(_x, _y, joystick);
    //joystick.normalize();
    //println(joystick);

    //this.acceleration = joystick;
    //this.acceleration.set(_x, _y);
    this.acc.set(_x, _y);
    this.acc.limit(2);
    this.acc.div(5);
    this.vel.add(this.acc);
    this.pos.add(this.vel);
    this.vel.limit(2);
    
    if (this.acc.equals(reference)) {
      this.vel.set(0, 0);
    }

    this.pos.x = constrain(this.pos.x, (this.size/2), width-(this.size/2)); 
    this.pos.y = constrain(this.pos.y, (this.size/2), height-(this.size/2));
  }

  public void update() {
    Iterator<ToiletRoll> gameRollIter = gameRolls.iterator();

    while (gameRollIter.hasNext()) {
      ToiletRoll thisRoll = gameRollIter.next();

      if (this.pos.dist(thisRoll.loc) < this.size / 2 + thisRoll.size / 2) { // SET PICKUP RADIUS AND DISPLAY THE ACTUAL RADIUS WITH A FUNCTION?
        rolls.add(thisRoll);
        gameRollIter.remove();
      }
    }
  }

  //  // IF THE UID EQUALS THE CURENT ITERATION, REMOVE IT AND PRINT TO CONSOLE
  //  //if (collected_.getClass() == ToiletRoll.class) {
  //  //  int rollIndex = gameRolls.indexOf(collected_);
  //  //  ToiletRoll toTransfer = gameRolls.get(rollIndex);
  //  //  iterator.remove(thisRoll);
  //  //  rolls.add(toTransfer);
  //  //}
  //  if (thisRoll.equals(collected_)) {
  //    gameRollIter.remove();
  //    rolls.add(new ToiletRoll(new PVector(0.0,0.0),0));
  //  }


  public int rollCount() {
    return this.rolls.size();
  }

  // PLAYER METHODS
  public String toString() {
    return str(this.UID);
  }

  public Integer getUID() {
    return this.UID;
  }

  public float[] getPosArray() {
    //float[] position = {this.playerPos.x, this.playerPos.y};
    return this.pos.array();
  }
  
  public PVector getPos() {
    return this.pos;
  }

  public void setPosition(float _x, float _y) {
    //this.playerX = _x;
    //this.playerY = _y;
    this.pos.set(_x, _y);
  }

  public color getColor() {
    return this.pColor;
  }

  public void setColor(color _newColor) {
    this.pColor = _newColor;
  }
  
  public void displayID(){
    pushMatrix();
    translate(this.pos.x, this.pos.y);
    fill(0);
    textAlign(CENTER, BOTTOM);
    text(str(getUID()), 0, -this.size/2);
    popMatrix();
  }
}
