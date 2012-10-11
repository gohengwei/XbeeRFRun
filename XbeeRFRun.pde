#include <XBee.h>
#include <SPI.h>
#include <DHT.h>
#include <SD.h>
#include <Wire.h>
#include "pitches.h"
#include <i2cLCD.h>
//Constants
#define DHTPIN 22
#define DHTTYPE DHT11
#define TEMP_ADD 72
#define DURATION 20 //Seconds
#define LED_IND A1
#define END_BUTTON A3
#define TIME 300 //Time in seconds

//Define variables

//Xbee Set up
uint8_t payload[] = {4,5};
XBee xbeeInt;
XBee xbeeExt;
XBee xbeeExt2;
Rx16Response rx16_Int = Rx16Response();
Rx16Response rx16_Ext = Rx16Response();
Rx16Response rx16_Ext2 = Rx16Response();

//Tx16Request tx = Tx16Request(0x03, payload, sizeof(payload));
//TxStatusResponse txStatus = TxStatusResponse();

//Other sensors, LCD and SD set up
DHT dht(DHTPIN, DHTTYPE);
const int sdSelect = 4;
i2cLCD lcd(227);

//Variables to be used
float temp, rh;
int delayS;
uint8_t rssi,endTime;
int fCount = 0,h,t;
bool isDone = false;
char filename[20] = "log";
char end[5] = ".txt";
char filenametemp[25];
char filenametempend[25];
char filenametemptop[25];
char filenametempbot[25];
char fCountChar[33];
File dataFile;
File dataFile2;
File dataFile3;
String buffer = "";

byte mac[] = {  0x90, 0xA2, 0xDA, 0x0D, 0x06, 0xF1 };
char serverName[] = "www.google.com";
//EthernetClient client;

void setup()
{	 
	//Set up various hardware
	lcd.begin();
	dht.begin();
	Serial2.begin(9600);
	Serial1.begin(9600);
	xbeeInt.begin(9600);
	xbeeExt.begin(9600);
	xbeeExt2.begin(9600);
	xbeeExt.setSerial(Serial1);
	xbeeExt2.setSerial(Serial2);
	Serial.begin(9600);

	pinMode(10,OUTPUT);
	pinMode(53,OUTPUT);
	pinMode(LED_IND, OUTPUT); 
	pinMode(END_BUTTON, OUTPUT); 
	delay(1000);
	lcd.clear();

	
	lcd.print("LCD initialized");
	delay(500);
	lcd.clear();
	lcd.setCursor(1,1);
	/*
	Ethernet.begin(mac, ip , gateway , subnet);
	lcd.print("Ethernet started");
	delay(1000);
	lcd.clear();
	*/

	/*  // start the Ethernet connection:
  if (Ethernet.begin(mac) == 0) {
    Serial.println("Failed to configure Ethernet using DHCP");
    // no point in carrying on, so do nothing forevermore:
    while(true);
  }
  // give the Ethernet shield a second to initialize:
  delay(1000);
  Serial.println("connecting...");
  */

	if(!SD.begin(sdSelect))
	{
		lcd.print("Card failed");
		for(;;);
	}
	lcd.print("Card initialized.");
	delay(1000);
	lcd.clear();
	h = dht.readHumidity();
	t = dht.readTemperature();
  
	// check if returns are valid, if they are NaN (not a number) then something went wrong!
	if (isnan(t) || isnan(h)) {
	  lcd.setCursor(2,1);
	  lcd.print("Sensor read failed");
	} else {
		Serial.println("read worked");
	lcd.setCursor(2,1);
    lcd.print("RH:"); 
    lcd.print(h);
	lcd.print("%"); 
    lcd.print(" T:"); 
    lcd.print(t);
    lcd.print("C");
  }
	lcd.setCursor(1,1);
	lcd.print("System Ready.");
	delay(2000);
	lcd.setCursor(1,1);
	lcd.print("             ");
	
	do
	{
		strcpy(filenametemp, filename);
		strcat(filenametemp,itoa(fCount,fCountChar,10));
		strcpy(filenametempend,filenametemp);
		strcat(filenametempend,end);
		if(!SD.exists(filenametempend))
		{
			strcpy(filenametemptop,filenametemp);
			strcpy(filenametempbot,filenametemp);
			
			strcat(filenametemptop,"b");
			strcat(filenametemptop,end);
			strcat(filenametempbot,"c");
			strcat(filenametempbot,end);

			dataFile = SD.open(filenametempend, FILE_WRITE);
			if (dataFile) {
				dataFile.print(h);
				dataFile.print(" ");
				dataFile.println(t);
				dataFile.close();
			}
			dataFile2 = SD.open(filenametemptop, FILE_WRITE);
			if (dataFile2) {
				dataFile2.print(h);
				dataFile2.print(" ");
				dataFile2.println(t);
				dataFile2.close();
			}

			dataFile3 = SD.open(filenametempbot, FILE_WRITE);
			if (dataFile3) {
				dataFile3.print(h);
				dataFile3.print(" ");
				dataFile3.println(t);
				dataFile3.close();
				break;
			}
		}

		fCount++;
	}
	while(SD.exists(filenametempend));

	delayS = millis()/1000;
}

