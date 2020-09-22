class Panel {
  // 28x14 dots
  Dot[][] dots = new Dot[28][14];
  PVector pos;
  
  public Panel(int _x, int _y) {
    pos = new PVector(_x, _y);
    for(int x = 0; x<28; x++) {
      for(int y = 0; y<14; y++) {
        dots[x][y] = new Dot(16*x, 16*y);
      }
    } 
  }
  
  void update() {
    for(int x = 0; x<28; x++) {
      for(int y = 0; y<14; y++) {
        dots[x][y].update();
      }
    }
  }
  
  void display() {
    push();
    translate(pos.x, pos.y);
    for(int x = 0; x<28; x++) {
      for(int y = 0; y<14; y++) {
        dots[x][y].display();
      }
    }
    pop();
  }
  
  void flip() { // eigentlich "invert"
    for(int x = 0; x<28; x++) {
      for(int y = 0; y<14; y++) {
        dots[x][y].flip();
      }
    }
  }
  
  void feed(PImage p) {
    p.loadPixels();
    color c = 0;
    boolean state = false;
    for(int x = 0; x<28; x++) {
      for(int y = 0; y<14; y++) {
        c = p.pixels[y*28+x];
        if(brightness(c) >= 50) state = true;
        else state = false;
        dots[x][y].flip(state);
      }
    }
  
  }
}
