// arranges panels in space aka the final Flipdot Display that hangs somewhere
class FlipdotDisplay {
  int amountPanels;
  Panel[] panels;
  PVector pos;
  int layout;
  
  public FlipdotDisplay(int _amountPanels, int _panelLayout, int x, int y) {
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
          translate(0, i*((flipdotSize+1)*14));
          panels[i].display();
          pop();
        }
      }
    pop();
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
    for(int i = 0; i<amountPanels; i++) {
      panels[i].send();
    }
  }
  
  void setPixel(int panel, int x, int y, boolean b) {
    panels[panel].setPixel(x, y, b);
  }
  
}
