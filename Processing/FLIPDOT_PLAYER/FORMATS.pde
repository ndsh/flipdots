/*

DISPLAY[][] - boolean / math array / W x H / states 0-127

Formats:
A[][] - alphabet character indexes / math array / W x H / states 0-127
BX[][] & BY[][] - boolean / two math arrays / W x 3H and 2W x 2H / states false/true
CX[][] & CY[][] - boolean / two math arrays / 2W x 3H and 2W x 3H (for vertical and horizontal lines starting at corners) / states false/true
D - data flow as a movie / W x H / states as color(0-127) pixels
M - movie for dithering / W x H / states as color(0-127) pixels
SD - Syphon with D / W x H / states as color(0-127) pixels
SM - Syphon with M
TI - thumb image / 28 x 24px per display / as 0/255 pixels in specific order
TM - thumb movie / 28 x 24px per display / as 0/255 pixels in specific order

*/

import processing.video.*;
import codeanticode.syphon.*;

Capture cam;
SyphonClient client;

int UW = 7;
int UH = 4;

int W = UW * cols;
int H = UH * rows;

byte[][] DISPLAY;

char[][] A;
boolean[][] BX, BY;
boolean[][] CY, CX;
PGraphics S;
PImage TI;
Movie Mov;
PGraphics MovX;
PGraphics MovY;
PGraphics D_preview, T_preview;

int BX_W = W;
int BX_H = 3*H;
int BY_W = 2*W;
int BY_H = 2*H;

int C_W = 2*W;
int C_H = 3*H;



void initFormats() {
  clr();
  A_clr();
  B_clr();
  C_clr();
  
  D_preview = createGraphics(W,H,P2D);
  D_preview.beginDraw();
  D_preview.background(0);
  D_preview.endDraw();
  
  T_preview = createGraphics(28*cols,24*rows,P2D);
  T_preview.beginDraw();
  T_preview.background(0);
  T_preview.endDraw();
  
  MovX = createGraphics(BX_W, BX_H, P2D);
  MovY = createGraphics(BY_W, BY_H, P2D);
  
}

void movieEvent(Movie m) {
  m.read();
}




/* CLEAR */

void clr() {
  DISPLAY = new byte[W][H];
}

void A_clr() {
  A = new char[W][H];
}

void B_clr() {
  BX = new boolean[BX_W][BX_H];
  BY = new boolean[BY_W][BY_H];
}

void C_clr() {
  CX = new boolean[C_W][C_H];
  CY = new boolean[C_W][C_H];
}

void full() {
  for(int x=0; x<W; x++) {
    for(int y=0; y<H; y++) {
      DISPLAY[x][y]=127;
    }
  }
}



/* IMPORT */

void A_to_DISPLAY() {
  for(int x = 0; x < W; x++) {
    for(int y = 0; y < H; y++) {
      String c = str(A[x][y]).toLowerCase();
      int ind = alphabet.indexOf(c);
      if(ind>=0) DISPLAY[x][y] = alphabetBin[ind];
    }
  }    
}

void B_to_DISPLAY() {
  for(int x = 0; x < W; x++) {
    for(int y = 0; y < H; y++) {            
      byte state = 0;
      if(BX[x][y*3]) state+=64; // 64 = TOP
      if(BX[x][y*3+1]) state+=1; // 1 = CENTER
      if(BX[x][y*3+2]) state+=8; // 8 = BOTTOM
      if(BY[x*2+1][y*2]) state+=32; // 32 = TR
      if(BY[x*2+1][y*2+1]) state+=16; // 16 = BR
      if(BY[x*2][y*2+1]) state+=4; // 4 = BL
      if(BY[x*2][y*2]) state+=2; // 2 = TL
      DISPLAY[x][y] = state;
    }
  }
}

void C_to_DISPLAY() {
  for(int x = 0; x < W; x++) {
    for(int y = 0; y < H; y++) {            
      byte state = 0;
      if(CX[x*2][y*3]) state+=64; // 64 = TOP
      if(CX[x*2][y*3+1]) state+=1; // 1 = CENTER
      if(CX[x*2][y*3+2]) state+=8; // 8 = BOTTOM
      if(CY[x*2+1][y*3]) state+=32; // 32 = TR
      if(CY[x*2+1][y*3+1]) state+=16; // 16 = BR
      if(CY[x*2][y*3+1]) state+=4; // 4 = BL
      if(CY[x*2][y*3]) state+=2; // 2 = TL
      DISPLAY[x][y] = state;
    }
  }
}

