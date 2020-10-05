
  boolean useFps = true;
  boolean play = false;
  
  
  
  int mode = 3;
  static final int NONE = 0;
  static final int IMAGE = 1;
  static final int VIDEO = 2;
  static final int TEXT = 3;
  
  boolean sizeSet = false;
  boolean shiftIsDown = false;
  boolean controlIsDown = false;
  
  float ratioX;
  float ratioY;
  float scale = 1;
  int maxsize = 16384;
  int sheight;
  
  String[] sagen = {
    "/ / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / ",
    /*
    "Ja?",
    "Hallo",
    "Hallo?",
    "Hallo, hier ist der Weihnachtsmann. Ich kann dies",
    "Ja",
    "Ich kann dieses Jahr nicht kommen. Ich hab schwer-depressiv-paranoide Wahnvorstellungen und sitz in Ochsenzoll ein.",
    "aha",
    "Vielleicht kann ich einen Kollegen schicken. Der Fritz Honka hat Freigang. Der kommt dann mit seinem Sack vorbei.",
    "mmhm.. und wer ist da jetz am Telefon?",
    "Der Weihnachtsmann.",
    "aha",
    "Ich hab einfach zuviel Crack geraucht in letzter Zeit...",
    "Was hast du?",
    "Ich hab einfach zuviel Crack geraucht in letzter Zeit...",
    "Und was is denn das für ne Musik dahinter?",
    "Die Weihnachtsmannmusik.",
    "aaha",
    "Das is die schöne Weihnachtsmannmusik.",
    "mmhm",
    "Ich kann einfach nich mehr. Der Fritz kommt vorbei.",
    "mmh und was hast du warum sprichst du so komisch?",
    "Ich hab zuviel Crack eingenommen...",
    "Was hast du?",
    "Ich hab.. ich hab.. ich hab Bier geraucht.",
    "aaha",
    "Ich kann nich mehr...",
    "mmh... und wer bist du eigentlich?",
    "Ich bin der Osterhase.",
    "aha",
    "Mir gehts schlecht. Oma, wann kann ich nach hause kommen? Oma?",
    "Ja.",
    "Wann kann ich nach hause kommen?",
    "Ja, du musst mir schon sagen wer du bist.",
    "Ich bin es der Fingstspatz.",
    "aha",
    "Mama",
    "Na",
    "Opamama",
    "mh",
    "Du bist meine Opamama.",
    "Wieso? Warum bin ich das?",
    "Ich weiss nich. Ich hab dich lieb.",
    "Ja ah..",
    "Bis bald mein Opamamaonkel",
    "mmhm",
    "Tschüüsss"
    */
                  };
  int sagenIndex = 0; 
  
  long yoMillis = 0;
  long delayMills = 60000; 

void setup() {


  //
  
  setupFlipDotMatrix();
  
  /********* Feste Größe 600x800 *********/
  //size(1280, 538, P3D); 
  
  /********* Fullscreen *********/
  //fullScreen(P2D, SPAN);
  
  /********* Feste Größe Display *********/
  size(displayWidth, displayHeight, P2D); 
  //size(1024, 768, P2D);
  //sagen = loadStrings("171130-Flipdots-Originalsagen_01.txt");
  //println(sagen.length);
  setupText();
    
  //if (useFps) frameRate(fps);
  initImages();
  play();
}

void draw() {
  if (useFps && millis() - lastMillis < 1000.0/fps) return;
  lastMillis = millis();
  
  if(drawDisplay()) {
  }
  
  drawFlipDotMatrix();
  if(millis() - yoMillis > delayMills) {
    yoMillis = millis();
    play();
  }
}

  
boolean drawDisplay() {
  pgDisplay.loadPixels();
  color[] oldPixels = new color[pgDisplay.pixels.length];
  
  arrayCopy(pgDisplay.pixels, oldPixels);
  
  pgDisplay.beginDraw();
  pgDisplay.clear();
  //pgDisplay.background(255);
  //pgDisplay.fill(0);
  // rectMode(CENTER);

  switch(mode) {
  case IMAGE:
    drawImages();
    break;
  case TEXT:
    drawText();
    break;
  default:
  }

  pgDisplay.endDraw();
  
  pgDisplay.loadPixels();
  int l = pgDisplay.pixels.length;
  
  //Variables to hold single pixel color and its components 
  int c = 0;
  int a = 0;
  int r = 0;
  int g = 0;
  int b = 0;
  
  
  PImage pi = createImage(flipDotWidth, flipDotHeight, ARGB);
  pi.loadPixels();
  for(int i = 0; i < l; i++)
  {
      c = pgDisplay.pixels[i];
      a = c >> 24 & 0xFF;
      r = adjustedComponent(c >> 16 & 0xFF, brightness, contrast, mid);
      g = adjustedComponent(c >> 8  & 0xFF, brightness, contrast, mid);
      b = adjustedComponent(c       & 0xFF, brightness, contrast, mid); 
      pi.pixels[i] = a << 24 | r << 16 | g << 8 | b;
  }
  
  maskImage.beginDraw();
  maskImage.clear();
  maskImage.background(0);
  maskImage.image(pi, 0, 0, flipDotDisplayWidth, flipDotDisplayHeight);
  maskImage.endDraw();
  
  return !Arrays.equals(pgDisplay.pixels, oldPixels);

}

void play() {
  saveFrame = true;
  useFps = false;
  
  initText(sagen[sagenIndex]);
  sagenIndex = sagenIndex+1 >= sagen.length ? 0 : sagenIndex + 1; 
  
  first();
  
  
}


void keyPressed() {
  //  println(keyCode);
  switch(keyCode) {
  case BACKSPACE:
  case ENTER:
    if (shiftIsDown || controlIsDown) switch(mode) {
    case IMAGE:
      initImages();
      break;
    case TEXT:
      break;
    default:
    }
    break;
  case SHIFT:
    shiftIsDown = true;
    break;
  case 157:
  case CONTROL:
    controlIsDown = true;
    break;
  }

  if (keyCode >= 112 && keyCode < 122) {
    mode = keyCode-112;
  }

  
  switch(key) {
  case '+':
    if (shiftIsDown) mid += 5;
    else if (controlIsDown) contrast += .05;
    else brightness += 5;
    break;
  case '-':
    if (shiftIsDown) mid -= 5;   
    else if (controlIsDown) contrast -= .05;
    else brightness -= 5;
    break;
  case 'b':
    showBackground = !showBackground;
    break;
  case 'l':
    showLight = !showLight;
    break;
  case 'm':
    showMask = !showMask;
    break;
  case ' ':
    if (!saveFrame) useFps = true;
    play = !play;
    break;
  }
}

void keyReleased() {
  switch(keyCode) {
  case SHIFT:
    shiftIsDown = false;
    break;
  case 157:
  case CONTROL:
    controlIsDown = false;
    break;
  case ENTER:
    play();
    //save("output/frames-"+millis()+".png");
    //println("save frame");
    break;
  }
}
