// Include libraries
#include <Adafruit_NeoPixel.h>

//#include <Ethernet.h>
//#include <EthernetUdp.h>
#include <NativeEthernet.h>
#include <NativeEthernetUdp.h>
#define UDP_TX_PACKET_MAX_SIZE 512 //increase UDP size
#include <Artnet.h>
#include <SPI.h>

// Pin definitions
#define LED_PIN 6 //30
#define RESET_PIN 12
#define NUM_STRIPS 1
#define HWSERIAL Serial1
#define HWSERIAL2 Serial2

// Variables
#define NUMPIXELS 8

// Read-only
const bool debug = false;

// Globals
boolean shieldAvailable = true;
boolean networkDataAvailable = false;
boolean linkEthernetStatus = false;
long millisRecheckNetwork = 0;
long millisKeepAlive = 0;
long delayNetworkCheck = 1000; // 10 sekunden ist auch okay, aber dauert lange zum reconnecten
byte ip[] = {2, 0, 0, 3};
byte broadcast[] = {2, 0, 0, 255}; // eigene ip
byte mac[] = {0x04, 0xE9, 0xE5, 0x00, 0x69, 0xEC};
uint16_t r;
boolean showStateTitle = false;
int prevState = 0;
byte dataPackage[32];
int pos = 0;
int u = 0;

// Millis Area
long millisLastTransmission = 0;
long delayTransmission = 0;
boolean dotsSwitcherState = false;

int idlePixel = 0;
boolean idleDirection = true;
int idleBrightness = 0;
int maxIdleBrightness = 50;

long millisEthernetStatusLink = 0;
long millisEthernetStatusDelay = 1000;
//int currentState = 0;


// Objects
//CRGB leds[NUMPIXELS];
Adafruit_NeoPixel pixels(NUMPIXELS, LED_PIN, NEO_GRB + NEO_KHZ800);
Artnet artnet;

// Arrays

// Temporär für Flipdigits
byte count = 0;
byte maximum = 127;
byte header[]= {0x80, 0x83};
byte header_norefresh[]= {0x80, 0x84};
byte header_refresh[]= {0x80, 0x82};
byte address13[] = {0x0D}; // panel 13
byte address14[] = {0x0E}; // panel 14
byte closure[]= {0x8F};
byte all_bright_2C[]= {0x80, 0x83, 0xFF, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x8F};
byte all_dark_2C[]=   {0x80, 0x83, 0xFF, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x8F};
byte mix_2C[]=        {0x80, 0x83, 0x0E, 0x06, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x8F};
byte f[]= {0x80, 0x89, 0xFF, 0x02, 0x8F};
byte e[]= {0x80, 0x89, 0xFF, 0x4F, 0x8F};
                                         
// Functions
float mapfloat(float x, float in_min, float in_max, float out_min, float out_max) {
  return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
}

void pin_reset() {
  #ifdef TEENSYDUINO
   SCB_AIRCR = 0x05FA0004;
  #endif
}

void setupEnv() {
  Serial.begin(115200);
  HWSERIAL.begin(57600);
  HWSERIAL2.begin(57600);
  //while (!Serial) ; // wait for serial port to connect. Needed for native USB port only

  Serial.println("/ / / / / / / / / / / / / / / / / / / / /");
  Serial.println("→ Setup");
  Serial.println("Artnet Control for Arduino is starting");
  Serial.println();
  Serial.println("Software: https://github.com/ndsh/living-the-city");


  // initialize sub-routines  
  pixels.begin();           // INITIALIZE NeoPixel strip object (REQUIRED)
  pixels.show();            
  artnet.begin(mac, ip);
  //artnet.setBroadcast(broadcast);

  attachInterrupt(RESET_PIN, pin_reset, FALLING);
  
  Serial.println("/ / / / / / / / / / / / / / / / / / / / /");
  Serial.println();
}

boolean checkEthernetLinkStatus() {
  linkEthernetStatus = true;
  /*
  if (Ethernet.hardwareStatus() == EthernetNoHardware) {
      Serial.println("Ethernet shield was not found.");
      linkEthernetStatus = false;
    }
  if (Ethernet.linkStatus() == LinkOFF) {
      Serial.println("Ethernet cable is not connected.");
      linkEthernetStatus = false;
  }
  */
  return linkEthernetStatus;
}

