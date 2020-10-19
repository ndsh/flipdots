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
static final int WEBCAM = 16;

int state = INTRO;

int[] availableStates = {VIDEO, TIME, WORDS, TRANSITION, PERLINGRID};

void stateMachine(int state) {
  
   switch(state) {
     
    case INTRO:
      setState(CHECK);
    break;
    
    case CHECK:
      // threadedStates
       if (frameCount % 30 == 0) {
        thread("timeThread");
      }
      if(threadedState >= 0) {
        setState(threadedState);
      }
      drawProgessbar(stateTimePercentageLabel, stateTimeRestLabel, (millis()-idleTimestamp)/1000f, idleInterval/1000f, w6-60, 10f, h3+h6+h12);
      if(millis() - idleTimestamp < idleInterval) return;
      idleTimestamp = millis();
      //stateTimestamp = millis();
      
      
      // markov chain hier?
      int r = (int)random(availableStates.length);
      setState(availableStates[r]);
      //setState(TIME);
    break;
    
    case VIDEO:
      if(!isPlaying) return;
      if(!isStateReady) {
        randomMovie(this);
        isStateReady = true;
      }
      if(!moviePlaying) playMovie();       
      
      source = myMovie.get();
      newFrame = myMovie;
      if(newFrame.height == 0) return;
      comped = shrinkToFormat(newFrame);
      
      visualOutput();
      ditherOutput();
      feedBuffer(comped);
      flipdots.feed(comped);
      
      sourceFlipdots();
      
      flipdots.update();
      flipdots.display();
      
      if(online) flipdots.send();
      drawProgessbar(movieTimePercentageLabel, movieTimeRestLabel, myMovie.time(), myMovie.duration(), w6-60, 10f, h3*2);
      if(!stateTerminates()) drawProgessbar(stateTimePercentageLabel, stateTimeRestLabel, (millis()-stateTimestamp)/1000f, stateRuntime/1000f, w6-60, 10f, h3+h6+h12);
        
      stateHasFinished = movieFinished();
      //if(stateHasFinished) randomMovie(this);
      stateCheckTime();
    break;
    
    case TIME:
      if(!isStateReady) {
        timeRotation = 90;
        textOverlay.beginDraw();
        textOverlay.clear();
        textOverlay.fill(black);
        textOverlay.endDraw();
        isStateReady = true;
      }
      //timeRotation += 0.2;
      textOverlay.beginDraw();
      textOverlay.push();
      textOverlay.textSize(pixelFontSize*2);
      textOverlay.background(white);
      textOverlay.translate(3, 1);
      textOverlay.stroke(black);
      textOverlay.rotate(radians(timeRotation));
      textOverlay.textAlign(LEFT);
      textOverlay.text(nf(hour(), 2) +":"+ nf(minute(),2) +":"+ nf(second(), 2), 0, 0);
      textOverlay.pop();
      textOverlay.endDraw();
      
      source = textOverlay.copy();
      newFrame = source;
      if(newFrame.height == 0) return;
      //comped = shrinkToFormat(newFrame);
      comped = textOverlay.copy();
      
      visualOutput();
      ditherOutput();
      feedBuffer(comped);
      flipdots.feed(comped);
      
      sourceFlipdots();
      
      flipdots.update();
      flipdots.display();
      
      if(online) flipdots.send();

      if(!stateTerminates()) drawProgessbar(stateTimePercentageLabel, stateTimeRestLabel, (millis()-stateTimestamp)/1000f, stateRuntime/1000f, w6-60, 10f, h3+h6+h12);
        
//      stateHasFinished = movieFinished();
      
      stateCheckTime();
    break;
    
    case TRANSITION:
      if(!isPlaying) return;
      if(!isStateReady) {
        randomTransition(this);
        isStateReady = true;
      }
      if(!moviePlaying) playMovie();
      
      source = myMovie.get();
      newFrame = myMovie;
      if(newFrame.height == 0) return;
      comped = shrinkToFormat(newFrame);
      
      visualOutput();
      ditherOutput();
      feedBuffer(comped);
      flipdots.feed(comped);
      
      sourceFlipdots();
      
      flipdots.update();
      flipdots.display();
      
      if(online) flipdots.send();
      drawProgessbar(movieTimePercentageLabel, movieTimeRestLabel, myMovie.time(), myMovie.duration(), w6-60, 10f, h3*2);
      if(!stateTerminates()) drawProgessbar(stateTimePercentageLabel, stateTimeRestLabel, (millis()-stateTimestamp)/1000f, stateRuntime/1000f, w6-60, 10f, h3+h6+h12);
        
      stateHasFinished = movieFinished();
      
      stateCheckTime();
    break;
    
    case WORDS:
      if(!isPlaying) return;
      if(!isStateReady) {
        randomTransition(this);
        randomFlipdotWord();
        isStateReady = true;
        randomTransition(this);
      }
      if(!moviePlaying) playMovie();
      
      // content
      source = myMovie.get();
      newFrame = myMovie;
      if(newFrame.height == 0) return;
      comped = shrinkToFormat(newFrame);
      
      temp.beginDraw();
      temp.clear();
      temp.image(comped, 0, 0);
      temp.image(textOverlay, 0, 0);
      temp.endDraw();
      comped = temp;
      // content end
      
      visualOutput();
      ditherOutput();
      feedBuffer(comped);
      flipdots.feed(comped);
      
      sourceFlipdots();
      
      flipdots.update();
      flipdots.display();
      if(online) flipdots.send();
      
      drawProgessbar(movieTimePercentageLabel, movieTimeRestLabel, myMovie.time(), myMovie.duration(), w6-60, 10f, h3*2);
      if(!stateTerminates()) drawProgessbar(stateTimePercentageLabel, stateTimeRestLabel, (millis()-stateTimestamp)/1000f, stateRuntime/1000f, w6-60, 10f, h3+h6+h12);

      stateHasFinished = movieFinished();
      
      stateCheckTime();
    break;
    
    case IMAGES:
      source = staticImage.copy();
      
      visualOutput();
      ditherOutput();
      feedBuffer(staticImage);
      flipdots.feed(staticImage);
        
      flipdots.update();
      flipdots.display();
      if(online) flipdots.send();
      
      if(!stateTerminates()) drawProgessbar(stateTimePercentageLabel, stateTimeRestLabel, (millis()-stateTimestamp)/1000f, stateRuntime/1000f, w6-60, 10f, h3+h6+h12);
      
      stateCheckTime();
    break;
    
    case SEND:
    
    break;
    
    case PERLINGRID:
      if(!isPlaying) return;
      if(!isStateReady) {
        isStateReady = true;
      }

      grid.update(); 
      grid.display();
      PImage t = grid.getDisplay();
      source = t.copy();
      newFrame = source;
      
      if(newFrame.height == 0) return;
      comped = shrinkToFormat(source);
      
      visualOutput();
      ditherOutput();
      feedBuffer(comped);
      flipdots.feed(comped);
      
      sourceFlipdots();
      
      flipdots.update();
      flipdots.display();
      
    //  refreshUI = true;
      //}
      if(online) flipdots.send();
      //drawProgessbar(movieTimePercentageLabel, movieTimeRestLabel, myMovie.time(), myMovie.duration(), w6-60, 10f, h3*2);
      if(!stateTerminates()) drawProgessbar(stateTimePercentageLabel, stateTimeRestLabel, (millis()-stateTimestamp)/1000f, stateRuntime/1000f, w6-60, 10f, h3+h6+h12);
        
      stateHasFinished = false;
      
      stateCheckTime();
    break;
   }
}

