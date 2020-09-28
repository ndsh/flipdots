/*
leds.feed(testImage);
leds.update();
leds.display();
leds.send();
*/

static final int INTRO = 0;
static final int VIDEO = 1; // videos von festplatte laden
static final int IMAGES = 2; // bilder von festplatte laden
static final int CALENDAR = 3; // events aus kalender lesen
static final int SCROLLTEXT = 4; // texts aus file lesen

int state = INTRO;

PGraphics ledTemp;

void stateMachine_LED(int state) {
  
   switch(state) {
    case INTRO:
      setState(SCROLLTEXT);
    break;
    
    case VIDEO:
      if(!isPlaying) return;
      if(ledMovie.available()) {
        ledMovie.read();
        push();
        fill(gray);
        noStroke();
        rect(300, 300, 1000, 200); 
        pop();
        //PImage temp = myMovie.get(0, 0, 64, 8);
        //image(temp, 0, 0);
        //myMovie.resize(320, 0);
        ledTemp = createGraphics(320, 16);
        ledTemp.beginDraw();
        ledTemp.image(ledMovie, 0, 0, 320, 16);
        ledTemp.endDraw();
        
        image(ledTemp, 300, height-100, 320*2.99, 16*2.99);
        
        leds.feed(ledTemp);
        //stripe.feed(myMovie);
        
        leds.update();
        push();
        translate(300, height-150);
        leds.display();
        pop();
        leds.send();
        
        push();
        translate(8, height-8);
        noStroke();
        rect(0, 0, map(ledMovie.time(), 0, ledMovie.duration(), 0, width-22), 6);
        pop();
        
      }
    break;
    
    case IMAGES:      
      //leds.feed(testImage);
      //leds.update();
      //leds.display();
      //leds.send();
    break;
    
    case SCROLLTEXT:
      if(!isPlaying) return;
      push();
        background(gray);
        if(ledMovie != null) ledMovie.stop();
        String currentString = scrollSource[currentScrollText];
        float sw = textWidth(currentString);
        ledTemp = createGraphics(320, 16);
        ledTemp.smooth();
        ledTemp.beginDraw();
        
        ledTemp.textFont(europaGrotesk, 16);
        ledTemp.textSize(16);
        scrollPosition--;
        ledTemp.text(currentString, scrollPosition, 13);
        ledTemp.endDraw();
        
        image(ledTemp, 300, height-100, 320*2.99, 16*2.99);
        
        leds.feed(ledTemp);
        //stripe.feed(myMovie);
        
        leds.update();
        push();
        translate(300, height-150);
        leds.display();
        pop();
        if(online) leds.send();
        
        
        if(scrollPosition <= -(sw)-320) {
          nextScrollText();
        }
        
      pop();
    break;
   }
}

void setState(int s) {
  state = s;
}
