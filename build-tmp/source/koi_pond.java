import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.opengl.PGraphicsOpenGL; 
import shiffman.box2d.*; 
import org.jbox2d.collision.shapes.*; 
import org.jbox2d.common.*; 
import org.jbox2d.dynamics.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class koi_pond extends PApplet {

/*
KOI FISH POND
 */


// Showing how to use applyForce() with box2d






// A reference to our box2d world
Box2DProcessing box2d;

// Movers, jsut like before!
Mover[] movers = new Mover[3];

// Attractor, just like before!
Attractor a;

int NUM_BOIDS = 10; // 50
int lastBirthTimecheck = 0;                // birth time interval
int addKoiCounter = 0;

ArrayList wanderers = new ArrayList();     // stores wander behavior objects
PVector mouseAvoidTarget, mouseAttractTarget;                // use mouse location as object to evade
boolean press = false;                     // check is mouse is press
int mouseAvoidScope = 300;
float chairRadius = 80;
float targetFromChair = 120;
float targetMinimumDistance = 15;

String[] skin = new String[10];

int line_stroke=1,w,h;
PFont font;
ArrayList<Drop> drops;


public void setup() {
      // publish size size(1680, 1100,P3D);
  font = loadFont("ArialRoundedMTBold-48.vlw");
  
  background(0xff5c9598);//#6DD8AD);//1EAFD6);
  drops=new ArrayList<Drop>();

  // init skin array images
  for (int n = 0; n < skin.length; n++) skin[n] = "skin-" + n + ".png";


  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  // No global gravity force
  box2d.setGravity(0,0);

  for (int i = 0; i < movers.length; i++) {
    movers[i] = new Mover(chairRadius, random(width), random(height));
  }
  a = new Attractor(0,0,0);
}


public void draw() {
  background(0xff30819D);//37A2B4);//429296);//#41AF93);//1EAFD6 5c9598);

  // adds new koi on a interval of time
  if (millis() > lastBirthTimecheck + 500) {
    lastBirthTimecheck = millis();
    if (addKoiCounter <  NUM_BOIDS) addKoi();
  }

  // fish motion wander behavior
  for (int n = 0; n < wanderers.size(); n++) {
    Boid wanderBoid = (Boid)wanderers.get(n);

    // if mouse is press pick objects inside the mouseAvoidScope
    // and convert them in evaders
    if (press) {
      if (dist(mouseX, mouseY, wanderBoid.location.x, wanderBoid.location.y) < mouseAvoidScope) {
        wanderBoid.timeCount = 0;
        PVector target = getTarget(wanderBoid.location);
        if (target != null) {
          wanderBoid.pursue(target);
        }
      }
    } else if (dist(mouseX, mouseY, wanderBoid.location.x, wanderBoid.location.y) < (mouseAvoidScope/2)) {
      wanderBoid.timeCount = 0;
      //mouseAvoidTarget = new PVector(mouseX, mouseY);
      //float collisionPointX = ((wanderBoid.location.x * mouseAvoidScope) + (mouseX * 1)) / (mouseAvoidScope+1);
      //float collisionPointY = ((wanderBoid.location.y * mouseAvoidScope) + (mouseY * 1)) / (mouseAvoidScope+1);
      //mouseAvoidTarget = new PVector(collisionPointX,collisionPointY);

      //stroke(255);
      //wanderBoid.evade();
    } else{
      wanderBoid.wander();
    }
    wanderBoid.run();

    // We must always step through time!
    box2d.step();

    a.display();

    for (int i = 0; i < movers.length; i++) {
      // Look, this is just like what we had before!
      //Vec2 force = a.attract(movers[i]);
      //movers[i].applyForce(force);
      movers[i].display();
    }

  }

  int dropCount;
  dropCount=drops.size();
  for(int i=dropCount-1;i>0;i--){
    Drop drop=(Drop)drops.get(i);
    if(drop.make()){
      drops.remove(i);
    }
  }
}

// increments number of koi by 1
public void addKoi() {
  int id = PApplet.parseInt(random(1, 11)) - 1;
  wanderers.add(
    new Boid(
      skin[id],
      new PVector(random(100, width - 100), random(100, height - 100)
    ),
    random(0.8f, 2.9f), 0.1f)
  );
  Boid wanderBoid = (Boid)wanderers.get(addKoiCounter);
  // sets opacity to simulate deepth
  wanderBoid.maxOpacity = PApplet.parseInt(map(addKoiCounter, 0, NUM_BOIDS - 1, 100,250));//10, 170));
  addKoiCounter++;
}

public void mouseMoved() {
  for (int i = 0; i < movers.length; i++) {
    movers[i].mouseMoved();
  }
}

public void mousePressed() {
  press = true;
  //mouseAvoidTarget = new PVector(mouseX, mouseY);
  int dropColor=color(255);
  Drop drop = new Drop(dropColor);
  drops.add(drop);

  for (int i = 0; i < movers.length; i++) {
    movers[i].mousePressed();
  }
}

public void mouseDragged() {
  //mouseAvoidTarget.x = mouseX;
  //mouseAvoidTarget.y = mouseY;

  Drop drop = new Drop(color(255));
  drops.add(drop);

  for (int i = 0; i < movers.length; i++) {
    movers[i].mouseDragged();
  }
}

public void mouseReleased() {
  press = false;

  for (int i = 0; i < movers.length; i++) {
    movers[i].mouseReleased();
  }
}

public void keyPressed() {
  saveFrame("##.jpg");
}

public PVector getTarget(PVector location) {

  float a = atan2(mouseY - location.y, mouseX - location.x);
  //a += random(-PI, PI) * 0.1; // randomize the angle?
  float d = dist(location.x, location.y, mouseX, mouseY) - targetFromChair;
  float x = cos(a) * d;
  float y = sin(a) * d;

  // don't return small distances, so that kois can roam free
  if (dist(0, 0, x, y) < targetMinimumDistance) return null;

  PVector p = new PVector(location.x + x, location.y + y);
  ellipse(p.x, p.y, 10, 10);
  return p;
}
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
  public Vec2 attract(Mover m) {
   
 
    // clone() makes us a copy
    //body.setLinearVelocity(new Vec2(mouseX,mouseY));
     Boid wanderBoid = (Boid)wanderers.get(0);
    
    Vec2 pos = box2d.coordPixelsToWorld(wanderBoid.location.x,wanderBoid.location.y);//body.getWorldCenter();  
    if(mousePressed){
      pos = box2d.coordPixelsToWorld(mouseX,mouseY);
      
       if(G>-10){
      G=(G-10)*0.1f;
      }
      if(damp>1){
      damp=(damp-1)*0.1f;
      }
    }
    else{
      G=0.5f;
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
    distance = constrain(distance,0.5f,2.5f);
    force.normalize();
    // Note the attractor's mass is 0 because it's fixed so can't use that
    float strength = 1*(G * 1 * m.body.m_mass) / (distance * distance); // Calculate gravitional force magnitude
    force.mulLocal(strength);         // Get force vector --> magnitude * direction
    return force;
  }

  public void display() {
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
    //ellipse(0,0,r*2,r*2);
    popMatrix();
  }
}
/*
Steer behavior class, to control/simulate natural movement
 the idea is to make some behaviors interactive like
 */

class Boid extends Flagellum {

  PVector location;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxForce;
  float maxSpeed;
  float wandertheta;
  float rushSpeed = random(3, 6);

  boolean timeCheck = false;                 // check if time interval is complete
  int timeCount = 0;                         // time cicle index
  int lastTimeCheck = 0;                     // stores last time check
  int timeCountLimit = 10;                   // max time cicles


  Boid (String _skin, PVector _location, float _maxSpeed, float _maxForce) {
    super(_skin);

    location = _location.get();
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    maxForce = _maxForce;
    maxSpeed = _maxSpeed;

     //if(random(1,10)%2!=0){println("ping");super.theta+=180;}
  }


  public PVector steer(PVector target, boolean slowdown) {
    PVector steer;
    PVector desired = PVector.sub(target, location);
    float d = desired.mag();

    if (d > 0) {
      desired.normalize();

      if (slowdown && d < 100) {
        desired.mult(maxSpeed * (d / 100));
      }
      else {
        desired.mult(maxSpeed);
      }

      steer = PVector.sub(desired, velocity);
      steer.limit(maxForce);
    }
    else {
      steer = new PVector(0, 0);
    }

    return steer;
  }


  /*  SEEK - FLEE  */
  public void seek(PVector target) {
    acceleration.add(steer(target, false));
  }

  public void arrive(PVector target) {
    acceleration.add(steer(target, true));
  }

  public void flee(PVector target) {
    acceleration.sub(steer(target, false));
  }



  /*  PURSUE - EVADE  */
  public void pursue(PVector target) {
    float lookAhead = location.dist(target) / maxSpeed;
    PVector predictedTarget = new PVector(target.x + lookAhead, target.y + lookAhead);
    seek(predictedTarget);
  }

  public void evade(PVector target) {
    timeCheck = true;
    if (dist(target.x, target.y, location.x, location.y) < 100) {

      float lookAhead = location.dist(target) / (maxSpeed * 2);
      PVector predictedTarget = new PVector(target.x - lookAhead, target.y - lookAhead);
      flee(predictedTarget);


    }
  }


  /*  WANDER  */
  public void wander() {
    float wanderR = 5;
    float wanderD = 100;
    float change = 0.05f;

    wandertheta += random(-change, change);

    PVector circleLocation = velocity.get();
    circleLocation.normalize();
    circleLocation.mult(wanderD);
    circleLocation.add(location);

    PVector circleOffset = new PVector(wanderR * cos(wandertheta), wanderR * sin(wandertheta));
    PVector target = PVector.add(circleLocation, circleOffset);
    seek(target);
  }


  public void run() {
    if (dist(mouseX, mouseY, location.x, location.y) < 50) {
      text("HELLO!",location.x+10,location.y);
    }
    update();
    borders();
    display();
  }


  public void update() {
    velocity.add(acceleration);
    velocity.limit(maxSpeed);
    location.add(velocity);
    acceleration.mult(0);

    // sets flagellum muscleFreq in relation to velocity
    //super.muscleRange = norm(velocity.mag(), 0, 1) * 2.5;
    super.muscleFreq = norm(velocity.mag(), 0, 1) * 0.06f;
    super.move();

    if (timeCheck) {
      if (millis() > lastTimeCheck + 200) {
        lastTimeCheck = millis();

        if (timeCount <= timeCountLimit) {
          // derease maxSpeed in relation with time cicles
          // this formula needs a proper look
          maxSpeed = rushSpeed - (norm(timeCount, 0, timeCountLimit) * 3);
          timeCount++;
        }
        else if (timeCount >= timeCountLimit) {
          // once the time cicle is complete
          // resets timer variables,
          timeCount = 0;
          timeCheck = false;

          // set default speed values
          maxSpeed = random(0.8f, 1.9f);
          maxForce = 0.2f;
        }
      }
    }
  }


  // control skin tint, for now it picks a random dark grey color
  int opacity = 0;
  int maxOpacity = 0;

  public void display() {
    if (opacity < 255) opacity += 1;
    else opacity = 255;
    tint(maxOpacity, maxOpacity, maxOpacity, opacity);

    // update location and direction
    float theta = velocity.heading2D() + radians(180);
    pushMatrix();
    translate(location.x, location.y);
    //rotate(theta);
    super.display();
    popMatrix();
    noTint();

    // update flagellum body rotation
    super.theta = degrees(theta);
    super.theta += 180;
  }

  // wrapper, appear opposit side
  public void borders() {
    if (location.x < -skin.width) location.x = width;
    if (location.x > width + skin.width) location.x = 0;
    if (location.y < -skin.width) location.y = height;
    if (location.y > height + skin.width) location.y = 0;
  }

}
/*
    Fish locomotion class
    Logic from levitated.com, simulates wave propagation through a kinetic array of nodes
    also some bits from flight404 blog
*/
class Flagellum {

  int numNodes = 16;
  float skinXspacing, skinYspacing;          // store distance for vertex points that builds the shape
  float muscleRange = 2;                     // controls rotation angle of the neck
  float muscleFreq = random(0.06f, 0.07f);     //
  float theta_vel;
  float theta = 180;
  float theta_friction = 0.6f;
  float count = 0;

  Node[] node = new Node[numNodes];

  PImage skin;


  Flagellum(String _skin) {
    skin = loadImage(_skin);

    // random image resize
    float scalar = random(0.1f, 0.3f);
    skin.resize(PApplet.parseInt(skin.width * scalar), PApplet.parseInt(skin.height * scalar));

    // nodes spacing
    skinXspacing = skin.width / PApplet.parseFloat(numNodes)+ 0.5f;
    skinYspacing = skin.height / 2;

    // initialize nodes
    for (int n = 0; n < numNodes; n++) node[n] = new Node();

  }


  public void move() {

    // head node
    node[0].x = cos(radians(theta));
    node[0].y = sin(radians(theta));

    // mucular node (neck)
    count += muscleFreq;
    float thetaMuscle = muscleRange * sin(count);
    node[1].x = -skinXspacing * cos(radians(theta + thetaMuscle)) + node[0].x;
    node[1].y = -skinXspacing * sin(radians(theta + thetaMuscle)) + node[0].y;

    // apply kinetic force trough body nodes (spine)
    for (int n = 2; n < numNodes; n++) {
      float dx = node[n].x - node[n - 2].x;
      float dy = node[n].y - node[n - 2].y;
      float d = sqrt(dx * dx + dy * dy);
      node[n].x = node[n - 1].x + (dx * skinXspacing) / d;
      node[n].y = node[n - 1].y + (dy * skinXspacing) / d;
    }
  }


  public void display() {
    noStroke();
    beginShape(QUAD_STRIP);
    texture(skin);
    for (int n = 0; n < numNodes; n++) {
      float dx;
      float dy;
      if (n == 0) {
        dx = node[1].x - node[0].x;
        dy = node[1].y - node[0].y;
      }
      else {
        dx = node[n].x - node[n - 1].x;
        dy = node[n].y - node[n - 1].y;
      }
      float angle = -atan2(dy, dx);
      float x1 = node[n].x + sin(angle) * -skinYspacing;
      float y1 = node[n].y + cos(angle) * -skinYspacing;
      float x2 = node[n].x + sin(angle) *  skinYspacing;
      float y2 = node[n].y + cos(angle) *  skinYspacing;
      float u = skinXspacing * n;
      vertex(x1, y1, u, 0);
      vertex(x2, y2, u, skin.height);
    }
    endShape();
  }

}
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
    fd.density = 0.01f;
    fd.friction = 300;
    fd.restitution = 0.05f;

    body.createFixture(fd);
    body.setTransform( body.getPosition(),random(360));
    //body.setLinearVelocity(new Vec2(random(-0.001,0.001),random(-0.001,0.001)));
    //body.setAngularVelocity(random(-0.001,0.001));
    body.setLinearDamping(20f);
  }

  public void applyForce(Vec2 v) {
    //body.setLinearVelocity(body.getLinearVelocity.mult(0.5));
    //body.applyForce(v, body.getWorldCenter());
  }


  public void display() {
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

  public void mouseMoved() {

  }

  public void mousePressed() {
    Vec2 v = box2d.coordWorldToPixels(body.getPosition());
    float d = dist(v.x, v.y, mouseX, mouseY);
    if (d <= chairRadius) {
        mousePress = true;
        ox = mouseX - v.x;
        oy = mouseY - v.y;
    }
  }

  public void mouseDragged() {
    if (mousePress) {
        println("moving");

        Vec2 p = box2d.coordPixelsToWorld(new Vec2(mouseX - ox, mouseY - oy));

        body.setTransform(p, body.getAngle());
    }
    //body.applyForce(new Vec2(mouseX, mouseY), body.getWorldCenter());


  }

  public void mouseReleased() {
    mousePress = false;
  }
}
/*
  just stores x and y position, could be done in a different way but ...,
  will change in a future sketch
*/
class Node {
  float x;
  float y;
}
/*
  how this works can be found here
  http://www.gamedev.net/reference/articles/article915.asp
  
  this end up as a simplified version of
  Riu Gil water sketch in openprocessing site
  http://www.openprocessing.org/visuals/?visualID=668
*/

