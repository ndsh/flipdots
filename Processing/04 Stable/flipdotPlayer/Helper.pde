void keyPressed() {
  if (key == CODED) {
    if (keyCode == LEFT) {
      prevMovie(this);
    } else if (keyCode == RIGHT) {
      nextMovie(this);
    } 
  } else if (key == 'o') {
    online = !online;
    println("online= " + online);
    float r[] = {online?1f:0f};
    onlineCheckbox.setArrayValue(r);
  } else if (key == 'd') {
    dither = !dither;
    println("dither= " + dither);
    float r[] = {dither?1f:0f};
    ditherCheckbox.setArrayValue(r);
  } else if (key == 's') {
    stretchMode = !stretchMode;
    println("stretchMode= " + stretchMode);
    float r[] = {stretchMode?1f:0f};
    stretchModeCheckbox.setArrayValue(r);
  
  } else if(key == ' ') {
    isPlaying = !isPlaying;
    println("isPlaying= "+ isPlaying);
    if(isPlaying) myMovie.play();
    else myMovie.pause();
    float r[] = {isPlaying?1f:0f};
    isPlayingCheckbox.setArrayValue(r);
    
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


boolean compareImages(PImage one, PImage two) {
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
      //pixel = p.get(x, y);
      pixel = p.pixels[y*28+x];
      if(brightness(pixel) > 50.0) toSend = 1 + toSend;
      else toSend = 0 + toSend;
    }
    data[x] = (byte) unbinary(toSend);
  }
  
  return data;
}

void feedVideo(PApplet pa, String s) {
  println("Flipdots movie= " + getBasename(s));
  
  if(myMovie != null) myMovie.stop();
  myMovie = new Movie(pa, s);
  myMovie.loop();
  myMovie.volume(movieVolume);
  //myMovie.jump(160.0);}
  System.gc();
  if(fileLabel != null) fileLabel.setText("File: " + getBasename(s));
}

void setVolume(float f) {
  myMovie.volume(f);
}

void runInits(PApplet pa) {
  initObjects(pa);
  initVariables();
  initArtnet();
  initCP5();
  
  importerLabel.setText("Importer\nSequences: " + importer.getFiles().size() + " loaded\n--------------------");
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
  
  flipdots = new FlipdotDisplay(panels, panelLayout, w6*3+3+30, h24+3+22);
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
  font = loadFont("04b-25-12.vlw");
  textFont(font, 12);
  textOverlay = createGraphics(28, 98);
  textOverlay.beginDraw();
  textOverlay.textFont(font, 12);
  textOverlay.textAlign(CENTER, CENTER);
  textOverlay.endDraw();
  
  sendDataViz = createGraphics((int)(w3*2+w6), (int)h12);
  sendDataViz.beginDraw();
  sendDataViz.fill(white);
  sendDataViz.endDraw();
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
   overviewLabel = cp5.addTextlabel("overviewLabel")
  .setText("Overview")
  .setPosition(10,10)
  ;
  
  importerLabel = cp5.addTextlabel("importerLabel")
  .setText("Hello")
  .setPosition(10,h24+10)
  ;
  
  movieTimeLabel = cp5.addTextlabel("movieTimeLabel")
  .setText("Movie Time")
  .setPosition(10,h3*2-15)
  ;
  movieTimeRestLabel = cp5.addTextlabel("movieTimeRestLabel")
  .setText("200 secs left")
  .setPosition(10,h3*2+15)
  ;
  movieTimePercentageLabel = cp5.addTextlabel("movieTimePercentageLabel")
  .setText("0%")
  .setPosition(10+w6-60,h3*2)
  ;
  

  stateLabel = cp5.addTextlabel("label2")
  .setText("StateMachine\n")
  .setPosition(10,h24+10+h12)
  ;
  dynamicLabel = cp5.addTextlabel("dynamicLabel")
  .setText("FPS")
  .setPosition(w6+10, h24+h6+h3+10)
  ;
  fileLabel = cp5.addTextlabel("label3")
  .setText("File: ")
  .setPosition(w6+10, h24+h6+h3+h6+10)
  .setHeight(40)
  ;
  currentBytesLabel = cp5.addTextlabel("currentBytesLabel")
  .setText("Current: ")
  .setPosition(w3*2+w6+10, h3+h3+h6+h12+10)
  .setHeight(40)
  .setColorBackground(black)
  ;
  
  stateVisualOutputLabel = cp5.addTextlabel("stateVisualOutputLabel")
  .setText("State Visual Output")
  .setPosition(w6+10, 0+10)
  .setHeight(40)
  .setColorBackground(black)
  ;
  
  sourceFlipdotsLabel = cp5.addTextlabel("sourceFlipdotsLabel")
  .setText("Source Flipdots")
  .setPosition(w6*2+10, 0+10)
  .setHeight(40)
  .setColorBackground(black)
  ;
  
  virtualFlipdotsLabel = cp5.addTextlabel("virtualFlipdotsLabel")
  .setText("Source Flipdots")
  .setPosition(w6*3+10, 0+10)
  .setHeight(40)
  .setColorBackground(black)
  ;
  
  consoleLabel = cp5.addTextlabel("consoleLabel")
  .setText("Source Console")
  .setPosition(w6*4+10, 0+10)
  .setHeight(40)
  .setColorBackground(black)
  ;
  
  stateControlLabel = cp5.addTextlabel("stateControlLabel")
  .setText("State Control")
  .setPosition(0+10,h24*2+h12*8+10)
  .setHeight(40)
  .setColorBackground(black)
  ;
  
  panelActivityLabel = cp5.addTextlabel("panelActivityLabel")
  .setText("Panel Activity")
  .setPosition(w6*1+10, h3+h3+h6+10)
  .setHeight(40)
  .setColorBackground(black)
  ;
  
  
  networkLabel = cp5.addTextlabel("networkLabel")
  .setText("Network")
  .setPosition(w6*4+10, h24+h3+h8+10)
  .setHeight(40)
  .setColorBackground(black)
  ;
  
  onlineCheckbox = cp5.addCheckBox("onlineCheckbox")
  .setPosition(w3*2+w6+10, h3+h3+h6+10)
  .setSize(32, 8)
  .addItem("Send Data", 1)
  ;
  
  isPlayingCheckbox = cp5.addCheckBox("isPlayingCheckbox")
  .setPosition(10, h24*3+h12*8+10)
  .setSize(32, 8)
  .addItem("Playing", 1)
  ;
  
  ditherCheckbox = cp5.addCheckBox("ditherCheckbox")
  .setPosition(w6+w6/4, h24+h6+h6/4)
  .setSize(32, 8)
  .addItem("Dither", 1)
  ;
  stretchModeCheckbox = cp5.addCheckBox("stretchModeCheckbox")
  .setPosition(w6+10, h24+h6+h12+h6+10)
  .setSize(32, 8)
  .addItem("Stretch", 1)
  ;
  
  if(panelLayout == 0) {
    cp5.addSlider("movieVolume")
    .setPosition(8,180)
    .setRange(0f,1f)
    .setLabel("Volume")
    ;
  } else if(panelLayout == 1) {
    cp5.addSlider("movieVolume")
    .setPosition(10,height-190)
    .setRange(0f,1f)
    .setLabel("Volume")
    ;
  }    
  
  cp5.setColorForeground(gray);
  cp5.setColorBackground(black);
  cp5.setColorActive(white);
}
void onlineCheckbox(float[] a) {
  if(state == INTRO) return;
  if (a[0] == 1f) online = true;
  else online = false;
  println("online: " + online);
}

