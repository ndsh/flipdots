
PFont f;

int stringIndex = -1;
String theString = "";
String targetString = "";

long letterMillis = 0;
int letterDelay = 100;
int wordDelay = 1200;
int wait = 0;

void setupText() {
  
  stringIndex = 0;
  targetString = "";
  theString = "";
  
  //f = createFont("SourceCodePro-Regular.ttf", 16);
  //f = loadFont("FagoCo-20.vlw");
  //f = loadFont("Theinhardt-MediumIta-16.vlw");
  //f = loadFont("RotisSansSerifStd-ExtraBold-16.vlw");
  //f = loadFont("Permanentdaylight.vlw");
  //f = loadFont("KarmaticArcade.vlw");
  //f = loadFont("ReturnOfGanonReg.vlw");
  f = loadFont("standard0757-Regular-8.vlw");
  pgDisplay.textFont(f);
  
}

void initText(String s) {
  stringIndex = 0;
  targetString = s;
  theString = "";
  //pgDisplay.textFont(f);
}

void drawText() {
  //println(theString);
  if (pgDisplay.textWidth(theString) < flipDotWidth) {
    pgDisplay.textAlign(LEFT);
    pgDisplay.background(255);
    pgDisplay.fill(0);
    pgDisplay.text(theString, 0, 13);
  } else {
    pgDisplay.textAlign(RIGHT);
    pgDisplay.text(theString, flipDotWidth, 13);
  }
}

void playText() {
}

void nextLetter() {
  
  if (stringIndex < 0 || millis() - letterMillis < letterDelay + wait) return;
  sendBytes = true;
  if (wait > 0) {
    theString = "";
    wait = 0;
    if (stringIndex > targetString.length()) {
      stringIndex = -1;
      return;
    }
  }
  letterMillis = millis();
  if (stringIndex < targetString.length()) {
    if (targetString.charAt(stringIndex) == ' ' && pgDisplay.textWidth(nextWord()) + pgDisplay.textWidth(theString) > flipDotWidth) wait = wordDelay; 
    else theString += targetString.charAt(stringIndex);
  }
  stringIndex ++;
  if (stringIndex > targetString.length()) wait = wordDelay;
}

String nextWord() {
  String word = " ";
  int i = stringIndex;
  while (++i<targetString.length() && targetString.charAt(i) != ' ') word += targetString.charAt(i);
  
  return word; 
}