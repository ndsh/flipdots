/* for Arduino controller: */

import processing.serial.*;
Serial myPort;
String val;
String[] vals = new String[2];
int scene;
float setting = 0.5;




void keyPressed() {
  
  switch(keyCode) {
    
    case UP:
      dir = 1; // play
      break;
    
    case DOWN: // stop
      dir = 0;
      break;
    
    case LEFT:
      if(currentAnimationId-2>=0) t = animationStart[currentAnimationId-2]+1; // go to previous algorithm
      break;

    case RIGHT:
      if(currentAnimationId+2<animationCounter-1) t = animationStart[currentAnimationId+2]+1; // go to next algorithm
      break;

  }
  
}



void controls() {
  
  switch(keyCode) {
    
    case BACKSPACE: // for "typewriter" algorithm
      int end = typewriting.length()-1;
      if(end<0) end = 0;
      typewriting = typewriting.substring(0, end);
      break;

  }    
}

void keyTyped() {
  if(typewriting.length()<W*H) typewriting += key;
}




void setController()  {
  println(Serial.list());
  String portName = Serial.list()[3];
  myPort = new Serial(this, portName, 9600);
}

void readController() {
  if ( myPort.available() > 0) {
    val = myPort.readStringUntil(10);
    vals = split(val,",");
    if(int(vals[0])==0) {
      scene = int(float(vals[1]))*2-1;
      t = animationStart[scene-1];
    }
    if(int(vals[0])==1) {
      setting = float(vals[1]);
    }
  }
}
