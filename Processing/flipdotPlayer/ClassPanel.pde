class Panel {
  // 28x14 dots
  int panelID = 0;
  Dot[][] dots = new Dot[28][14];
  PVector pos;
  byte[] data = new byte[28];
  byte[] previousDataUp = new byte[28];
  byte[] previousDataDown = new byte[28];
  PImage currentFrame; 
  boolean changeUp = false;
  boolean changeDown = false;
  
  public Panel(int id, int _x, int _y) {
    panelID = id;
    pos = new PVector(_x, _y);
    for(int x = 0; x<28; x++) {
      for(int y = 0; y<14; y++) {
        dots[x][y] = new Dot(int(flipdotSize+1)*x, int(flipdotSize+1)*y);
      }
    } 
  }
  
  void update() {
    for(int x = 0; x<28; x++) {
      for(int y = 0; y<14; y++) {
        dots[x][y].update();
      }
    }
  }
  
  void display() {
    push();
    translate(pos.x, pos.y);
    
    push();
    noStroke();
    
    if(changeUp) fill(black);
    else fill(white);
    rect(-(flipdotSize/2), 70, 28*(flipdotSize+1)-2, 1*(flipdotSize+1));
    pop();
    
    push();
    noStroke();
    if(changeDown) fill(black);
    else fill(white);
    rect(-(flipdotSize/2), 72+(1*(flipdotSize+1)), 28*(flipdotSize+1)-2, 1*(flipdotSize+1));
    
    pop();
    /*
    push();
    stroke(background);
    strokeWeight(2);
    line(-(flipdotSize/2), 70, -(flipdotSize/2), 80);
    line(-(flipdotSize/2)+28*(flipdotSize+1), 70, -(flipdotSize/2)+28*(flipdotSize+1), 80);
    pop();
    */
    
    for(int x = 0; x<28; x++) {
      for(int y = 0; y<14; y++) {
        dots[x][y].display();
      }
    }
    pop();
  }
  
  void flip() { // eigentlich "invert"
    for(int x = 0; x<28; x++) {
      for(int y = 0; y<14; y++) {
        dots[x][y].flip();
      }
    }
  }
  
  void updateFrame(PImage p) {
    /*
    if(oldFrame != null) {
      change = compareFrames(oldFrame, p);
      print(getPanelID() + ": " + compareFrames(oldFrame, p) + " ");
    }
    */
    //oldFrame = p.copy();
    //println("panel=" + panelID + " " + compareFrames());
    changeUp = compareFrames(true);
    changeDown = compareFrames(false);
    feed(p);
    
  }
  
  void feed(PImage p) {
    //if(oldFrame != null) if(!isFrameSame(oldFrame, newFrame)) println("n");
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
  
  int getPanelID() {
    return panelID;
  }
  
  
  byte[] getData(boolean b) {
    int y_start = 0;
    int y_end = 7;
    if(b) {
      arrayCopy(data, previousDataUp);
      y_start = 0;
      y_end = 7;
    } else {
      arrayCopy(data, previousDataDown);
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
  
  boolean compareFrames(boolean b) {
    for(int i = 0; i<data.length; i++) {
      if(b) if(data[i] != previousDataUp[i]) return false;
      if(!b) if(data[i] != previousDataDown[i]) return false;
    } 
    return true;
  }
  
  boolean hasChanged(boolean b) {
    if(b) return changeUp;
    else return changeDown;
  }
  
  
}