class Ripple {

  int heightMap[][][];             // water surface (2 pages)
  int turbulenceMap[][];           // turbulence map 
  int lineOptimizer[];             // line optimizer; 
  int space; 
  int radius, heightMax, density; 
  int page = 0; 

  PImage water;


  Ripple(PImage _water) {
    water = _water;
    density = 4; 
    radius = 20; 
    space = width * height - 1; 
    
    initMap();
  }



  public void update() {
    waterFilter(); 
    updateWater();
    page ^= 1; 
  }

  public void initMap() { 
    // the height map is made of two "pages" 
    // one to calculate the current state, and another to keep the previous state
    heightMap = new int[2][width][height]; 
   
  } 


  public void makeTurbulence(int cx, int cy) {
    int r = radius * radius; 
    int left = cx < radius ? -cx + 1 : -radius; 
    int right = cx > (width - 1) - radius ? (width - 1) - cx : radius; 
    int top = cy < radius ? -cy + 1 : -radius; 
    int bottom = cy > (height - 1) - radius ? (height - 1) - cy : radius; 

    for (int x = left; x < right; x++) { 
      int xsqr = x * x; 
      for (int y = top; y < bottom; y++) { 
        if (xsqr + (y * y) < r)
          heightMap[page ^ 1][cx + x][cy + y] += 100;
      }
    } 
  }


