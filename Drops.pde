
class Drops {

  ArrayList<Drop> drops;

  Drops() {
    drops = new ArrayList<Drop>();
  }

  void addDrop(float x, float y) {
    drops.add(new Drop(x, y));
  }

  void draw() {
    ArrayList<Drop> deletable = new ArrayList<Drop>();
    for (Drop drop : drops) {
      drop.draw();
      if (drop.deletable()){
        deletable.add(drop);
      }
    }
    for (Drop drop : deletable) {
      drops.remove(drop);
    }
  }

  void assignWalkers(ArrayList<Detected> detectedWalkers) {

    for (Detected detected : detectedWalkers) {
      PVector scaled = detected.getCenter().mult(width * 1.0 / blobber.w);
      addDrop(scaled.x, scaled.y);
    }
  }
}