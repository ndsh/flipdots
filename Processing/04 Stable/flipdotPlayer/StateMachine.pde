static final int INTRO = 0;
static final int CHECK = 1; // regular checks
static final int VIDEO = 2; // videos von festplatte laden
static final int IMAGES = 3; // bilder von festplatte laden
static final int CALENDAR = 4; // events aus kalender lesen
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
static final int PERLINGRID = 15;

int state = INTRO;

/*String getStateName(int state) {
  return currentState.getString("name");
  //return stateNames[state];
}*/

void stateMachine(int state) {
  
   switch(state) {
     
    case INTRO:
      setState(CHECK);
    break;
    
    case CHECK:
      drawProgessbar(stateTimePercentageLabel, stateTimeRestLabel, (millis()-idleTimestamp)/1000f, idleInterval/1000f, w6-60, 10f, h3+h6+h12);
      if(millis() - idleTimestamp < idleInterval) return;
      idleTimestamp = millis();
      
      // markov chain hier?
      int r = (int)random(2);
      //int r = 0;
      if(r == 0) setState(VIDEO);
      else if(r == 1) setState(WORDS);
      else if(r == 2) setState(TRANSITION);
      else if(r == 3) setState(PERLINGRID);
    break;
    
    case VIDEO:
      if(!isPlaying) return;
      if(!moviePlaying) playMovie();       
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
      //}
      if(online) flipdots.send();
      drawProgessbar(movieTimePercentageLabel, movieTimeRestLabel, myMovie.time(), myMovie.duration(), w6-60, 10f, h3*2);
      if(!stateTerminates()) drawProgessbar(stateTimePercentageLabel, stateTimeRestLabel, (millis()-stateTimestamp)/1000f, stateRuntime/1000f, w6-60, 10f, h3+h6+h12);
        
      stateHasFinished = movieFinished();
      if(stateHasFinished) nextMovie(this);
      stateCheckTime();
    break;
    
    case TRANSITION:
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
      //}
      if(online) flipdots.send();
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
      //}
      if(online) flipdots.send();
      drawProgessbar(movieTimePercentageLabel, movieTimeRestLabel, myMovie.time(), myMovie.duration(), w6-60, 10f, h3*2);
      if(!stateTerminates()) drawProgessbar(stateTimePercentageLabel, stateTimeRestLabel, (millis()-stateTimestamp)/1000f, stateRuntime/1000f, w6-60, 10f, h3+h6+h12);
        
      stateHasFinished = movieFinished();
      
      stateCheckTime();
    break;
   }
}

void setState(int s) {
  //println("setState");
  state = s;
  currentState = stateSettings.getJSONObject(state);
  //stateLabel.setText("State: " + getStateName(s));
  listStates();
  setStateRuntime();
  setScale();
  setDither();
  stateHasFinished = false;
  
}

void stateCheckTime() {
  //boolean b = stateFinishes[state];
  //println("stateCheckTime");
  boolean b = currentState.getBoolean("finishes");
  //println("state= " + state);
  //println(b);
  if(!b) {
    if(millis() - stateTimestamp < stateRuntime) {
      stateTimestamp = millis();
      setState(CHECK);
      return;
    }
  } else {
    //println("else");
    if(stateHasFinished) {
      idleTimestamp = millis();
      setState(CHECK);
    } //else setState(state);
  }
  
}

void setStateRuntime() {
  //stateRuntime = stateRuntimes[state];
  stateRuntime = currentState.getInt("runtime");
}

void setScale() {
  //stateRuntime = stateRuntimes[state];
  scaleBang(currentState.getBoolean("scale"));
  
}

void setDither() {
  //stateRuntime = stateRuntimes[state];
  ditherBang(currentState.getBoolean("dither"));
}

boolean stateTerminates() {
  //return stateFinishes[state];
  return currentState.getBoolean("finishes");
}
