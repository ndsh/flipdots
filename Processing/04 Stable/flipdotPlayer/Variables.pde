import processing.video.*;
import ch.bildspur.artnet.*;
import controlP5.*;

ArtNetClient artnet;
ControlP5 cp5;
Importer importer;
Dither d;
//String ip = "2.0.0.3"; // flipdoteeny
//String ip = "2.0.0.23"; // local, ndsh macbook
String ip = "2.0.0.24"; // local, iMac
boolean switcher = false;
float flipdotSize = 4.95;

String toSend = "";
int bytesSent = 0; // zahl am ende durch 7 teilen, weil nicht bits
int bytesTotal = 0;
color pixel = color(0);

PImage newFrame;
PImage staticImage;
PImage shrink;
PImage source;
PGraphics pg;
PGraphics textOverlay;
PGraphics sendDataViz;
Movie myMovie;
PFont font;
boolean online = true;
boolean dither = false;
boolean isPlaying = true;

FlipdotDisplay flipdots;
Panel panel;
//Dot dot;

boolean sendMode = true; // false = one panel is one universe / true = one universe is all data
byte[] flipdotData = new byte[392]; // 28 bytes per 14 pcbs auf flipdots = 392 bytes total

int panels = 7;
int startPanel = 1; // flipdots cant have a 0 starting address

color black;
color white;
color gray = color(9);
float movieVolume = 0;
boolean stretchMode = true; // true = fit to width, false = no fitting. source must be 1:1 (that is 196x14 pixels)

StringList movieFiles = new StringList();
int currentMovie = 0;

PApplet pa;

// CP5
CheckBox onlineCheckbox;
CheckBox isPlayingCheckbox;
CheckBox ditherCheckbox;
CheckBox stretchModeCheckbox;
Textlabel stateLabel;
Textlabel fileLabel;
Textlabel dynamicLabel;
Textlabel overviewLabel;
Textlabel importerLabel;
Textlabel movieTimeLabel;
Textlabel movieTimeRestLabel;
Textlabel movieTimePercentageLabel;
Textlabel currentBytesLabel;

Textlabel stateVisualOutputLabel;
Textlabel sourceFlipdotsLabel;
Textlabel virtualFlipdotsLabel;
Textlabel consoleLabel;
Textlabel networkLabel;
Textlabel stateControlLabel;
Textlabel panelActivityLabel;

int panelLayout = 1; // horizontal

long idleTime = 5000;
long idleTimestamp = 0;

boolean refreshUI = false;
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
 
 // Grid Variables
float h24 = 28.125;
float h12 = 56.25;
float h8 = 84.375;
float h6 = 112.5;
float h4 = 168.75;
float h3 = 225;
float h2 = 337.5;

float w12 = 100;
float w6 = 200;
float w4 = 300;
float w3 = 400;