boolean checkEthernetLinkStatus_OLD() {
  linkEthernetStatus = false;
  /*
  if (Ethernet.linkStatus() == Unknown) {
      Serial.println("Link status unknown. Link status detection is only available with W5200 and W5500.");
    }
    else if (Ethernet.linkStatus() == LinkON) {
      //Serial.println("Link status: On");
      linkEthernetStatus = true;
    }
    else if (Ethernet.linkStatus() == LinkOFF) {
      //Serial.println("Link status: Off");
      linkEthernetStatus = false;
    }
    */
    return linkEthernetStatus;
}

void runIdleLEDAnimation() {
  if(idleDirection) {
    pixels.setPixelColor(idlePixel, pixels.Color(idleBrightness, idleBrightness, idleBrightness));
    if(idleBrightness < maxIdleBrightness) {
      idleBrightness++;
    } else if(idleBrightness >= maxIdleBrightness) {
      idlePixel++;
      idleBrightness = 0;
    }
    if(idlePixel >= NUMPIXELS) {
      idleDirection = false;
      idleBrightness = maxIdleBrightness;
      
    }
  } else {
    pixels.setPixelColor(idlePixel, pixels.Color(idleBrightness, idleBrightness, idleBrightness));
    if(idleBrightness > 0) {
      idleBrightness--;
    } else if(idleBrightness <= 0) {
      idlePixel--;
      idleBrightness = maxIdleBrightness;
    }
    if(idlePixel < 0) {
      idleDirection = true;
      idleBrightness = 0;      
      pixels.clear();
      pixels.show();
    }
  }
}


// Flipdigits examples
void runIdleFlipdigitSwitcher() {
  if(millis() - millisLastTransmission  > delayTransmission) {
    millisLastTransmission = millis();
    dotsSwitcherState = !dotsSwitcherState;
    if(dotsSwitcherState) Serial1.write(e, 5);
    else Serial1.write(f, 5);
   }
}

void runIdleFlipdigitCounter() {
  if(millis() - millisLastTransmission  > delayTransmission) {
    millisLastTransmission = millis();
    Serial.println("ciao");
    count++;
    if(count >= maximum) count = 0;
    Serial1.write(header, 3); 
    Serial1.write(count);
    Serial1.write(closure, 1); 
    //delay (200);
  }
}

// Flipdots examples
void runIdleFlipdotsSwitcher() {
  if(millis() - millisLastTransmission  > delayTransmission) {
    millisLastTransmission = millis();
    dotsSwitcherState = !dotsSwitcherState;
    //if(dotsSwitcherState) Serial1.write(all_dark_2C, 32); 
    //else Serial1.write(all_bright_2C, 32); 
   }
}