  public void waterFilter() { 
    for (int x = 0; x < width; x++) { 
      for (int y = 0; y < height; y++) { 
        int n = y - 1 < 0 ? 0 : y - 1; 
        int s = y + 1 > height - 1 ? height - 1 : y + 1; 
        int e = x + 1 > width - 1 ? width - 1 : x + 1; 
        int w = x - 1 < 0 ? 0 : x - 1; 
        int value = ((heightMap[page][w][n] + heightMap[page][x][n] 
                    + heightMap[page][e][n] + heightMap[page][w][y] 
                    + heightMap[page][e][y] + heightMap[page][w][s] 
                    + heightMap[page][x][s] + heightMap[page][e][s]) >> 2) 
                    - heightMap[page ^ 1][x][y];

        heightMap[page ^ 1][x][y] = value - (value >> density); 
      } 
    } 
  } 

  public void updateWater() { 
    loadPixels();
    for (int y = 0; y < height - 1; y++) { 
      for (int x = 0; x < width - 1; x++) {
        int deltax = heightMap[page][x][y] - heightMap[page][x + 1][y]; 
        int deltay = heightMap[page][x][y] - heightMap[page][x][y + 1]; 
        int offsetx = (deltax >> 3) + x; 
        int offsety = (deltay >> 3) + y; 

        offsetx = offsetx > width ? width - 1 : offsetx < 0 ? 0 : offsetx; 
        offsety = offsety > height ? height - 1 : offsety < 0 ? 0 : offsety; 

        int offset = (offsety * width) + offsetx; 
        offset = offset < 0 ? 0 : offset > space ? space : offset;
        int pixel = water.pixels[offset]; 
        pixels[y * width + x] = pixel; 
      } 
    } 
    updatePixels(); 
  }

}


class Drop
{
int dropBaseSize=1;
int dropSizeFix=7;
float dropAlphaFix=5;
int dropCount=0;
float loopCount=255/dropAlphaFix;
int dropColor;
int dropX,dropY;

Drop(int initColor){
  dropX=mouseX;
  dropY=mouseY;
  dropColor = initColor;
}

public boolean make(){
  int i;
  if(frameCount%2==1){
  dropCount++;
  }
  if(dropCount>loopCount){
    return true;
  }
  noStroke();
  
  int dropSize=dropBaseSize+dropSizeFix*dropCount;
  float dropAlpha=255-dropAlphaFix*dropCount;
  noFill();
  stroke(dropColor,dropAlpha);
  ellipse(dropX,dropY,dropSize,dropSize);
  
  return false;
}

}
  public void settings() {  size(1280, 800,P3D);  smooth(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "koi_pond" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
