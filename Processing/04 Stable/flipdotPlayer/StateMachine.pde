static final int INTRO = 0;
static final int VIDEO = 1; // videos von festplatte laden
static final int IMAGES = 2; // bilder von festplatte laden
static final int CALENDAR = 3; // events aus kalender lesen
static final int CHECK = 4; // regular checks
static final int TIME = 5; // uhrzeit, z.B. jede viertel oder halbe stunde
static final int INTERVENTION = 6; // störer oder marquee? z.B. livingthecity.eu
static final int TRANSITION = 7; // plays random transition from the transition folder
static final int WORDS = 8; // plays random text from file
static final int IDLE = 9; // idle for a certain amount off time
static final int OSC = 10;
static final int NETWORK = 11;
static final int SEND = 12;
static final int GIFS = 13;

int state = INTRO;

static final String[] stateNames = {
  "Intro", "Video", "Images",
  "Calendar", "Check", "Time",
  "Intervention", "Transition", "Words",
  "Check", "OSC", "Network", "Send"
};

String getStateName(int state) {
  return stateNames[state];
}

void stateMachine(int state) {
  
   switch(state) {
     
    case INTRO:
      setState(WORDS);
    break;
    
    case VIDEO:
      if(!isPlaying) return;
      if(myMovie.available()) {
        background(black);
        myMovie.read();
        
        source = myMovie.get();
        newFrame = myMovie;
        shrink = shrinkToFormat(newFrame);
        
        visualOutput();
        ditherOutput();
        feedBuffer(shrink);
        flipdots.feed(shrink);
        
        push();
          if(panelLayout == 0) image(pg, 8, 95, width-22, 71);
          else if(panelLayout == 1) image(pg, w6*2+30, h24+22, 140, 490);
        pop();
        
        flipdots.update();
        flipdots.display();
        if(online) flipdots.send();
        drawProgessbar(movieTimePercentageLabel, movieTimeRestLabel, myMovie.time(), myMovie.duration(), w6-60, 10f, h3*2);
        drawProgessbar(stateTimePercentageLabel, stateTimeRestLabel, (millis()-checkTimestamp)/1000f, checkInterval/1000f, w6-60, 10f, h3+h6+h12);
        refreshUI = true;
      }
      if(millis() - checkTimestamp < checkInterval) return;
      checkTimestamp = millis();
      setState(CHECK);
    break;
    
    case WORDS:
      
      if(!isPlaying) return;
      if(myMovie.available()) {
        background(black);
        myMovie.read();
        
        String displayText = "L\nT\nC\n";
        source = myMovie.get();
        newFrame = myMovie;
        shrink = shrinkToFormat(newFrame);
        
        // content
        textOverlay.beginDraw();
        textOverlay.image(shrink, 0, 0);
        textOverlay.fill(black);
        textOverlay.text(displayText, textOverlay.width/2-1, textOverlay.height/2);
        
        textOverlay.text(displayText, textOverlay.width/2, textOverlay.height/2-1);
        
        textOverlay.text(displayText, textOverlay.width/2, textOverlay.height/2+1);
        textOverlay.text(displayText, textOverlay.width/2, textOverlay.height/2+2);
        textOverlay.text(displayText, textOverlay.width/2+1, textOverlay.height/2);
        textOverlay.text(displayText, textOverlay.width/2+2, textOverlay.height/2);
        textOverlay.fill(white);
        textOverlay.text(displayText, textOverlay.width/2, textOverlay.height/2);
        textOverlay.endDraw();
        shrink = textOverlay.copy();
        // content end
        
        visualOutput();
        ditherOutput();
        feedBuffer(shrink);
        flipdots.feed(shrink);
        
        push();
          if(panelLayout == 0) image(pg, 8, 95, width-22, 71);
          else if(panelLayout == 1) image(pg, w6*2+30, h24+22, 140, 490);
        pop();
        
        flipdots.update();
        flipdots.display();
        if(online) flipdots.send();
        
        drawProgessbar(movieTimePercentageLabel, movieTimeRestLabel, myMovie.time(), myMovie.duration(), w6-60, 10f, h3*2);
        drawProgessbar(stateTimePercentageLabel, stateTimeRestLabel, (millis()-checkTimestamp)/1000f, checkInterval/1000f, w6-60, 10f, h3+h6+h12);
        refreshUI = true;
      }
      if(millis() - checkTimestamp < checkInterval) return;
      checkTimestamp = millis();
      setState(CHECK);
    break;
    
    case IMAGES:
      feedBuffer(staticImage);
      flipdots.feed(staticImage);
      
      push();
      image(pg, 5, height-160, 28*11, 14*11);
      pop();
        
      flipdots.update();
      flipdots.display();
      if(online) flipdots.send();
    break;
    
    case CHECK:
      float r = random(2);
      if(r == 0) setState(VIDEO);
      else setState(WORDS);
    break;
    
    case SEND:
    
    break;
   }
}

void setState(int s) {
  state = s;
  //stateLabel.setText("State: " + getStateName(s));
  listStates();
}
