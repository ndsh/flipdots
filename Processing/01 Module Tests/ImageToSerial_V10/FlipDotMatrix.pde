import java.util.Arrays;
import processing.serial.*;
  
  
  Serial myPort;  // Create object from Serial class

  /********* 300 cm Wandgröße *********/
  int flipDotWidth = 196;
  int flipDotHeight = 14;
  int fps = 15;
  long lastMillis = 0;
  int thePixelDensity = 1; //displayDensity();

  
  int brightness = 0;
  float mid = 0;
  float contrast = 1.0;
  
  boolean renderWall = true;
  
  
  boolean showBackground = true;
  boolean showLight = true;
  boolean showMask = false;
  boolean serialInit = false;
  
  boolean greyscale = true;
  boolean sendBytes = true;
  boolean saveFrame = false;

  
  int flipDotDisplayWidth = flipDotWidth/thePixelDensity;
  int flipDotDisplayHeight = flipDotHeight/thePixelDensity;
  
  PShader maskShader;
  PGraphics maskImage;
  
  PGraphics pgDisplay; 
  PGraphics pgOutput; 
  PGraphics pgWall;
  
  PImage wall;
  PImage wall_bg;
  
  PVector dot = new PVector(1,1);
  
  
  int panels = (flipDotWidth*flipDotHeight/7) / 28;
  long sendMillis = 0;
  int sendDelay = 10;
  
  float lastFrameTime = 0;
  long lastFrameMillis;
  
  int brightnessThreashold = 100;
  int lowestBrightness = 40;
  int brightnessSteps = 40;
  
  void setupFlipDotMatrix() {
    
    String[] ports = Serial.list();
    println(ports);
    for (int i=0; i<ports.length; i++) {
      // if (ports[i].indexOf("/dev/tty.usbserial-FTR") != -1) {  // Windows
      //if (ports[i].indexOf("/dev/tty.usbmodem141") != -1) {  // mac
      if (ports[i].indexOf("/dev/ttyAMA0") != -1) { // RasPi (ttyACM0=USB, ttyAMA0=PIN)
        myPort = new Serial(this, ports[i], 57600);
        println("Init serial "+ports[i] + ".");
        serialInit = true;
        break;
      }
    }
    
    //serialInit = false;
    
    
    pgDisplay = createGraphics(flipDotDisplayWidth, flipDotDisplayHeight, P2D);
    pgDisplay.noSmooth();
    pgDisplay.beginDraw();
    pgDisplay.background(0);
    pgDisplay.endDraw();
    //((PGraphicsOpenGL)pgDisplay).textureSampling(POINT);
    
    dot = new PVector(maxsize/flipDotWidth, maxsize/flipDotHeight);
    dot.x = dot.y = dot.y < dot.x ? dot.y : dot.x;
    
    while (scale*flipDotWidth*dot.x*thePixelDensity > maxsize || scale*flipDotHeight*dot.y*thePixelDensity > maxsize) scale /= 2.0;
    //size(flipDotWidth*scale, (int) (flipDotHeight*scale+flipDotHeight+filterDistance+2));
    
    pgWall = createGraphics((int) (flipDotWidth*dot.x*scale), (int) (flipDotHeight*dot.y*scale), P2D);
    
    if (renderWall) {
      File f = new File(dataPath("wall.png"));
      if (!f.exists()) {
        pgWall.imageMode(CENTER);
        pgWall.beginDraw();
        pgWall.clear();
        pgWall.noStroke();
        pgWall.fill(255);
        //pgWall.background(0);
        pgWall.translate(dot.x*scale/2.0, dot.y*scale/2.0);
        for (int l=0; l<flipDotWidth; l++) for (int k=0; k<flipDotHeight; k++) {
          pgWall.pushMatrix();
          pgWall.translate(l*dot.x*scale, k*dot.y*scale);
          if (l % 2 == 0) pgWall.scale(-1);
          pgWall.ellipse(0, 0, dot.x*scale*0.9, dot.y*scale*0.9);
          pgWall.popMatrix();
        }
        pgWall.endDraw();
        pgWall.save(dataPath("wall.png"));
        println("scale = " + scale + ", width = " + flipDotWidth*dot.x*scale + ", height = " + flipDotHeight*dot.y*scale);
      }
      
      f = new File(dataPath("wall_bg.png"));
      if (!f.exists()) {
        pgWall.beginDraw();
        pgWall.clear();
        pgWall.imageMode(CENTER);
        pgWall.background(40);
        pgWall.fill(0);
        pgWall.noStroke();
        //pgWall.stroke(100);
        pgWall.translate(dot.x*scale/2.0, dot.y*scale/2.0);
        for (int l=0; l<flipDotWidth; l++) for (int k=0; k<flipDotHeight; k++) {
          pgWall.pushMatrix();
          pgWall.translate(l*dot.x*scale, k*dot.y*scale);
          if (l % 2 == 0) pgWall.scale(-1);
          pgWall.ellipse(0, 0, dot.x*scale*0.9, dot.y*scale*0.9);
          pgWall.popMatrix();
        }
        pgWall.endDraw();
        pgWall.save(dataPath("wall_bg.png"));
      }
    }
    wall = loadImage("wall.png");
    wall_bg = loadImage("wall_bg.png");
    
    pixelDensity(thePixelDensity);
  
    sheight = (int) (width * ((float)pgWall.height/(float)pgWall.width));
    
    ratioX = (float) 1.0 / dot.x * (float) pgWall.width / width;
    ratioY = (float) 1.0 / dot.y * (float) pgWall.height / sheight;
  
    pgOutput = createGraphics((int) width, (int) sheight, P2D);
  
    println("size("+pgWall.width+", "+pgWall.height+")");
  
    lowestBrightness /= brightnessSteps;
  
    lastFrameMillis = millis();
    frameRate(300);
  
    maskImage = createGraphics(flipDotDisplayWidth, flipDotDisplayHeight, P2D);
    println("maskImage size("+maskImage.width+", "+maskImage.height+")");
    maskImage.noSmooth();
    ((PGraphicsOpenGL)maskImage).textureSampling(POINT);
    
    maskShader = loadShader("mask.glsl");
    maskShader.set("mask", maskImage);
  }
  
  void drawFlipDotMatrix() {
       
    pgOutput.beginDraw();
    pgOutput.clear();
    pgOutput.shader(maskShader);  
    pgOutput.image(wall, 0, 0, width, sheight);
    pgOutput.endDraw();
    
    background(0);
  
    pushMatrix();
    translate(0, (height-sheight)/2);
    
    blendMode(ADD);
    if (showBackground) image(wall_bg, 0, 0, width, sheight);
    if (showLight) image(pgOutput, 0, 0, width, sheight);
    if (showMask) image(maskImage, 0, 0, width, sheight);
    
    popMatrix();
    sendImage();
    
    if (keyPressed) {
      switch(mode) {
      case IMAGE:
        keyPressedImages();
        break;
      case VIDEO:
        break;
      default:
      }
    }
    
    if (play || saveFrame) next();
} 

