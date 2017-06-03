import controlP5.*;

class Controller {

  color bg = color(64,128);
  color fg = color(192,128);

  float floorCutoff = 80;
  float chairCutoff = 60;
  float sitterCutoff = 50;

  float chairMinSize = 50;
  float chairMaxSize = 100;

  float sitterMinSize = 50;
  float sitterMaxSize = 100;

  float walkerMinSize = 50;
  float walkerMaxSize = 100;

  int kinectOverlap = 0;

  int kinectCutoffTop = 0;
  int kinectCutoffBottom = 0;
  int kinectCutoffLeft = 0;
  int kinectCutoffRight = 0;

  ControlP5 cp5;

  Controller(PApplet p) {
    cp5 = new ControlP5(p);
    cp5.enableShortcuts();
    setup();
  }

  void setup(){
    cp5.addSlider("sitter cutoff")
      .setColorBackground(bg)
      .setColorForeground(fg)
      .setBroadcast(false)
      .setPosition(100,100)
      .setWidth(255)
      .setRange(0, 255)
      .setValue(sitterCutoff)
      .setBroadcast(true);

    cp5.addSlider("chair cutoff")
      .setColorBackground(bg)
      .setColorForeground(fg)
      .setBroadcast(false)
      .setPosition(100,125)
      .setWidth(255)
      .setRange(0, 255)
      .setValue(chairCutoff)
      .setBroadcast(true);

    cp5.addSlider("floor cutoff")
      .setColorBackground(bg)
      .setColorForeground(fg)
      .setBroadcast(false)
      .setPosition(100,150)
      .setWidth(255)
      .setRange(0, 255)
      .setValue(floorCutoff)
      .setBroadcast(true);

    cp5.addRange("chair size")
      .setColorBackground(bg)
      .setColorForeground(fg)
      .setBroadcast(false)
      .setPosition(100, 200)
      .setSize(255, 10)
      .setHandleSize(20)
      .setRange(0, 215) // ???
      .setRangeValues(chairMinSize, chairMaxSize)
      .setBroadcast(true);

    cp5.addRange("sitter size")
      .setColorBackground(bg)
      .setColorForeground(fg)
      .setBroadcast(false)
      .setPosition(100, 225)
      .setSize(255, 10)
      .setHandleSize(20)
      .setRange(0, 215) // ???
      .setRangeValues(sitterMinSize, sitterMaxSize)
      .setBroadcast(true);

    cp5.addRange("walker size")
      .setColorBackground(bg)
      .setColorForeground(fg)
      .setBroadcast(false)
      .setPosition(100, 250)
      .setSize(255, 10)
      .setHandleSize(20)
      .setRange(0, 215) // ???
      .setRangeValues(walkerMinSize, walkerMaxSize)
      .setBroadcast(true);

    cp5.addSlider("kinect overlap")
      .setColorBackground(bg)
      .setColorForeground(fg)
      .setBroadcast(false)
      .setPosition(100,300)
      .setWidth(255)
      .setRange(0, 255)
      .setValue(kinectOverlap)
      .setBroadcast(true);

    cp5.addSlider("cutoff top")
      .setColorBackground(bg)
      .setColorForeground(fg)
      .setBroadcast(false)
      .setPosition(100,325)
      .setWidth(255)
      .setRange(0, 255)
      .setValue(kinectCutoffTop)
      .setBroadcast(true);

    cp5.addSlider("cutoff bottom")
      .setColorBackground(bg)
      .setColorForeground(fg)
      .setBroadcast(false)
      .setPosition(100,350)
      .setWidth(255)
      .setRange(0, 255)
      .setValue(kinectCutoffBottom)
      .setBroadcast(true);

    cp5.addSlider("cutoff left")
      .setColorBackground(bg)
      .setColorForeground(fg)
      .setBroadcast(false)
      .setPosition(100,375)
      .setWidth(255)
      .setRange(0, 255)
      .setValue(kinectCutoffLeft)
      .setBroadcast(true);

    cp5.addSlider("cutoff right")
      .setColorBackground(bg)
      .setColorForeground(fg)
      .setBroadcast(false)
      .setPosition(100,400)
      .setWidth(255)
      .setRange(0, 255)
      .setValue(kinectCutoffRight)
      .setBroadcast(true);
  }

  void controlEvent(ControlEvent e) {
    if (e.isFrom("floor cutoff")) {
      floorCutoff = e.getController().getValue();
    } else if (e.isFrom("chair cutoff")) {
      chairCutoff = e.getController().getValue();
    } else if (e.isFrom("sitter cutoff")) {
      sitterCutoff = e.getController().getValue();
    } else if (e.isFrom("chair size")) {
      chairMinSize = e.getController().getArrayValue(0);
      chairMaxSize = e.getController().getArrayValue(1);
    } else if (e.isFrom("sitter size")) {
      sitterMinSize = e.getController().getArrayValue(0);
      sitterMaxSize = e.getController().getArrayValue(1);
    } else if (e.isFrom("walker size")) {
      walkerMinSize = e.getController().getArrayValue(0);
      walkerMaxSize = e.getController().getArrayValue(1);
    } else if (e.isFrom("kinect overlap")) {
      kinectOverlap = (int)e.getController().getValue();
    } else if (e.isFrom("cutoff top")) {
      kinectCutoffTop = (int)e.getController().getValue();
    } else if (e.isFrom("cutoff bottom")) {
      kinectCutoffBottom = (int)e.getController().getValue();
    } else if (e.isFrom("cutoff left")) {
      kinectCutoffLeft = (int)e.getController().getValue();
    } else if (e.isFrom("cutoff right")) {
      kinectCutoffRight = (int)e.getController().getValue();
    }
  }

  void show() {
    cp5.show();
  }

  void hide() {
    cp5.hide();
  }
}