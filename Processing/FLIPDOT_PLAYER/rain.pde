PVector[] rain = new PVector[1000];
float rainDir;
int rainLen = 2;
int speeds = 1;
  
void setupRain() {
  for(int i=0; i<rain.length; i++) {
    rain[i] = new PVector(random(C_W),random(C_H),random(1,3));
  }
}

void rain () {  
  if(init) setupRain();
  C_clr();
  
  rainDir = -1+2*noise(frameCount*0.02);
  for(int i=0; i<20*density; i++) {
    drawLine(int(rain[i].x), int(rain[i].y), int(rain[i].x+rainDir), int(rain[i].y+rainLen));
    rain[i].y+=rain[i].z;
    rain[i].x+=rainDir;
    if(rain[i].y>C_H) rain[i].y=0;
    if(rain[i].x<0) rain[i].x=C_W;
    if(rain[i].x>C_W) rain[i].x=0;
  }
  CX = new boolean[C_W][C_H];
  
  C_to_DISPLAY();
}
