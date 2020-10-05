void keyPressed() {
  //dot.flip();
  //  panel.flip(); // invertiert gerade einfach das display
  if (key == CODED) {
    if (keyCode == LEFT) {
      prevMovieLEDs(this);
    } else if (keyCode == RIGHT) {
      nextMovieLEDs(this);
    } 
  } else if (key == 'o') {
    online = !online;
    println("online= " + online);
    float r[] = {online?1f:0f};
    onlineCheckbox.setArrayValue(r);
  } else if (key == 'd') {
    dither = !dither;
    println("dither= " + dither);
  } else if(key == ' ') {
    isPlaying = !isPlaying;
    println("isPlaying= "+ isPlaying);
    if(isPlaying) ledMovie.play();
    else ledMovie.pause();
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
  
  //pg_t.image(p, 0, 0, pg.width, calcHeight);
  
  //pg_t.image(p, 0, -50, pg.width, 147);
  pg_t.endDraw();
  return pg_t;
} 

void feedBuffer(PImage p) {
  pg.beginDraw();
  pg.image(p, 0, 0);
  pg.endDraw();
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

void feedVideoLEDs(PApplet pa, String s) {
  println("LEDs movie= " + getBasename(s));
  if(ledMovie != null) ledMovie.stop();
  ledMovie = new Movie(pa, s);
  ledMovie.loop();
  ledMovie.volume(movieVolume);
  //myMovie.jump(160.0);}
  //System.gc();
}

void setVolume(float f) {
  ledMovie.volume(f);
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
  followers = getFollowers();
  followerIcon = loadImage("f.png");
  diameter = pg.width - 10;
}
void initObjects(PApplet pa) {
  cp5 = new ControlP5(pa);
  //frameRate(15);
  
  pg = createGraphics(320, 16);
  ledTemp = createGraphics(320, 16);
  
  leds = new SchnickSchnack(maxBrightness);
  d = new Dither();
  d.setCanvas(pg.width, pg.height);
  
  
  importer = new Importer("footage");
  for(int i = 0; i<importer.folders.size(); i++) {
    if(importer.folders.get(i).equals("leds")) {
      importer.loadFiles(importer.folders.get(i));
      for (int j = 0; j <importer.getFiles().size(); j++) {
        ledFiles.append(importer.getFiles().get(j));
      }
    }
  }
  if(ledFiles.size() > 0) feedVideoLEDs(pa, ledFiles.get(currentMovieLEDs));
  
  scrollSource = loadStrings("scroll.txt");
  leaHashtags = loadStrings("leaHashtags.txt");
  String s = bunchTextTogether(scrollSource);
  scrollSource = new String[1];
  scrollSource[0] = s;
  europaGrotesk = loadFont(usedFont);
  float w = textWidth(scrollSource[currentScrollText]);
  scrollPosition = (int)320;
  monoFont = loadFont("04b-25-12.vlw");
  //textFont(monoFont, 12);
  textOverlay = createGraphics(320, 16);
  textOverlay.beginDraw();
  textOverlay.textFont(monoFont, 12);
  textOverlay.textAlign(CENTER, CENTER);
  textOverlay.endDraw();
  
  ledTemp.beginDraw();
  ledTemp.textFont(europaGrotesk, 16);
  ledTemp.textSize(16);
  ledTemp.endDraw();
  
  grid = new Cell[cols][rows];
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      // Initialize each object
      grid[i][j] = new Cell(i*10,j*2,10,2,i+j);
    }
  }
  ca = new CA(ruleset);                 // Initialize CA
  
}

void nextScrollText() {
  currentScrollText++;
  currentScrollText %= scrollSource.length;
  float w = textWidth(scrollSource[currentScrollText]);
  scrollPosition = (int)320;
}

String bunchTextTogether(String[] split) {
  String toSend = "";
  for(int i = 0; i<split.length; i++) {
    toSend += split[i] + " / ";
  }
  return toSend;
  
}

