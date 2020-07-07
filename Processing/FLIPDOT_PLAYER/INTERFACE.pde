float digitW = 100/cols;
float digitH = 140/rows;

PImage[] parts = new PImage[7];

float margin = 50;

void loadImages() {
  for(int i=0; i<7; i++) {
    parts[i] = loadImage("preview/"+i+".png");
  }
}

void showInterface() {
  
  background(30);
  
  translate(margin, margin);
  
  fill(0);
  noStroke();
  rect(0,0,W*digitW,H*digitH);
  
  for(int x = 0; x < W; x++) {
    for(int y = 0; y < H; y++) {
      
      int c = DISPLAY[x][y]; // TODO: sprawdzić byte zamiast in i niżej też
      String state = binary(c,7);
      
      float startX = x*digitW;
      float startY = y*digitH;
      
      if(state.charAt(0)=='1') { image(parts[0], startX, startY, digitW, digitH); } // 64 = TOP 
      if(state.charAt(1)=='1') { image(parts[1], startX, startY, digitW, digitH); } // 32 = TR
      if(state.charAt(2)=='1') { image(parts[2], startX, startY, digitW, digitH); } // 16 = BR
      if(state.charAt(3)=='1') { image(parts[3], startX, startY, digitW, digitH); } // 8 = BOTTOM
      if(state.charAt(4)=='1') { image(parts[4], startX, startY, digitW, digitH); } // 4 = BL
      if(state.charAt(5)=='1') { image(parts[5], startX, startY, digitW, digitH); } // 2 = TL
      if(state.charAt(6)=='1') { image(parts[6], startX, startY, digitW, digitH); } // 1 = CENTER

    }
  }
  
  
  
  
  /* STATUS */

  float statusW = width-2*margin;
  float statusH = 10;
  
  pushMatrix();
  
    translate(0,H*digitH+margin);
    noStroke();    
    
    fill(0);
    rect(0,0,statusW,statusH);
    fill(100);
    rect(0,0,float(t)/totalLng*statusW,statusH);
    fill(255);
    for(int i=1; i<animationCounter-1; i++) {
      rect(float(animationStart[i])/totalLng*statusW,0,1,statusH);
    }
  
  popMatrix();
  
  
  
  
  /* STATUS */
  
  pushMatrix();
  
    translate(margin+W*digitW, 0);
    fill(0);
    rect(0,0,C_W*2,C_H*2);
    stroke(255);
    for(int x = 0; x < C_W; x++) {
      for(int y = 0; y < C_H; y++) {      
        int sx=x*2;
        int sy=y*2;
        if(CX[x][y]) line(sx,sy,sx+2,sy);
        if(CY[x][y]) line(sx,sy,sx,sy+2);
      }
    }
    
    translate(0,C_H*2+margin);
    image(T_preview,0,0);
   
    translate(0,T_preview.height+margin);
    image(D_preview,0,0,T_preview.width,T_preview.height);
    
    translate(0,T_preview.height+margin);
    fill(255);
    
    String status = "";
    if(dir<-1) status = "BACKWARDS x"+(-dir);
    if(dir==-1) status = "BACKWARDS";
    if(dir==0) status = "STOP";
    if(dir==1) status = "PLAY";
    if(dir>1) status = "FORWARDS x"+dir;
        
    float ts = float(frameCount)/30*10;
    float ms = (millis()-tstart)/100;
    
    text(
      status+"\n"+
      t+"/"+totalLng+" ("+totalLng/30+"s)\n"+
      round(ts/ms*1000)/10+"%"+"\n"+
      (currentAnimationId+1)+"/"+(animationCounter-1)+" "+currentAnimationName
    ,0,0);
    
  popMatrix();
    
  
  pushMatrix();
  
    translate(margin+W*digitW, H*digitH-1);
  
    if(controllerOn) {
      stroke(100);
      line(0,0,100,0);
      stroke(255);
      line(0,0,100*setting,0);
    }
    
  popMatrix();
  
  
}
