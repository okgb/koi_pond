import org.openkinect.processing.*;
import blobDetection.*;

class Blobber {

  EdgeVertex eA, eB;

  ArrayList<BlobDetection> detections;

  ArrayList<Detected> detectedChairs;
  ArrayList<Detected> detectedSitters;
  ArrayList<Detected> detectedWalkers;

  static final int NUMBER_OF_KINECTS = 2; // this works only with 1 or 2, because of overlap
  static final int KINECT_W = 512;
  static final int KINECT_H = 424;

  PGraphics blobs;
  PGraphics kImages;
  PImage[] kImage;
  PShader blur;
  Kinect2[] kinects;
  int w, h;

  Blobber(PApplet p) {
    kinects = new Kinect2[NUMBER_OF_KINECTS]; // this has to be 2 for the rest to work
    for (int i = 0; i < NUMBER_OF_KINECTS; i++) {
      kinects[i] = new Kinect2(p);
      kinects[i].initDepth();
      kinects[i].initDevice(i);
    }
    kImage = new PImage[NUMBER_OF_KINECTS]; // this has to be 2 for the rest to work

    // because rotating 90 degrees
    w = KINECT_H / 2 * NUMBER_OF_KINECTS;
    h = KINECT_W / 2;

    detections = new ArrayList<BlobDetection>(3);
    for(int i = 0; i < 3; i++) {
      BlobDetection detection = new BlobDetection(w, h);
      detection.setPosDiscrimination(true);
      detection.setThreshold(i / 3.0 + 0.125);
      detections.add(detection);
    }
    blobs = createGraphics(w, h, P3D);
    kImages = createGraphics(w, h, P3D);
    blur = loadShader("blur.glsl");

    detectedChairs = new ArrayList<Detected>();
    detectedSitters = new ArrayList<Detected>();
    detectedWalkers = new ArrayList<Detected>();
  }

  void detect() {

    detectedChairs.clear();
    detectedSitters.clear();
    detectedWalkers.clear();

    /**
     * @todo make this one kinect again
     */
    for (int i = 0; i < NUMBER_OF_KINECTS; i++) {
      kImage[i] = kinects[i].getDepthImage();
      kImage[i].loadPixels();
    }
    /**
     * @todo end - make this one kinect again
     */

    kImages.loadPixels();
    int black = color(0);
    for (int i = 0; i < w * h; i++) {
      int k = i % w / (KINECT_H / 2);
      int x = KINECT_W / 2 - i / w;
      int y = (i % w - k * KINECT_H / 2) + controller.kinectOverlap * (k == 0 ? -1 : 1);
      kImages.pixels[i] = y >= KINECT_H / 2 || y < 0 ? black : kImage[k].pixels[x * 2 + y * 2 * KINECT_W];
    }
    kImages.updatePixels();

    // overlay edges
    kImages.beginDraw();
    kImages.fill(0);
    kImages.noStroke();
    kImages.rect(0, 0, w, controller.kinectCutoffTop);
    kImages.rect(0, h - controller.kinectCutoffBottom, w, controller.kinectCutoffBottom);
    kImages.rect(0, 0, controller.kinectCutoffLeft, h);
    kImages.rect(w - controller.kinectCutoffRight, 0, controller.kinectCutoffRight, h);
    kImages.endDraw();

    kImages.loadPixels();
    blobs.loadPixels();

    int chair = color(255 / 3);
    int sitter = color(255 / 3 * 2);
    int walker = color(255);

    for (int i = 0, n = w * h; i < n; i++) {
      int c = kImages.pixels[i];
      float level = brightness(c);
      if (level == 0.0 || level > controller.floorCutoff) { // everything beyond is "floor", do not detect
        blobs.pixels[i] = black;
      } else if (level > controller.chairCutoff) { // chairs
        blobs.pixels[i] = chair;
      } else if (level > controller.sitterCutoff) { // sitters
        blobs.pixels[i] = sitter;
      } else { // the rest are walkers
        blobs.pixels[i] = walker;
      }
    }
    blobs.updatePixels();

    blobs.beginDraw();
    int a=0; while(++a < 5) blobs.filter(blur); // apply X times
    blobs.endDraw();

    blobs.loadPixels();
    // for loop so we can enumerate
    for (int d = 0; d < detections.size(); d++) {
      BlobDetection detection = detections.get(d);
      detection.computeBlobs(blobs.pixels);
      ArrayList<Detected> detectedList = new ArrayList<Detected>();
      for (int i = 0, n = detection.getBlobNb(); i < n; i++) {
        Blob b = detection.getBlob(i);
        if (b != null) {
          Detected detected = new Detected(b.xMin * w, b.yMin * h, b.w * w, b.h * h);
          if ( // skip if size not correct
            (d == 0 && (
              detected.w < controller.chairMinSize ||
              detected.w > controller.chairMaxSize ||
              detected.h < controller.chairMinSize ||
              detected.h > controller.chairMaxSize
            )) ||
            (d == 1 && (
              detected.w < controller.sitterMinSize ||
              detected.w > controller.sitterMaxSize ||
              detected.h < controller.sitterMinSize ||
              detected.h > controller.sitterMaxSize
            )) ||
            (d == 2 && (
              detected.w < controller.walkerMinSize ||
              detected.w > controller.walkerMaxSize ||
              detected.h < controller.walkerMinSize ||
              detected.h > controller.walkerMaxSize
            ))
          ) {
            continue;
          }
          for (int j = 0, m = b.getEdgeNb(); j < m ; j++) {
            eA = b.getEdgeVertexA(j);
            eB = b.getEdgeVertexB(j);
            if (eA != null && eB != null)
              detected.addEdge(eA.x * w, eA.y * h, eB.x * w, eB.y * h);
          }
          detectedList.add(detected);
        }
      }
      switch(d) {
        case 0:
          detectedChairs = detectedList;
          break;
        case 1:
          detectedSitters = detectedList;
          break;
        case 2:
          detectedWalkers = detectedList;
          break;
      }
    }
  }

  void draw() {
    pushStyle();
    imageMode(CORNER);
    image((PImage)blobs, 0, 0);
    image(kImages, w, 0);
    strokeWeight(1);
    noFill();
    for (Detected chairBlob : detectedChairs) {
      chairBlob.draw(color(255, 0, 255), color(0, 255, 0));
    }
    for (Detected sitterBlob : detectedSitters) {
      sitterBlob.draw(color(0, 255, 255), color(0, 0, 255));
    }
    for (Detected walkerBlob : detectedWalkers) {
      walkerBlob.draw(color(255, 255, 0), color(0, 0, 255));
    }
    popStyle();
  }
}