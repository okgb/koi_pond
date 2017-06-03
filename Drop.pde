
class Drop {

  static final int LIFETIME = 500;
  static final int STEP = 5;
  static final int THICKNESS = 3;

  static final int randomShift = 10;

  int lifetime;

  float x, y;

  Drop(float x, float y) {
    this.x = x + random(-randomShift, randomShift);
    this.y = y + random(-randomShift, randomShift);
    lifetime = LIFETIME;
  }

  void draw() {
    int size = LIFETIME - lifetime;
    ellipseMode(CENTER);
    noFill();
    strokeWeight(THICKNESS);
    stroke(0, max(0, 32 * lifetime / LIFETIME));
    ellipse(x + THICKNESS, y + THICKNESS, size, size);
    stroke(255, max(0, 64 * lifetime / LIFETIME));
    ellipse(x, y, size, size);
    lifetime -= STEP;
  }

  boolean deletable() {
    return lifetime <= 0;
  }
}