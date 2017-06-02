import org.openkinect.processing.*;
import blobDetection.*;

class Blobber {
  EdgeVertex eA, eB;

  ArrayList<BlobDetection> detections;

  ArrayList<Detected> detectedChairs;
  ArrayList<Detected> detectedSitters;
  ArrayList<Detected> detectedWalkers;

  PGraphics blobs;
  PImage kImage;
  PShader blur;
  Kinect2 kinect;
  int w, h;

  Blobber(PApplet p) {
    kinect = new Kinect2(p);
    kinect.initDepth();
    kinect.initDevice(); // (0)?

    w = kinect.depthWidth;
    h = kinect.depthHeight;

    detections = new ArrayList<BlobDetection>(3);
    for(int i = 0; i < 3; i++) {
      BlobDetection detection = new BlobDetection(w, h);
      detection.setPosDiscrimination(true);
      detection.setThreshold(i / 3.0 + 0.125);
      detections.add(detection);
    }
    blobs = createGraphics(w, h, P3D);
    blur = loadShader("blur.glsl");
  }

  void detect() {

    detectedChairs = new ArrayList<Detected>();
    detectedSitters = new ArrayList<Detected>();
    detectedWalkers = new ArrayList<Detected>();

    kImage = kinect.getDepthImage();
    kImage.loadPixels();
    blobs.loadPixels();
    int black = color(0);
    int chair = color(255 / 3);
    int sitter = color(255 / 3 * 2);
    int walker = color(255);

    for (int i = 0, n = w * h; i < n; i++) {
      int c = kImage.pixels[i];
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
    imageMode(CORNER);
    image((PImage)blobs, 0, 0);
    image(kImage, w, 0);
    strokeWeight(1);
    noFill();
    for (Detected chairBlob : detectedChairs) {
      chairBlob.draw(color(255, 0, 0), color(0, 255, 255));
    }
    for (Detected sitterBlob : detectedSitters) {
      sitterBlob.draw(color(0, 255, 0), color(255, 0, 255));
    }
    for (Detected walkerBlob : detectedWalkers) {
      walkerBlob.draw(color(0, 0, 255), color(255, 255, 0));
    }
  }
}