void D_to_DISPLAY() {
  for(int x=0; x<W; x++) {
    for(int y=0; y<W; y++) {
      DISPLAY[x][y] = byte(Mov.get(x,y));
    }
  }
}

void M_to_DISPLAY() {
  MovX.beginDraw();
  MovX.image(Mov, 0, 0, MovX.width, MovX.height);
  MovX.endDraw();
  MovX.filter(GRAY);
  MovY.beginDraw();
  MovY.image(Mov, 0, 0, MovY.width, MovY.height);
  MovY.endDraw();
  MovY.filter(GRAY);
  THRESHOLD();
  B_to_DISPLAY();
}

void M_to_DISPLAY_dithering() {
  MovX.beginDraw();
  MovX.image(Mov, 0, 0, MovX.width, MovX.height);
  MovX.endDraw();
  MovX.filter(GRAY);
  MovY.beginDraw();
  MovY.image(Mov, 0, 0, MovY.width, MovY.height);
  MovY.endDraw();
  MovY.filter(GRAY);
  DITHER();
  B_to_DISPLAY();
}

void SD_to_DISPLAY() {
  if (client.newFrame()) {
    S = client.getGraphics(S);
    for(int x=0; x<W; x++) {
      for(int y=0; y<W; y++) {
        DISPLAY[x][y] = byte(S.get(x,y));
      }
    }
  }
}

void SM_to_DISPLAY() {
  if (client.newFrame()) {
    S = client.getGraphics(S);
    MovX.beginDraw();
    MovX.image(S, 0, 0, MovX.width, MovX.height);
    MovX.endDraw();
    MovX.filter(GRAY);
    MovY.beginDraw();
    MovY.image(S, 0, 0, MovY.width, MovY.height);
    MovY.endDraw();
    MovY.filter(GRAY);    
    DITHER();    
    B_to_DISPLAY();  
  }
}

void TI_to_DISPLAY() {
  //int TW = TI.width/4;
  //int TH = TI.height/6;
  int TW = 7;
  int TH = 4;
  int cx = (W-TW)/2;
  int cy = (H-TH)/2;
  for(int x = 0; x < TW; x++) {
    for(int y = 0; y < TH; y++) {
      int posx = x*4;
      int posy = y*6;      
      byte state = 0;
      if(TI_checkstate(posx+1, posy)) state+=64; // 64 = TOP
      if(TI_checkstate(posx+2, posy+1)) state+=32; // 32 = TR
      if(TI_checkstate(posx+2, posy+3)) state+=16; // 16 = BR
      if(TI_checkstate(posx+1, posy+4)) state+=8; // 8 = BOTTOM
      if(TI_checkstate(posx, posy+3)) state+=4; // 4 = BL
      if(TI_checkstate(posx, posy+1)) state+=2; // 2 = TL
      if(TI_checkstate(posx+1, posy+2)) state+=1; // 1 = CENTER
      DISPLAY[cx+x][cy+y] = state;
    }
  }
}

boolean TI_checkstate(int x, int y) {
  return brightness(TI.get(x, y)) > 127;
}

/* TODO: zrobic wspolna funkcje */

void TM_to_DISPLAY() {
  for(int x = 0; x < W; x++) {
    for(int y = 0; y < H; y++) {
      int posx = x*4;
      int posy = y*6;      
      int state = 0;  
      if(TM_checkstate(posx+1, posy)) state+=64; // 64 = TOP
      if(TM_checkstate(posx+2, posy+1)) state+=32; // 32 = TR
      if(TM_checkstate(posx+2, posy+3)) state+=16; // 16 = BR
      if(TM_checkstate(posx+1, posy+4)) state+=8; // 8 = BOTTOM
      if(TM_checkstate(posx, posy+3)) state+=4; // 4 = BL
      if(TM_checkstate(posx, posy+1)) state+=2; // 2 = TL
      if(TM_checkstate(posx+1, posy+2)) state+=1; // 1 = CENTER
      DISPLAY[x][y] = byte(state);
    }
  }
}

boolean TM_checkstate(int x, int y) {
  return brightness(Mov.get(x, y)) > 127;
}





/* EXPORT */

void DISPLAY_to_D_preview() {
  D_preview.beginDraw();
  for(int x = 0; x < W; x++) {
    for(int y = 0; y < H; y++) {
      D_preview.set(x,y,color(DISPLAY[x][y]));
    }
  }
  D_preview.endDraw();
}

