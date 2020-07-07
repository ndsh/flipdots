void worm() {
  if(init) setupSnake();
  C_clr();
  int wormLength = 12 * cols;
  int wormRange = 6 * cols;
  for(int i=0; i<wormLength; i++) {
    drawLine(int(snake[i].x), int(snake[i].y), int(snake[i+1].x), int(snake[i+1].y));
  }
  for(int i=snake.length-2; i>=0; i--) {
    snake[i+1].x = snake[i].x;
    snake[i+1].y = snake[i].y;
  }
  dirx = int(-wormRange/2 + random(wormRange));
  diry = int(-wormRange/2 + random(wormRange));
  snake[0].x+=dirx;
  snake[0].y+=diry;
  if(snake[0].x > C_W) snake[0].x = 2 * C_W - snake[0].x;
  if(snake[0].x < 0) snake[0].x *= -1;
  if(snake[0].y > C_H) snake[0].y = 2 * C_H - snake[0].y;
  if(snake[0].y < 0) snake[0].y *= -1;
  
  C_to_DISPLAY();
}
