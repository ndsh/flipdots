
import processing.video.*;

int fileIndex = -1;
PVector imagePos = new PVector();
int imgtype = NONE;

Movie movie;
PImage theImage;
float x = 0;

long loadMillis = 0;
int loadDelay = 10;

void initImages() {
}


void drawImages() {
  float ratio;
  float sratio;
  switch(imgtype) {
    case IMAGE:
      ratio = (float) theImage.height / theImage.width;
      ratio *= (float)dot.x/(float)dot.y;
      sratio = (float) flipDotDisplayHeight / flipDotDisplayWidth;
      //pgOutput.tint(index);
      //pgDisplay.imageMode(CENTER);
      //pgDisplay.image(theImage, round(imagePos.x)+flipDotDisplayWidth/2.0, round(imagePos.y)+flipDotDisplayHeight/2.0, 
      //ratio > sratio ? flipDotDisplayWidth : flipDotDisplayHeight / ratio, ratio > sratio ? flipDotDisplayWidth * ratio : flipDotDisplayHeight);
      pgDisplay.imageMode(CORNER);
      pgDisplay.image(theImage, 0,0, 
      ratio > sratio ? flipDotDisplayWidth : flipDotDisplayHeight / ratio, ratio > sratio ? flipDotDisplayWidth * ratio : flipDotDisplayHeight);
      break;
    case VIDEO:
      ratio = (float) movie.height / movie.width;
      ratio *= (float)dot.x/(float)dot.y;
      sratio = (float) flipDotDisplayHeight / flipDotDisplayWidth;
      //pgOutput.tint(index);
      pgDisplay.imageMode(CENTER);
      movie.loadPixels();
      pgDisplay.image(movie, round(imagePos.x)+flipDotDisplayWidth/2.0, round(imagePos.y)+flipDotDisplayHeight/2.0, 
      ratio > sratio ? flipDotDisplayWidth : flipDotDisplayHeight / ratio, ratio > sratio ? flipDotDisplayWidth * ratio : flipDotDisplayHeight);
      break;
    default:
      break;
  }
}
void playImage() {
  fileIndex = 0;
  loadImage();
}

void nextImage() {
  fileIndex ++;
  if (!loadImage()) fileIndex --;
  else sendBytes = saveFrame;
}

void prevImage() {
  fileIndex --;
  if (!loadImage()) fileIndex ++;
}


void keyPressedImages() {
  switch(keyCode) {
    case LEFT:
      prevImage();
      break;
    case RIGHT:
      nextImage();
      break;
  }
  
}

void mouseDraggedImages() {
  /*
  float x = mouseX-pmouseX;
  float y = mouseY-pmouseY;
  
  imagePos.add(x/dot_right.width, y/dot_right.height, 0);
  */
}

boolean loadImage() {
  if (millis() - loadMillis < loadDelay) return false;
  loadMillis = millis();
  // we'll have a look in the data folder
  java.io.File folder = new java.io.File(sketchPath("images/"));
   
  String imgfiletypes = "jpeg, jpg, png, gif";
  String movfiletypes = "mov, mp4, m4v, avi";
  // list the files in the data folder, passing the filter as parameter
  String[] files = folder.list();
  ArrayList<String> filenames = new ArrayList<String>(); 
  for (int i=0; i<files.length; i++) {
    String[] f = split(files[i], '.');
    if (f.length > 1 && (imgfiletypes.indexOf(f[f.length-1].toLowerCase()) != -1 || movfiletypes.indexOf(f[f.length-1].toLowerCase()) != -1)) filenames.add(files[i]);
  }
  
  while (fileIndex<0) fileIndex += filenames.size();
  //print("fileIndex: "+fileIndex+", filenames.size(): "+filenames.size());
  if (fileIndex >= filenames.size()) {
    finish();
  }
  fileIndex %= filenames.size();
  //println(", % fileIndex: "+fileIndex);

  // get and display the number of jpg files
  String file = filenames.get(fileIndex);
  String[] f = split(file, '.');
  imgtype = NONE;
  if (f.length > 1 && imgfiletypes.indexOf(f[f.length-1].toLowerCase()) != -1) {
    theImage = loadImage(sketchPath("images/")+file);
    imgtype = IMAGE;
    //println(fileIndex + ": image: images/"+file);
  } else if (f.length > 1 && movfiletypes.indexOf(f[f.length-1].toLowerCase()) != -1) {
    movie = new Movie(this, sketchPath("images/")+file);
    movie.loop();
    imgtype = VIDEO;
    //println(fileIndex + ": video: images/"+file);
  }
  
  imagePos = new PVector();
  loadMillis = millis();
  return imgtype != NONE;
}

void movieEvent(Movie m) {
  m.read();
  m.updatePixels();
  //m.loadPixels();
}