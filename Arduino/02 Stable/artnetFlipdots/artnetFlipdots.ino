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

 /*
  *     reduce the MAX_SOCK_NUM to 1, e.g. replace the following highlighted code: https://github.com/PaulStoffregen/Ethernet/blob/master/src/Ethernet.h#L36-L40
    by:

      #define MAX_SOCK_NUM 1

  */

    //enable ETHERNET_LARGE_BUFFERS , e.g. uncomment the following line: https://github.com/PaulStoffregen/Ethernet/blob/master/src/Ethernet.h#L48
#include "Helper.h"
#include "StateMachine.h"


void setup() {
  setupEnv();
}

void loop() {
  stateMachine();
}
