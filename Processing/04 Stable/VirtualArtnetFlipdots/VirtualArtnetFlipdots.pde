import ch.bildspur.artnet.*;
ArtNetClient artnet;

String toSend = "";
color pixel = color(0);

PGraphics pg;

void setup() {
  size(200, 550);
  pg = createGraphics(28, 98);
  pg.beginDraw();
  pg.background(0);
  pg.endDraw();
  
  surface.setLocation(1000, 0);
  colorMode(HSB, 360, 100, 100);
  
  initVariables();
  flipdots = new FlipdotDisplay(panels, panelLayout, 10, 10);

  // create artnet client
  artnet = new ArtNetClient();
  artnet.start();
}

void draw() {
  if(!receptionMode) { // one panel = one universe
    for(int i = 1; i<=14; i++) {
      byte[] data = artnet.readDmxData(0, i);      
      for(int x = 0; x<28; x++) {;
        String binary = binary(data[x] & 0xFF,7);
        String output = new StringBuilder(binary).reverse().toString();
        
        for(int y = 0; y<output.length(); y++) {
          int val = Integer.parseInt(String.valueOf(output.charAt(y)));
          if(val == 1) pg.set(x, (i-1)*7+y, white);
          else pg.set(x, (i-1)*7+y, black);
        }
      }
    }    
  } else {
    byte[] data = artnet.readDmxData(0, 0);
    int u = 0; // our universe or frame
    for(int x = 0; x<392; x++) {
      if(x % 28 == 0) {
        u++;
        //println("u= "+ u + " x= " + x);
      }
      
      String binary = binary(data[x] & 0xFF,7);
      String output = new StringBuilder(binary).reverse().toString();
      for(int y = 0; y<output.length(); y++) {
        int val = Integer.parseInt(String.valueOf(output.charAt(y)));
        
        if(val == 1) pg.set(x%28, (u-1)*7+y, white);
        else pg.set(x%28, (u-1)*7+y, black);

      }
    }
  }
  background(gray);
  //image(pg, 0, 0);
  
  flipdots.feed(pg);
  flipdots.update();
  
  flipdots.display();

  
}