void isPlayingCheckbox(float[] a) {
  if(state == INTRO) return;
  if (a[0] == 1f) isPlaying = true;
  else isPlaying = false;
  println("isPlaying: " + isPlaying);
}
void ditherCheckbox(float[] a) {
  if(state == INTRO) return;
  if (a[0] == 1f) dither = true;
  else dither = false;
  println("dither: " + dither);
}
void stretchModeCheckbox(float[] a) {
  if(state == INTRO) return;
  if (a[0] == 1f) stretchMode = true;
  else stretchMode = false;
  println("stretchMode: " + stretchMode);
}

void movieVolume(float theVol) {
  if(state == INTRO) return;
  setVolume(theVol);
}

String getBasename(String s) {
  String[] split = split(s, "/");
  String out = truncate(split[split.length-1], 36);
  return out;
}

String truncate(String s, int n){
  return (s.length() > n) ? s.substring(0, n-1) + "..." : s;
};

void drawUserInterface() {
  // grid stuff, erstmal hier. später in variables
  
  push();
  noFill();
  //background(0);
  stroke(white);
    // #### column 1
    rect(0,0,w6, h24); // overview
    rect(0,h24,w6, h24+h12*8); // overview content
    rect(0,h24*2+h12*8,w6, h24); // state control label
    rect(0, h24*3+h12*8, w6, h24); // play/pause state
    rect(0,h24*4+h12*8,w6, h24); // force state
    rect(0,h24*5+h12*8,w6, h12+h24); // left / right buttons for states
    
    // #### column 2
    rect(w6, 0, w6, h24); // state visual output
    rect(w6, h24, w6, h6); // pimage
    rect(w6, h24+h6, w6, h12); // dither options
    rect(w6, h24+h6+h12, w6, h6); // dither preview, if activated
    rect(w6, h24+h6+h12+h6, w6, h24); // stretch options
    rect(w6, h24+h6+h12+h6+h24, w6, h24); // dynamic information label
    rect(w6, h24+h6+h12+h6+h24+h24, w6, h6+h12+h24); // dynamic information content
    
    
    // #### column 3
    rect(w6*2, 0, w6, h24); // source flipdots
    rect(w6*2, h24, w6, h2+h4+h24); // source object outputs
    
    // #### column 4
    rect(w6*3, 0, w6, h24); // virtual flipdots
    rect(w6*3, h24, w6, h2+h4+h24); // virtual flipdots outputs
    
    // #### column 5
    rect(w6*4, 0, w3, h24); // console
    rect(w6*4, h24, w3, h3+h8); // console content
    rect(w6*4, h24+h3+h8, w3, h24); // network
    rect(w6*4, h24+h3+h8, w3, h4+h12); // network
    
    // #### row 1
    rect(w6*1, h3+h3+h6, w3*2+w6, h24); // panel activity
    rect(w3*2+w6, h3+h3+h6, w6, h24); // send data button
    rect(w6*1, h3+h3+h6+h24, w3*2+w6, h24); // panel outputs
    rect(w6*1, h3+h3+h6+h12, w3*2, h12); // total output, history
    rect(w3*2+w6, h3+h3+h6+h12, w6, h12); // current output
    stroke(white);
    rect(0,0,width-1, height-1);
  pop();
}

void updateLabels() {
  dynamicLabel.setText("FPS: " + frameRate +"\nBytes sent: " + bytesTotal +" bytes\nSending to: " + ip);
}
