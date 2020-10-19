void keyPressed() {
  if (key == CODED) {
    if (keyCode == LEFT) {
      prevMovie(this);
      playMovie();
    } else if (keyCode == RIGHT) {
      nextMovie(this);
      playMovie();
    } 
  } else if (key == 'o') {
    onlineBang(!online);
  } else if (key == 'd') {
    ditherBang(!dither);
  } else if (key == 's') {
    scaleBang(!scaleMode);
  } else if (key == 'f') {
    forceBang(!forceState);
  } else if (key == 'c') {
    setState(CHECK);
    return;
  } else if(key == ' ') {
    playBang(!isPlaying);
  }
}

void onlineBang(boolean b) {
  online = b;
  //println("online= " + b);
  float r[] = {b?1f:0f};
  onlineCheckbox.setArrayValue(r);
}

void scaleBang(boolean b) {
  scaleMode = b;
  //println("scaleMode= " + b);
  float r[] = {b?1f:0f};
  scaleModeCheckbox.setArrayValue(r);
}

void ditherBang(boolean b) {
  dither = b;
  //println("dither= " + b);
  float r[] = {b?1f:0f};
  ditherCheckbox.setArrayValue(r);
}

void forceBang(boolean b) {
  forceState = b;
  //println("forceState= " + b);
  float r[] = {b?1f:0f};
  forceStateCheckbox.setArrayValue(r);
}

void playBang(boolean b) {
  isPlaying = b;
  //println("isPlaying= "+ b);
  if(isPlaying) myMovie.play();
  else myMovie.pause();
  float r[] = {b?1f:0f};
  isPlayingCheckbox.setArrayValue(r);
}

