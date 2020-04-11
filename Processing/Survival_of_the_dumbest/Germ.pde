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
