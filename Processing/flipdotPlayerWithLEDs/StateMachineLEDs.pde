/*
leds.feed(testImage);
leds.update();
leds.display();
leds.send();
*/

static final int INTRO_L = 0;
static final int VIDEO_L = 1; // videos von festplatte laden
static final int IMAGES_L = 2; // bilder von festplatte laden
static final int CALENDAR_L = 3; // events aus kalender lesen

int state_L = INTRO_L;

PGraphics ledTemp;

void stateMachine_LED(int state) {
  
   switch(state) {
    case INTRO_L:
      setState_L(VIDEO_L);
    break;
    
    case VIDEO_L:
      //if(ledMovie.available()) {
        //ledMovie.read();
        
        //PImage temp = myMovie.get(0, 0, 64, 8);
        //image(temp, 0, 0);
        //myMovie.resize(320, 0);
        ledTemp = createGraphics(320, 16);
        ledTemp.beginDraw();
        ledTemp.image(ledMovie, 0, 0, 320, 16);
        ledTemp.endDraw();
        
        image(ledMovie, 300, height-100, 320*2.99, 16*2.99);
        
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
        
      //}
    break;
    
    case IMAGES_L:      
      //leds.feed(testImage);
      //leds.update();
      //leds.display();
      //leds.send();
    break;
   }
}

void setState_L(int s) {
  state_L = s;
}
