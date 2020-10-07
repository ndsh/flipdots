PFont font;
Noise noise;

//String letters = "MN@#$o;:,. ";
String letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

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

int currentFont = 8;
int fontSize = 0;
int fontScale = 2;

int gridSizeX = 16;
int gridSizeY = 9;

void setup() {
  size(600, 300);
  surface.setLocation(0, 0);
  fontSize = Integer.parseInt(fontSets[currentFont][1]);
  font = createFont(fontSets[currentFont][0], fontSize);
  textFont(font);
  textSize(fontSize*fontScale);
  textAlign(CENTER, CENTER);
  
  noise = new Noise(600, 300);
}

void draw() {
  noise.update();
  background(0);
  //image(noise.getDisplay(), 0, 0);
  
  
  /*loadPixels();
  color c = pixels[height/2*width+width/2];
  float b = brightness(c);
  int val = (int)map(b, 0, 255, 0, letters.length());
  text(letters.charAt(val), width/2, height/2);
  */
  translate((width/gridSizeX)/2, (height/gridSizeY)/2);
  for(int x = 0; x<gridSizeX; x++) {
    for(int y = 0; y<gridSizeY; y++) {
      asciify(noise.getDisplay(), x*(width/gridSizeX), y*(height/gridSizeY));
    }
  }
  
}

void asciify(PImage p, int x, int y) {
  p.loadPixels();
  color c = p.pixels[y*p.width+x];
  float b = brightness(c);
  int val = (int)map(b, 0, 255, 0, letters.length()-1);
  text(letters.charAt(val), x, y);
}
