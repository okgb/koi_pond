// KOI FISH POND
import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;

// A reference to our box2d world
Box2DProcessing box2d;

Chair[] chairs = new Chair[6];

// Attractor, just like before!
//Attractor a;

int NUM_BOIDS = 50;
int lastBirthTimecheck = 0;                // birth time interval
int addKoiCounter = 0;

ArrayList wanderers = new ArrayList();     // stores wander behavior objects
PVector mouseAvoidTarget, mouseAttractTarget;                // use mouse location as object to evade
boolean press = false;                     // check is mouse is press
//int mouseAvoidScope = 300;
float chairRadius = 120;
float targetFromChair = 150;
float targetMinimumDistance = 10;
float attractionStartDistance = 300; // same as mouseAvoidScope

String[] skin = new String[10];

int line_stroke=1,w,h;
PFont font;
ArrayList<Drop> drops;


void setup() {
  size(1280, 800,P3D);    // publish size size(1680, 1100,P3D);
  font = loadFont("ArialRoundedMTBold-48.vlw");
  smooth();
  background(#5c9598);//#6DD8AD);//1EAFD6);
  drops=new ArrayList<Drop>();

  // init skin array images
  for (int n = 0; n < skin.length; n++) skin[n] = "skin-" + n + ".png";


  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  // No global gravity force
  box2d.setGravity(0,0);

  for (int i = 0; i < chairs.length; i++) {
    chairs[i] = new Chair(chairRadius, random(width), random(height));
  }
  //a = new Attractor(0,0,0);
}


void draw() {
  background(#30819D);//37A2B4);//429296);//#41AF93);//1EAFD6 5c9598);

  // adds new koi on a interval of time
  if (millis() > lastBirthTimecheck + 500) {
    lastBirthTimecheck = millis();
    if (addKoiCounter <  NUM_BOIDS) addKoi();
  }

  // fish motion wander behavior
  for (int n = 0; n < wanderers.size(); n++) {
    Boid wanderBoid = (Boid)wanderers.get(n);




    Chair chair = getClosestChair(wanderBoid.location);
    PVector c = chair.getPosition();
    float dFromChair = dist(c.x, c.y, wanderBoid.location.x, wanderBoid.location.y);
    if (dFromChair < targetFromChair) {
      wanderBoid.timeCount = 0;
      wanderBoid.evade(c);
    } else if (chair.sitting && dFromChair < attractionStartDistance) {
      wanderBoid.timeCount = 0;
      PVector target = getTarget(wanderBoid.location, c);
      if (target != null) {
        wanderBoid.pursue(target);
      } else {
        wanderBoid.wander();
      }
    } else {
      wanderBoid.wander();
    }





    //


    // if mouse is press pick objects inside the mouseAvoidScope
    // and convert them in evaders
    // if (press) {
    //   if (dist(mouseX, mouseY, wanderBoid.location.x, wanderBoid.location.y) < mouseAvoidScope) {
    //     wanderBoid.timeCount = 0;
    //     PVector target = getTarget(wanderBoid.location);
    //     if (target != null) {
    //       wanderBoid.pursue(target);
    //     }
    //   }
    // } else if (dist(mouseX, mouseY, wanderBoid.location.x, wanderBoid.location.y) < (mouseAvoidScope/2)) {
    //   wanderBoid.timeCount = 0;
    //   //mouseAvoidTarget = new PVector(mouseX, mouseY);
    //   //float collisionPointX = ((wanderBoid.location.x * mouseAvoidScope) + (mouseX * 1)) / (mouseAvoidScope+1);
    //   //float collisionPointY = ((wanderBoid.location.y * mouseAvoidScope) + (mouseY * 1)) / (mouseAvoidScope+1);
    //   //mouseAvoidTarget = new PVector(collisionPointX,collisionPointY);

    //   //stroke(255);
    //   //wanderBoid.evade();
    // } else{
    //   wanderBoid.wander();
    // }
    wanderBoid.run();

    // We must always step through time!
    //box2d.step();

    //a.display();

    for (int i = 0; i < chairs.length; i++) {
      chairs[i].display();
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
void addKoi() {
  int id = int(random(1, 11)) - 1;
  wanderers.add(
    new Boid(
      skin[id],
      new PVector(random(100, width - 100), random(100, height - 100)
    ),
    random(0.8, 2.9), 0.1)
  );
  Boid wanderBoid = (Boid)wanderers.get(addKoiCounter);
  // sets opacity to simulate deepth
  wanderBoid.maxOpacity = int(map(addKoiCounter, 0, NUM_BOIDS - 1, 100,250));//10, 170));
  addKoiCounter++;
}

void mouseMoved() {
  for (int i = 0; i < chairs.length; i++) {
    chairs[i].mouseMoved();
  }
}

void mousePressed() {
  press = true;
  //mouseAvoidTarget = new PVector(mouseX, mouseY);
  int dropColor=color(255);
  Drop drop = new Drop(dropColor);
  drops.add(drop);

  for (int i = 0; i < chairs.length; i++) {
    chairs[i].mousePressed();
  }
}

void mouseDragged() {
  //mouseAvoidTarget.x = mouseX;
  //mouseAvoidTarget.y = mouseY;

  Drop drop = new Drop(color(255));
  drops.add(drop);

  for (int i = 0; i < chairs.length; i++) {
    chairs[i].mouseDragged();
  }
}

void mouseReleased() {
  press = false;

  for (int i = 0; i < chairs.length; i++) {
    chairs[i].mouseReleased();
  }
}

void keyPressed() {
  //saveFrame("##.jpg");
}

PVector getTarget(PVector boid, PVector chair) {

  float a = atan2(chair.y - boid.y, chair.x - boid.x);

  //a += 0.2;
  //a += random(-PI, PI) * 0.1; // randomize the angle?
  float x = -cos(a) * targetFromChair;
  float y = -sin(a) * targetFromChair;

  // don't return small distances, so that kois can roam free
  if (dist(0, 0, x, y) < targetMinimumDistance) return null;

  pushStyle();
  noFill();
  stroke(0);
  strokeWeight(1);
  line(chair.x, chair.y, chair.x + x, chair.y + y);
  popStyle();




  PVector p = new PVector(chair.x + x, chair.y + y);

  pushStyle();
  noFill();
  stroke(0);
  strokeWeight(1);
  ellipse(p.x, p.y, 10, 10);
  popStyle();

  return p;
}

Chair getClosestChair(PVector p) {
  Chair closest = null;
  float minD = width + height; // too distant
  for (int i = 0; i < chairs.length; i++){
    PVector c = chairs[i].getPosition();
    float d = dist(p.x, p.y, c.x, c.y);
    if (d < minD) {
      closest = chairs[i];
      minD = d;
    }
  }
  return closest;
}