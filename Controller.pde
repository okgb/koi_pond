import controlP5.*;

class Controller {

  float floorCutoff = 200;
  float chairCutoff = 190;
  float sitterCutoff = 64;

  ControlP5 cp5;

  Controller(PApplet p) {
    cp5 = new ControlP5(p);
    cp5.enableShortcuts();
    setup();
  }

  void setup(){
    cp5.addSlider("floor cutoff")
      .setPosition(50,100)
      .setWidth(255)
      .setRange(0, 255)
      .setValue(floorCutoff);
    cp5.addSlider("chair cutoff")
      .setPosition(350,100)
      .setWidth(200)
      .setRange(0, 255)
      .setValue(chairCutoff);
    cp5.addSlider("sitter cutoff")
      .setPosition(650,100)
      .setWidth(255)
      .setRange(0, 255)
      .setValue(sitterCutoff);
    //  //New slider
    // cp5.addSlider("blurAmount")
    //    .setPosition(50,120)
    //    .setWidth(200)
    //    .setRange(0,10)
    //    ;


    // use Slider.FIX or Slider.FLEXIBLE to change the slider handle
    // by default it is Slider.FIX
    // cp5.addRange("rangeController")
    //   // disable broadcasting since setRange and setRangeValues will trigger an event
    //   .setBroadcast(false)
    //   .setPosition(50,70)
    //   .setSize(200,20)
    //   .setHandleSize(20)
    //   .setRange(minD,maxD)
    //   //.setRangeValues(50,100)
    //   // after the initialization we turn broadcast back on again
    //   .setBroadcast(true)
    //   .setColorForeground(color(255,40))
    //   .setColorBackground(color(255,40))
    //   ;
    // println(range);

    // use Slider.FIX or Slider.FLEXIBLE to change the slider handle
    // by default it is Slider.FIX
    // cp5.addRange("rangeController2")
    //   // disable broadcasting since setRange and setRangeValues will trigger an event
    //   .setBroadcast(false)
    //   .setPosition(350,70)
    //   .setSize(200,20)
    //   .setHandleSize(20)
    //   .setRange(minD,maxD)
    //   //.setRangeValues(50,100)
    //   // after the initialization we turn broadcast back on again
    //   .setBroadcast(true)
    //   .setColorForeground(color(255,40))
    //   .setColorBackground(color(255,40))
    //   ;
    //   // println(range);

    // use Slider.FIX or Slider.FLEXIBLE to change the slider handle
    // by default it is Slider.FIX
    // cp5.addRange("rangeController3")
    //   // disable broadcasting since setRange and setRangeValues will trigger an event
    //   .setBroadcast(false)
    //   .setPosition(650,70)
    //   .setSize(200,20)
    //   .setHandleSize(20)
    //   .setRange(minD,maxD)
    //   //.setRangeValues(50,100)
    //   // after the initialization we turn broadcast back on again
    //   .setBroadcast(true)
    //   .setColorForeground(color(255,40))
    //   .setColorBackground(color(255,40))
    //   ;
    //   // println(range);
  }

  void controlEvent(ControlEvent e) {
    if (e.isFrom("floor cutoff")) {
      floorCutoff = e.getController().getValue();
    } else if (e.isFrom("chair cutoff")) {
      chairCutoff = e.getController().getValue();
    } else if (e.isFrom("sitter cutoff")) {
      sitterCutoff = e.getController().getValue();
    }

    // if(theControlEvent.isFrom("rangeController")) {
    //   minDepth[0] = int(theControlEvent.getController().getArrayValue(0));
    //   maxDepth[0] = int(theControlEvent.getController().getArrayValue(1));
    //   //println("range update, done.");
    // }
    // if(theControlEvent.isFrom("rangeController2")) {
    //   minDepth[1] = int(theControlEvent.getController().getArrayValue(0));
    //   maxDepth[1] = int(theControlEvent.getController().getArrayValue(1));
    //   //println("range2 update, done.");
    // }
    // if(theControlEvent.isFrom("rangeController3")) {
    //   minDepth[2] = int(theControlEvent.getController().getArrayValue(0));
    //   maxDepth[2] = int(theControlEvent.getController().getArrayValue(1));
    //   //println("range3 update, done.");
    // }
  }
}