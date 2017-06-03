class Boids {

  private ArrayList<Boid> boids;

  Boids() {
    boids = new ArrayList<Boid>();
  }

  void addBoid() {
    Boid boid = new Boid(
      skin[boids.size() % 11],
      new PVector(random(100, width - 100), random(100, height - 100)),
      1.0,
      1.0
    );
    boid.maxOpacity = 255; //int(map(boids.size(), 0, boids.size(), 100, 250));//10, 170));
    boids.add(
      boid
    );
  }

  PVector getTarget(PVector boid, PVector chair) {
    float a = atan2(chair.y - boid.y, chair.x - boid.x);
    //a += 0.2;
    //a += random(-PI, PI) * 0.1; // randomize the angle?
    float x = -cos(a) * targetFromChair;
    float y = -sin(a) * targetFromChair;
    // don't return small distances, so that kois can roam free
    if (dist(0, 0, x, y) < targetMinimumDistance) return null;
    // draw
    pushStyle();
    noFill();
    stroke(0);
    strokeWeight(1);
    line(chair.x, chair.y, chair.x + x, chair.y + y);
    popStyle();
    PVector p = new PVector(chair.x + x, chair.y + y);
    // ???
    pushStyle();
    noFill();
    stroke(0);
    strokeWeight(1);
    ellipse(p.x, p.y, 10, 10);
    popStyle();

    return p;
  }

  void draw() {
    // fish motion wander behavior
    for (Boid boid : boids) {
      Chair chair = chairs.getClosest(boid.location);
      if (chair != null) {
        PVector c = chair.getCenter();
        float dFromChair = dist(c.x, c.y, boid.location.x, boid.location.y);
        if (dFromChair < targetFromChair) {
          boid.timeCount = 0;
          boid.evade(c);
        } else if (chair.sitting && dFromChair < attractionStartDistance) {
          boid.timeCount = 0;
          PVector target = getTarget(boid.location, c);
          if (target != null) {
            boid.pursue(target);
          } else {
            boid.wander();
          }
        } else {
          boid.wander();
        }
      } else {
        boid.wander();
      }
      boid.run();
    }
  }
}