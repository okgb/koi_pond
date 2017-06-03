// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2011
// Box2DProcessing example

class Chair {

  static final int REMOVE_COUNT = 500; // frames to wait until it gets removed

  float r;
  PImage img;
  PVector pos;
  float a; // angle
  // manupulation
  boolean mousePress = false;
  boolean drag = false;
  float ox = 0, oy = 0; // mouse hold offset
  // sitting state
  boolean sitting = false;

  int removeCounter;
  boolean removable;

  Chair(PVector center) {
    this(center.x, center.y, 150, random(-PI, PI));
  }

  Chair(float x, float y, float r, float a) {
    this.r = r;
    this.a = a;
    this.pos = new PVector(x, y);
    img = loadImage("data/poppy.gif");//"data/l"+(int)random(1,5)+".gif");
    removeCounter = REMOVE_COUNT;
    removable = false;
  }

  void draw() {

    if (removable) {
      --removeCounter;
    } else {
      removeCounter = REMOVE_COUNT;
    }

    // Get its angle of rotation
    pushMatrix();
    translate(pos.x,pos.y);
    rotate(a);
    fill(150);
    stroke(0);
    strokeWeight(1);
    imageMode(CENTER);
    blendMode(sitting ? ADD : BLEND);
    image(img, 0, 0, r * 2, img.height * r * 2 / img.width);
    blendMode(BLEND);
    noFill();
     // ellipse(0,0,r*2,r*2);
     // Let's add a line so we can see the rotation
     // line(0,0,r,0);
    popMatrix();
  }

  void initiateRemoval() {
    removable = true;
  }

  boolean removable() {
    return removable && removeCounter <= 0;
  }

  PVector getCenter() {
    return this.pos;
  }

  void setCenter(PVector c) {
    PVector d = c.sub(pos);
    d.mult(0.1);
    pos.add(d);
  }

  void mouseMoved() {

  }

  void mousePressed() {
    if (inside(mouseX, mouseY)) {
      drag = false;
      mousePress = true;
      ox = mouseX - pos.x;
      oy = mouseY - pos.y;
    }
  }

  void mouseDragged() {
    drag = true;
    if (mousePress) {
      setCenter(new PVector(mouseX - ox, mouseY - oy));
    }
  }

  void mouseReleased() {
    mousePress = false;
    if (inside(mouseX, mouseY) && !drag) {
      sitting = !sitting;
    }
  }

  boolean inside(float x, float y) {
    float d = dist(pos.x, pos.y, x, y);
    return d <= chairRadius;
  }
}