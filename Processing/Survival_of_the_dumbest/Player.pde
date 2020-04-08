class Player {
  private int UID; // Player Identifier variable
  private PVector location; // Player location
  private PVector velocity; // Player velocity
  private PVector acceleration; // Player velocity
  //private float x, y; // Player position vars
  //private float playerWidth, playerHeight; // Player size vars.
  private float size; // Player size vars.
  //private float velocityX, velocityY; // Velocity vars.
  //private float accelerationX, accelerationY; // Acceleration vars.
  private final float DEFAULT_SPEED = 1.0;
  private float speed = DEFAULT_SPEED;
  private color pColor = color( random(0, 360), 100, random(75, 100)); // GENERATES RANDOM COLOR FOR USER

  // CHANGE PARAMS ORDER TO MATCH CONSTRUCTOR
  Player(float _x, float _y, float _size, int _id) {
    this.UID = _id;
    this.location = new PVector(_x, _y);
    this.velocity = new PVector(0, 0);
    this.acceleration = new PVector(0, 0);
    this.size = _size;
    //this.playerX = _x;
    //this.playerY = _y;
    // SPEED = MAP VELOCITY FROM -50, 50 to whatsever


    //this.playerWidth = _w;
    //this.playerHeight = _h;
  }

  // DISPLAYS PLAYER
  // Change player to new game
  void display() {
    colorMode(HSB, 360, 100, 100);
    //rectMode(CENTER);
    pushMatrix();
    translate(this.location.x, this.location.y);
    fill(this.pColor);
    stroke(0);
    strokeWeight(this.size * 0.05);
    circle(0, 0, this.size);


    // DISPLAY USER ID
    fill(0);
    textAlign(CENTER, BOTTOM);
    text(str(this.UID), 0, -this.size/2);
    popMatrix();
  }

  void move(float _x, float _y) {
    PVector reference = new PVector(0, 0);
    //this.velocityX = map(_x, -50.0, 50.0, -this.speed, this.speed);
    //this.velocityY = map(_y, -50.0, 50.0, -this.speed, this.speed);

    //this.velocity.set(map(_x, -50, 50, -this.speed, this.speed), map(_y, -50, 50, -this.speed, this.speed));
    //println(_x, _y);
    //PVector joystick = new PVector(_x, _y);
    //println(_x, _y, joystick);
    //joystick.normalize();
    //println(joystick);

    //this.acceleration = joystick;
    //this.acceleration.set(_x, _y);
    this.acceleration.set(_x, _y);
    this.acceleration.limit(2);
    this.acceleration.div(5);
    this.velocity.add(this.acceleration);
    this.location.add(this.velocity);
    this.velocity.limit(2);
    

    //redraw();
    //this.velocityX += this.accelerationX;
    //this.velocityY += this.accelerationY;
    //this.x += this.velocityX;
    //this.y += this.velocityY;
    if (this.acceleration.equals(reference)) {
      this.velocity.set(0, 0);
      //println("OY");
    }




    this.location.x = constrain(this.location.x, (this.size/2), width-(this.size/2)); 
    this.location.y = constrain(this.location.y, (this.size/2), height-(this.size/2));
  }

  // PLAYER METHODS
  public String toString() {
    return str(this.UID);
  }

  public int getUID() {
    return this.UID;
  }

  public float[] getPosition() {
    //float[] position = {this.playerPos.x, this.playerPos.y};
    return this.location.array();
  }

  public void setPosition(float _x, float _y) {
    //this.playerX = _x;
    //this.playerY = _y;
    this.location.set(_x, _y);
  }

  //public float getX() {
  //  return this.playerPos.x;
  //}

  //public float getY() {
  //  return this.playerPos.y;
  //}

  //public void setX(float _x) {
  //  this.playerX = _x;
  //}

  //public void setY(float _y) {
  //  this.playerY = _y;
  //}

  public color getColor() {
    return this.pColor;
  }

  public void setColor(color _newColor) {
    this.pColor = _newColor;
  }

  //public float getSpeed() {
  //  return this.playerSpeed;
  //}

  //public void setSpeed(float _speed) {
  //  this.playerSpeed = _speed;
  //}

  //public void setDefaultSpeed() {
  //  this.speed = DEFAULT_SPEED;
  //}
}
