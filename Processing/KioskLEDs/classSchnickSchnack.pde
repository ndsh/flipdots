class SchnickSchnack {
  
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
        //if(id == 1) image(temp, 40, 50);
        stripes[x][y].feed(temp);
      }
    }
  }
  
  void send() {
    for(int y = 0; y<panelsHeight; y++) {
      for(int x = 0; x<panelsWidth; x++) {
        stripes[x][y].send();
      }
    }
  }
  
  // ########################
  // ########################
  // Begin Stripe Class
  
  class Stripe {
    int stripeID = 0;
    PVector pos;
    int[][] leds = new int[64][8];
    int router = 0;
    String routerIP;
    byte[] data = new byte[512];
    int ledSize;
    int universe = 0;
    int maxBrightness;
    
    public Stripe(int id, int _x, int _y, int _router, int _ledSize, int _maxBrightness) {
      stripeID = id;
      ledSize = _ledSize;
      maxBrightness = _maxBrightness;
      //println("created stripeID:" + stripeID);
      pos = new PVector(_x, _y);
      router = _router;
      for(int x = 0; x<64; x++) {
        for(int y = 0; y<8; y++) {
          leds[x][y] = (int)random(100);
        } 
      }
      
      findRouter();
    }
    
    void findRouter() {
      //println(stripeID);
      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < routing[i].length; j++) {
          //println(routing[i][j]);
          if(stripeID == routing[i][j]) {
            router = i;
            universe = j;
            //println("stripeID= " + stripeID + " --> " + routers[router]);
            return;
          }
        }
      }
    }
    
    void update() {
    }
    
    void display() {
      push();
      translate(pos.x, pos.y);
      noStroke();
      int ledColor = 0;
      for(int x = 0; x<64; x++) {
        for(int y = 0; y<8; y++) {
          ledColor = leds[x][y];
          fill(ledColor);
          ellipse(3*x, 3*y, ledSize, ledSize);
        } 
      }
      pop();
    }
    
    void feed(PImage p) {
      color c = 0;
      p.loadPixels();
      int b = 0;
      for(int y = 0; y<8; y++) {
        for(int x = 0; x<16; x++) {
          c = p.get(x, y);
          //int l = y*16+x;
          //c = p.pixels[l];
          b = (int)map(brightness(c), 0, 100, 0, maxBrightness);
          leds[x][y] = b;
          data[y*16+x] = (byte)b;
        } 
      }
      
      for(int y = 0; y<8; y++) {
        for(int x = 16; x<32; x++) {
          c = p.get(x, y);
          //int l = y*16+x;
          //c = p.pixels[l];
          b = (int)map(brightness(c), 0, 100, 0, maxBrightness);
          leds[x][y] = b;
          data[(y*16+x+(64*2))-16] = (byte)b;
        } 
      }
      
      for(int y = 0; y<8; y++) {
        for(int x = 32; x<48; x++) {
          c = p.get(x, y);
          //int l = y*16+x;
          //c = p.pixels[l];
          b = (int)map(brightness(c), 0, 100, 0, maxBrightness);
          leds[x][y] = b;
          data[(y*16+x+(64*3))+32] = (byte)b;
        } 
      }
      
      for(int y = 0; y<8; y++) {
        for(int x = 48; x<64; x++) {
          c = p.get(x, y);
          //int l = y*16+x;
          //c = p.pixels[l];
          b = (int)map(brightness(c), 0, 100, 0, maxBrightness);
          leds[x][y] = b;
          data[(y*16+x+(64*3))+144] = (byte)b;
        } 
      }
      
    }
    
    void send() {
      if(online) artnet.unicastDmx(routers[router], 0, universe, data);
    }
  }
  // End Stripe Class
  
}
