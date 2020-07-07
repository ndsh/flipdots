// Alphabet - an array with encoded characters

String alphabet = " 0123456789-abcdefghijklmnoprstuvwxyz";
byte[] alphabetBin = new byte[50];
byte[] nums = {
  byte(unbinary("1111110")), // 0
  byte(unbinary("0110000")), // 1
  byte(unbinary("1101101")), // 2
  byte(unbinary("1111001")), // 3
  byte(unbinary("0110011")), // 4
  byte(unbinary("1011011")), // 5
  byte(unbinary("1011111")), // 6
  byte(unbinary("1110000")), // 7
  byte(unbinary("1111111")), // 8
  byte(unbinary("1111011"))  // 9
};

String typewriting = "Hello";

void loadAlphabet() {
  
  /* TODO: zmiana na byte */
  
  alphabetBin[0] = byte(unbinary("0000000")); // spacja
  
  alphabetBin[1] = byte(unbinary("1111110")); // 0
  alphabetBin[2] = byte(unbinary("0110000")); // 1
  alphabetBin[3] = byte(unbinary("1101101")); // 2
  alphabetBin[4] = byte(unbinary("1111001")); // 3
  alphabetBin[5] = byte(unbinary("0110011")); // 4
  alphabetBin[6] = byte(unbinary("1011011")); // 5
  alphabetBin[7] = byte(unbinary("1011111")); // 6
  alphabetBin[8] = byte(unbinary("1110000")); // 7
  alphabetBin[9] = byte(unbinary("1111111")); // 8
  alphabetBin[10] = byte(unbinary("1111011")); // 9
  
  alphabetBin[11] = byte(unbinary("0000001")); // -
  
  alphabetBin[12] = byte(unbinary("1110111")); // a
  alphabetBin[13] = byte(unbinary("1111111")); // b
  alphabetBin[14] = byte(unbinary("1001110")); // c
  alphabetBin[15] = byte(unbinary("0111101")); // d
  alphabetBin[16] = byte(unbinary("1001111")); // e
  alphabetBin[17] = byte(unbinary("1000111")); // f
  alphabetBin[18] = byte(unbinary("1011110")); // g
  alphabetBin[19] = byte(unbinary("0110111")); // h
  alphabetBin[20] = byte(unbinary("0110000")); // i
  alphabetBin[21] = byte(unbinary("1111100")); // j
  alphabetBin[22] = byte(unbinary("1010111")); // k - bad
  alphabetBin[23] = byte(unbinary("0001110")); // l
  alphabetBin[24] = byte(unbinary("1110110")); // m
  alphabetBin[25] = byte(unbinary("0010101")); // n
  alphabetBin[26] = byte(unbinary("1111110")); // o
  alphabetBin[27] = byte(unbinary("1100111")); // p
  alphabetBin[28] = byte(unbinary("1000110")); // r
  alphabetBin[29] = byte(unbinary("1011011")); // s
  alphabetBin[30] = byte(unbinary("1110000")); // t - bad
  alphabetBin[31] = byte(unbinary("0111110")); // u
  alphabetBin[32] = byte(unbinary("0100111")); // v - bad
  alphabetBin[33] = byte(unbinary("0110110")); // w - bad
  alphabetBin[34] = byte(unbinary("0010011")); // x - bad
  alphabetBin[35] = byte(unbinary("0111011")); // y
  alphabetBin[36] = byte(unbinary("1101101")); // z
  
}


void write(String text) {
  text = text.toLowerCase();
  int strLen = constrain(text.length(),0,W*H);
  for(int i=0; i<strLen; i++) {
    int ind = alphabet.indexOf( text.charAt(i) );
    int x = i % W;
    int y = i / W;
    if( ind >= 0 ) DISPLAY[x][y] = alphabetBin[ind];
  }
}

void writeCenter(String text) {
  String spaces = "";
  int spacesLength = (H/2-1)*W + (W-text.length())/2;
  for(int i=0; i<spacesLength; i++) spaces+=" ";
  write(spaces+text);  
}
