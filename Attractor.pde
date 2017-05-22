// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2011
// Box2DProcessing example

// Showing how to use applyForce() with box2d

// Fixed Attractor (this is redundant with Mover)

class Attractor {

  // We need to keep track of a Body and a radius
  Body body;
  float r;
  float G = 1; // Strength of force
  float damp=20;
  Attractor(float r_, float x, float y) {
    r = r_;
    // Define a body
    BodyDef bd = new BodyDef();
    bd.type = BodyType.STATIC;
    // Set its position
    bd.position = box2d.coordPixelsToWorld(x,y);
    body = box2d.world.createBody(bd);

    // Make the body's shape a circle
    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(r);

    body.createFixture(cs,1);
  }


  // Formula for gravitational attraction
  // We are computing this in "world" coordinates
  // No need to convert to pixels and back
  Vec2 attract(Mover m) {


    // clone() makes us a copy
    //body.setLinearVelocity(new Vec2(mouseX,mouseY));
    Boid wanderBoid = (Boid)wanderers.get(0);

    Vec2 pos = box2d.coordPixelsToWorld(wanderBoid.location.x,wanderBoid.location.y);//body.getWorldCenter();
    if(mousePressed){
      pos = box2d.coordPixelsToWorld(mouseX,mouseY);

       if(G>-10){
      G=(G-10)*0.1;
      }
      if(damp>1){
      damp=(damp-1)*0.1;
      }
    }
    else{
      G=0.5;
      if(G<1){
      //G=(G+1)*0.1;
      }
      if(damp<40){
      //damp=(damp+1)/50;
      }
    //m.body.setLinearDamping(20f);
    //pos = box2d.coordPixelsToWorld(mouseX,mouseY);
    }

     //m.body.setLinearDamping(damp);

    Vec2 moverPos = m.body.getWorldCenter();
    // Vector pointing from mover to attractor
    Vec2 force = pos.sub(moverPos);
    float distance = force.length();
    //println(distance);
    //if(mousePressed)
    m.body.setLinearDamping(damp*(distance));
    // Keep force within bounds
    distance = constrain(distance,0.5,2.5);
    force.normalize();
    // Note the attractor's mass is 0 because it's fixed so can't use that
    float strength = 1*(G * 1 * m.body.m_mass) / (distance * distance); // Calculate gravitional force magnitude
    force.mulLocal(strength);         // Get force vector --> magnitude * direction
    return force;
  }

  void display() {
    // We look at each body and get its screen position
    Vec2 pos = box2d.getBodyPixelCoord(body);
   // pos.x=mouseX;
    //pos.y=mouseY;
    // Get its angle of rotation
    float a = body.getAngle();
    pushMatrix();
    translate(pos.x,pos.y);
    rotate(a);
    fill(0);
    stroke(0);
    strokeWeight(1);
    ellipse(0,0,r*2,r*2);
    ellipse(0,0,100, 100);
    popMatrix();
  }
}