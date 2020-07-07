void gol() {
    if(init) {
      C_clr();
      golNoise();
    }
    boolean[][] CXtemp = new boolean[C_W][C_H];
    boolean[][] CYtemp = new boolean[C_W][C_H];
    for(int x = 0; x < C_W; x++) {
      for(int y = 0; y < C_H; y++) {
        CXtemp[x][y] = checkGOLState(0, x, y);
        CYtemp[x][y] = checkGOLState(1, x, y);
      }
    }      
    arrayCopy(CXtemp, CX);
    arrayCopy(CYtemp, CY);
    C_to_DISPLAY();
}

boolean checkGOLState(int dir, int x, int y) {
  int around = 0;
  int current;
  boolean newState = false;
  
  if(dir==0) { // X
    current = int(CX[x][y]);
    
    if(y>0) around += int(CX[x][y-1]);
    if((y+1)<C_H) around += int(CX[x][y+1]);
    if(x>0) around += int(CX[x-1][y]);
    if((x+1)<C_W) around += int(CX[x+1][y]);
    
    around += int(CY[x][y]);
    if((y+1)<C_H) around += int(CY[x][y+1]);
    if(x>0) around += int(CY[x-1][y]);
    if(x>0&&(y+1)<C_H) around += int(CY[x-1][y+1]);
    
  } else { // Y
    current = int(CY[x][y]);
    
    if(x>0) around += int(CY[x-1][y]);
    if((x+1)<C_W) around += int(CY[x+1][y]);
    if(y>0) around += int(CY[x][y-1]);
    if((y+1)<C_H) around += int(CY[x][y+1]);
    
    around += int(CX[x][y]);
    if((x+1)<C_W) around += int(CX[x+1][y]);
    if(y>0) around += int(CX[x][y-1]);
    if(y>0&&(x+1)<C_W) around += int(CX[x+1][y-1]);
    
  }
  
  if(    ( current==1 && ( around == 2 || around == 3 ) )    ||    ( current == 0 && around == 3 )    ) newState = true;
  return newState;
}

void golNoise() {
  C_clr();
  for(int x = 0; x < C_W; x++) {
    for(int y = 0; y < C_H; y++) {
      boolean rand = random(1) > 0.5;
      CX[x][y] = rand;
      CY[x][y] = rand;
    }
  }
  C_to_DISPLAY();
}