void runFlipdotsDataSingleUniverse() {
  // single universe with 392 bytes
    r = artnet.read();
    u = 0; // our universe or frame
    //u*28+x
    for(int x = 0; x<392; x++) {
      pos = x - 28 * (x / 28); // modulo funktion umgeschrieben! performance.
      dataPackage[pos+3] = artnet.getDmxFrame()[x];
      //if(x % 28 == 0 && x != 0) {
      if(x == 27) {
        u = 1;
        dataPackage[0] = 0x80;
        dataPackage[1] = 0x84;
        dataPackage[2] = u & 0xFF;
        dataPackage[31] = 0x8F;
        Serial1.write(dataPackage, 32);
      } else if(x == 55) {
        u = 2;
        dataPackage[0] = 0x80;
        dataPackage[1] = 0x84;
        dataPackage[2] = u & 0xFF;
        dataPackage[31] = 0x8F;
        Serial1.write(dataPackage, 32);
      } else if(x == 83) {
        u = 3;
        dataPackage[0] = 0x80;
        dataPackage[1] = 0x84;
        dataPackage[2] = u & 0xFF;
        dataPackage[31] = 0x8F;
        Serial1.write(dataPackage, 32);
      } else if(x == 111) {
        u = 4;
        dataPackage[0] = 0x80;
        dataPackage[1] = 0x84;
        dataPackage[2] = u & 0xFF;
        dataPackage[31] = 0x8F;
        Serial1.write(dataPackage, 32);
      } else if(x == 139) {
        u = 5;
        dataPackage[0] = 0x80;
        dataPackage[1] = 0x84;
        dataPackage[2] = u & 0xFF;
        dataPackage[31] = 0x8F;
        Serial1.write(dataPackage, 32);
      } else if(x == 167) {
        u = 6;
        dataPackage[0] = 0x80;
        dataPackage[1] = 0x84;
        dataPackage[2] = u & 0xFF;
        dataPackage[31] = 0x8F;
        Serial1.write(dataPackage, 32);
      } else if(x == 195) {
        u = 7;
        dataPackage[0] = 0x80;
        dataPackage[1] = 0x84;
        dataPackage[2] = u & 0xFF;
        dataPackage[31] = 0x8F;
        Serial1.write(dataPackage, 32);
      } else if(x == 223) {
        u = 8;
        dataPackage[0] = 0x80;
        dataPackage[1] = 0x84;
        dataPackage[2] = u & 0xFF;
        dataPackage[31] = 0x8F;
        Serial1.write(dataPackage, 32);
      } else if(x == 251) {
        u = 9;
        dataPackage[0] = 0x80;
        dataPackage[1] = 0x84;
        dataPackage[2] = u & 0xFF;
        dataPackage[31] = 0x8F;
        Serial2.write(dataPackage, 32);
      } else if(x == 279) { 
        u = 10;
        dataPackage[0] = 0x80;
        dataPackage[1] = 0x84;
        dataPackage[2] = u & 0xFF;
        dataPackage[31] = 0x8F;
        Serial2.write(dataPackage, 32);
      } else if(x == 307) {
        u = 11;
        dataPackage[0] = 0x80;
        dataPackage[1] = 0x84;
        dataPackage[2] = u & 0xFF;
        dataPackage[31] = 0x8F;
        Serial2.write(dataPackage, 32);
      } else if(x == 335) {
        u = 12;
        dataPackage[0] = 0x80;
        dataPackage[1] = 0x84;
        dataPackage[2] = u & 0xFF;
        dataPackage[31] = 0x8F;
        Serial2.write(dataPackage, 32);
      } else if(x == 364) {
        u = 13;
        dataPackage[0] = 0x80;
        dataPackage[1] = 0x84;
        dataPackage[2] = u & 0xFF;
        dataPackage[31] = 0x8F;
        Serial2.write(dataPackage, 32);
      } else if(x == 391) {
        u = 14;
        dataPackage[0] = 0x80;
        dataPackage[1] = 0x84;
        dataPackage[2] = u & 0xFF;
        dataPackage[31] = 0x8F;
        Serial2.write(dataPackage, 32);
      }
      /*
      if(pos == 0 && x != 0) {
        u++;
        dataPackage[0] = 0x80;
        dataPackage[1] = 0x84;
        dataPackage[2] = u & 0xFF;
        dataPackage[31] = 0x8F;
        if(u <= 8) Serial1.write(dataPackage, 32);
        else Serial2.write(dataPackage, 32);
      } else if(x == 391) { // letztes bit
        u++;
        dataPackage[0] = 0x80;
        dataPackage[1] = 0x84;
        dataPackage[2] = u & 0xFF;
        dataPackage[31] = 0x8F;
        if(u <= 8) Serial1.write(dataPackage, 32);
        else Serial2.write(dataPackage, 32);
      }
      */
    }
    
}

void runFlipdotsDataMultiUniverse() {
  // per universe (from 1 - 14)
  // mit data packing
  r = artnet.read();
  dataPackage[0] = 0x80;
  dataPackage[1] = 0x84;
  dataPackage[2] = artnet.getUniverse() & 0xFF;
  for(int x = 0; x<28; x++) {
    dataPackage[x+3] = artnet.getDmxFrame()[x];
  }
  dataPackage[31] = 0x8F;
  if(artnet.getUniverse() <= 8) {
    Serial1.write(dataPackage, 32);
  } else {
    Serial2.write(dataPackage, 32);
  }  

}

void runFlipdotsDataMultiUniverse____OLD() {
  // per universe (from 1 - 14)
  r = artnet.read();
  if(artnet.getUniverse() <= 8) {
    Serial1.write(header_norefresh, 2); 
    Serial1.write(artnet.getUniverse() & 0xFF);
    for(int x = 0; x<28; x++) {
      // fehlerquelle: jedes bit wird einzeln geschickt. DAS GEHT BESSER!
      Serial1.write(artnet.getDmxFrame()[x]); // farben umkehren
    }
    Serial1.write(closure, 1); 
  } else {
    Serial2.write(header_norefresh, 2); 
    Serial2.write(artnet.getUniverse() & 0xFF);
    for(int x = 0; x<28; x++) {
      // fehlerquelle: jedes bit wird einzeln geschickt. DAS GEHT BESSER!
      Serial2.write(artnet.getDmxFrame()[x]); // farben umkehren
    }
    Serial2.write(closure, 1); 
  }
}

void refreshFlipdots() {
  Serial1.write(header_refresh, 2);
  Serial1.write(closure, 1);

  Serial2.write(header_refresh, 2);
  Serial2.write(closure, 1);
}
