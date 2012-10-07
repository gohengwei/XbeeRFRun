#define __AVR_ATmega2560__
#define __cplusplus
#define __builtin_va_list int
#define __attribute__(x)
#define __inline__
#define __asm__(x)
#define ARDUINO 100
extern "C" void __cxa_pure_virtual() {}
#include "C:\Users\Eng Wei\Documents\Arduino\libraries\Xbee\XBee.h"
#include "K:\Google Drive\Hardware\Arduino\arduino-1.0.1\libraries\SPI\SPI.h"
#include "C:\Users\Eng Wei\Documents\Arduino\libraries\DHT\DHT.h"
#include "K:\Google Drive\Hardware\Arduino\arduino-1.0.1\libraries\SD\SD.h"
#include "K:\Google Drive\Hardware\Arduino\arduino-1.0.1\libraries\SD\utility\FatStructs.h"
#include "K:\Google Drive\Hardware\Arduino\arduino-1.0.1\libraries\SD\utility\Sd2Card.h"
#include "K:\Google Drive\Hardware\Arduino\arduino-1.0.1\libraries\SD\utility\Sd2PinMap.h"
#include "K:\Google Drive\Hardware\Arduino\arduino-1.0.1\libraries\SD\utility\SdFat.h"
#include "K:\Google Drive\Hardware\Arduino\arduino-1.0.1\libraries\SD\utility\SdFatmainpage.h"
#include "K:\Google Drive\Hardware\Arduino\arduino-1.0.1\libraries\SD\utility\SdFatUtil.h"
#include "K:\Google Drive\Hardware\Arduino\arduino-1.0.1\libraries\SD\utility\SdInfo.h"
#include "K:\Google Drive\Hardware\Arduino\arduino-1.0.1\libraries\Wire\Wire.h"
#include "K:\Google Drive\Hardware\Arduino\arduino-1.0.1\libraries\Wire\utility\twi.h"
#include "C:\Users\Eng Wei\Documents\Arduino\libraries\i2cLCD\i2cLCD.h"
#include "C:\Users\Eng Wei\Documents\Arduino\libraries\Xbee\XBee.cpp"
#include "K:\Google Drive\Hardware\Arduino\arduino-1.0.1\libraries\SPI\SPI.cpp"
#include "C:\Users\Eng Wei\Documents\Arduino\libraries\DHT\DHT.cpp"
#include "K:\Google Drive\Hardware\Arduino\arduino-1.0.1\libraries\SD\File.cpp"
#include "K:\Google Drive\Hardware\Arduino\arduino-1.0.1\libraries\SD\SD.cpp"
#include "K:\Google Drive\Hardware\Arduino\arduino-1.0.1\libraries\SD\utility\Sd2Card.cpp"
#include "K:\Google Drive\Hardware\Arduino\arduino-1.0.1\libraries\SD\utility\SdFile.cpp"
#include "K:\Google Drive\Hardware\Arduino\arduino-1.0.1\libraries\SD\utility\SdVolume.cpp"
#include "K:\Google Drive\Hardware\Arduino\arduino-1.0.1\libraries\Wire\Wire.cpp"
#include "K:\Google Drive\Hardware\Arduino\arduino-1.0.1\libraries\Wire\utility\twi.c"
#include "C:\Users\Eng Wei\Documents\Arduino\libraries\i2cLCD\i2cLCD.cpp"
void setup();
void loop();
void writeToSD(uint8_t value, char* filename);

#include "K:\Google Drive\Hardware\Arduino\arduino-1.0.1\hardware\arduino\variants\mega\pins_arduino.h" 
#include "K:\Google Drive\Hardware\Arduino\arduino-1.0.1\hardware\arduino\cores\arduino\Arduino.h"
#include "C:\Users\Eng Wei\Documents\Arduino\XbeeRFRun\XbeeRFRun.pde" 
