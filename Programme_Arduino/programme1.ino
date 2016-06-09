#include <SoftwareSerial.h>
#include "Utils.h"

//Initialisation des ports necessaires
const int PORT_OUT=9, PORT_IN=8, PORT_POT_OUT = 11, PORT_RX = 10, PORT_TX = 11;

//Serial d'envoi et reception du controller
static SoftwareSerial mySerial(PORT_IN,PORT_OUT);

//Assistance
const byte assist[][2] = {{(byte)0x00,(byte)0x0D}, {(byte)0x01,(byte)0x0C}, {(byte)0x02,(byte)0x0F}, {(byte)0x03,(byte)0x0E},{(byte)0x04,(byte)0x09}, {(byte)0x05,(byte)0x08}, {(byte)0x06,(byte)0x0B}};
static int current_assist = 0;

//Information renvoyé par le controller
int battery;
int time_speed_high;
int time_speed_low;
int error;
//Compteur du nombre d'informations
static int count = 0;

//rafraissisement des taches
long last_time_send = 0;
long last_time_button = 0;
long last_time_read = 0;
long last_time_bat = 0;
int action_send_counter = 0;

//Potentiometre
int val_pot = 0;
long pot_couter = 0;
boolean speedChanged = true;

//Vitesse du velo
volatile float bike_speed = 0.0;
const float wheel_circumference = 1.6;

//Bluetooth
//Brancher TX sur le fil avec la resistance
boolean start = false, btConnected = false;
char c, dataRead[1024] = "";

void setup() {
  
  pinMode(PORT_OUT,OUTPUT);
  pinMode(PORT_IN,INPUT);
  
  pinMode(PORT_RX,INPUT);
  pinMode(PORT_TX,OUTPUT);
  
  pinMode(PORT_POT_OUT,OUTPUT);

  mySerial.begin(9600);
  Serial.begin(9600);
  
  last_time_send = millis();
  last_time_read = millis();
  last_time_button = millis();
  
  //Allumage du controller
  
  setAssist(1);

  setupBluetooth();
}

void loop() {
  if(btConnected){
    readDATA();
    checkPot();
    sendDATA();
  }
  readBluetooth();
}

//Setup bluetooth
void setupBluetooth()
{
   Serial.write("AT+NAMEeBike");
   delay(300);
   Serial.write("AT+PIN123456");
   delay(300);
   Serial.write("AT+RESET");
   delay(300);
   Serial.write("AT+COMI0");
   delay(300);
   Serial.write("AT");  
   
}

//Methode permettant de savoir si on a reçu un message bluetooth 
void readBluetooth()
{
  
  if (Serial.available()) {
    c = Serial.read();
    if(c == '<')
    {
      memset(dataRead, 0, strlen(dataRead));
      append(dataRead, c);
      start=true;
    }
    else if(c == '>')
    {
      append(dataRead, c);
      checkDataRead();
      memset(dataRead, 0, strlen(dataRead));
      start = false;
    }
    else if(start)
    {
      append(dataRead, c);
    }else{
      append(dataRead, c);
      if(c == '+'){      
        memset(dataRead, 0, strlen(dataRead));
      }else if(strcmp(dataRead, "CONN") == 0){
        btConnected = true;
        Serial.write("CONNECTED");
        last_time_bat = 0;
      }else if(strcmp(dataRead, "LOST") == 0){
        btConnected = false;
        Serial.write("DISCONNECTED");
      }else if(strlen(dataRead) > 5){
        Serial.write(dataRead);
      }
    }
  }
}



void checkDataRead()
{
  char dataTmp[2];
  memcpy( dataTmp, &dataRead[1], 1);
  dataTmp[1] = '\0';
  int command = atoi(dataTmp);
 
  switch(command)
  {
    case 0:   //stopAssist
      stopAssist();
      break;
    case 1: //GetAssist
      Serial.print("<3,");
      Serial.print(current_assist);
      Serial.print(">");
      break;
    case 2: //upAssist
      upAssist();
      break;
    case 3: //downAssist
      downAssist();
      break;
    case 4://setAssist
    {
      char assistChar[2];
      memcpy(assistChar, &dataRead[3], 1);
      assistChar[1] = '\0';
      int assist = atoi(assistChar);
      setAssist(assist);
      break;
    }
    case 5: //setAssistPieton
      assistPieton();
      break;
    case 6:
    {
      char dataPot[4];
      memcpy( dataPot, &dataRead[3], 3);
      dataPot[3] = '\0';
      int val = atoi(dataPot);
      speedChanged =true;
      val_pot = val;
      break;
    }
  }
}