void setState(int s) {
  state = s;
  currentState = stateSettings.getJSONObject(state);
  listStates();
  setStateRuntime();
  setScale();
  setDither();
  stateHasFinished = false;
  isStateReady = false;
  stateTimestamp = millis();
}

void stateCheckTime() {
  boolean b = currentState.getBoolean("finishes");
  if(!b) {
    if(millis() - stateTimestamp > stateRuntime) {
      stateTimestamp = millis();
      randomizeIdleTime();
      threadedState = -1;
      setState(CHECK);
      return;
    }
  } else {
    if(stateHasFinished) {
      idleTimestamp = millis();
      randomizeIdleTime();
      threadedState = -1;
      setState(CHECK);
    }
  }
}

void randomizeIdleTime() {
  idleInterval = (int)random(minIdle, maxIdle);
  println("new idleInterval= " + idleInterval);
}

void setStateRuntime() {
  stateRuntime = currentState.getInt("runtime");
}

void setScale() {
  scaleBang(currentState.getBoolean("scale"));
}

void setDither() {
  ditherBang(currentState.getBoolean("dither"));
}

boolean stateTerminates() {
  return currentState.getBoolean("finishes");
}

/*String getStateName(int state) {
  return currentState.getString("name");
  //return stateNames[state];
}*/
