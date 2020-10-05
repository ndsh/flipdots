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
        panels[i].updateFrame(temp);  
      }
    } else if(panelLayout == 1) {
      for(int i = 0; i<amountPanels; i++) {
        temp = p.get(0, 0+(i*14), 28, 14);  
        panels[i].updateFrame(temp);  
      }
    }
    //println(" ");
  }
 
  
  byte[] getData(int i, boolean b) {
    return panels[i].getData(b);
  }
  
  void sendData() {
    for(int i = 0; i<amountPanels; i++) {
      int ungerade = (i*2)+2;
      int gerade = (i*2)+1;
      data = getData(i, true);
      //if(!panels[i].hasChanged(true)) {
      artnet.unicastDmx(ip, 0, gerade, data);
      //}
      data = getData(i, false);
      //if(!panels[i].hasChanged(false)) {
      artnet.unicastDmx(ip, 0, ungerade, data);
      //}
      
    }
  } // neues sendData
  
  void sendData_old() {
    for(int i = 0; i<amountPanels; i++) {
      //data = grabFrame(newFrame, i+1);
      //println(panels[i].hasChanged());
      
      for(int k = 0; k<2; k++) {
        data = getData(i, (k==0?true:false));
        boolean b = k==0?true:false;
        if(!panels[i].hasChanged(b)) {   
          //println(data);
          println("send to: " + ((i+1)*(k+1)));
          //artnet.unicastDmx(ip, 0, ((i+1)*(k+1)), data);
          //print("i=" + i +" ");
          for(int f = 0; f<data.length; f++) {
            //print(data[f] + " ");
          }
          //println(" ");  
        }
      }
      
      
    }
    //println("--------------");
    //println(" ");
    //hasChanged
  } // altes sendData
}