void DISPLAY_to_T_preview() {
  T_preview.beginDraw();
  T_preview.background(0);
  for(int x = 0; x < W; x++) {
    for(int y = 0; y < H; y++) {      
      int c = DISPLAY[x][y]; // TODO: sprawdzić byte zamiast in i niżej też
      String state = binary(c,7);      
      int posx = x*4;
      int posy = y*6;      
      if(state.charAt(0)=='1') T_preview.set(posx+1, posy, color(255)); // 64 = TOP 
      if(state.charAt(1)=='1') T_preview.set(posx+2, posy+1, color(255)); // 32 = TR
      if(state.charAt(2)=='1') T_preview.set(posx+2, posy+3, color(255)); // 16 = BR
      if(state.charAt(3)=='1') T_preview.set(posx+1, posy+4, color(255)); // 8 = BOTTOM
      if(state.charAt(4)=='1') T_preview.set(posx, posy+3, color(255)); // 4 = BL
      if(state.charAt(5)=='1') T_preview.set(posx, posy+1, color(255)); // 2 = TL
      if(state.charAt(6)=='1') T_preview.set(posx+1, posy+2, color(255)); // 1 = CENTER
    }
  }
  T_preview.endDraw();
}




/* THRESHOLD */

void THRESHOLD() {
  MovX.loadPixels();
  MovY.loadPixels();
  for(int i=0; i<MovX.pixels.length; i++) {
    BX[(i % BX_W)][i / BX_W] = brightness(MovX.pixels[i]) > 255 * ( 1 - setting );
  }
  for(int i=0; i<MovY.pixels.length; i++) {
    BY[(i % BY_W)][i / BY_W] = brightness(MovY.pixels[i]) > 255 * ( 1 - setting );
  }
  MovX.updatePixels();
  MovY.updatePixels();
}



/* DITHERING */

void DITHER() {
    
  MovX.loadPixels();

  for (int y = 0; y < MovX.height-1; y++) {
    for (int x = 1; x < MovX.width-1; x++) {
      color pix = MovX.pixels[index1(x, y)];
      float oldR = red(pix);
      float oldG = green(pix);
      float oldB = blue(pix);
      int factor = 1;
      int newR = round(factor * oldR / 255) * (255/factor);
      int newG = round(factor * oldG / 255) * (255/factor);
      int newB = round(factor * oldB / 255) * (255/factor);
      MovX.pixels[index1(x, y)] = color(newR, newG, newB);
      
      float errR = oldR - newR;
      float errG = oldG - newG;
      float errB = oldB - newB;

      int index1 = index1(x+1, y);
      color c = MovX.pixels[index1];
      float r = red(c);
      float g = green(c);
      float b = blue(c);
      r = r + errR * 7/16.0;
      g = g + errG * 7/16.0;
      b = b + errB * 7/16.0;
      MovX.pixels[index1] = color(r, g, b);

      index1 = index1(x-1, y+1);
      c = MovX.pixels[index1];
      r = red(c);
      g = green(c);
      b = blue(c);
      r = r + errR * 3/16.0;
      g = g + errG * 3/16.0;
      b = b + errB * 3/16.0;
      MovX.pixels[index1] = color(r, g, b);

      index1 = index1(x, y+1);
      c = MovX.pixels[index1];
      r = red(c);
      g = green(c);
      b = blue(c);
      r = r + errR * 5/16.0;
      g = g + errG * 5/16.0;
      b = b + errB * 5/16.0;
      MovX.pixels[index1] = color(r, g, b);

      index1 = index1(x+1, y+1);
      c = MovX.pixels[index1];
      r = red(c);
      g = green(c);
      b = blue(c);
      r = r + errR * 1/16.0;
      g = g + errG * 1/16.0;
      b = b + errB * 1/16.0;
      MovX.pixels[index1] = color(r, g, b);
    }
  }
    
  for(int i=0; i<MovX.pixels.length; i++) {
    BX[(i % BX_W)][i / BX_W] = brightness(MovX.pixels[i]) > 50;
    //BX[BX_W - 1 - (i % BX_W)][i / BX_W] = brightness(MovX.pixels[i]) > 50;
  }
  
  MovX.updatePixels();


  MovY.loadPixels();

  for (int y = 0; y < MovY.height-1; y++) {
    for (int x = 1; x < MovY.width-1; x++) {
      color pix = MovY.pixels[index2(x, y)];
      float oldR = red(pix);
      float oldG = green(pix);
      float oldB = blue(pix);
      int factor = 1;
      int newR = round(factor * oldR / 255) * (255/factor);
      int newG = round(factor * oldG / 255) * (255/factor);
      int newB = round(factor * oldB / 255) * (255/factor);
      MovY.pixels[index2(x, y)] = color(newR, newG, newB);

      float errR = oldR - newR;
      float errG = oldG - newG;
      float errB = oldB - newB;

      int index2 = index2(x+1, y);
      color c = MovY.pixels[index2];
      float r = red(c);
      float g = green(c);
      float b = blue(c);
      r = r + errR * 7/16.0;
      g = g + errG * 7/16.0;
      b = b + errB * 7/16.0;
      MovY.pixels[index2] = color(r, g, b);

      index2 = index2(x-1, y+1);
      c = MovY.pixels[index2];
      r = red(c);
      g = green(c);
      b = blue(c);
      r = r + errR * 3/16.0;
      g = g + errG * 3/16.0;
      b = b + errB * 3/16.0;
      MovY.pixels[index2] = color(r, g, b);

      index2 = index2(x, y+1);
      c = MovY.pixels[index2];
      r = red(c);
      g = green(c);
      b = blue(c);
      r = r + errR * 5/16.0;
      g = g + errG * 5/16.0;
      b = b + errB * 5/16.0;
      MovY.pixels[index2] = color(r, g, b);

      index2 = index2(x+1, y+1);
      c = MovY.pixels[index2];
      r = red(c);
      g = green(c);
      b = blue(c);
      r = r + errR * 1/16.0;
      g = g + errG * 1/16.0;
      b = b + errB * 1/16.0;
      MovY.pixels[index2] = color(r, g, b);
    }
  }
    
  for(int i=0; i<MovY.pixels.length; i++) {
    BY[(i % BY_W)][i / BY_W] = brightness(MovY.pixels[i]) > 50;
    //BY[BY_W - 1 - (i % BY_W)][i / BY_W] = brightness(MovY.pixels[i]) > 50;
  }
  
  MovY.updatePixels();
   
}