//Methode simulant un potentiometre (besoin d'un condensateur 1000 pour le branchement)
void checkPot()
{
  /*
  if(speedChanged)
  {
    speedChanged = false;
    pot_couter=millis();
    analogWrite(PORT_POT_OUT, 255);
  }
  else if(millis() - pot_couter > 15 && millis() - pot_couter < 30 && pot_couter != 0)
  {
    analogWrite(PORT_POT_OUT, 0);
  }*/
  if(speedChanged){
    analogWrite(PORT_POT_OUT, val_pot);
    speedChanged = false;
  }
}

//Envoi des données au controller toutes les 100ms
void sendDATA()
{
  if(millis() - last_time_send >= 100)
  {
    mySerial.write((byte)0x0C);
    mySerial.write(assist[current_assist][0]); //Assistance
    mySerial.write((byte)0xF2); //Vitesse Max
    mySerial.write((byte)0xD6);
    mySerial.write((byte)0x29);
    mySerial.write(assist[current_assist][1]);//Relié avec assistance selon la vitesse max
    mySerial.write((byte)0x0E);
    
    last_time_send = millis();
  }
}

//Récupération des informations envoyés par le controller
void readDATA()
{
  int data = mySerial.read();
  if(data == -1)
  {
    return;  
  }
  if(data == 65)
  {
    count = 0;
  }
  switch(count){
    case 1:
          battery = data;
          break;
    case 3:
          time_speed_high = data;
          break;
    case 4:
          time_speed_low = data;
          break;
    case 5:
          error=data;
          break;
    case 6:
          count = 0;
          break;
  }
  
  sendBatAndVitBluetooth();
 
  count++;
}

//Envoi des données de battery et vitesse via bluetooth  
void sendBatAndVitBluetooth()
{
  long currentTime = millis() - last_time_read;
  if(millis()- last_time_bat >= 10000)
  {
    int batteryPourcent = battery*6.25;
    Serial.print("<1,");
    Serial.print(batteryPourcent);
    Serial.print(">");
    last_time_bat = millis();
  }
  if(currentTime >= 150 && currentTime < 300 && action_send_counter == 0)
  {
    calculVitesse();
    Serial.print("<2,");
    Serial.print(bike_speed);
    Serial.print(">");
    action_send_counter++;
  }else if(currentTime >= 300 && currentTime < 450 && action_send_counter == 1)
  {
    Serial.print("<3,");
    Serial.print(current_assist);
    Serial.print(">");
    action_send_counter++;
  }else if(currentTime >= 450)
  {
    Serial.print("<4,");
    Serial.print(error);
    Serial.print(">");
    last_time_read= millis();
    action_send_counter = 0;
  }
  
}

//Methode de calcul de la vitesseDossierComponent
void calculVitesse()
{
  float result = time_speed_high*256 + time_speed_low;
  bike_speed = (3600/result)*wheel_circumference;
  if(bike_speed<1)
    bike_speed = 0;
}

//Augmentation de l'assistance
void upAssist()
{
  if(current_assist < 5)
  {
    current_assist++;
  }
}

//Diminution de l'assistance
void downAssist()
{
  if(current_assist > 0)
  {
    current_assist--;
    if(current_assist == 0){
      val_pot = 0;
      speedChanged = true;
    }
  }
}

//Mettre en assist pieton
void assistPieton()
{
  current_assist = 6;
}

//Enlever l'assistance
void stopAssist()
{
  current_assist = 0;
  val_pot = 0;
  speedChanged = true;
}

//Changer la valeur de l'assistance
void setAssist(int valAssist)
{
  current_assist = valAssist;
  if(current_assist == 0){
    val_pot = 0;
    speedChanged = true;
  }
}

