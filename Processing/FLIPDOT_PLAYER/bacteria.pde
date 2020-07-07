void bacteria() {
  C_clr();
  
  int bacteriaCount = int( 500 * (0.02+progress) * density * setting );
  for(int i=0; i<bacteriaCount; i++) {
    int x = int( C_W * map(noise(i,0,frameCount*0.003),0.3,0.6,0,1) );
    int y = int( C_H * map(noise(i,1,frameCount*0.003),0.3,0.6,0,1) );
    if( noise(i,2,frameCount*0.003) > 0.5 ) {
      drawLine(x,y,x+1,y);
    } else {
      drawLine(x,y,x,y+1);
    }
  }
  
  C_to_DISPLAY();
}
