// todo:

// https://github.com/natcl/Artnet/issues/44
// https://github.com/natcl/Artnet/issues/44#issuecomment-609733932

// flipdot outputs an größe vom grid anpassen
// force output implementieren
// alle cp5 buttons durchstylen
// histogram
// buttons müssen richtig "gebangt" werden

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
