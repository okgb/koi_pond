import org.openkinect.processing.*;
import blobDetection.*;

class Blobber {

  BlobDetection detection;

  ArrayList<PVector> standing;
  ArrayList<PVector> seated;
  ArrayList<PVector> empty;

  PGraphics chairs, sitters, walkers, blobs;
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

    detection = new BlobDetection(w, h);
    detection.setPosDiscrimination(true);
    detection.setThreshold(0.2f); // will detect bright areas whose luminosity > 0.2f;
    chairs = createGraphics(w, h, P3D);
    sitters = createGraphics(w, h, P3D);
    walkers = createGraphics(w, h, P3D);
    blur = loadShader("blur.glsl");
  }

  void detect() {
    kImage = kinect.getDepthImage();
    kImage.loadPixels();
    chairs.loadPixels();
    sitters.loadPixels();
    walkers.loadPixels();
    int red = color(255, 0, 0);
    int green = color(0, 255, 0);
    int blue = color(0, 0, 255);
    int black = color(0);
    for (int i = 0, n = w * h; i < n; i++) {
      int c = kImage.pixels[i];
      float level = brightness(c);

      if (level == 0.0 || level > controller.floorCutoff) { // cutoff
        chairs.pixels[i] = sitters.pixels[i] = walkers.pixels[i] = black;
      } else if (level > controller.chairCutoff) { // chairs
        chairs.pixels[i] = red;
        sitters.pixels[i] = walkers.pixels[i] = black;
      } else if (level > controller.sitterCutoff) { // sitters
        chairs.pixels[i] = red;
        sitters.pixels[i] = green;
        walkers.pixels[i] = black;
      } else { // walkers
        chairs.pixels[i] = red;
        sitters.pixels[i] = green;
        walkers.pixels[i] = blue;
      }
    }
    chairs.updatePixels();
    sitters.updatePixels();
    walkers.updatePixels();

    chairs.beginDraw();
    int a=0; while(++a < 5) chairs.filter(blur); // apply 10 times
    chairs.filter(THRESHOLD);
    chairs.endDraw();

    sitters.beginDraw();
    a=0; while(++a < 5) sitters.filter(blur); // apply 10 times
    sitters.filter(THRESHOLD);
    sitters.endDraw();

    walkers.beginDraw();
    a=0; while(++a < 5) walkers.filter(blur); // apply 10 times
    walkers.filter(THRESHOLD);
    walkers.endDraw();

    // PImage snapshot = depth.get();

    chairs.loadPixels();
    detection.computeBlobs(chairs.pixels);
  }

  void draw() {
    imageMode(CORNER);
    image(blobber.getChairsImage(), 0, 0);
    image(blobber.getSittersImage(), blobber.w, 0);
    image(blobber.getWalkersImage(), 0, blobber.h);
    image(blobber.getKinectImage(), blobber.w, blobber.h);
    for (int i = 0, n = detection.getBlobNb(); i < n; i++) {
      Blob b = detection.getBlob(n);
      if (b != null) println(b.getEdgeNb());
    }
  }

  PImage getChairsImage() {
    return (PImage)chairs;
  }

  PImage getSittersImage() {
    return (PImage)sitters;
  }

  PImage getWalkersImage() {
    return (PImage)walkers;
  }

  PImage getKinectImage() {
    return kImage;
  }

  int getWidth() {
    return w;
  }

  int getHeight() {
    return h;
  }
}