PImage shrinkToFormat(PImage p) {
  //float[] aspectRatio = calculateAspectRatioFit(pg.width, pg.height, 196, 34);
  PGraphics pg_t = createGraphics(pg.width, pg.height);
  pg_t.beginDraw();
  int calcHeight = 0;
  int calcWidth = 0;
  if(panelLayout == 0) calcHeight = (pg.width*p.height)/p.width;
  else if(panelLayout == 1) calcWidth = (pg.height*p.width)/p.height;
  if(panelLayout == 0) pg_t.image(p, 0, map(mouseY, 0, height, 0, -calcHeight), pg.width, 147);
  else if(panelLayout == 1) {
    if(scaleMode) pg_t.image(p, map(mouseX, 0, width, 0, -calcWidth), 0, calcWidth, pg.height);
    else pg_t.image(p, 0, 0, 28, 98);
    
  }
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

void runInits(PApplet pa) {
  initObjects(pa);
  initVariables();
  initArtnet();
  initCP5();
  initLabels();
}

void initObjects(PApplet pa) {
  cp5 = new ControlP5(pa);
  stateSettings = loadJSONArray("stateSettings.json");
  currentState = stateSettings.getJSONObject(state);
  //frameRate(15);
  if(panelLayout == 0) pg = createGraphics(196, 14); // 2744 pixel
  else if(panelLayout  == 1) pg = createGraphics(28, 98); // 2744 pixels
  
  flipdots = new FlipdotDisplay(panels, panelLayout, w6*3+3+30, h24+3+22);
  d = new Dither();
  d.setCanvas(pg.width, pg.height);
  
  importer = new Importer("footage");
  for(int i = 0; i<importer.folders.size(); i++) {
    if(importer.folders.get(i).equals("sequences3")) {
      importer.loadFiles(importer.folders.get(i));
      for (int j = 0; j <importer.getFiles().size(); j++) {   
        movieFiles.append(importer.getFiles().get(j));
      }
    }
  }
  
  importer = new Importer("footage");
  for(int i = 0; i<importer.folders.size(); i++) {
    if(importer.folders.get(i).equals("transitions2")) {
      importer.loadFiles(importer.folders.get(i));
      for (int j = 0; j <importer.getFiles().size(); j++) {   
        transitionFiles.append(importer.getFiles().get(j));
      }
    }
  }
  
  if(movieFiles.size() > 0) feedVideo(pa, movieFiles.get(currentMovie));
  //font = loadFont("04b-25-12.vlw");
  pixelFontSize = 16;
  font = createFont("fonts/DigitalDisco_16px.ttf", pixelFontSize);
  textFont(font, pixelFontSize);
  textOverlay = createGraphics(28, 98);
  textOverlay.beginDraw();
  textOverlay.textFont(font, pixelFontSize);
  textOverlay.textAlign(CENTER, CENTER);
  textOverlay.endDraw();
  
  temp = createGraphics(28, 98);
  
  sendDataViz = createGraphics((int)(w3*2+w6), (int)h12);
  sendDataViz.beginDraw();
  sendDataViz.fill(white);
  sendDataViz.endDraw();
  
  grid = new PerlinGrid(28, 98);
  
  flipdotWords = loadStrings("flipdotWords.txt");
}

void initVariables() {
  black = color(0, 0, 0);
  white = color(0, 0, 100);
  gray = color(90);
}

void initArtnet() {
  artnet = new ArtNetClient(null);
  artnet.start();
}

void initLabels() {
  importerLabel.setText("IMPORTER\nSEQUENCES: " + movieFiles.size() + " LOADED\nTRANSITIONS: " + transitionFiles.size() + " LOADED\n\n--------------------");
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
  /*if(refreshUI) {
    cp5.setAutoDraw(true);
    refreshUI = false;
  } else cp5.setAutoDraw(false);
  */
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
    line(w6+w12, h24+h6, w6+w12, h24+h6+h12);
    line(w6+w12, h24+h6+h24, w6+w12+w12, h24+h6+h12-h24);
    line(w6+w12+w24, h24+h6, w6+w12+w24, h24+h6+h12);
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
    rect(w6*4, h24+h3+h8, w3, h4+h12); // network content
    
    // #### row 1
    rect(w6*1, h3+h3+h6, w3*2+w6, h24); // panel activity
    rect(w3*2+w6, h3+h3+h6, w6, h24); // send data button
    rect(w6*1, h3+h3+h6+h24, w3*2+w6, h24); // panel outputs
    rect(w6*1, h3+h3+h6+h12, w3*2, h12); // total output, history
    rect(w3*2+w6, h3+h3+h6+h12, w6, h12); // current output
    stroke(white);
    rect(0,0,width-1, height-1); // draw a nice white outline because either processing or mac sucks at drawing windows :)
  pop();
}

void updateLabels() {
  dynamicContentLabel.setText("FPS: " + frameRate +"\nBytes sent: " + bytesTotal +" bytes\nSending to: " + ip);
}

void drawProgessbar(Textlabel percentLabel, Textlabel leftLabel, float current, float duration, float w, float x, float y) {
  push();
    translate(x, y);
    noStroke();
    rect(0, 0, map(current, 0, duration, 0, w6-60), 6);
    float percentage = map(current, 0, duration, 0, 100);
    float restSecs = duration-current;
    percentLabel.setText(nf((int)percentage,2) + "%");
    leftLabel.setText(nf((int)restSecs,2) + " secs left");
    stroke(white);
    line(0,6,w6-60,6);
  pop();
}

void listStates() {
  // currentState.getInt("runtime");
  String out = "";
  /*for(int i = 0; i<stateNames.length; i++) {
    if(i == state) out += "[x] " + stateNames[i].toUpperCase() + "\n";
    else out += "[   ] " + stateNames[i].toUpperCase() + "\n";
  }*/
  for(int i = 0; i<stateSettings.size(); i++) {
    //currentState.getInt("name");
    JSONObject current = stateSettings.getJSONObject(i);
    if(i == state) out += "[x] " + current.getString("name").toUpperCase() + "\n";
    else out += "[   ] " + current.getString("name").toUpperCase() + "\n";
  }
  stateLabel.setText(out);
}

void visualOutput() {
  push();
    source.resize((int)w6, (int)h6);
    if(panelLayout == 0) translate(8, 200);
    else if(panelLayout == 1) translate(w6, h24);
    
    if(scaleMode) image(source, 0, 0);
    else image(source, w6/2-(28/2), h24/2, 28, 98);
  pop();
}

void ditherOutput() {
  if(dither) {
    push();
      if(panelLayout == 0) translate(8, 200);
      else if(panelLayout == 1) translate(w6, h24);
       d.feed(source);
      
      if(scaleMode) image(d.floyd_steinberg(), 0, h6+h12);
      else image(d.floyd_steinberg(), w6/2-(28/2), h6+h12, 28, 98); //image(source, w6/2-(28/2), 0, 28, 98);
    pop();
    
    d.feed(comped);
    //comped = d.floyd_steinberg();
    comped = d.dither();
  } else {
    push();
    if(panelLayout == 0) translate(8, 200);
    else if(panelLayout == 1) translate(w6, h24);
    stroke(white);
    line(0, h6+h12, w6, h6*2+h12);
    line(w6, h6+h12, 0, h6*2+h12);
    //rect(w6, h24+h6+h12, w6, h6); // dither preview, if activated
    pop();
  }
}

void sourceFlipdots() {
  push();
    if(panelLayout == 0) image(pg, 8, 95, width-22, 71);
    else if(panelLayout == 1) image(pg, w6*2+30, h24+22, 140, 490);
    //else if(panelLayout == 1) image(pg, w6*2+23.6605, h24, 152.679, h2+h4+h24);
  pop();
}



// #######################################
// ########## MOVIE SECTION ##############
// #######################################
void feedVideo(PApplet pa, String s) {
  println("Flipdots movie= " + getBasename(s));
  movieFinished = false;
  if(myMovie != null) myMovie.stop();
  myMovie = new Movie(pa, s);
  
  //myMovie.stop();
  // this doesn't work under linux with the movie beta library :(
  /*myMovie = new Movie(pa, s) {
    @ Override public void eosEvent() {
      super.eosEvent();
      myEoS();
    }
  };
  */
  
  //myMovie.loop();
  moviePlaying = false;
  //myMovie.volume(movieVolume);
  //myMovie.jump(160.0);}
  System.gc();
  if(fileLabel != null) fileLabel.setText("File: " + getBasename(s));
}

void playMovie() {
  if(myMovie != null) {
    myMovie.play();
    myMovie.volume(movieVolume);
    moviePlaying = true;
    movieTimestamp = millis();
  }
}
boolean movieFinished() {
  boolean result = false;
  //println(myMovie.time() +" " + myMovie.duration());
  if(myMovie.time() >= myMovie.duration()) {
    //println("11");
    result = true;
  } else if(millis() - movieTimestamp > ((long)myMovie.duration())*1000) {
    //println("22");
    result = true;
  }
  return result;
}

void myEoS() {
  movieFinished = true;
}

void setVolume(float f) {
  myMovie.volume(f);
}

void movieEvent(Movie m) {
  if (m == myMovie) {
    myMovie.read();
  }
}

void movieVolume(float theVol) {
  if(state == INTRO) return;
  setVolume(theVol);
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

void randomTransition(PApplet pa) {
  int r = (int)random(transitionFiles.size());
  feedVideo(pa, transitionFiles.get(r));
}

void randomMovie(PApplet pa) {
  int r = (int)random(movieFiles.size());
  feedVideo(pa, movieFiles.get(r));
}

void randomFlipdotWord() {
  displayText = "";
  int r = (int)random(flipdotWords.length-1);
  displayText = flipdotWords[r];
  int totalTextHeight = displayText.length()*pixelFontSize-(displayText.length()*4);
  
  textOverlay.beginDraw();
  textOverlay.clear();
  textOverlay.fill(black);
  for(int x = -1; x<3; x++) {
    for(int y = -1; y<3; y++) {
      for(int i = 0; i<displayText.length(); i++) {
        textOverlay.text(displayText.charAt(i), textOverlay.width/2+x, textOverlay.height/2+map(i, 0, displayText.length()-1, int(totalTextHeight/2)*-1,  int(totalTextHeight/2))+y);
      }
    }
  }
  textOverlay.fill(white);
  for(int i = 0; i<displayText.length(); i++) {
    textOverlay.text(displayText.charAt(i), textOverlay.width/2, textOverlay.height/2+map(i, 0, displayText.length()-1, int(totalTextHeight/2)*-1,  int(totalTextHeight/2)));
  }
  textOverlay.endDraw();
}

void timeThread() {
  // set threadedState to TIME when something interesting is happening
  if(minute() % 15 == 0) {
    threadedState = TIME;
  }
}

// #######################################
// ##########    CP5   ###################
// #######################################
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
  
  stateTimeLabel = cp5.addTextlabel("stateTimeLabel")
  .setText("Next State")
  .setPosition(10,h3+h6+h12-15)
  ;
  stateTimeRestLabel = cp5.addTextlabel("stateTimeRestLabel")
  .setText("200 secs left")
  .setPosition(10,h3+h6+h12+15)
  ;
  stateTimePercentageLabel = cp5.addTextlabel("stateTimePercentageLabel")
  .setText("0%")
  .setPosition(10+w6-60,h3+h6+h12)
  ;
  

  stateLabel = cp5.addTextlabel("label2")
  .setText("StateMachine\n")
  .setPosition(10,h24+10+h12)
  ;
  inputLabel = cp5.addTextlabel("inputLabel")
  .setText("State Input")
  .setPosition(w6+10, h6+h6+h6+10)
  ;
  dynamicContentLabel = cp5.addTextlabel("dynamicContentLabel")
  .setText("FPS")
  .setPosition(10, h24+h3+10)
  ;
  
  fileLabel = cp5.addTextlabel("fileLabel")
  .setText("File: ")
  .setPosition(10, h3+h12+10)
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
  .setText("Virtual Flipdots")
  .setPosition(w6*3+10, 0+10)
  .setHeight(40)
  .setColorBackground(black)
  ;
  
  consoleLabel = cp5.addTextlabel("consoleLabel")
  .setText("Console")
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
  
  forceStateCheckbox = cp5.addCheckBox("forceStateCheckbox")
  .setPosition(10, h24*3+h12*8+h24+10)
  .setSize(32, 8)
  .addItem("Force State", 1)
  ;
  
  ditherCheckbox = cp5.addCheckBox("ditherCheckbox")
  .setPosition(w6+10, h24+h6+h6/4)
  .setSize(32, 8)
  .addItem("Dither", 1)
  ;
  scaleModeCheckbox = cp5.addCheckBox("scaleModeCheckbox")
  .setPosition(w6+10, h24+h6+h12+h6+10)
  .setSize(32, 8)
  .addItem("Scale", 1)
  ;
  
  cp5.addSlider("movieVolume")
  .setPosition(10,height-190)
  .setRange(0f,1f)
  .setLabel("Volume")
  ;
  
  
  
  cp5.setColorForeground(gray);
  cp5.setColorBackground(black);
  cp5.setColorActive(white);
  
  onlineCheckbox.setArrayValue((online?y:n));
  ditherCheckbox.setArrayValue((dither?y:n));
  isPlayingCheckbox.setArrayValue((isPlaying?y:n));
  forceStateCheckbox.setArrayValue((forceState?y:n));
  scaleModeCheckbox.setArrayValue((scaleMode?y:n));
  
  
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
void scaleModeCheckbox(float[] a) {
  if(state == INTRO) return;
  if (a[0] == 1f) scaleMode = true;
  else scaleMode = false;
  println("scaleMode: " + scaleMode);
}
