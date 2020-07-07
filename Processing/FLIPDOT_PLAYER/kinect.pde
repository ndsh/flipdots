import org.openkinect.freenect.*;
import org.openkinect.processing.*;

Kinect kinect;
PImage kinectImg;
int kinectDistance = 590;
int kinectRange = 30;
float kinectAngle;
float kinectScale;

void readKinect() {
  
  kinectScale = 1 + 3 * setting;

  int[] rawDepth = kinect.getRawDepth();

  kinectImg.loadPixels();
  
  for (int i=0; i < rawDepth.length; i++) {
    int brightness = int( constrain( map( rawDepth[i], kinectDistance+kinectRange, kinectDistance-kinectRange, 0, 255 ), 0, 255 ));
    kinectImg.pixels[i] = color(brightness);
  }

  kinectImg.updatePixels();
  
  
  MovX.beginDraw();
  MovX.imageMode(CENTER);
  MovX.image(kinectImg, MovX.width/2, MovX.height/2, MovX.width * kinectScale, MovX.height * kinectScale);
  MovX.filter(GRAY);
  flipImage(MovX);
  MovX.endDraw();
  
  MovY.beginDraw();
  MovY.imageMode(CENTER);
  MovY.image(kinectImg, MovY.width/2, MovY.height/2, MovY.width * kinectScale, MovY.height * kinectScale);
  MovY.filter(GRAY);
  flipImage(MovY);
  MovY.endDraw();
  
  DITHER();
  B_to_DISPLAY();
  
  
  
  if(keyPressed) {
    
    switch(key) {
      case 'k':
        kinectAngle++;
        break;
      case 'i':
        kinectAngle--;
        break;
      case 'y':
        kinectDistance -= 5;
        break;
      case 'h':
        kinectDistance += 5;
        break;   
      case 'u':
        kinectRange += 2;
        break;
      case 'j':
        kinectRange -= 2;
        break;
    }
    
    kinectAngle = constrain(kinectAngle, 0, 30);
    kinectDistance = constrain(kinectDistance, 500, 2000);  
    kinectRange = constrain(kinectRange, 10, 300);  
    
    kinect.setTilt(kinectAngle);
  
    println("Tilt: " + kinectAngle + " / Distance: " + kinectDistance + " / Range: " + kinectRange);
  
  }
  
}
