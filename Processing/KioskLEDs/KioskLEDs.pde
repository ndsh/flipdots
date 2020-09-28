void setup() {
  size(1000, 200);
  //frameRate(20);
  surface.setLocation(0, 0);
  colorMode(HSB, 360, 100, 100);
  ellipseMode(CENTER);
  smooth();
  
  staticImage = loadImage("source.png");
  pa = this;
  runInits(pa);
}

void draw() {
  stateMachine_LED(state);
}
