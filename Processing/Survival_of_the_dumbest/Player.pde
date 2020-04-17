class Player {
  private Integer UID; // Player Identifier variable
  private PVector loc; // Player location
  private PVector vel; // Player velocity
  private PVector acc; // Player velocity
  private float mass;
  private float size; // Player size vars.
  private PVector dirForce; // Player directional force [x, y]
  private float rot;
  //private final float DEFAULT_SPEED = 1.0;
  //private float speed = DEFAULT_SPEED;
  private color pColor = color( random(0, 360), 100, random(75, 100)); // GENERATES RANDOM COLOR FOR USER

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
  }

  // DISPLAYS PLAYER
  // Change player to new game
  void display() {
    pushMatrix();
    pushStyle();
    //ellipseMode(RADIUS);
    colorMode(HSB, 360, 100, 100);
    translate(this.loc.x, this.loc.y);
    rotate(this.rot + radians(90)); // SETS CORRECT ORIENTATION 
    fill(this.pColor);
    stroke(0);
    strokeWeight(this.size * 0.05);
    circle(0, 0, this.size);
    fill(255);
    noStroke();
    rect((-this.size * 0.2) / 2, -this.size/2, this.size * 0.2, this.size * 0.4);
    popStyle();
    popMatrix();

    if (DEBUG) displayPlayerInfo();
  }

  // APPLYS FRICTION TO THE PLAYER
  void applyFriction() {
    PVector friction = this.vel.get();
    friction.normalize();
    float c = -0.08; // COEFICIENT OF FRICTION
    friction.mult(c);
    this.acc.add(friction);
  }

  void update() {
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

  void setDirForce(PVector force) {
    force.normalize();
    force.mult(0.5);  // TAKE MASS INTO ACCOUNT?? MORE TP = MORE MASS THUS HARDER TIME NAVIGATING
    this.dirForce = force; 
    this.rot = this.dirForce.heading();
  }

  // HANDLES THE PLAYER ATTACK
  void attack() {
    println(this.toString(), "attacked!");
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

  public PVector getPos() {
    return this.loc;
  }

  public void setPosition(float _x, float _y) {
    this.loc.set(_x, _y);
  }

  public color getColor() {
    return this.pColor;
  }

  public void setColor(color _newColor) {
    this.pColor = _newColor;
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
  void displayPlayerInfo() {
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
