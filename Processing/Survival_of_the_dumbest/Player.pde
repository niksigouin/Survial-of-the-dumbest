class Player {
  private int playerID; // Player Identifier variable
  private float playerX, playerY; // Player position vars
  //private float playerWidth, playerHeight; // Player size vars.
  private float playerSize; // Player size vars.
  private float velocityX, velocityY; // Velocity vars.
  private float accelerationX, accelerationY; // Acceleration vars.
  private final float DEFAULT_SPEED = 1.0;
  private float playerSpeed = DEFAULT_SPEED;
  private color playerColor = color( random(0, 360), 100, random(75, 100)); // GENERATES RANDOM COLOR FOR USER


  Player(float _x, float _y, float _size, int _id) {
    this.playerX = _x;
    this.playerY = _y;
    this.playerSize = _size;
    //this.playerWidth = _w;
    //this.playerHeight = _h;
    this.playerID = _id;
  }

  // DISPLAYS PLAYER
  // Change player to new game
  void display() {
    colorMode(HSB, 360, 100, 100);
    //rectMode(CENTER);
    pushMatrix();
    translate(this.playerX, this.playerY);
    fill(this.playerColor);
    stroke(0);
    strokeWeight(this.playerSize * 0.05);
    circle(0,0, this.playerSize);
    
    
    // DISPLAY USER ID
    fill(0);
    textAlign(CENTER, BOTTOM);
    text(str(this.playerID), 0, -this.playerSize/2);
    popMatrix();
  }

  void move(float _x, float _y) {
    redraw();
    this.velocityX += this.accelerationX;
    this.velocityY += this.accelerationY;
    this.playerX += this.velocityX;
    this.playerY += this.velocityY;

    this.velocityX = map(_x, -50.0, 50.0, -this.playerSpeed, this.playerSpeed);
    this.velocityY = map(_y, -50.0, 50.0, -this.playerSpeed, this.playerSpeed);

    this.playerX = constrain(this.playerX, this.playerSize, width-this.playerSize); 
    this.playerY = constrain(this.playerY, this.playerSize, height);
  }

  // PLAYER METHODS
  public String toString() {
    return str(this.playerID);
  }

  public int getUID() {
    return this.playerID;
  }

  public float[] getPosition() {
    float[] position = {this.playerX, this.playerY};
    return position;
  }

  public void setPosition(float _x, float _y) {
    this.playerX = _x;
    this.playerY = _y;
  }

  public float getX() {
    return this.playerX;
  }

  public float getY() {
    return this.playerY;
  }

  public void setX(float _x) {
    this.playerX = _x;
  }

  public void setY(float _y) {
    this.playerY = _y;
  }

  public color getColor() {
    return this.playerColor;
  }

  public void setColor(color _newColor) {
    this.playerColor = _newColor;
  }

  public float getSpeed() {
    return this.playerSpeed;
  }

  public void setSpeed(float _speed) {
    this.playerSpeed = _speed;
  }

  public void setDefaultSpeed() {
    this.playerSpeed = DEFAULT_SPEED;
  }
}
