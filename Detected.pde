class Detected {

  float x, y, w, h;
  ArrayList<DetectedEdge> edges;

  Detected(float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    edges = new ArrayList<DetectedEdge>();
  }

  void addEdge(float ax, float ay, float bx, float by) {
    edges.add(new DetectedEdge(ax, ay, bx, by));
  }

  PVector getCenter() {
    return new PVector(x + w / 2, y + h / 2);
  }

  void draw() {
    draw(color(255, 0, 0));
  }

  void draw(int boxColor) {
    draw(boxColor, color(0, 255, 0));
  }

  void draw(int boxColor, int edgeColor) {
    pushStyle();
    strokeWeight(1);
    stroke(boxColor);
    rect(x, y, w, h);
    stroke(edgeColor);
    for (DetectedEdge edge : edges) {
      line(edge.a.x, edge.a.y, edge.b.x, edge.b.y);
    }
    popStyle();
  }
}

class DetectedEdge {
  PVector a;
  PVector b;

  DetectedEdge(float ax, float ay, float bx, float by) {
    a = new PVector(ax, ay);
    b = new PVector(bx, by);
  }
}