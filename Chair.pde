// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2011
// Box2DProcessing example

class Chair {

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

  Chair(float r, float x, float y) {
    this.r = r;
    this.a = random(-PI, PI);
    this.pos = new PVector(x, y);
    img=loadImage("data/poppy.gif");//"data/l"+(int)random(1,5)+".gif");
  }

  void display() {
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

  PVector getPosition() {
    return this.pos;
  }

  void setPosition(float x, float y) {
    pos.x = x;
    pos.y = y;
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
      setPosition(mouseX - ox, mouseY - oy);
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