// todo:
// dither filter geht noch nicht
// updates (zahlen, wieviele bytes per panel, histogram, )
// difference between frames (noch nicht ganz korrekt)
// impprterClass
// cp5 stylen
// pause button

void setup() {
  size(1600, 550);
  //frameRate(20);
  surface.setLocation(0, 0);
  colorMode(HSB, 360, 100, 100);
  ellipseMode(CENTER);
  smooth();
  
  staticImage = loadImage("source.png");
  pa = this;
  runInits(pa);
  //feedVideo(this, "1183361194.mp4");
}

void draw() {
  stateMachine_LED(state);
}
