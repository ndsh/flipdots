Panel panel;
Dot dot;

PImage p;

void setup() {
  size(600, 300, P2D);
  surface.setLocation(0, 0);
  
  panel = new Panel(85, 45);
  p = loadImage("source.png");
  panel.feed(p);
  ellipseMode(CENTER);
  //dot = new Dot(width/2, height/2);
  smooth();
}

void draw() {
  background(90);
  panel.update();
  panel.display();
  //dot.update();
  //dot.display();
}

void keyPressed() {
  //dot.flip();
  panel.flip(); // invertiert gerade einfach das display
}
