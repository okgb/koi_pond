// KOI FISH POND

boolean controlsVisible = true;

Chairs chairs;
Controller controller;
Boids boids;
Drops drops;

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

  boids = new Boids();
  for (int i = 0; i < 20; i++) boids.addBoid();

  drops = new Drops();

  controller = new Controller(this);
  blobber = new Blobber(this);
}


void draw() {
  if (frameCount % 60 == 0) println(frameRate);

  //if (frameCount % 3 == 0) {
    blobber.detect();
    chairs.assignChairs(blobber.detectedChairs);
    chairs.assignSitters(blobber.detectedSitters);
    drops.assignWalkers(blobber.detectedWalkers);
  //}

  blendMode(BLEND);
  background(#30819D);
  boids.draw();
  drops.draw();
  chairs.draw();
  fill(0, 128);
  //rect(0, 0, width, height);
  if (controlsVisible) blobber.draw();
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
  switch(key) {
    case 'h':
      controller.hide();
      break;
    case 's':
      controller.show();
      break;
    case 'k':
      controlsVisible = !controlsVisible;
      break;
    case 'f':
      //saveFrame("##.jpg");
      break;
  }
}
