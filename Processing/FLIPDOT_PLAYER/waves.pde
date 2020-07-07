int[][] wave = new int[W][H];

void wave1() {
  
  byte[] sequence = {
    byte(unbinary("0110000")), // 1
    byte(unbinary("0110011")), // 4
    byte(unbinary("1111001")), // 3
    byte(unbinary("1111110")), // 0
    byte(unbinary("1111011")), // 9
    byte(unbinary("1111111")), // 8
    byte(unbinary("1011111")), // 6
    byte(unbinary("1011011")), // 5
    byte(unbinary("1101101")), // 2
    byte(unbinary("1110000")), // 7
    byte(unbinary("0000000")), // nic
    byte(unbinary("0000000")), // nic
    byte(unbinary("0000000")) // nic
  };
  
  if(init) {
    for(int y = 0; y < H; y++) {
    int move = 0;
    for(int x = 0; x < W; x++) {
        wave[x][y] = 1 + y + move;
      }
    }
  }
  
  for(int x = 0; x < W; x++) {
    for(int y = 0; y < H; y++) {
      wave[x][y] -= int( 5 * setting );
      int ind = wave[x][y] + int(noise(x*0.01,y,frameCount*0.1)*5);
      ind = ind % sequence.length;
      if( ind < 0 ) ind = sequence.length + ind;
      DISPLAY[x][y] = sequence[ ind ];
    }
  }
  
}

void wave2() {
  
  byte[] sequence = {
    byte(unbinary("0110000")), // 1
    byte(unbinary("0110011")), // 4
    byte(unbinary("1111001")), // 3
    byte(unbinary("1111110")), // 0
    byte(unbinary("1111011")), // 9
    byte(unbinary("1111111")), // 8
    byte(unbinary("1011111")), // 6
    byte(unbinary("1011011")), // 5
    byte(unbinary("1101101")), // 2
    byte(unbinary("1110000")), // 7
    byte(unbinary("0000000")), // nic
    byte(unbinary("0000000")), // nic
    byte(unbinary("0000000")) // nic
  };
  
  if(init) {
    for(int y = 0; y < H; y++) {
      for(int x = 0; x < W; x++) {
        
        wave[x][y] = int( random(float(y)/H*sequence.length/2) + random(float(x)/W*sequence.length/2) );
      }
    }
  }
  
  for(int x = 0; x < W; x++) {
    for(int y = 0; y < H; y++) {
      wave[x][y]--;
      int ind = wave[x][y];
      ind = ind % sequence.length;
      if( ind < 0 ) ind = sequence.length + ind;
      DISPLAY[x][y] = sequence[ ind ];
    }
  }
  
}
