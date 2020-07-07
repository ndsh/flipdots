/*

FLIPDIGITS PLAYER
an algorithm sequencer
and a bunch of demo animations
for a flipdigits display

Ksawery Kirklewski
www.ksawerykomputery.pl/tools/flipdigits-player
5-01-2020

*/

int cols = 4;
int rows = 5;

boolean senddataOn = false; // if you have a display, turn it on
boolean controllerOn = false; // dedicated controller based on Arduino

boolean cameraOn = false; // if you want to use camera
boolean kinectOn = false; // if you want to use kinect
boolean syphonOn = false; // if you want to use syphon


void setup() {
  size(960, 720, P2D);
  frameRate(30); // it should work fine up to 60 fps
      
      
      
      
  /* ===== ANIMATION LIST: ===== */
  
  /* use keyboard arrows to jump between algorithms */
  
  
  
  
  
  /* DEMOS */
  
  String[] scenes = {
    "counters",
    "blinks",
    "noiseX",
    "noiseY",
    "rain",
    "wave1",
    "wave2",
    "grid",
    "sin",
    "bacteria",
    "cell",
    "worm",
    "terrain",
    "gameoflife",
    "fingerprint",
    "3d"
  };
  
  for(int i=0; i<scenes.length; i++) {
    addToList(scenes[i], 320);
    addToList("clear", 24);
  }
  
  
  
  /* WORD */  
  
  //addToList("typewriter", 80);  
  
  
  
  /* JUKEBOX */  
  
  //addToList("music", 256); // dedicated for 4 cols and 5 rows
  
  
  
  
  
  /* SNAKE */
  
  //addToList("full", 3);
  //addToList("clear", 24);  
  //addToList("writeCenter", 6,  "s    ");
  //addToList("writeCenter", 6,  "sn   ");
  //addToList("writeCenter", 6,  "sna  ");
  //addToList("writeCenter", 6,  "snak ");
  //addToList("writeCenter", 30, "snake");
  //addToList("clear", 20);
  //addToList("snake", 10000);
  //addToList("clear", 10);
  
  
  
  
  
  /* FONTS */
  
  //for(int i=1; i<=10; i++) {
  //  addToList("writeCenter", 12, str(i%10));
  //}
  //addToList("clear", 24);
  
  //for(int i=2; i<=5; i++) {
  //  for(int j=1; j<=10; j++) {
  //    addToList("image", 12, "fonts/"+i+"/"+j%10+".png");
  //  }
  //  addToList("clear", 24);
  //}
  //addToList("clear", 100);
      
      
      
  
  /* CAPTURE */
  
  //addToList("movieDithering", 500, "szdk.mp4");
  //addToList("cam", 500);
  //addToList("syphonDither", 500);
  //addToList("kinect", 500);
   
   
   
  
  
  
}


void draw() {
  
  if(frameCount==1) {
          
    if(senddataOn) {
      setDisplay();
    }
    
    if(kinectOn) {
      kinect = new Kinect(this);
      kinect.initDepth();
      kinectAngle = kinect.getTilt();
      kinectImg = new PImage(kinect.width, kinect.height);
    }
  
    if(cameraOn) {
      String[] cameras = Capture.list();
      //println(cameras);
      cam = new Capture(this, cameras[6]);
      cam.start();
    }    
    
    if(syphonOn) {
      client = new SyphonClient(this);
    }
    
    initFormats(); 
    loadImages();
    loadAlphabet();
    if(controllerOn) setController();
    addToList("", 0);
    tstart = millis();
    
  } else {
  
    if(controllerOn) readController();
    
    play();
    
    DISPLAY_to_D_preview();
    DISPLAY_to_T_preview();
    
    showInterface();
    updateDisplay();
    
  }
  
  if(keyPressed) controls();
  
}
