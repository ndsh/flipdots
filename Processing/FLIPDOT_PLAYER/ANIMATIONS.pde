int t = 0;
int dir = 1; // = play
int tstart;

String[] animationNames = new String[200];
int[] animationLength = new int[200];
int[] animationStart = new int[200];
String[] animationParams = new String[200];

int animationCounter = 0;
String currentAnimationName;
int currentAnimationId, prevAnimationId, currentFrame;

boolean init;

int totalLng;
float progress;

float density = cols*rows;

float paramx;
float paramy;

int sin;
  
void addToList(String name, int lng) {
  addToList(name, lng, "");
}

void addToList(String name, int lng, String param) {
  animationNames[animationCounter] = name;
  animationLength[animationCounter] = lng;
  animationStart[animationCounter] = totalLng;
  animationParams[animationCounter] = param;
  totalLng+=lng;
  animationCounter++;
}



void play() {
  
  currentAnimationId=0;
  while(animationStart[currentAnimationId+1]<t) {
    currentAnimationId++;
  }
  currentAnimationName = animationNames[currentAnimationId];
 
  if( currentAnimationId != prevAnimationId || t==0 ) {
    init = true;
    currentFrame=0;
  } else {
    init = false;
  }
  currentFrame+=dir;
  progress = float(currentFrame) / animationLength[currentAnimationId];
  prevAnimationId=currentAnimationId;
  
  
  switch(currentAnimationName) {
    
      
      
    /* BASIC */
    
    case "clear":
      clr();
      break;
      
    case "full":
      full();
      break;
      
    case "write":
      clr();
      write(animationParams[currentAnimationId]);
      break;
      
    case "writeCenter":
      clr();
      writeCenter(animationParams[currentAnimationId]);
      break;
    
    case "movie": // requires min 16x16px video
      if(init) {
        Mov = new Movie(this, animationParams[currentAnimationId]);
        Mov.loop();
      }
      M_to_DISPLAY();
      break;
    
    case "movieDithering": // requires min 16x16px video
      if(init) {
        Mov = new Movie(this, animationParams[currentAnimationId]);
        Mov.loop();
      }
      M_to_DISPLAY_dithering();
      break;
    
    case "image":
      if(init) {
        TI = loadImage(animationParams[currentAnimationId]);
      }
      TI_to_DISPLAY();
      break;
    
    case "data": // requires min 16x16px video
      if(init) {
        Mov = new Movie(this, animationParams[currentAnimationId]);
        Mov.loop();
      }
      D_to_DISPLAY();
      break;
    
    case "thumb":
      if(init) {
        Mov = new Movie(this, animationParams[currentAnimationId]);
        Mov.loop();
      }
      TM_to_DISPLAY();
      break;
    
    case "cam":
      if (cam.available() == true) {
        cam.read();    
        MovX.beginDraw();
        MovX.image(cam, 0, 0, MovX.width, MovX.height);
        MovX.endDraw();
        MovX.filter(GRAY);    
        MovY.beginDraw();
        MovY.image(cam, 0, 0, MovY.width, MovY.height);
        MovY.endDraw();
        MovY.filter(GRAY);
        //THRESHOLD();
        DITHER();
        B_to_DISPLAY();      
      }
      break;
    
    case "kinect":
      readKinect();
      break;
    
    case "syphonDither":
      SD_to_DISPLAY();
      break;
    
    case "syphonMovie":
      SM_to_DISPLAY();
      break;
      
      
      
      
      
    /* IDEAS */
      
    case "typewriter":
      clr();
      write(typewriting);
      break;
      
    case "music":
      music();
      break;
      
    case "blinks":
      blinks();
      break;
      
    case "grid":
      grid();
      break;
      
    case "cell":
      cell();
      break;
      
    case "counters":
      if(init) full();
      String letters = "000011111123456789";
      int rsx = int(random(W*0.6));
      int rsy = int(random(H*0.6));
      int rw = rsx+int(random(W-rsx+1));
      int rh = rsy+int(random(H-rsy+1));
      int a = int(random(0, letters.length()));
      char n = letters.charAt(a);
      for(int x=rsx; x<rw; x++) {
        for(int y=rsy; y<rh; y++) {
          A[x][y] = n;
        }
      }
      A_to_DISPLAY();
      break;
      
    case "counters2":
      if(init) clr();
      if(t % 2 == 0) {
        letters = "0123456789";
        rsx = int(random(W));
        rsy = int(random(H));
        boolean dir = random(1) > 0.5;
        a = int(random(0, letters.length()));
        n = letters.charAt(a);
        if(dir) {
          for(int i=0; i<H; i++) {
            A[rsx][i] = n;
          }
        } else {
          for(int i=0; i<W; i++) {
            A[i][rsy] = n;
          }
        }
        A_to_DISPLAY();
      }
      break;
    
    case "sin":
      if(init) {
        paramx = 0.09;
        sin = 30;
        //paramx = random(0.5,4);
        //paramy = random(0.5,4);
      }
      C_clr();
      int sinPoints = C_W;
      int sinx, siny, psinx=0, psiny=C_H/2;
      sin++;
      paramx += sin*0.000176;
      paramy = 0.8;
      for(int i=0; i<sinPoints; i++) {
        sinx = int(float(i)/sinPoints*C_W);
        siny = int( ( 1 + sin(TWO_PI*3/4 + i*paramx+t*0.2)  ) / 2 * C_H );
        if(i>0) drawLine( psinx, psiny, sinx, siny );
        psinx=sinx;
        psiny=siny;
      }
      C_to_DISPLAY();
      break;
    
    case "noiseX":
      B_clr();
      for(int x=0; x<BX_W; x++) {
        for(int i=0; i<rows*4; i++) {
          int noise = int( 1 + 3*i + constrain(map(noise(x,i*3,frameCount*0.2),0.2,0.6,-1,1),-1,1) );
          if( noise>=0 && noise<BX_H ) BX[x][noise] = true;
        }
      }
      B_to_DISPLAY();
      break;
    
    case "noiseY":
      B_clr();
      for(int y=0; y<BY_H; y++) {
        for(int i=0; i<cols*4; i++) {
          int noise = int( 2 + i*4 + constrain(map(noise(y,i*3,frameCount*0.1),0.3,0.5,-1,1),-2,2) );
          if( noise>=0 && noise<BY_W ) BY[noise][y] = true;
        }
      }
      B_to_DISPLAY();
      break;
    
    case "gameoflife":
      gol();
      break;
    case "gameoflife-noise":
      golNoise();
      break;
      
    case "3d":
      draw_3d();
      break;
      
    case "snake":
      snake();
      break;
      
    case "worm":
      worm();
      break;
      
    case "rain":
      rain();
      break;
      
    case "terrain":
      C_clr();
      for(int x = 0; x < W; x++) {
        for(int y = 0; y < H; y++) {
          float pow = map(noise(0.15*x,0.15*y,frameCount*0.04),0.31,0.64,0,1);
          if(pow>0.75) { DISPLAY[x][y] = 127; }
          else if(pow>0.5) { DISPLAY[x][y] = 73; }
          else if(pow>0.25) { DISPLAY[x][y] = 1; }
          else { DISPLAY[x][y] = 0; }
        }
      }
      break;
      
    case "bacteria":
      bacteria();
      break;
      
    case "wave1":
      wave1();
      break;
      
    case "wave2":
      wave2();
      break;
      
    case "fingerprint":
      fingerprint();
      break;

      
  }
  
    
    
  t+=dir;
  t = t % totalLng;
  if(t<0) t = totalLng;
  
}
