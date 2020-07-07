int[][] growingNumbersArray = new int[W][H];

void blinks() {
  byte[] sequence = { 1, 73, 127, 127, 73, 1, 0, 0, 0, 0, 0, 0 };
  if(init) {
    for(int x = 0; x < W; x++) {
      for(int y = 0; y < H; y++) {
        growingNumbersArray[x][y] = int(random(0,sequence.length));
      }
    }
  }
  for(int x = 0; x < W; x++) {
    for(int y = 0; y < H; y++) {
      growingNumbersArray[x][y]++;
      growingNumbersArray[x][y] %= sequence.length;
      DISPLAY[x][y] = sequence[ growingNumbersArray[x][y] ];
    }
  }
}
