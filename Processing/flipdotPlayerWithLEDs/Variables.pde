import processing.video.*;
import ch.bildspur.artnet.*;
import controlP5.*;

ArtNetClient artnet;
ControlP5 cp5;
Importer importer;
PFont europaGrotesk;
Dither d;
String ip = "2.0.0.3"; // flipdoteeny
//String ip = "2.0.0.2";
boolean switcher = false;
byte[] data = new byte[28];
float flipdotSize = 4;

String toSend = "";
color pixel = color(0);

PImage newFrame;
PImage staticImage;
PImage shrink;
PImage source;
PGraphics pg;
Movie flipdotMovie;
Movie ledMovie;
boolean online = false;
boolean dither = false;
boolean isPlaying = true;

FlipdotDisplay flipdots;
SchnickSchnack leds;
Panel panel;
//Dot dot;

int panels = 7;
int startPanel = 1; // flipdots cant have a 0 starting address

color black;
color white;
color gray = color(9);
float movieVolume = 0;
boolean stretchMode = true; // true = fit to width, false = no fitting. source must be 1:1 (that is 196x14 pixels)

StringList flipdotFiles = new StringList();
StringList ledFiles = new StringList();
int currentMovieFlipdots = 0;
int currentMovieLEDs = 0;

PApplet pa;

int panelLayout = 1; // horizontal
/*
  0
    ▀ ▀ ▀ ▀ ▀ ▀ ▀
    
  1
    ▀
    ▀
    ▀
    ▀
    ▀
    ▀
    ▀
   
  2 (1 == 2; 90° gedreht)
    █ █ █ █ █ █ █
  3
    █
    █
    █
    █
    █
    █
    █
*/

// SchnickSchnack LEDs
String[] routers = {"2.161.30.223", "2.12.4.156", "2.12.4.69"};
int[][] routing = {{0, 1, 5, 6}, {2, 3, 7, 8}, {4, 9}};
int maxBrightness = 120;
String[] scrollSource;
int currentScrollText = 0;
int scrollPosition = 0;
String usedFont = "Nobile-italic-16.vlw";
//String usedFont = "LKEuropaGroteskCity-MediumItalic-16.vlw";