void first() {
  switch(mode) {
    case IMAGE:
      playImage();
      break;
    case TEXT:
      playText();
      break;
    default:
  }
}

void next() {
  switch(mode) {
    case IMAGE:
      nextImage();
      break;
    case TEXT:
      nextLetter();
      break;
    default:
  }
}

void prev() {
  switch(mode) {
    case IMAGE:
      prevImage();
      break;
    case TEXT:
      //prevLetter();
      break;
    default:
  }
}


int adjustedComponent(int component, int brightness, float contrast, float mid)
  {
      component += int(sin(component/255.0*PI) * mid);
      component = int((component - 128) * contrast) + 128 + brightness;
      return component < 0 ? 0 : component > 255 ? 255 : component;  
  }  
     

void handleImage() {
  int nextValue = 0;
  int value = 0;
  maskImage.loadPixels();
  int index = 0;
  //println(maskImage.pixels);
  for (int p=0; p<flipDotWidth/28; p++) {
    for (int y=0; y<flipDotHeight/7; y++) {
      index++;
      myPort.write(0x80);
      myPort.write(0x84);
      myPort.write(byte(index));
      for (int x=0; x<28; x++) {
        nextValue = 0;
        value = 0;
        for (int j=0; j<7; j++) {
          int count = j%7;
          nextValue = (int) pow(2, count);
          int offset = floor(j/7.0)*flipDotWidth;
          if (brightness(maskImage.pixels[(p*28+x)+flipDotWidth*(y*7+j)]) > brightnessThreashold) value += nextValue;
        }
  
        myPort.write(value);
      }
      
      myPort.write(0x8F);
    }
  }
}

int refresh[]= {0x80, 0x82, 0x8F};

void sendImage() {
  if (sendBytes && serialInit && millis()-sendMillis > sendDelay) { //  && !Arrays.equals(toSaveBytes, saveBytes)
    //println("send");
    handleImage();   
/*    
      myPort.write(byte(0x80));
      myPort.write(byte(0x82));
      myPort.write(byte(0x8F));
*/
    sendToSerial(refresh);
    //myPort.write(254);
    sendMillis = millis();
    sendBytes = false;
  }
}

void sendToSerial(int[] message) {
  if (!serialInit) return;
  //println(message.length);
  for (int i=0; i<message.length; i++) {
    myPort.write(message[i]); 
    print(message[i]+",");
  }
  println();
//  delay (70);
}


void finish() {
  if (!saveFrame) return;
  saveFrame = false;
  useFps = true;
}