import ch.bildspur.artnet.*;
import controlP5.*;
import processing.video.*;

SchnickSchnack leds;
Stripe stripe;
ArtNetClient artnet;
ControlP5 cp5;
Movie myMovie;

boolean online = true;

// router IPs
String[] routers = {"2.161.30.223", "2.12.4.156", "2.12.4.69"};
int[][] routing = {{0, 1, 5, 6}, {2, 3, 7, 8}, {4, 9}};

PImage testImage;

void setup() {
  //size(80, 16);
  size(1650, 195);
  surface.setLocation(0, 0);
  leds = new SchnickSchnack(90);
  artnet = new ArtNetClient(null);
  artnet.start();
  //imageMode(CENTER);
  //stripe = new Stripe(0, 10, 10, 0);
  myMovie = new Movie(this, "expand.mp4");
  myMovie.loop();
  //  stripe.feed(myMovie);
  testImage = loadImage("text.png");
}

void draw() {
  
  
  if(myMovie.available()) {
    background(120);
    myMovie.read();
    //PImage temp = myMovie.get(0, 0, 64, 8);
    //image(temp, 0, 0);
    //myMovie.resize(320, 0);
    PGraphics pt = createGraphics(320, 16);
    pt.beginDraw();
    pt.image(myMovie, 0, 0, 320, 16);
    pt.endDraw();
    
    leds.feed(testImage);
    //stripe.feed(myMovie);
    
    leds.update();
    leds.display();
    leds.send();
  }
  
  //leds.feed(myMovie);
  
  
  //stripe.update();
  //stripe.display();
  //stripe.send();
}
