void keyPressed() {
  if (key == CODED) {
    if (keyCode == LEFT) {
      
    } else if (keyCode == RIGHT) {
      
    } 
  } else if (key == 'm') {
    receptionMode = !receptionMode;
    println("receptionMode= " + receptionMode);
    
  }
}

FlipdotDisplay flipdots;
int panels = 7;
boolean receptionMode = true; // false = one panel is one universe / true = one universe is all data
color black;
color white;
color gray = color(9);
float flipdotSize = 4;
int panelLayout = 1;
String ip = "2.0.0.23";
boolean online = false;

void initVariables() {
  black = color(0, 0, 0);
  white = color(0, 0, 100);
  gray = color(90);
}
