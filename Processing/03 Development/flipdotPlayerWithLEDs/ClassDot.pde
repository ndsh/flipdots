class Dot {
  boolean state = false;
  boolean animate = false;
  PVector pos = new PVector(0, 0);
  float size = flipdotSize;
  float rotation;
  float increment;
  long timestamp = 0;
  
  public Dot() {
    rotation = size*1;
    increment = size/3;
  }
  
  public Dot(int x, int y) {
    rotation = size*1;
    increment = size/1.1;
    pos = new PVector(x, y);
  }
  
  void update() {
    if(animate) {
      if(state) {
        rotation += increment;
        if(rotation >= size) {
          animate = false;
          rotation = size;
        }
      } else {
          rotation -= increment;
          if(rotation < (size*-1)) {
            rotation = (size*-1);
            animate = false;
          }
      }
    }
  }
  
  void display() {
    push();
    noStroke();
    
    if(state) fill(0, 0, 100);
    else fill(0);
    translate(pos.x, pos.y);
    
    rotate(radians(-45));
    ellipse(0, 0, size, rotation);
    pop();
  }
  
  void flip() {
    state = !state;
    animate = true;
  }
  
  void flip(boolean b) {
    if(b != state) animate = true; 
    state = b;
    
  }
  
  
}
