import processing.video.*;
import ch.bildspur.artnet.*;
import controlP5.*;

ArtNetClient artnet;
ControlP5 cp5;
Importer importer;
Dither d;
String ip = "2.0.0.3"; // flipdoteeny
//String ip = "2.0.0.23"; // local
boolean switcher = false;
float flipdotSize = 4;

String toSend = "";
byte bytesSent = 0;
color pixel = color(0);

PImage newFrame;
PImage staticImage;
PImage shrink;
PImage source;
PGraphics pg;
PGraphics textOverlay;
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

int panelLayout = 1; // horizontal

long idleTime = 5000;
long idleTimestamp = 0;
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