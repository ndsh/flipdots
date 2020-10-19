class PerlinGrid {
  PGraphics pg;
  PFont font;
  Noise noise;
  
  //String letters = "MN@#$o;:,. ";
  String letters = "ABCDEFGHJKILMNOPQRSTUVWXYZ " ;

  String fontSets[][] = {
    {"BitFUUL_10px.ttf", "10"},
    {"CD-IconsPC_20px.ttf", "20"},
    {"MiniStrzalki_12px.ttf", "12"},
    {"pixel_dingbats-7_8px.ttf", "8"},
    {"SlapAndCrumbly_12px.ttf", "12"},
    {"Spacy Stuff_10px.ttf", "10"},
    {"SPAIDERS_6px.TTF", "6"},
    {"sqcon_10px.ttf", "10"},
    {"craft_16px.ttf", "16"}
  };
  
  int currentFont = 3;
  int fontSize = 0;
  int fontScale = 1;
  
  int gridSizeX = 3;
  int gridSizeY = 12;
  
  public PerlinGrid(int w, int h) {
    pg = createGraphics(w, h);
    pg.beginDraw();
    fontSize = Integer.parseInt(fontSets[currentFont][1]);
    font = createFont("fonts/" + fontSets[currentFont][0], fontSize);
    pg.textFont(font);
    pg.textSize(fontSize*fontScale);
    pg.textAlign(CENTER, CENTER);
    
    noise = new Noise(w, h);
    //pg.beginDraw();
  }
  
  void update() {
    noise.update();
  }
  
  void display() {
    pg.beginDraw();
    pg.clear();
    pg.translate((pg.width/gridSizeX)/2, (pg.height/gridSizeY)/2);
    for(int x = 0; x<gridSizeX; x++) {
      for(int y = 0; y<gridSizeY; y++) {
        asciify(noise.getDisplay(), x*(pg.width/gridSizeX), y*(pg.height/gridSizeY));
      }
    }
    pg.endDraw();
  }
  
  PGraphics getDisplay() {
    return pg;
  }
  
  void asciify(PImage p, int x, int y) {
    p.loadPixels();
    color c = p.pixels[y*p.width+x];
    float b = pg.brightness(c);
    int val = (int)map(b, 0, 255, 0, letters.length()-1);
    pg.text(letters.charAt(val), x, y);
  }
  
  class Noise {
    // from the processing examples: PerlinNoise3D
    PGraphics pg;
    // noise
    float increment = 0.015;
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
          float bright = noise(xoff,yoff,zoff)*200;
    
          // Try using this line instead
          //float bright = random(0,255);
          
          // Set each pixel onscreen to a grayscale value
          pg.pixels[y*pg.width+x] = color(bright,bright,bright);
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
  // end noise
}
