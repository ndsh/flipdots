/*
 * todo
 * https://forum.pjrc.com/threads/52512-External-RESET-button-Teensy-3-2
 * reset watchdog bauen
 * linkStatus = ohne kabel oder keine verbindung --> gelbe led
 * linkStatus = verbindung hergestellt --> grün
 * 
 * spezielles usb kabel bauen: https://www.pjrc.com/teensy/external_power.html
 * reset button
 * 
 * verbindungsabbrüche = warum?
 * https://github.com/ndsh/flipdigits/blob/master/Arduino/01_getStarted/01_getStarted.ino
 * 
 * modified the Artnet library from natcl
 * Artnet.h:
 * #else
    #include <NativeEthernet.h>
    #include <NativeEthernetUdp.h>
    //#include <Ethernet.h>
    //#include <EthernetUdp.h>
#endif
 */
#include "Helper.h"
#include "StateMachine.h"


void setup() {
  setupEnv();
}

void loop() {
  stateMachine();
}


/* fehlerquelle
 *  
127 127 111 115 120 125 125 125 125 124 113 69 125 125 125 125 127 127 96 111 103 119 119 115 120 127 127 127 ---
127 127 111 115 120 125 125 125 125 124 113 69 125 125 125 125 127 127 96 111 103 119 119 115 120 127 127 127 ---
127 127 111 115 120 125 125 125 125 124 113 69 125 125 125 125 127 127 96 111 103 119 119 115 120 127 127 127 ---
127 127 127 127 63 31 103 99 31 127 127 127 127 127 127 127 127 115 3 59 27 27 3 39 63 127 127 127 ---
127 127 111 115 120 125 125 125 125 124 113 69 125 125 125 125 127 127 96 111 103 119 119 115 120 127 127 127 ---
127 127 111 115 120 125 125 125 125 124 113 69 125 125 125 125 127 127 96 111 103 119 119 115 120 127 127 127 ---
127 127 111 115 120 125 125 125 125 124 113 69 125 125 125 125 127 127 96 111 103 119 119 115 120 127 127 127 ---

 */
