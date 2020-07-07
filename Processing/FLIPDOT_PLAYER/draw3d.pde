float[][] points3d = new float[100][3];
int[][] points2d = new int[100][2];

int pointsCount = 16;

float rotx, roty, rotz, rotxx, rotyy, rotzz, rotxxx, rotyyy, rotzzz;

float angle;
int size = 3*cols;

int[][] cube = {
  { -size, -size, -size },
  { size, -size, -size },
  { size, size, -size },
  { -size, size, -size },
  { -size, -size, -size },
  
  { -size, -size, size },
  { size, -size, size },
  { size, size, size },
  { -size, size, size },
  { -size, -size, size },
  
  { -size, size, size },
  { -size, size, -size },
  { size, size, -size },
  { size, size, size },
  { size, -size, size },
  { size, -size, -size },
  
};

void draw_3d() {
  C_clr();
  
  angle += 0.1 + 3 * setting;
  float radiansX = radians(angle);
  float radiansY = radians(angle);
  float radiansZ = radians(angle);
  
  for (int i = 0; i < pointsCount; i++) {

    //rotateY
    rotz = cube[i][2] * cos(radiansY) - cube[i][0] * sin(radiansY);
    rotx = cube[i][2] * sin(radiansY) + cube[i][0] * cos(radiansY);
    roty = cube[i][1];
    
    //rotateX
    rotyy = roty * cos(radiansX) - rotz * sin(radiansX);
    rotzz = roty * sin(radiansX) + rotz * cos(radiansX);
    rotxx = rotx;
    
    //rotateZ
    rotxxx = rotxx * cos(radiansZ) - rotyy * sin(radiansZ);
    rotyyy = rotxx * sin(radiansZ) + rotyy * cos(radiansZ);
    rotzzz = rotzz;

    //orthographic projection
    //rotxxx = rotxxx + C_W/2;
    //rotyyy = rotyyy + C_H/2;

    //perspective projection
    float d = 30;
    rotxxx = rotxxx * d / (d - rotzzz) + C_W/2;
    rotyyy = rotyyy * d / (d - rotzzz) + C_H/2;

    points2d[i][0] = int(rotxxx);
    points2d[i][1] = int(rotyyy);

   }
   
  for(int i=1; i<pointsCount; i++) {
    
    int Sx = points2d[i-1][0];
    int Sy = points2d[i-1][1];
    int Ex = points2d[i][0];
    int Ey = points2d[i][1];
        
    if(Sx<=0) { Sx=0; } 
    if(Sx>=127) { Sx=C_W; }
    
    if(Sy<=0) { Sy=0; }
    if(Sy>=63) { Sy=C_H; }
    
    if(Ex<=0) { Ex=0; }
    if(Ex>=127) { Ex=C_W; }
    
    if(Ey<=0) { Ey=0; }
    if(Ey>=63) { Ey=C_H; }
    
    drawLine(Sx, Sy, Ex, Ey);
    
  }
  
  C_to_DISPLAY();

}
