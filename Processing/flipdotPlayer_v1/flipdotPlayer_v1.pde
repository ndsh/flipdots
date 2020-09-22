import processing.video.*;
import ch.bildspur.artnet.*;

ArtNetClient artnet;
byte[] dmxData = new byte[28];
boolean switcher = false;

String toSend = "";
color pixel = color(0);

PImage p;
PGraphics pg;
Movie myMovie;
boolean canSend = false;

Panel panel;
Dot dot;

int mode = 1; // picture, movie

// todo: dither filter einbauen

void setup() {
  size(800, 300);
  surface.setLocation(0, 0);
  
  frameRate(15);
  pg = createGraphics(196, 14);
  //pg = createGraphics(28, 14);
  
  panel = new Panel(50, 45);
  p = loadImage("source.png");
  //feedBuffer(p);
  //panel.feed(p);
  ellipseMode(CENTER);
  smooth();
  
  artnet = new ArtNetClient(null);
  artnet.start();
  
  //println(unbinary("1111111"));
  if(mode == 1) {
    myMovie = new Movie(this, "badApple.mp4");
    myMovie.loop();
    myMovie.volume(0);
  }
  //myMovie.jump(160.0);
}

void draw() {
  background(90);
  
  if(mode == 0) {
    feedBuffer(p);
    panel.feed(p);
    
    push();
      imageMode(CENTER);
      image(pg, 650, height/2, width/3, height/3);
    pop();
      
    panel.update();
    panel.display();
    artnet.unicastDmx("2.0.0.3", 0, 13, grabFrame(true));
    artnet.unicastDmx("2.0.0.3", 0, 14, grabFrame(false));
  } else if(mode == 1) {
    if(canSend) {
      //image(myMovie, 10, 10);
      feedBuffer(myMovie);
      panel.feed(myMovie);
      push();
      imageMode(CENTER);
      image(pg, 650, height/2, width/3, height/3);
      pop();
      
      panel.update();
      panel.display();
      artnet.unicastDmx("2.0.0.3", 0, 13, grabFrame(true));
      artnet.unicastDmx("2.0.0.3", 0, 14, grabFrame(false));
      canSend = false;
    }
  }
}

void keyPressed() {
  //dot.flip();
  panel.flip(); // invertiert gerade einfach das display
}

byte[] grabFrame(boolean panelPart) {
  //panelPart => true|up <> false|down
  byte[] data = new byte[28];
  int start = 0;
  int end = 7;
  if(!panelPart) {
    start = 7;
    end = 14;
  }
  pg.loadPixels();
  for(int x = 0; x<28; x++) {
    toSend = "";
    for(int y = start; y<end; y++) {
      pixel = pg.get(x, y);
      if(brightness(pixel) > 50.0) toSend = 1 + toSend;
      else toSend = 0 + toSend;
    }
    data[x] = (byte) unbinary(toSend);
  }
  return data;
}

void movieEvent(Movie m) {
  m.read();
  canSend = true;
}

void feedBuffer(PImage p) {
  pg.beginDraw();
  pg.image(p, 0, 0, pg.width, pg.height);
  pg.endDraw();
}
