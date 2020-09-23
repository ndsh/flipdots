void keyPressed() {
  //dot.flip();
  //  panel.flip(); // invertiert gerade einfach das display
  if (key == CODED) {
    if (keyCode == LEFT) {
      prevMovie(this);
    } else if (keyCode == RIGHT) {
      nextMovie(this);
    } 
  } else if (key == 'o') {
    online = !online;
    println("online= " + online);
  } else if (key == 'd') {
    dither = !dither;
    println("dither= " + dither);
  } else if(key == ' ') {
    isPlaying = !isPlaying;
    println("isPlaying= "+ isPlaying);
    if(isPlaying) myMovie.play();
    else myMovie.pause();
  }
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
/*
void movieEvent(Movie m) {
  m.read();
}
*/

PImage shrinkToFormat(PImage p) {
  //float[] aspectRatio = calculateAspectRatioFit(pg.width, pg.height, 196, 34);
  PGraphics pg_t = createGraphics(pg.width, pg.height);
  pg_t.beginDraw();
  int calcHeight = 0;
  int calcWidth = 0;
  if(panelLayout == 0) calcHeight = (pg.width*p.height)/p.width;
  else if(panelLayout == 1) calcWidth = (pg.height*p.width)/p.height;
  //pg_t.image(p, 0, 0, pg.width, calcHeight);
  if(panelLayout == 0) pg_t.image(p, 0, map(mouseY, 0, height, 0, -calcHeight), pg.width, 147);
  else if(panelLayout == 1)  pg_t.image(p, map(mouseX, 0, width, 0, -calcWidth), 0, calcWidth, pg.height);
  //pg_t.image(p, 0, -50, pg.width, 147);
  pg_t.endDraw();
  return pg_t;
} 

void feedBuffer(PImage p) {
  pg.beginDraw();
  pg.image(p, 0, 0);
  pg.endDraw();
}

void send() {
  if(online) {
    flipdots.sendData();
  }
}


boolean compareFrames(PImage one, PImage two) {
  one.loadPixels();
  two.loadPixels();
  for (int i = 0; i < one.pixels.length; i++) {
    color c1 = one.pixels[i];
    color c2 = two.pixels[i];
    if (isSame(c1, c2)) return true;
  }
  //println("-------");
  return false;
} 

boolean isSame(color c1, color c2) {
  float r1 = hue(c1);
  float b1 = saturation(c1);
  float g1 = brightness(c1);
   
  float r2 = hue(c2);
  float b2 = saturation(c2);
  float g2 = brightness(c2);
  return r1 == r2 && b1 ==b2 && g1 == g2;
}

float[] calculateAspectRatioFit(float srcWidth, float srcHeight, float maxWidth, float maxHeight) {
  //float[] result;
  float ratio = Math.min(maxWidth / srcWidth, maxHeight / srcHeight);
  float result[] = {srcWidth*ratio, srcHeight*ratio};
  //return { width: srcWidth*ratio, height: srcHeight*ratio };
  return result;
}
 
byte[] grabFrame(PImage p, int panel) {
  byte[] data = new byte[28]; // 28 columns of 8 bit data, MSB ignored
  int y_start = 0;
  int y_end = 7;
  if(panel % 2 == 0) {
    y_start = 7;
    y_end = 14;
  }
  
  p.loadPixels();
  for(int x = 0; x<28; x++) {
    toSend = "";
    for(int y = y_start; y<y_end; y++) {
      pixel = p.get(x, y);
      if(brightness(pixel) > 50.0) toSend = 1 + toSend;
      else toSend = 0 + toSend;
    }
    data[x] = (byte) unbinary(toSend);
  }
  
  return data;
}

void feedVideo(PApplet pa, String s) {
  if(myMovie != null) myMovie.stop();
  myMovie = new Movie(pa, s);
  myMovie.loop();
  myMovie.volume(movieVolume);
  //myMovie.jump(160.0);}
  System.gc();
}

void setVolume(float f) {
  myMovie.volume(f);
}

void runInits(PApplet pa) {
  initObjects(pa);
  initVariables();
  initArtnet();
  initCP5();
}

void initVariables() {
  black = color(0, 0, 0);
  white = color(0, 0, 100);
  gray = color(90);
}
void initObjects(PApplet pa) {
  cp5 = new ControlP5(pa);
  //frameRate(15);
  if(panelLayout == 0) pg = createGraphics(196, 14); // 2744 pixel
  else if(panelLayout  == 1) pg = createGraphics(28, 98); // 2744 pixels
  
  flipdots = new FlipdotDisplay(panels, panelLayout, 10, 10);
  d = new Dither();
  d.setCanvas(pg.width, pg.height);
  
  importer = new Importer("footage");
  for(int i = 0; i<importer.folders.size(); i++) {
    if(importer.folders.get(i).equals("sequences")) {
      importer.loadFiles(importer.folders.get(i));
      for (int j = 0; j <importer.getFiles().size(); j++) {   
        movieFiles.append(importer.getFiles().get(j));
      }
    }
  }
  if(movieFiles.size() > 0) feedVideo(pa, movieFiles.get(currentMovie)); 
  
}

void nextMovie(PApplet pa) {
  currentMovie++;
  currentMovie %= movieFiles.size();
  feedVideo(pa, movieFiles.get(currentMovie));
}

void prevMovie(PApplet pa) {
  currentMovie--;
  if(currentMovie < 0) currentMovie = movieFiles.size()-1;
  feedVideo(pa, movieFiles.get(currentMovie));
}

void initArtnet() {
  artnet = new ArtNetClient(null);
  artnet.start();
}
// cp5
void initCP5() {
  cp5.addToggle("onlineButton")
  .setPosition(width-50,height-20)
  .setSize(50,20)
  .setValue(online)
  .setLabel("Online")
  ;
  
  if(panelLayout == 0) {
    cp5.addSlider("movieVolume")
    .setPosition(8,180)
    .setRange(0f,1f)
    .setLabel("Volume")
    ;
  } else if(panelLayout == 1) {
    cp5.addSlider("movieVolume")
    .setPosition(300,8)
    .setRange(0f,1f)
    .setLabel("Volume")
    ;
  }    
  
  cp5.setColorForeground(gray);
  cp5.setColorBackground(black);
  cp5.setColorActive(white);
}
void onlineButton(boolean theFlag) {
  if(state == INTRO) return; 
  if(theFlag==true) {
    online = true;
  } else {
    online = false;
  }
  println("online: " + online);
}

void movieVolume(float theVol) {
  if(state == INTRO) return;
  setVolume(theVol);
}
