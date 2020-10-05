[![](https://img.shields.io/badge/using-Processing-brightgreen.svg?style=flat-square&color=000000)](http://processing.org/)

![](assets/flip-dot-board-xy5-1.png)

# Processing Flipdots Controller

Everything you ever wanted to know about Flipdots in one compact repository!

**Contents**



- Generate a PImage / PGraphics
- Convert it into a bytestream
- Send via UDP (in times of corona it is important to not shake hands!)



## Notes
- AlfaZeta XY5 Boards are 24x14
- RS485 serial port interface


## Arduino Notes
// 0x80 beginning 
//___________________
// 0x81 - 112 bytes / no refresh / C+3E
// 0x82 - refresh
// 0x83 - 28 bytes of data / refresh / 2C
// 0x84 - 28 bytes of data / no refresh / 2C
// 0x85 - 56 bytes of data / refresh / C+E
// 0x86 - 56 bytes of data / no refresh / C+E
// ---------------------------------------
// address or 0xFF for all
// data ... 1 to nuber of data bytes
// 0x8F end

// panel's speed setting: 1-OFF 2-ON 3 - ON
// panel address : 1 (8 pos dip switch: 1:on 2 -8: off)

// I was sng RS485 Breakout and Duemilanova connected in the following way:
// [Panel]  [RS485]  [Arduino]
// 485+       A  
// 485-       B
//          3-5V    5V
//          RX-I    TX
//          TX-O    Not connected
//           RTS    5V
//           GND    GND

// these are blank transmissions for various controller configurations: CE - one controller + one extension, 2C - two controllers (the most popular), C3E - one controller + threee extensions
// you can use them by putting data bytes 