int FPx;
int FPy;
int FPd = 0; // first move: bottom
int tries = -1;

void fingerprint() {
  
  if(init) {
    C_clr();
    for(int i=0; i<50; i++) {
      int sx = int(random(C_W-1));
      int sy = int(random(C_W-1));
      if(random(1)>0.5) {
        drawLine(
          sx,
          sy,
          sx,
          sy+1
        );
      }
      if(random(1)>0.5) {
        drawLine(
          sx,
          sy,
          sx+1,
          sy
        );
      }
    }
  }
  
  if(tries<0) {
    
    FPx = 0;
    FPy = 0;
    FPx = int(random(C_W));
    FPy = int(random(C_H));
    tries = 3;
    
  } else {
  
    for(int i=0; i<60*setting; i++) {
      
      int nsx = FPx;
      int nsy = FPy;
      
      switch(FPd) {
        case 0:
          nsy++;
          break;
        case 1:
          nsx++;
          break;
        case 2:
          nsy--;
          break;
        case 3:
          nsx--;
          break;
      }      
        
      if( isFree(nsx, nsy) ) {
        drawLine(FPx,FPy,nsx,nsy);
        FPd = ( FPd + 1 ) % 4;
        FPx = nsx;
        FPy = nsy;
        tries = 3;
      } else {
        FPd--;
        tries--;
      }
      
      if(FPd<0) FPd = 3;
      
    }
  }
  
  C_to_DISPLAY();
}

boolean isFree(int nsx, int nsy) {
  if( nsx>=C_W || nsx<0 || nsy>=C_H || nsy<0 || CX[nsx][nsy] || CY[nsx][nsy] ) {
    return false;
  }
  if( nsx > 0 ) {
    if( CX[nsx-1][nsy] ) {
      return false;
    }
  }
  if( nsy > 0 ) {
    if( CY[nsx][nsy-1] ) {
      return false;
    }
  }
  return true;
}
