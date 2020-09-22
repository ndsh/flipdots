import ch.bildspur.artnet.*;

ArtNetClient artnet;
byte[] dmxData = new byte[28];

void setup()
{
  size(500, 250);

  artnet = new ArtNetClient();
  artnet.start();
}

void draw()
{
  // read rgb color from the first 3 bytes
  byte[] data = artnet.readDmxData(0, 0);
  //println(data[0] & 0xFF);
  for(int i = 0; i<28; i++) {
    print((data[i] & 0xFF)+ " ");
  }
  println("------");
   
}
