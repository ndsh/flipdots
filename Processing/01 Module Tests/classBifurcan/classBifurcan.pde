OpenSimplexNoise noise = new OpenSimplexNoise();
float t;
int numFrames = 360;
boolean recording = false;

float n = 30;
float side;
float radius = 150;
float noiseRadius = 2;
float xb, yb;



void setup() {
  size(500, 500);
  noFill();
  side = width/n;
  frameRate(260);
}

void draw() {
  background(0);
  t = map(frameCount-1, 0, numFrames, 0, 1);
  
  xb = width/2*(float)noise.eval(0, noiseRadius*cos(TWO_PI*t), noiseRadius*sin(TWO_PI*t))+width/2;
  yb = height/2*(float)noise.eval(10000, noiseRadius*cos(TWO_PI*t), noiseRadius*sin(TWO_PI*t))+height/2;
  
  for(int y=0;y<n;y++) {
    for(int x=0;x<n;x++) {
      stroke(255);
      
      radius = 100*(float)noise.eval(x*side*0.01, y*side*0.01, noiseRadius*cos(TWO_PI*t), noiseRadius*sin(TWO_PI*t))+100;
      
      if(dist(x*side, y*side, xb, yb) < radius) {
        line(x*side, y*side, (x+1)*side, (y+1)*side);
      } else {
        line((x+1)*side, y*side, x*side, (y+1)*side);
      }
      
    }
  }
  
  if(recording) {
    saveFrame("###.png");
    
    if(frameCount==numFrames)
      exit();
  }
}
