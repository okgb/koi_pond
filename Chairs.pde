class Chairs {

  private ArrayList<Chair> chairs;

  Chairs() {
    chairs = new ArrayList<Chair>();
  }

  void addChair(float x, float y, float r, float a) {
    chairs.add(new Chair(x, y, r, a));
  }

  Chair getClosest(PVector v) {
    Chair closest = null;
    float minD = 0;
    for (Chair chair : chairs) {
      PVector c = chair.getPosition();
      float d = dist(v.x, v.y, c.x, c.y);
      if (closest == null || d < minD) {
        closest = chair;
        minD = d;
      }
    }
    return closest;
  }

  void draw() {
    for (Chair chair : chairs) chair.draw();
  }

  void mouseMoved() {
    for (Chair chair : chairs) chair.mouseMoved();
  }

  void mousePressed() {
    for (Chair chair : chairs) chair.mousePressed();
  }

  void mouseDragged() {
    for (Chair chair : chairs) chair.mouseDragged();
  }

  void mouseReleased() {
    for (Chair chair : chairs) chair.mouseReleased();
  }
}