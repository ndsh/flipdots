PerlinGrid grid;


void setup() {
  size(280, 980);
  surface.setLocation(0, 0);
  grid = new PerlinGrid(28, 98);
}

void draw() {
  background(0);
  grid.update(); 
  grid.display();
  image(grid.getDisplay(), 0, 0, width, height);
}
