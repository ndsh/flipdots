class SchnickSchnack {
  PGraphics pg;
  PGraphics out;
  
  PImage temp;
  int stripeWidth = 64;
  int stripeHeight = 8;
  int panelsWidth = 5;
  int panelsHeight = 2;
  Stripe[][] stripes = new Stripe[panelsWidth][panelsHeight];
  
  int maxBrightness = 0;
  
  // eine kachel: 16*8 = 128 pixel
  // ein streifen: 64*8 = 512 pixel
  // totale breite: 16*20 = 320 * 16 pixel = 5120 pixel
  
  int ledSize = 2;

  public SchnickSchnack(int _brightness) {
    maxBrightness = _brightness;
    for(int y = 0; y<panelsHeight; y++) {
      for(int x = 0; x<panelsWidth; x++) {
        int id = y*5+x;
        stripes[x][y] = new Stripe(id, x*((ledSize+1)*64), y*((ledSize+1)*8), 0, ledSize, _brightness);
      }
    }
  }
  
  void update() {
    
  }
  
  void display() {
    for(int y = 0; y<panelsHeight; y++) {
      for(int x = 0; x<panelsWidth; x++) {
        stripes[x][y].display();
      }
    }
  }
  
  void feed(PImage p) {
    PImage temp;
    for(int y = 0; y<panelsHeight; y++) {
      for(int x = 0; x<panelsWidth; x++) {
        int id = y*5+x;
        temp = p.get(64*x, 8*y, 64, 8);
        //if(id == 0) println("x0=" + 64*x, 8*y, 64, 8);
        //println(temp.width + " * " + temp.height);
        if(id == 1) image(temp, 40, 50);
        
        stripes[x][y].feed(temp);
      }
    }
    
  }
  
  void send() {
    //println("sending");
    for(int y = 0; y<panelsHeight; y++) {
      for(int x = 0; x<panelsWidth; x++) {
        stripes[x][y].send();
      }
    }
  }
  
  
}
