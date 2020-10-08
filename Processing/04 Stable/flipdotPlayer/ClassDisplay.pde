// arranges panels in space aka the final Flipdot Display that hangs somewhere
class FlipdotDisplay {
  int amountPanels;
  Panel[] panels;
  PVector pos;
  int layout;
  PGraphics pg;
  
  public FlipdotDisplay(int _amountPanels, int _panelLayout, int x, int y) {
    pos = new PVector(x, y);
    amountPanels = _amountPanels;
    panels = new Panel[amountPanels];
    layout = _panelLayout;
    for(int i = 0; i<amountPanels; i++) {
      panels[i] = new Panel(i+1, 0, 0);  
    }
  }
  
  public FlipdotDisplay(int _amountPanels, int _panelLayout, float x, float y) {
    pos = new PVector(x, y);
    amountPanels = _amountPanels;
    panels = new Panel[amountPanels];
    layout = _panelLayout;
    for(int i = 0; i<amountPanels; i++) {
      panels[i] = new Panel(i+1, 0, 0);  
    }
  }
  
  void update() {
    for(int i = 0; i<amountPanels; i++) {
      panels[i].update();  
    }
  }
  
  void display() {
    push();
      if(layout == 0) {
        translate(pos.x, pos.y);
        for(int i = 0; i<amountPanels; i++) {
          push();
          translate(i*((flipdotSize+1)*28), 0);
          panels[i].display();
          pop();
        }
      } else if(layout == 1) {       
        translate(pos.x, pos.y);
        for(int i = 0; i<amountPanels; i++) {
          push();
          //translate(0, i*((flipdotSize+1)*14));
          translate(0, i*((flipdotSize+0.06)*14));
          panels[i].display();
          pop();
        }
      }
    pop();
    displayIndicator();
  }
  
  void feed(PImage p) {
    PImage temp; 
    if(panelLayout  == 0) {
      for(int i = 0; i<amountPanels; i++) {
        temp = p.get(0+(i*28), 0, 28, 14);  
        panels[i].feed(temp);  
      }
    } else if(panelLayout == 1) {
      for(int i = 0; i<amountPanels; i++) {
        temp = p.get(0, 0+(i*14), 28, 14);  
        panels[i].feed(temp);  
      }
    }

  }
 /*
  byte[] getData(int i, boolean b) {
    return panels[i].getData(b);
  }
  */
  
  void send() {
    byte[][] retrieve = new byte[7][2];
    if(!sendMode) { // single packages
      for(int i = 0; i<amountPanels; i++) {
        panels[i].send();
      }
    } else { // big package of 392 bytes
      flipdotData = new byte[392];
      int c = 0;
      for(int i = 0; i<amountPanels; i++) {
        retrieve = panels[i].getData();
        for(int k = 0; k<retrieve[0].length; k++) {
          flipdotData[c] = retrieve[0][k];
          c++;
        }
        for(int k = 0; k<retrieve[1].length; k++) {
          flipdotData[c] = retrieve[1][k];
          c++;
        }
      }
      if(online) artnet.unicastDmx(ip, 0, 0, flipdotData);
      // send off
      bytesSent /= 7;
      currentBytesLabel.setText("Currently sending: " + bytesSent +" bytes");
      displaySendViz(bytesSent);
      bytesTotal += bytesSent;
      bytesSent = 0;
    }
  }
  
  void displaySendViz(int i) {
    PImage temp;
    float dataHeight = map(i, 0, 392, h12-4, 0); 
    temp = sendDataViz.copy();
    sendDataViz.beginDraw();
    sendDataViz.clear();
    sendDataViz.stroke(white);
    sendDataViz.image(temp, -1, 0);
    sendDataViz.rect(sendDataViz.width-1, dataHeight, 1,1);
    sendDataViz.endDraw();
    
    image(sendDataViz, w6*1, h3+h3+h6+h12);
  }
  
  void setPixel(int panel, int x, int y, boolean b) {
    panels[panel].setPixel(x, y, b);
  }
  
  void displayIndicator() {
    push();
      float indicatorWidth = (w3*2+w6)/14;
      translate(w6*1, h3+h3+h6+h24);
      noFill();
      stroke(white);
      int panel = 0;
      for(int i = 0; i<14; i++) {
        if(i % 2 == 1 && i < 7) {
            if(panels[i].getChangeIndicator()[1] == false) fill(white);
            else fill(black);
          } else if((i % 2 == 0) && i < 7){
            if(panels[i].getChangeIndicator()[0] == false) fill(white);
            else fill(black);
          }
          rect(indicatorWidth*i, 0, indicatorWidth, h24);
          panel = (int)i/2;
      } 
    pop();
  }
}
