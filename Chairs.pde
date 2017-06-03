class Chairs {

  private ArrayList<Chair> chairs;

  Chairs() {
    chairs = new ArrayList<Chair>();
  }

  void addChair(float x, float y, float r, float a) {
    chairs.add(new Chair(x, y, r, a));
  }

  void assignChairs(ArrayList<Detected> d) {

    ArrayList<Detected> detectedChairs = new ArrayList<Detected>(d);

    // assign closest
    for (Chair chair : chairs) {
      chair.removable = true; // set default to removable
      for (Detected detected : detectedChairs) {
        if (detected.getCenter().mult(width * 1.0 / blobber.w).dist(chair.getCenter()) < chair.r) { // if within perimiter
          chair.setCenter(detected.getCenter().mult(width * 1.0 / blobber.w)); // fix ration screen/kinect
          chair.removable = false;
          detectedChairs.remove(detected);
          break;
        }
      }
    }

    // add missing chairs
    for (Detected detected : detectedChairs) {
      if (chairs.size() < 2) {
        chairs.add(new Chair(detected.getCenter().mult(width * 1.0 / blobber.w)));
      }
    }

    // remove removable
    ArrayList<Chair> chairsToRemove = new ArrayList<Chair>();
    for (Chair chair : chairs) {
      if (chair.removable()) {
        chairsToRemove.add(chair);
      }
    }
    for (Chair chair : chairsToRemove) {
      chairs.remove(chair);
    }
  }

  void assignSitters(ArrayList<Detected> d) {

    ArrayList<Detected> detectedSitters = new ArrayList<Detected>(d);

    // assign closest
    for (Chair chair : chairs) {
      chair.sitting = false;
      for (Detected detected : detectedSitters) {
        if (detected.getCenter().mult(width * 1.0 / blobber.w).dist(chair.getCenter()) < chair.r) { // if within perimiter
          chair.sitting = true; // fix ration screen/kinect
          PVector direction = detected.getCenter().mult(width * 1.0 / blobber.w).sub(chair.getCenter());
          chair.setAngle(atan2(direction.y, direction.x));
          break;
        }
      }
    }
  }

  Chair getClosest(PVector v) {
    Chair closest = null;
    float minD = 0;
    for (Chair chair : chairs) {
      PVector c = chair.getCenter();
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