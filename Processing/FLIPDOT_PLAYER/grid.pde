int p = 0;
void grid() {
  
  C_clr();
  
  float kr1 = map(noise(1,frameCount*0.028),0.33,0.65,0,1)/2;
  float kr2 = map(noise(2,frameCount*0.028),0.33,0.65,0,1)/2;
    
  drawLine(int(C_W/2-kr1*C_W),0,int(C_W/2-kr1*C_W),C_H);
  drawLine(int(C_W/2+kr1*C_W),0,int(C_W/2+kr1*C_W),C_H);
  
  drawLine(int(C_W/2-kr2*C_W),0,int(C_W/2-kr2*C_W),C_H);
  drawLine(int(C_W/2+kr2*C_W),0,int(C_W/2+kr2*C_W),C_H);
  
  drawLine(0,int(C_H/2-kr1*C_H),C_W,int(C_H/2-kr1*C_H));
  drawLine(0,int(C_H/2+kr1*C_H),C_W,int(C_H/2+kr1*C_H));
  
  drawLine(0,int(C_H/2-kr2*C_H),C_W,int(C_H/2-kr2*C_H));
  drawLine(0,int(C_H/2+kr2*C_H),C_W,int(C_H/2+kr2*C_H));
  
    
  C_to_DISPLAY();
  
}
