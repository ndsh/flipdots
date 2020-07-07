int snakeMaxLength = 100;
int snakeLength = 6;
PVector[] snake = new PVector[snakeMaxLength+1];
PVector apple;
int dirx=1, diry=0;
boolean snakeDead = false;
int deathTime=0;

void setupSnake() {
  for(int i=0; i<snake.length; i++) {
    snake[i] = new PVector(int(C_W/2),int(C_H/2));
  }
  apple = new PVector(     2 * int(random(1,W)),     int(3 * int(random(1,H)) + random(0,2) )     );
}



void snake() {

  if(init) setupSnake();
  
  if(!snakeDead) {
    if(t % 2 == 0) {
      C_clr();
      
      for(int i=0; i<snakeLength; i++) {    
        if( abs(int(snake[i+1].x) - int(snake[i].x)) < 5 && abs(int(snake[i+1].y) - int(snake[i].y)) < 5 ) {
          drawLine(int(snake[i].x), int(snake[i].y), int(snake[i+1].x), int(snake[i+1].y));
        }
      }
      for(int i=snake.length-2; i>=0; i--) {
        snake[i+1].x = snake[i].x;
        snake[i+1].y = snake[i].y;
      }
      if( snakeCollision(int(snake[0].x+dirx), int(snake[0].y+diry)) ) {
        snakeDead = true;
        snakeLength = 3;
      } else {
        snake[0].x+=dirx;
        snake[0].y+=diry;
      }
      if(snake[0].x > C_W) snake[0].x = 0;
      if(snake[0].x < 0) snake[0].x = C_W;
      if(snake[0].y > C_H) snake[0].y = 0;
      if(snake[0].y < 0) snake[0].y = C_H;
      
      int ax;
      int ay;
      ax = int(apple.x);
      ay = int(apple.y);
      
      if(frameCount % 2 == 0) {
        drawLine(ax, ay, ax+1, ay);
        drawLine(ax, ay, ax, ay+1);
        drawLine(ax+1, ay, ax+1, ay+1);
        drawLine(ax, ay+1, ax+1, ay+1);
      }
      
      if( ( snake[0].x == ax && snake[0].y == ay ) || ( snake[0].x == ax+1 && snake[0].y == ay ) || ( snake[0].x == ax && snake[0].y == ay+1 ) || ( snake[0].x == ax+1 && snake[0].y == ay+1 ) ) {
        snakeLength++;
        if(snakeLength==snakeMaxLength) snakeLength=3;
        apple = new PVector(     2 * int(random(1,W)),     int(3 * int(random(1,H)) + random(0,2) )     );
      }
      
      C_to_DISPLAY();
    }
  } else {
    if(deathTime>100) {
      snakeDead = false;
      deathTime=0;
    } else {
      if(deathTime % 2 == 0) {
        TI = loadImage("snakeDeath1.png");
      } else {
        TI = loadImage("snakeDeath2.png");        
      }
      TI_to_DISPLAY();
      deathTime++;
    }
  }
  
  if(keyPressed) {  
    switch(key) {
      case 'w':
        dirx=0;
        if(diry!=1) diry=-1;
        break;
      case 's':
        dirx=0;
        if(diry!=-1) diry=1;
        break;
      case 'a':
        if(dirx!=1) dirx=-1;
        diry=0;
        break;
      case 'd':
        if(dirx!=-1) dirx=1;
        diry=0;
        break;   
    }
  }
  
}

boolean snakeCollision(int x, int y) {
  for(int i=1; i<snakeLength; i++) {    
    if( snake[i].x == x && snake[i].y == y ) {
      return true;
    }
  }
  return false;
}
