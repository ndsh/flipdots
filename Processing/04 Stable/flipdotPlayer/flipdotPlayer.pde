// todo:
// updates (zahlen, wieviele bytes per panel, histogram, )
// histogram?

// https://github.com/natcl/Artnet/issues/44
// https://github.com/natcl/Artnet/issues/44#issuecomment-609733932

void setup() {
  size(1200, 675);
  //frameRate(20);
  surface.setLocation(0, 0);
  colorMode(HSB, 360, 100, 100);
  ellipseMode(CENTER);
  smooth();
  
  staticImage = loadImage("source3.png");
  pa = this;
  runInits(pa);
}

void draw() {
  stateMachine(state);
  drawUserInterface();
  updateLabels();
}
