class ToiletRoll {
  private PVector loc;
  private float size;
  private boolean isUsable;

  ToiletRoll(PVector loc_, float size_) {
    this.loc = loc_;
    this.size = size_;
    this.isUsable = false;
  }

  public void display() {
    pushMatrix();
    pushStyle();
    translate(this.loc.x, this.loc.y);
    fill(255);
    stroke(0);
    strokeWeight(this.size * 0.0002);
    circle(0, 0, this.size);
    popStyle();
    popMatrix();
  }
  
  
}
