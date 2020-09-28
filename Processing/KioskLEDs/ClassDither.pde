class Dither {
  PGraphics pg;
  PImage src;
  PImage p; 
  
  // Bayer matrix
  int[][] matrix = {   
    {
      1, 9, 3, 11
    }
    , 
    {
      13, 5, 15, 7
    }
    , 
    {
      4, 12, 2, 10
    }
    , 
    {
      16, 8, 14, 6
    }
  };
  float mratio = 1.0 / 17;
  float mfactor = 255.0 / 5;
  
  Dither() {
    pg = createGraphics(196, 14);
    // if colorMode is on HSB, input should be true
    //src = loadImage("medusa.jpg");
    //res = createImage(src.width, src.height, RGB);
  }
  
  Dither(String s) {
    p = loadImage(s);
    pg = createGraphics(p.width, p.height);
    
    //src = loadImage("medusa.jpg");
    //res = createImage(src.width, src.height, RGB);
  }
  
  void feed(PImage p) {
    src = p;
  }
  
  void setCanvas(int x, int y) {
    pg = createGraphics(x, y);
  }
  
  
  
  PGraphics floyd_steinberg() {
    push();
    colorMode(RGB, 255, 255, 255);
    PGraphics temp = createGraphics(src.width, src.height);
    temp.beginDraw();
    temp.image(src, 0, 0);
    temp.endDraw();
    
    PGraphics result = createGraphics(temp.width, temp.height);
    result.noSmooth();
    result.noStroke();
    result.beginDraw();
    //pg.background(0);
    
    //result.background(255, 0, 0);
    //pg.noStroke();
    
    int s = 1;
    for (int x = 0; x < temp.width; x+=s) {
      for (int y = 0; y < temp.height; y+=s) {
        color oldpixel = temp.get(x, y);
        color newpixel = findClosestColor(oldpixel);
        float quant_error = brightness(oldpixel) - brightness(newpixel);
        temp.set(x, y, newpixel);
  
        temp.set(x+s, y, color(brightness(temp.get(x+s, y)) + 7.0/16 * quant_error) );
        temp.set(x-s, y+s, color(brightness(temp.get(x-s, y+s)) + 3.0/16 * quant_error) );
        temp.set(x, y+s, color(brightness(temp.get(x, y+s)) + 5.0/16 * quant_error) );
        temp.set(x+s, y+s, color(brightness(temp.get(x+s, y+s)) + 1.0/16 * quant_error));
  
        
        result.stroke(newpixel);      
        result.point(x,y);
        
      }
    }
    result.endDraw();
    pop();
    return result;
  }
  
  // ordered
  PGraphics bayer() {
    push();
    colorMode(RGB, 255, 255, 255);
    PGraphics temp = createGraphics(src.width, src.height);
    temp.beginDraw();
    temp.image(src, 0, 0);
    temp.endDraw();
    
    PGraphics result = createGraphics(temp.width, temp.height);
    result.noSmooth();
    result.beginDraw();

    // Scan image
    int s = 1;
    for (int x = 0; x < temp.width; x+=s) {
      for (int y = 0; y < temp.height; y+=s) {
        // Calculate pixel
        color oldpixel = temp.get(x, y);
        color value = color( brightness(oldpixel) + (mratio*matrix[x%4][y%4] * mfactor));
        color newpixel = findClosestColor(value);
        
        temp.set(x, y, newpixel);
  
  
        // Draw
        result.stroke(newpixel);   
        result.point(x, y);
      }
    }
    result.endDraw();
    pop();
    return result;
  }
  
  PGraphics atkinson() {
    push();
    colorMode(RGB, 255, 255, 255);
    PGraphics temp = createGraphics(src.width, src.height);
    temp.beginDraw();
    temp.image(src, 0, 0);
    temp.endDraw();
    
    PGraphics result = createGraphics(pg.width, pg.height);
    result.noSmooth();
    result.beginDraw();
    // Init canvas
    //result.background(0,0,0);
    // Define step
    int s = 4;
    
    // Scan image
    for (int x = 0; x < temp.width; x+=s) {
      for (int y = 0; y < temp.height; y+=s) {
        // Calculate pixel
        color oldpixel = temp.get(x, y);
        color newpixel = findClosestColor(oldpixel);
        float quant_error = brightness(oldpixel) - brightness(newpixel);
        temp.set(x, y, newpixel);
        
        // Atkinson algorithm http://verlagmartinkoch.at/software/dither/index.html
        temp.set(x+s, y, color(brightness(src.get(x+s, y)) + 1.0/8 * quant_error) );
        temp.set(x-s, y+s, color(brightness(src.get(x-s, y+s)) + 1.0/8 * quant_error) );
        temp.set(x, y+s, color(brightness(src.get(x, y+s)) + 1.0/8 * quant_error) );
        temp.set(x+s, y+s, color(brightness(src.get(x+s, y+s)) + 1.0/8 * quant_error));
        temp.set(x+2*s, y, color(brightness(src.get(x+2*s, y)) + 1.0/8 * quant_error));
        temp.set(x, y+2*s, color(brightness(src.get(x, y+2*s)) + 1.0/8 * quant_error));
        
        // Draw
        result.stroke(newpixel);   
        result.point(x,y);
      }
    }
    result.endDraw();
    pop();
    return result;
    
  }
  
  PGraphics rand() {
    push();
    colorMode(RGB, 255, 255, 255);
    PGraphics temp = createGraphics(src.width, src.height);
    temp.beginDraw();
    temp.image(src, 0, 0);
    temp.endDraw();
    
    PGraphics result = createGraphics(temp.width, temp.height);
    result.noSmooth();
    result.beginDraw();
    //pg.background(255,0,0);
    int s = 1;
    for (int x = 0; x < temp.width; x+=s) {
      for (int y = 0; y < temp.height; y+=s) {
        color oldpixel = temp.get(x, y);
        color newpixel = findClosestColor( color(brightness(oldpixel) + random(-64,64)) );      
        temp.set(x, y, newpixel);
        result.stroke(newpixel);      
        result.point(x,y);
      }
    }
    result.endDraw();   
    pop();
    return result;
  }
  
  // Threshold function
  color findClosestColor(color c) {
    color r;    
    if (brightness(c) < 128) {
      r = color(0);
    } else {
      r = color(255);
    }
    return r;
  }

}
