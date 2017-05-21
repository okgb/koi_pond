// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2011
// Box2DProcessing example

// Showing how to use applyForce() with box2d

class Mover {

  // We need to keep track of a Body and a radius
  Body body;
  float r;
  PImage img;
  float scalar;
  boolean mousePress = false;
  float ox = 0, oy = 0;

  Mover(float r_, float x, float y) {
    r = r_;
    //scalar=random(3,7);
    img=loadImage("data/poppy.gif");//"data/l"+(int)random(1,5)+".gif");//
    //r = img.width/(45*r_);
    //println(r);
    // Define a body
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;

    // Set its position
    bd.position = box2d.coordPixelsToWorld(x,y);
    body = box2d.world.createBody(bd);

    // Make the body's shape a circle
    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(r/2);

    // Define a fixture
    FixtureDef fd = new FixtureDef();
    fd.shape = cs;
    // Parameters that affect physics
    fd.density = 0.01;
    fd.friction = 300;
    fd.restitution = 0.05;

    body.createFixture(fd);
    body.setTransform( body.getPosition(),random(360));
    //body.setLinearVelocity(new Vec2(random(-0.001,0.001),random(-0.001,0.001)));
    //body.setAngularVelocity(random(-0.001,0.001));
    body.setLinearDamping(20f);
  }

  void applyForce(Vec2 v) {
    //body.setLinearVelocity(body.getLinearVelocity.mult(0.5));
    //body.applyForce(v, body.getWorldCenter());
  }


  void display() {
    // We look at each body and get its screen position
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Get its angle of rotation
    float a = body.getAngle();
    pushMatrix();
    translate(pos.x,pos.y);
    rotate(a);
    fill(150);
    stroke(0);
    strokeWeight(1);
    imageMode(CENTER);
    image(img,0, 0, r * 2, img.height*r*2/img.width);
    noFill();
    // ellipse(0,0,r*2,r*2);
    // Let's add a line so we can see the rotation
    // line(0,0,r,0);
    popMatrix();
  }

  void mouseMoved() {

  }

  void mousePressed() {
    Vec2 v = box2d.coordWorldToPixels(body.getPosition());
    float d = dist(v.x, v.y, mouseX, mouseY);
    if (d <= chairRadius) {
        mousePress = true;
        ox = mouseX - v.x;
        oy = mouseY - v.y;
    }
  }

  void mouseDragged() {
    if (mousePress) {
        println("moving");

        Vec2 p = box2d.coordPixelsToWorld(new Vec2(mouseX - ox, mouseY - oy));

        body.setTransform(p, body.getAngle());
    }
    //body.applyForce(new Vec2(mouseX, mouseY), body.getWorldCenter());


  }

  void mouseReleased() {
    mousePress = false;
  }
}