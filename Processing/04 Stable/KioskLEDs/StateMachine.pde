/*
leds.feed(testImage);
leds.update();
leds.display();
leds.send();
*/

static final int INTRO = 0;
static final int VIDEO = 1; // videos von festplatte laden
static final int IMAGES = 2; // bilder von festplatte laden
static final int CHECK = 3; // versch. routen checken
static final int SCROLLTEXT_BORING = 4; // texts aus file lesen
static final int TIME = 5;
static final int CALENDAR = 6; // events aus kalender lesen
static final int SINE = 7;
static final int CELLS = 8;
static final int BALLS = 9;
static final int CELLULARAUTOMATA = 10;
static final int FLOCKING = 11;

int state = INTRO;

PGraphics ledTemp;

void stateMachine_LED(int state) {
  
   switch(state) {
    case INTRO:
      setState(CHECK);
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
        ledTemp.beginDraw();
        ledTemp.clear();
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
    
    case CHECK:
      if(minute() % 30 == 0) {
        // time check!
        setState(TIME);
      } else if(millis() - randomCheckTimestamp > randomCheckInterval) {
        randomCheckTimestamp = millis();
        demoTimestamp = millis();
        int random = (int)random(5);
        //random = 0; // force a random state :)
        leaResults = pickNewHashtags();
        if(random == 0) {
          setState(SINE);
        } else if(random == 1) {
          int random1 = (int)random(10,40);
          int random2 = (int)random(6);
          grid = new Cell[cols][rows];
          for (int i = 0; i < cols; i++) {
            for (int j = 0; j < rows; j++) {
              // Initialize each object
              grid[i][j] = new Cell(i*random1,j*random2,random1,random2,i+j);
            }
          }
          setState(CELLS);
        } else if(random == 2) {
          numBalls = (int)random(12, 50);
          spring = random(0.05, 1.1);
          gravity = random(-0.03, 0.03);
          friction = random(0.9, -0.9);
          balls = new Ball[numBalls];
          for (int i = 0; i < numBalls; i++) {
            balls[i] = new Ball(random(ledTemp.width), random(ledTemp.height*2), random(3, 7), i, balls);
          }
          setState(BALLS);
        } else if(random == 3) {
          setState(CELLULARAUTOMATA);
        } else if(random == 4) {
          flock = new Flock();
          // Add an initial set of boids into the system
          for (int i = 0; i < 150; i++) {
            flock.addBoid(new Boid(ledTemp.width/2, ledTemp.height/2));
          }
          setState(FLOCKING);
        }
      } else {
        setState(SCROLLTEXT_BORING);
      }
      stateLabel.setText("Next state in: " + (randomCheckInterval-(millis() - randomCheckTimestamp))/1000 +" seconds");
      
    break;
    
    case SCROLLTEXT_BORING:
      if(!isPlaying) return;
      push();
        background(gray);
        if(ledMovie != null) ledMovie.stop();
        String currentString = scrollSource[currentScrollText];
        float sw = textWidth(currentString);
        
        //ledTemp.smooth();
        ledTemp.beginDraw();
        ledTemp.push();
        //ledTemp.background(black);
        ledTemp.fill(black, 60);
        ledTemp.rect(0,0,ledTemp.width, ledTemp.height);
        ledTemp.pop();
        scrollPosition -= 0.75;
        ledTemp.text(currentString, scrollPosition, 13);
        ledTemp.endDraw();
        
        image(ledTemp, 20, 80, 320*2.99, 16*2.99);
        
        push();
        noFill();
        stroke(black);
        rect(20, 80, 320*2.99, 16*2.99);
        pop();
        leds.feed(ledTemp);
        //stripe.feed(myMovie);
        
        leds.update();
        push();
        translate(20, 20);
        leds.display();
        pop();
        if(online) leds.send();
        
        
        if(scrollPosition <= -(sw)-320) {
          nextScrollText();
        }
        
      pop();
        setState(CHECK);
    break;
    
    case TIME:
      push();
        background(gray);
        if(millis() - followerTimestamp > followerInterval) {
          followerTimestamp = millis();
          followers = getFollowers();
        }
        ledTemp.smooth();
        ledTemp.beginDraw();
        ledTemp.clear();
        ledTemp.text(nf(hour(),2) +":"+nf(minute(),2)+":"+nf(second(),2), 0, 13);
        ledTemp.text(" Follow @livingthecity.eu! "+ followers , 70, 13);
        ledTemp.image(followerIcon, ledTemp.width-20, 0);
        ledTemp.endDraw();
        textPos++;
        textPos %= ledTemp.width;
        
        image(ledTemp, 20, 80, 320*2.99, 16*2.99);
        push();
          noFill();
          stroke(black);
          rect(20, 80, 320*2.99, 16*2.99);
        pop();
        leds.feed(ledTemp);
        
        leds.update();
        push();
          translate(20, 20);
          leds.display();
        pop();
        if(online) leds.send();
        
        
      pop();
      setState(CHECK);
    break;
    
    case SINE:
      float d1 = 10 + (sin(angle) * diameter/2) + diameter/2;
      float d2 = 10 + (sin(angle + PI/2) * diameter/2) + diameter/2;
      float d3 = 10 + (sin(angle + PI) * diameter/2) + diameter/2;
      
      angle += 0.02;
      push();
        background(gray);
        ledTemp.smooth();
        ledTemp.beginDraw();
        ledTemp.noStroke();
        ledTemp.clear();
        ledTemp.ellipse(0, ledTemp.height/2, d1, d1);
        ledTemp.ellipse(ledTemp.width/2, ledTemp.height/2, d2, d2);
        ledTemp.ellipse(ledTemp.width, ledTemp.height/2, d3, d3);
        ledTemp.endDraw();
        textPos++;
        textPos %= ledTemp.width;
        
        //
        textOverlay();
        
        image(ledTemp, 20, 80, 320*2.99, 16*2.99);
        push();
          noFill();
          stroke(black);
          rect(20, 80, 320*2.99, 16*2.99);
        pop();
        leds.feed(ledTemp);
        
        leds.update();
        push();
          translate(20, 20);
          leds.display();
        pop();
        if(online) leds.send();
        
        
      pop();
      stateLabel.setText("Next state in: " + (demoInterval-(millis() - demoTimestamp))/1000 +" seconds");
      if(millis() - demoTimestamp < demoInterval) return;
      demoTimestamp = millis();
      randomCheckTimestamp = millis();
      setState(CHECK);
      
    break;
    
    case CELLS:
      push();
        background(gray);
        // hashtags von lea
        ledTemp.smooth();
        ledTemp.beginDraw();
        ledTemp.noStroke();
        ledTemp.clear();
        for (int i = 0; i < cols; i++) {
          for (int j = 0; j < rows; j++) {
            // Oscillate and display each object
            grid[i][j].oscillate();
            grid[i][j].display();
          }
        }
        ledTemp.endDraw();
        textPos++;
        textPos %= ledTemp.width;
        
        
        textOverlay();
        
        image(ledTemp, 20, 80, 320*2.99, 16*2.99);
        push();
          noFill();
          stroke(black);
          rect(20, 80, 320*2.99, 16*2.99);
        pop();
        leds.feed(ledTemp);
        
        leds.update();
        push();
          translate(20, 20);
          leds.display();
        pop();
        if(online) leds.send();
        
        
      pop();
      stateLabel.setText("Next state in: " + (demoInterval-(millis() - demoTimestamp))/1000 +" seconds");
      if(millis() - demoTimestamp < demoInterval) return;
      demoTimestamp = millis();
      randomCheckTimestamp = millis();
      setState(CHECK);
      
      
    break;
    
    case BALLS:
      push();
        background(gray);
        
        
        ledTemp.smooth();
        ledTemp.beginDraw();
        ledTemp.noStroke();
        ledTemp.clear();
        
        for (Ball ball : balls) {
          ball.collide();
          ball.move();
          ball.display();  
        }
        
        ledTemp.endDraw();
        textPos++;
        textPos %= ledTemp.width;
        
        
        textOverlay();
        
        image(ledTemp, 20, 80, 320*2.99, 16*2.99);
        push();
          noFill();
          stroke(black);
          rect(20, 80, 320*2.99, 16*2.99);
        pop();
        leds.feed(ledTemp);
        
        leds.update();
        push();
          translate(20, 20);
          leds.display();
        pop();
        if(online) leds.send();
        
        
      pop();
      stateLabel.setText("Next state in: " + (demoInterval-(millis() - demoTimestamp))/1000 +" seconds");
      if(millis() - demoTimestamp < demoInterval) return;
      demoTimestamp = millis();
      randomCheckTimestamp = millis();
      setState(CHECK);
      
      
    break;
    
    case CELLULARAUTOMATA:
      push();
        background(gray);
        
        ledTemp.push();
        ledTemp.beginDraw();
        //ledTemp.clear();
        
        ca.render();    // Draw the CA
        ca.generate();  // Generate the next level
        
        if (ca.finished()) {   // If we're done, clear the screen, pick a new ruleset and restart
          ledTemp.background(black);
          ca.randomize();
          ca.restart();
        }
        
        ledTemp.endDraw();
        ledTemp.pop();
        textPos++;
        textPos %= ledTemp.width;
        
        textOverlay();
        
        image(ledTemp, 20, 80, 320*2.99, 16*2.99);
        push();
          noFill();
          stroke(black);
          rect(20, 80, 320*2.99, 16*2.99);
        pop();
        leds.feed(ledTemp);
        
        leds.update();
        push();
          translate(20, 20);
          leds.display();
        pop();
        if(online) leds.send();
        
        
      pop();
      stateLabel.setText("Next state in: " + (demoInterval-(millis() - demoTimestamp))/1000 +" seconds");
      if(millis() - demoTimestamp < demoInterval) return;
      demoTimestamp = millis();
      randomCheckTimestamp = millis();
      setState(CHECK);
    break;
    
    case FLOCKING:
      push();
        background(gray);
        
        ledTemp.push();
        ledTemp.beginDraw();
        ledTemp.background(black);
        flock.run();
        
        ledTemp.endDraw();
        ledTemp.pop();
        textPos++;
        textPos %= ledTemp.width;
        
        textOverlay();
        
        image(ledTemp, 20, 80, 320*2.99, 16*2.99);
        push();
          noFill();
          stroke(black);
          rect(20, 80, 320*2.99, 16*2.99);
        pop();
        leds.feed(ledTemp);
        
        leds.update();
        push();
          translate(20, 20);
          leds.display();
        pop();
        if(online) leds.send();
        
        
      pop();
      stateLabel.setText("Next state in: " + (demoInterval-(millis() - demoTimestamp))/1000 +" seconds");
      if(millis() - demoTimestamp < demoInterval) return;
      demoTimestamp = millis();
      randomCheckTimestamp = millis();
      setState(CHECK);
    break;
    
   }
}

void setState(int s) {
  state = s;
}
