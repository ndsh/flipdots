int cellPointsCount = 8;
PVector[] cellPoints = new PVector[cellPointsCount+1];
  
void cell() {
  C_clr();
  float pos = frameCount * 0.025;
  for(int i=0; i<=cellPointsCount; i++) {
    float sin = sin(TWO_PI * i / cellPointsCount + pos);
    float cos = cos(TWO_PI * i / cellPointsCount + pos);
    cellPoints[i] = new PVector(
      C_W/2  +  C_W * 0.4 * sin  +  C_W * 0.15 * map(noise(sin*5*setting, 0, pos), 0.2, 0.75, -1, 1),
      C_H/2  +  C_H * 0.4 * cos  +  C_H * 0.15 * map(noise(sin*5*setting, 1, pos), 0.2, 0.75, -1, 1)
    );
  }  
  drawWireframe();
  
  C_to_DISPLAY();
}


void drawWireframe() {
  for(int i=0; i<cellPointsCount; i++) {
    drawLine(
      int(cellPoints[i].x),
      int(cellPoints[i].y),
      int(cellPoints[i+1].x),
      int(cellPoints[i+1].y)
    );
  }
  drawLine(
    int(cellPoints[cellPointsCount-1].x),
    int(cellPoints[cellPointsCount-1].y),
    int(cellPoints[0].x),
    int(cellPoints[0].y)
  );
}
