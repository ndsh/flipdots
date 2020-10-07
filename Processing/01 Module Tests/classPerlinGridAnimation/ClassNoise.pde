class Noise {
  // from the processing examples: PerlinNoise3D
  PGraphics pg;
  // noise
  float increment = 0.02;
  // The noise function's 3rd argument, a global variable that increments once per cycle
  float zoff = 0.0;  
  // We will increment zoff differently than xoff and yoff
  float zincrement = 0.005;

  public Noise(int w, int h) {
    pg = createGraphics(w, h);
    pg.beginDraw();
    pg.endDraw();
    //noiseDetail(8,0.65f);
  }
  
  void update() {
    pg.loadPixels();
    float xoff = 0.0; // Start xoff at 0
    
    // For every x,y coordinate in a 2D space, calculate a noise value and produce a brightness value
    for (int x = 0; x < pg.width; x++) {
      xoff += increment;   // Increment xoff 
      float yoff = 0.0;   // For every xoff, start yoff at 0
      for (int y = 0; y < pg.height; y++) {
        yoff += increment; // Increment yoff
        
        // Calculate noise and scale by 255
        float bright = noise(xoff,yoff,zoff)*512;
  
        // Try using this line instead
        //float bright = random(0,255);
        
        // Set each pixel onscreen to a grayscale value
        pg.pixels[x+y*pg.width] = color(bright,bright,bright);
      }
    }
    pg.updatePixels();
    
    zoff += zincrement; // Increment zoff
  }
  
  void display() {
  }
  
  PGraphics getDisplay() {
    return pg;
  }
}
