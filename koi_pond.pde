// KOI FISH POND

Chairs chairs;
Controller controller;
Boids boids;

float chairRadius = 120;
float targetFromChair = 150;
float targetMinimumDistance = 10;
float attractionStartDistance = 300; // same as mouseAvoidScope

String[] skin = new String[11];

// Which pixels do we care about?
// int minD = 10;
// int maxD = 1000;
// int[] minDepth =  {50,500,1000};
// int[] maxDepth = {450,950,2000};

Blobber blobber;

PImage depth;

void setup() {
  size(1280, 800, P3D);    // publish size size(1680, 1100,P3D);
  //smooth();
  // init skin array images
  for (int n = 0; n < skin.length; n++) skin[n] = "skin-" + n + ".png";

  chairs = new Chairs();
  for (int i = 0; i < 6; i++) chairs.addChair(random(width), random(height), chairRadius, random(-PI, PI));

  boids = new Boids();
  for (int i = 0; i < 6; i++) boids.addBoid();

  controller = new Controller(this);
  blobber = new Blobber(this);
}


void draw() {
  blendMode(BLEND);
  background(#30819D);
  boids.draw();
  chairs.draw();
  blobber.detect();

/////
  // bleh
  pushStyle();
  noStroke();
  fill(128);
  rect(0, 0, blobber.getWidth(), blobber.getHeight());
  popStyle();


//////

  blobber.draw();
}

void mouseMoved() {
  chairs.mouseMoved();
}

void mousePressed() {
  chairs.mousePressed();
}

void mouseDragged() {
  chairs.mouseDragged();
}

void mouseReleased() {
  chairs.mouseReleased();
}

void controlEvent(ControlEvent theControlEvent) {
  controller.controlEvent(theControlEvent);
}

void keyPressed() {
  //saveFrame("##.jpg");
}
