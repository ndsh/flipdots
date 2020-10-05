class Dither {
  PGraphics pg;
  PGraphics temp;
  PGraphics result;
  PImage src;
  PImage p; 
  int mode = 0; // 0 floyd, 1 bayer, 2 atkinson, 3 random
  
  // Bayer matrix
  int[][] matrix = {   
    {1, 9, 3, 11}, 
    {13, 5, 15, 7}, 
    {4, 12, 2, 10}, 
    {16, 8, 14, 6}
  };
  float mratio = 1.0 / 17;
  float mfactor = 255.0 / 5;
  
  Dither() {
    pg = createGraphics(196, 14);
  }
  
  Dither(String s) {
    p = loadImage(s);
    src = p.copy();
    pg = createGraphics(p.width, p.height);
  }
  
  Dither(int w, int h) {
    pg = createGraphics(w, h);
  }
  
  void feed(PImage p) {
    src = p;
  }
  
  void setCanvas(int w, int h) {
    pg = createGraphics(w, h);
  }
  
  void setMode(int m) {
    mode = m;
  }
  
  void setMode(String s) {
    if(s.equals("FLOYD")) mode = 0;
    else if(s.equals("BAYER")) mode = 1;
    else if(s.equals("ATKINSON")) mode = 2;
    else if(s.equals("RAND")) mode = 3;
  }
  
  PGraphics dither() {
    if(mode == 0) return floyd_steinberg();
    else if(mode == 1) return bayer();
    else if(mode == 2) return atkinson();
    else if(mode == 3) return rand();
    return null;
  }
  
  PGraphics dither(int m) {
    if(m == 0) return floyd_steinberg();
    else if(m == 1) return bayer();
    else if(m == 2) return atkinson();
    else if(m == 3) return rand();
    return null;
  }
  
  
  PGraphics floyd_steinberg() {
    push();
    colorMode(RGB, 255, 255, 255);
    temp = createGraphics(src.width, src.height);
    temp.beginDraw();
    temp.image(src, 0, 0);
    temp.endDraw();
    
    result = createGraphics(temp.width, temp.height);
    result.noSmooth();
    result.noStroke();
    result.beginDraw();
    
    int s = 1;
    temp.loadPixels();
    result.loadPixels();
    for (int x = 0; x<temp.width; x++) {
      for (int y = 0; y<temp.height; y++) {
        color oldpixel = temp.get(x, y);
        color newpixel = findClosestColor(oldpixel);
        float quant_error = brightness(oldpixel) - brightness(newpixel);
        temp.pixels[y*temp.width+x] = newpixel;
        temp.set(x+s, y, color(brightness(temp.get(x+s, y)) + 7.0/16 * quant_error) );
        temp.set(x-s, y+s, color(brightness(temp.get(x-s, y+s)) + 3.0/16 * quant_error) );
        temp.set(x, y+s, color(brightness(temp.get(x, y+s)) + 5.0/16 * quant_error) );
        temp.set(x+s, y+s, color(brightness(temp.get(x+s, y+s)) + 1.0/16 * quant_error));
        result.pixels[y*result.width+x] = newpixel;
      }
    }
    temp.updatePixels();
    result.updatePixels();
    result.endDraw();
    pop();
    return result;
  }
  
  // ordered
  PGraphics bayer() {
    push();
    colorMode(RGB, 255, 255, 255);
    temp = createGraphics(src.width, src.height);
    temp.beginDraw();
    temp.image(src, 0, 0);
    temp.endDraw();
    
    result = createGraphics(temp.width, temp.height);
    result.noSmooth();
    result.beginDraw();

    // Scan image
    temp.loadPixels();
    result.loadPixels();
    int s = 1;
    for (int x = 0; x < temp.width; x+=s) {
      for (int y = 0; y < temp.height; y+=s) {
        // Calculate pixel
        color oldpixel = temp.get(x, y);
        color value = color( brightness(oldpixel) + (mratio*matrix[x%4][y%4] * mfactor));
        color newpixel = findClosestColor(value);
        temp.pixels[y*temp.width+x] = newpixel;
        result.pixels[y*result.width+x] = newpixel;
        
      }
    }
    temp.loadPixels();
    result.updatePixels();
    result.endDraw();
    
    pop();
    return result;
  }
  
  PGraphics atkinson() {
    push();
    colorMode(RGB, 255, 255, 255);
    temp = createGraphics(src.width, src.height);
    temp.beginDraw();
    temp.image(src, 0, 0);
    temp.endDraw();
    
    result = createGraphics(pg.width, pg.height);
    result.noSmooth();
    result.beginDraw();
    // Init canvas
    //result.background(0,0,0);
    // Define step
    int s = 4;
    
    // Scan image
    temp.loadPixels();
    result.loadPixels();
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
        //result.stroke(newpixel);   
        //result.point(x,y);
        result.pixels[y*result.width+x] = newpixel;
      }
    }
    temp.updatePixels();
    result.updatePixels();
    result.endDraw();
    pop();
    return result;
    
  }
  
  PGraphics rand() {
    push();
    colorMode(RGB, 255, 255, 255);
    temp = createGraphics(src.width, src.height);
    temp.beginDraw();
    temp.image(src, 0, 0);
    temp.endDraw();
    
    result = createGraphics(temp.width, temp.height);
    result.noSmooth();
    result.beginDraw();
    //pg.background(255,0,0);
    temp.loadPixels();
    result.loadPixels();
    int s = 1;
    for (int x = 0; x < temp.width; x+=s) {
      for (int y = 0; y < temp.height; y+=s) {
        color oldpixel = temp.get(x, y);
        color newpixel = findClosestColor( color(brightness(oldpixel) + random(-64,64)) );      
        //temp.set(x, y, newpixel);
        temp.pixels[y*result.width+x] = newpixel;
        //result.stroke(newpixel);      
        //result.point(x,y);
        result.pixels[y*result.width+x] = newpixel;
      }
    }
    temp.updatePixels();
    result.updatePixels();
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
