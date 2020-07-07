byte[] r = new byte[rows];
int musicCase = 1;

byte r11, r12, r2, r4;
int r5;

void music() {
  
  switch(musicCase) {
    
    case 0:
      if( frameCount % 4 == 0 ) r[0] = byte(random(0,128));
      if( frameCount % 3 == 0 ) r[1] = byte(random(0,128));
      if( frameCount % 2 == 0 ) r[2] = byte(random(0,128));
      if( frameCount % 8 == 0 ) r[3] = byte(random(0,128));
      if( frameCount % 16 == 0 ) r[4] = byte(random(0,128));
      for(int row=0; row<rows; row++) {
        for(int x=0; x<W; x++) {
          for(int y=0; y<UH; y++) {
            DISPLAY[x][row*UH+y] = r[row];
          }
        }
      }
      break;
      
    case 1:
      
      if(init) {
        r11 = byte(random(0,128));
        r12 = byte(random(0,128));
        r2 = byte(random(0,128));
        r5 = int(random(0,10));
      }
      
      if(t==0) clr();
      
      byte state = 0;
      for(int row=0; row<rows; row++) {
        for(int x=0; x<W; x++) {
          for(int y=0; y<UH; y++) {
            
            byte current = DISPLAY[x][row*UH+y];
            
            if(row==0) { state = random(1) < noise(0,frameCount*0.03)/80 ? byte(random(0,128)) : current; }
            
            else if(row==1) {
              if((y+x) % 2 == 0) { state = frameCount % 8 < 4 ? r11 : r12; }
              else { state = frameCount % 8 < 4 ? r12 : r11; }
            }
            
            else if(row==2) {
              if(y==0) { state = t==0 ? byte(random(0,128)) : current; if(t!=0 && t % 32 == 0) state = byte(127-current); }
              else { state = DISPLAY[x][row*UH]; }
            }
            
            else if(row==3) {
              if(x==0) { state = random(1) < noise(1,frameCount*0.02)/30 ? byte(random(0,128)) : current; }
              else { state = DISPLAY[0][row*UH+y]; }
            }
            
            //else if(row==4 && ( x < t / 16 % W || x >= W - t / 16 % W ) ) { state = nums[r5]; } // r2
            else if(row==4 && ( x % UW < ( t / 16 % W ) ) ) { state = nums[r5]; } // r2
            
            else { state = 0; }
            
            DISPLAY[x][row*UH+y] = state;
          }
        }
      }
      
      break;
      
  }
      
  
}