void nextMovieLEDs(PApplet pa) {
  currentMovieLEDs++;
  currentMovieLEDs %= ledFiles.size();
  feedVideoLEDs(pa, ledFiles.get(currentMovieLEDs));
}

void prevMovieLEDs(PApplet pa) {
  currentMovieLEDs--;
  if(currentMovieLEDs < 0) currentMovieLEDs = ledFiles.size()-1;
  feedVideoLEDs(pa, ledFiles.get(currentMovieLEDs));
}

void initArtnet() {
  artnet = new ArtNetClient(null);
  artnet.start();
}
// cp5
void initCP5() {
  stateLabel = cp5.addTextlabel("label2")
  .setText("Next state in: ")
  .setPosition(16, 140)
  ;
    
  onlineCheckbox = cp5.addCheckBox("onlineCheckbox")
  .setPosition(width-100,height-20)
  .setSize(32, 8)
  .addItem("online", 1)
  ;
  
  isPlayingCheckbox = cp5.addCheckBox("isPlayingCheckbox")
  .setPosition(width-100,height-30)
  .setSize(32, 8)
  .addItem("Playing", 1)
  ;
  
  ditherCheckbox = cp5.addCheckBox("ditherCheckbox")
  .setPosition(width-100,height-40)
  .setSize(32, 8)
  .addItem("Dither", 1)
  ;
  
  
  cp5.addSlider("movieVolume")
  .setPosition(8,180)
  .setRange(0f,1f)
  .setLabel("Volume")
  ;
      
  
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

void movieVolume(float theVol) {
  if(state == INTRO) return;
  setVolume(theVol);
}


String getBasename(String s) {
  String[] split = split(s, "/");
  return split[split.length-1];
}

int getFollowers() {
  println("polling followers");
  json = loadJSONObject("https://www.instagram.com/livingthecity.eu/?__a=1");
  int i = json.getJSONObject("graphql").getJSONObject("user").getJSONObject("edge_followed_by").getInt("count");
  return i;
}

String[] pickNewHashtags() {
  //String[] result = {"a", "b"};
  
  int randomRow = (int)random(leaHashtags.length);
  String[] split = split(leaHashtags[randomRow], ";");
  return split;
}

void textOverlay() {
  textOverlay.beginDraw();      
        
  textOverlay.push();
  textOverlay.clear();
  textOverlay.fill(black);
  textOverlay.text(leaResults[0].toUpperCase(), ledTemp.width/4, ledTemp.height/2-1);
  textOverlay.text(leaResults[0].toUpperCase(), ledTemp.width/4, ledTemp.height/2+1);
  textOverlay.text(leaResults[0].toUpperCase(), ledTemp.width/4+1, ledTemp.height/2);
  textOverlay.text(leaResults[0].toUpperCase(), ledTemp.width/4-1, ledTemp.height/2);
  textOverlay.text(leaResults[1].toUpperCase(), ledTemp.width/2+ledTemp.width/4, ledTemp.height/2-1);
  textOverlay.text(leaResults[1].toUpperCase(), ledTemp.width/2+ledTemp.width/4, ledTemp.height/2+1);
  textOverlay.text(leaResults[1].toUpperCase(), ledTemp.width/2+ledTemp.width/4+1, ledTemp.height/2);
  textOverlay.text(leaResults[1].toUpperCase(), ledTemp.width/2+ledTemp.width/4-1, ledTemp.height/2);
  textOverlay.fill(white);
  textOverlay.text(leaResults[0].toUpperCase(), ledTemp.width/4, ledTemp.height/2);
  textOverlay.text(leaResults[1].toUpperCase(), ledTemp.width/2+ledTemp.width/4, ledTemp.height/2);
  textOverlay.pop();
  textOverlay.endDraw();
  //
  ledTemp.beginDraw();
  ledTemp.image(textOverlay, 0, 0);
  ledTemp.endDraw();
}
