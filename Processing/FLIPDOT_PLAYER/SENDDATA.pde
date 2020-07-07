import processing.net.*;

String HOST_IP = "169.254.111.100";
int[] PORT_TX = { 5000, 5001, 5002, 5003 };

byte[][] addresses = {
  { 0, 1, 2, 3, 4 }, // first column, from top display to bottom
  { 5, 6, 7, 8, 9 }, 
  { 10, 11, 12, 13, 14 }, 
  { 15, 16, 17, 18, 19 }
};

Client[] myTCP = new Client[PORT_TX.length];

void setDisplay() {
  for (int i=0; i<cols; i++) {
    myTCP[i] = new Client(this, HOST_IP, PORT_TX[i]);
  }
}

byte[][] DISPLAY_copy = new byte[W][H];

void updateDisplay() {
  if( newFrame() && senddataOn ) { // send data only if changed
  
    for (int col=0; col<cols; col++) {
      for (int row=0; row<rows; row++) {
        
        myTCP[col].write(0x80);
        myTCP[col].write(0x83);
        myTCP[col].write(addresses[col][row]);
        
        for (int y=0; y<UH; y++) {
          for (int x=0; x<UW; x++) {
            byte d = DISPLAY[col*UW+x][row*UH+y];
            myTCP[col].write(d); // states
          }
        }
        
        myTCP[col].write(0x8F); // closure
        
      }
    }
    
  }
  for(int i=0; i<DISPLAY.length; i++) {
    arrayCopy(DISPLAY[i], DISPLAY_copy[i]);
  }
}

boolean newFrame() {
  for (int x=0; x<W; x++) {
    for (int y=0; y<H; y++) {
      if( DISPLAY[x][y] != DISPLAY_copy[x][y] ) {
        return true;
      }
    }
  }
  return false;
}
