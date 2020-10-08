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
static final int DRAWING = 14; // draw directly to the flipdots
static final int PERLINGRID = 15; // draw directly to the flipdots

int state = INTRO;

static final String[] stateNames = {
  "Intro", "Video", "Images",
  "Calendar", "Check", "Time",
  "Intervention", "Transition", "Words",
  "Check", "OSC", "Network",
  "Send", "GIFs", "Drawing",
  "PerlinGrid"
};

// state that finish by themself, have a runtime of 0
static final long[] stateRuntimes = {
  0, 0, 5000,
  0, 0, 2000,
  5000, 0, 0,
  0, 0, 0,
  0, 5000, 0,
  15000
};

// if a state "finishes" by itself, eg. a movie file such as a transition, it will switch to the next state
static final boolean[] stateFinishes = {
  true, true, false,
  true, true, false,
  false, true, true,
  true, true, true,
  true, false, true,
  false
};

// if a state needs dither, it can be defined here!
static final boolean[] stateDither = {
  false, false, false,
  false, false, false,
  false, false, false,
  false, false, false,
  false, false, false,
  false
};

String getStateName(int state) {
  return stateNames[state];
}

void stateMachine(int state) {
  
   switch(state) {
     
    case INTRO:
      setState(CHECK);
    break;
    
    case VIDEO:
      stateHasOutput = false;
      if(!isPlaying) return;
      if(!moviePlaying) {
        nextMovie(this);
        playMovie();
      }
      //if(myMovie.available()) {
      //background(black);
      //myMovie.read();
      
      source = myMovie.get();
      newFrame = myMovie;
      if(newFrame.height == 0) return;
      shrink = shrinkToFormat(newFrame);
      
      visualOutput();
      ditherOutput();
      feedBuffer(shrink);
      flipdots.feed(shrink);
      
      sourceFlipdots();
      
      flipdots.update();
      flipdots.display();
      
    //  refreshUI = true;
      stateHasOutput = true;
      //}
      if(online && stateHasOutput) flipdots.send();
      drawProgessbar(movieTimePercentageLabel, movieTimeRestLabel, myMovie.time(), myMovie.duration(), w6-60, 10f, h3*2);
      if(!stateTerminates()) drawProgessbar(stateTimePercentageLabel, stateTimeRestLabel, (millis()-stateTimestamp)/1000f, stateRuntime/1000f, w6-60, 10f, h3+h6+h12);
        
      stateHasFinished = movieFinished();
      if(stateHasFinished) nextMovie(this);
      stateCheckTime();
    break;
    
    case TRANSITION:
      stateHasOutput = false;
      if(!isPlaying) return;
      if(!moviePlaying) {
        randomTransition(this);
        playMovie();
      }
      //if(myMovie.available()) {
      //background(black);
      //myMovie.read();
      
      source = myMovie.get();
      newFrame = myMovie;
      if(newFrame.height == 0) return;
      shrink = shrinkToFormat(newFrame);
      
      visualOutput();
      ditherOutput();
      feedBuffer(shrink);
      flipdots.feed(shrink);
      
      sourceFlipdots();
      
      flipdots.update();
      flipdots.display();
      
    //  refreshUI = true;
      stateHasOutput = true;
      //}
      if(online && stateHasOutput) flipdots.send();
      drawProgessbar(movieTimePercentageLabel, movieTimeRestLabel, myMovie.time(), myMovie.duration(), w6-60, 10f, h3*2);
      if(!stateTerminates()) drawProgessbar(stateTimePercentageLabel, stateTimeRestLabel, (millis()-stateTimestamp)/1000f, stateRuntime/1000f, w6-60, 10f, h3+h6+h12);
        
      stateHasFinished = movieFinished();
      if(stateHasFinished) randomTransition(this);
      stateCheckTime();
    break;
    
    case WORDS:
      
      if(!isPlaying) return;
      if(!moviePlaying) {
        nextMovie(this);
        playMovie();
      }
      //if(myMovie.available()) {
      //background(black);
      //myMovie.read();
      
      // content
      String displayText = "L\nT\nC\n";
      source = myMovie.get();
      newFrame = myMovie;
      if(newFrame.height == 0) return;
      shrink = shrinkToFormat(newFrame);
      
      
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
      
      sourceFlipdots();
      
      flipdots.update();
      flipdots.display();
      if(online) flipdots.send();
      
      drawProgessbar(movieTimePercentageLabel, movieTimeRestLabel, myMovie.time(), myMovie.duration(), w6-60, 10f, h3*2);
      if(!stateTerminates()) drawProgessbar(stateTimePercentageLabel, stateTimeRestLabel, (millis()-stateTimestamp)/1000f, stateRuntime/1000f, w6-60, 10f, h3+h6+h12);
    //  refreshUI = true;
    //  }
      stateHasFinished = movieFinished();
      if(stateHasFinished) nextMovie(this);
      stateCheckTime();
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
      drawProgessbar(stateTimePercentageLabel, stateTimeRestLabel, (millis()-idleTimestamp)/1000f, idleInterval/1000f, w6-60, 10f, h3+h6+h12);
      if(millis() - idleTimestamp < idleInterval) return;
      idleTimestamp = millis();
      //setState(TRANSITION);
      
      // markov chain hier?
      
      int r = (int)random(2);
      if(r == 0) setState(VIDEO);
      else if(r == 1) setState(WORDS);
      else if(r == 2) setState(TRANSITION);
      
    break;
    
    case SEND:
    
    break;
    
    case PERLINGRID:
      if(!isPlaying) return;
      
      grid.update(); 
      grid.display();
      PImage t = grid.getDisplay();
      source = t.copy();
      newFrame = source;
      
      if(newFrame.height == 0) return;
      shrink = shrinkToFormat(newFrame);
      
      visualOutput();
      ditherOutput();
      feedBuffer(shrink);
      flipdots.feed(shrink);
      
      sourceFlipdots();
      
      flipdots.update();
      flipdots.display();
      
    //  refreshUI = true;
      stateHasOutput = true;
      //}
      if(online && stateHasOutput) flipdots.send();
      drawProgessbar(movieTimePercentageLabel, movieTimeRestLabel, myMovie.time(), myMovie.duration(), w6-60, 10f, h3*2);
      if(!stateTerminates()) drawProgessbar(stateTimePercentageLabel, stateTimeRestLabel, (millis()-stateTimestamp)/1000f, stateRuntime/1000f, w6-60, 10f, h3+h6+h12);
        
      stateHasFinished = movieFinished();
      if(stateHasFinished) nextMovie(this);
      stateCheckTime();
    break;
   }
}

void setState(int s) {
  state = s;
  //stateLabel.setText("State: " + getStateName(s));
  listStates();
  setStateRuntime();
  stateHasFinished = false;
}

void stateCheckTime() {
  boolean b = stateFinishes[state];
  if(!b) {
    if(millis() - stateTimestamp > stateRuntime) {
      stateTimestamp = millis();
      setState(CHECK);
      return;
    }
  } else {
    if(stateHasFinished) {
      idleTimestamp = millis();
      setState(CHECK);
    } else setState(state);
  }
  
}

void setStateRuntime() {
  stateRuntime = stateRuntimes[state];
}

boolean stateTerminates() {
  return stateFinishes[state];
}
