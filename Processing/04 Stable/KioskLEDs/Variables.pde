import processing.video.*;
import ch.bildspur.artnet.*;
import controlP5.*;

ArtNetClient artnet;
ControlP5 cp5;
Importer importer;
PFont europaGrotesk;
Dither d;
//String ip = "2.0.0.3"; // flipdoteeny
//String ip = "2.0.0.23";
boolean switcher = false;

String toSend = "";
color pixel = color(0);

PImage newFrame;
PImage staticImage;
PImage shrink;
PImage source;
PGraphics pg;
Movie ledMovie;
boolean online = true;
boolean dither = false;
boolean isPlaying = true;
PFont monoFont;
PGraphics textOverlay;

SchnickSchnack leds;

color black;
color white;
color gray = color(9);
float movieVolume = 0;
boolean stretchMode = true; // true = fit to width, false = no fitting. source must be 1:1 (that is 196x14 pixels)

StringList ledFiles = new StringList();
int currentMovieLEDs = 0;

PApplet pa;

int textPos = 0;

CheckBox onlineCheckbox;
CheckBox isPlayingCheckbox;
CheckBox ditherCheckbox;
Textlabel stateLabel;

JSONObject json;
long followerTimestamp = 0;
long followerInterval = 120000;
int followers = 0;
PImage followerIcon;

// SchnickSchnack LEDs
String[] routers = {"2.161.30.223", "2.12.4.156", "2.12.4.69"};
int[][] routing = {{0, 1, 5, 6}, {2, 3, 7, 8}, {4, 9}};
int maxBrightness = 120;
String[] scrollSource;
int currentScrollText = 0;
float scrollPosition = 0;
//String usedFont = "Nobile-italic-16.vlw";
String usedFont = "OdinRounded-LightItalic-16.vlw";
String[] leaHashtags; // hashtags die lea per mail gesendet hat
String[] leaResults = {"a", "b"};
//String usedFont = "LKEuropaGroteskCity-MediumItalic-16.vlw";