int index1(int x, int y) {
  return x + y * MovX.width;
}

int index2(int x, int y) {
  return x + y * MovY.width;
}









/* MATH */

void drawLine(int x1, int y1, int x2, int y2) {
  
  int w = C_W;
  int h = C_H;
  
  x1 = constrain(x1, 0, w-1);
  y1 = constrain(y1, 0, h-1);
  
  x2 = constrain(x2, 0, w-1);
  y2 = constrain(y2, 0, h-1);
  
  if( x2 < x1 ) {
    int temp;
    temp = x1;
    x1 = x2;
    x2 = temp;
    temp = y1;
    y1 = y2;
    y2 = temp;
  }
  
  float dx = x2 - x1;
  float dy = y2 - y1;  
    
  float p, t;
  int r=0;
  int ny=0, pny, nny;
  
  p = dx != 0 ? dy / dx : 0;
  t = 0;

  for(int i=0; i<=dx; i++) {
    r = int(round(t));
    pny = ny;
    ny = y1 + r;
    
    if(i>0) { // vertical lines connecting horizontal lines
      for(int j=0; j<abs(ny-pny); j++) {
        if( pny > ny ) {
          nny = pny-j-1;
        } else {
          nny = pny+j;
        }
        CY[ x1+i ][ nny ] = true;
      }
    }    
    
    if(i!=dx) CX[ x1+i ][ ny ] = true;
    t += p;    
  }

  
  if(dx==0&&dy!=0) { // in case of no vertical lines
    
    int fs = 0;
    int fe = int(dy);
    
    if(dy<0) {
      fs = fe;
      fe = 0;      
    }
  
    for(int i=fs; i<fe; i++) {
        CY[ x1 ][ y1+i ] = true;       
    }
    
  }
    
}


void flipImage(PGraphics img) {
  
  PImage flipped = createImage(img.width,img.height,RGB);
  for(int i = 0 ; i < flipped.pixels.length; i++){
    int srcX = i % flipped.width;
    int dstX = flipped.width-srcX-1;
    int y    = i / flipped.width;
    flipped.pixels[y*flipped.width+dstX] = img.pixels[i];
  }
  flipped.updatePixels();

  img.loadPixels();
  arrayCopy(flipped.pixels, img.pixels);  
  img.updatePixels();
}