void loop()
{
	if(!isDone)
	{
		lcd.setCursor(1,1);
		lcd.print("Time:");
		endTime = millis()/1000 - delayS;
		lcd.print(endTime);

		xbeeInt.readPacket(50) ;
		if (xbeeInt.getResponse().isAvailable()) {
			if (xbeeInt.getResponse().getApiId() == RX_16_RESPONSE) {
                xbeeInt.getResponse().getRx16Response(rx16_Int);
				rssi = rx16_Int.getRssi();
				lcd.setCursor(3,1);
				lcd.print("M/RSSI:");
				lcd.print(rssi);
				writeToSD(rssi,filenametempend);
			}
		}

		xbeeExt.readPacket(50);
		if (xbeeExt.getResponse().isAvailable()) {
			if (xbeeExt.getResponse().getApiId() == RX_16_RESPONSE) {
                xbeeExt.getResponse().getRx16Response(rx16_Ext);
				rssi = rx16_Ext.getRssi();
				lcd.setCursor(3,11);
				lcd.print("T/RSSI:");
				lcd.print(rssi);
				writeToSD(rssi,filenametemptop);
			}
		} 

		xbeeExt2.readPacket(50);
		if (xbeeExt2.getResponse().isAvailable()) {
			if (xbeeExt2.getResponse().getApiId() == RX_16_RESPONSE) {
                xbeeExt2.getResponse().getRx16Response(rx16_Ext2);
				rssi = rx16_Ext2.getRssi();
				lcd.setCursor(4,1);
				lcd.print("B/RSSI:");
				lcd.print(rssi);
				writeToSD(rssi,filenametempbot);
			}
		} 
	}
	
	if((millis()/1000)%2 && !isDone){
		digitalWrite(LED_IND,HIGH);
		tone(11, 523, 1000);
	}
	else	
	{
			digitalWrite(LED_IND,LOW);
			noTone(11);
	}

	if( millis()/1000 > (TIME + delayS) && isDone == false)
	{
		isDone = true;
		lcd.setCursor(2,1);
		lcd.print("                   ");
		lcd.setCursor(2,1);
		lcd.print(filenametempend);
		lcd.setCursor(2,11);
		lcd.print(filenametemp);
	}

	if(digitalRead(END_BUTTON) == HIGH)
	{
		isDone = false;
		lcd.setCursor(1,1);
		lcd.print("Card initialized.");
		delay(1000);
		lcd.clear();
		h = dht.readHumidity();
		t = dht.readTemperature();
  
		// check if returns are valid, if they are NaN (not a number) then something went wrong!
		if (isnan(t) || isnan(h)) {
		  lcd.setCursor(2,1);
		  lcd.print("Sensor read failed");
		} else {
			Serial.println("read worked");
		lcd.setCursor(2,1);
		lcd.print("RH:"); 
		lcd.print(h);
		lcd.print("%"); 
		lcd.print(" T:"); 
		lcd.print(t);
		lcd.print("C");
	  }
		lcd.setCursor(1,1);
		lcd.print("System Ready.");
		delay(2000);
		lcd.setCursor(1,1);
		lcd.print("             ");
	
		do
	{
		strcpy(filenametemp, filename);
		strcat(filenametemp,itoa(fCount,fCountChar,10));
		strcpy(filenametempend,filenametemp);
		strcat(filenametempend,end);
		if(!SD.exists(filenametempend))
		{
			strcpy(filenametemptop,filenametemp);
			strcpy(filenametempbot,filenametemp);
			
			strcat(filenametemptop,"b");
			strcat(filenametemptop,end);
			strcat(filenametempbot,"c");
			strcat(filenametempbot,end);

			dataFile = SD.open(filenametempend, FILE_WRITE);
			if (dataFile) {
				dataFile.print(h);
				dataFile.print(" ");
				dataFile.println(t);
				dataFile.close();
			}
			dataFile2 = SD.open(filenametemptop, FILE_WRITE);
			if (dataFile2) {
				dataFile2.print(h);
				dataFile2.print(" ");
				dataFile2.println(t);
				dataFile2.close();
			}

			dataFile3 = SD.open(filenametempbot, FILE_WRITE);
			if (dataFile3) {
				dataFile3.print(h);
				dataFile3.print(" ");
				dataFile3.println(t);
				dataFile3.close();
				break;
			}
		}

		fCount++;
	}
	while(SD.exists(filenametempend));

		delayS = millis()/1000;
		/*
			  if (client.connect(serverName, 80)) {
    Serial.println("connected");
    // Make a HTTP request:
    client.println("GET /search?q=arduino HTTP/1.0");
    client.println();
  } 
  else {
    // kf you didn't get a connection to the server:
    Serial.println("connection failed");
  }
  */

	}
}

void writeToSD(uint8_t value, char* filename)
{
	Serial.println(filename);
	File dataFileTemp = SD.open(filename, FILE_WRITE);
	if (dataFileTemp)
	{
		dataFileTemp.print(value);
		dataFileTemp.println();
		dataFileTemp.close();
	}		  
}
