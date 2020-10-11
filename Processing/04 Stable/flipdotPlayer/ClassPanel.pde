class Panel {
  // 28x14 dots
  PGraphics pg;
  int panelID = 0;
  Dot[][] dots = new Dot[28][14];
  PVector pos;
  byte[] dataUp = new byte[28];
  byte[] dataDown = new byte[28];
  byte[] previousDataUp = new byte[28];
  byte[] previousDataDown = new byte[28];
  PImage currentFrame; 
  boolean changeUp = false;
  boolean changeDown = false;
  int upBits = 0;
  int downBits = 0;
  boolean showIndicators = false;
  
  public Panel(int id, int _x, int _y) {
    panelID = id;
    pos = new PVector(_x, _y);
    for(int x = 0; x<28; x++) {
      for(int y = 0; y<14; y++) {
        dots[x][y] = new Dot(int(flipdotSize+1.0f)*x, int(flipdotSize+1.0f)*y);
      }
    } 
  }
  
  void update() {
    copyPreviousData("up");
    copyPreviousData("down");
    dataUp = pixelsToByteArray(0, 7);
    dataDown = pixelsToByteArray(7, 14);
    changeUp = sameArray(previousDataUp, dataUp);
    changeDown = sameArray(previousDataDown, dataDown);
    
    
    // update visuals on flipdots
    for(int x = 0; x<28; x++) {
      for(int y = 0; y<14; y++) {
        dots[x][y].update();
      }
    }
  }
  
  void display() {
    push();
    translate(pos.x, pos.y);
    
    if(showIndicators) {
      push();
      noStroke();
      
      if(!changeUp) fill(white);
      else fill(black);
      if(panelLayout == 0) {
        rect(-(flipdotSize/2), 70, 28*(flipdotSize+1)-2, 1*(flipdotSize+1));
      } else if(panelLayout == 1) {
        //rect(140, -2, 27, 7*(flipdotSize+1)-2);
        ellipse(150, 13, 5, 5);
      }
      pop();
      
      push();
      noStroke();
      if(!changeDown) fill(white);
      else fill(black);
      if(panelLayout == 0) {
        rect(-(flipdotSize/2), 72+(1*(flipdotSize+1)), 28*(flipdotSize+1)-2, 1*(flipdotSize+1));
      } else if(panelLayout == 1) {
        //rect(140, 7*(flipdotSize+1)-2, 27, 7*(flipdotSize+1)-2);
        ellipse(150, 7*(flipdotSize+1.0f)+5, 5, 5);
      } 
      
      pop();
    }
    
    for(int x = 0; x<28; x++) {
      for(int y = 0; y<14; y++) {
        dots[x][y].display();
      }
    }
    pop();
  }
  
  void updateFrame(PImage p) {
    changeUp = sameArray(previousDataUp, dataUp);
    changeDown = sameArray(previousDataDown, dataDown);
    feed(p);
  }
  
  void feed(PImage p) {
    currentFrame = p.copy();
    currentFrame.loadPixels();
    color c = 0;
    boolean state = false;
    for(int x = 0; x<28; x++) {
      for(int y = 0; y<14; y++) {
        c = currentFrame.pixels[y*28+x];
        //println(brightness(c));
        if(brightness(c) >= 50) state = true;
        else state = false;
        dots[x][y].flip(state);
      }
    }
  }
  
  void setPixel(int x, int y, boolean b) {
    dots[x][y].flip(b);
  }
  
  int getPanelID() {
    return panelID;
  }
  
  void copyPreviousData(String s) {
    if(s.equals("up")) {
      arrayCopy(dataUp, previousDataUp);
    } else if(s.equals("down")) {
      arrayCopy(dataDown, previousDataDown);
    }
    
  }
  
  byte[] pixelsToByteArray(int y_start, int y_end) {
    byte[] data = new byte[28];
    currentFrame.loadPixels();
    for(int x = 0; x<28; x++) {
      toSend = "";
      for(int y = y_start; y<y_end; y++) {
        //pixel = currentFrame.get(x, y);
        pixel = currentFrame.pixels[y*28+x];
        if(brightness(pixel) > 50.0) {
          toSend = 1 + toSend;
          bytesSent++;
        } else toSend = 0 + toSend;
      }
      data[x] = (byte) unbinary(toSend);
    }
    return data;
  }
  
  /*
  byte[] getData(boolean b) {
    int y_start = 0;
    int y_end = 7;
    if(b) {
      arrayCopy(dataUp, previousDataUp);
      y_start = 0;
      y_end = 7;
    } else {
      arrayCopy(dataDown, previousDataDown);
      y_start = 7;
      y_end = 14;
    }
    
    data = new byte[28];
    
    //if(panelID == 1) image(currentFrame, 40, 40);
    currentFrame.loadPixels();
    for(int x = 0; x<28; x++) {
      toSend = "";
      for(int y = y_start; y<y_end; y++) {
        pixel = currentFrame.get(x, y);
        if(brightness(pixel) > 50.0) toSend = 1 + toSend;
        else toSend = 0 + toSend;
      }
      data[x] = (byte) unbinary(toSend);
    }
   
    return data;
  }
  */
  
  boolean sameArray(byte[] a, byte[] b) {
    
    boolean result = true;
    for(int i = 0; i<a.length; i++) {
      if(a[i] != b[i]) {
        result = false;
        break;
      }
    }
    return result;
  }
  
  void send() {
    // set universe
    //println(panelID + " --- " + (panelID+1));
    int[][] panelHalves = {{1,2}, {3,4}, {5,6}, {7,8}, {9,10}, {11,12}, {13,14} };
    //int first 
    if(changeUp); 
    artnet.unicastDmx(ip, 0, panelHalves[panelID-1][0], dataUp);
    if(changeDown); 
    artnet.unicastDmx(ip, 0, panelHalves[panelID-1][1], dataDown);
  }
  
  void flip() { // eigentlich "invert"
    for(int x = 0; x<28; x++) {
      for(int y = 0; y<14; y++) {
        dots[x][y].flip();
      }
    }
  }
  
  byte[][] getData() {
    byte[][] result = {dataUp, dataDown};
    return result;
  }
  
  boolean[] getChangeIndicator() {
    boolean[] result = {changeUp, changeDown};
    return result;
  }
  
  // BEGIN DOT CLASS
  class Dot {
    boolean state = false;
    boolean animate = false;
    PVector pos = new PVector(0, 0);
    float size = flipdotSize;
    float rotation;
    float increment;
    long timestamp = 0;
    
    public Dot() {
      rotation = size*1;
      increment = size/3;
    }
    
    public Dot(int x, int y) {
      rotation = size*1;
      increment = size/1.1;
      pos = new PVector(x, y);
    }
    
    void update() {
      if(animate) {
        if(state) {
          rotation += increment;
          if(rotation >= size) {
            animate = false;
            rotation = size;
          }
        } else {
            rotation -= increment;
            if(rotation < (size*-1)) {
              rotation = (size*-1);
              animate = false;
            }
        }
      }
    }
    
    void display() {
      push();
      noStroke();
      
      if(state) fill(0, 0, 100);
      else fill(0);
      translate(pos.x, pos.y);
      
      rotate(radians(-45));
      ellipse(0, 0, size, rotation);
      pop();
    }
    
    void flip() {
      state = !state;
      animate = true;
    }
    
    void flip(boolean b) {
      if(b != state) animate = true; 
      state = b;
      
    }
    
    
  }
  // END DOT CLASS
  
}
