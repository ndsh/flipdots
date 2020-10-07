PFont font;
void setup() {
  font = loadFont("OdinRounded-LightItalic-16.vlw");
  textFont(font);
  size(900, 900);
  surface.setLocation(0, 0);
}

void draw() {
  background(0);
  text("yallo", 20, 20);
}
