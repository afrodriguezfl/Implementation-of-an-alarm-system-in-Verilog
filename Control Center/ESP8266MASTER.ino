#include <Ubidots.h>


const char* UBIDOTS_TOKEN = "BBFF-HAZBp2HnU85PhuURZqDjwadwXo6tQS";  // Put here your Ubidots TOKEN
const char* WIFI_SSID = "Andres Redmi Note";      // Put here your Wi-Fi SSID
const char* WIFI_PASS = "NosenseT0ME";      // Put here your Wi-Fi password 

Ubidots ubidots(UBIDOTS_TOKEN, UBI_HTTP);

#define DEVICE_LABEL "10521c01f556"

#define LAB_inwifi "senal_cucuta"
#define LAB_outwifi "senal_bogota"// Se envía 1 señal, pues la interpretación ocurre en el ESP8266

#define PIN_LED_out1 D2
#define PIN_LED_out2 D3
#define PIN_LED_out3 D5

#define PIN_in1 D6
#define PIN_in2 D7

bool outwifi1, outwifi2, outwifi3;
int aux, inwifi;
void setup() { 

  //Establecer conexión
  Serial.begin(115200);
  ubidots.wifiConnect(WIFI_SSID, WIFI_PASS);
  ubidots.setDebug(true);  // Uncomment this line for printing debug  messages  

  inwifi=0;
  
  outwifi1=0;
  outwifi2=0;
  outwifi3=0;

  aux=0;

  pinMode(PIN_in1,OUTPUT); 
  pinMode(PIN_in2,OUTPUT);

  pinMode(PIN_LED_out1,INPUT); 
  pinMode(PIN_LED_out2,INPUT);
  pinMode(PIN_LED_out3,INPUT);

  digitalWrite(PIN_in1,inwifi);
  digitalWrite(PIN_in2,inwifi);

  digitalRead(PIN_LED_out1);    
  digitalRead(PIN_LED_out2);     
  digitalRead(PIN_LED_out3);     
 }

void loop() {

  outwifi1=digitalRead(PIN_LED_out1);
  Serial.println("Pin D2: "+String(outwifi1));
  
  outwifi2=digitalRead(PIN_LED_out2);
  Serial.println("Pin D3: "+String(outwifi2));
  
  outwifi3=digitalRead(PIN_LED_out3);
  Serial.println("Pin D5: "+String(outwifi3));
  
  //Inactivo
  if(outwifi1==0 && outwifi2==0 && outwifi3==0){
    aux=0;
  }
  //Activo 
  else if (outwifi1==0 && outwifi2==1 && outwifi3==0){
    aux=1;
  }
  //Alarma
  else if (outwifi1==1 && outwifi2==0 && outwifi3==0){
    aux=2;
  }
  //Emergencia
  else if (outwifi1==1 && outwifi2==1 && outwifi3==0){
    aux=3;
  }
  //No interferencia 
  else if (outwifi1==0 && outwifi2==0 && outwifi3==1){
    aux=4;
  } 
  
  //Añadir variable para ENVIARLA
  ubidots.add(LAB_outwifi, aux); 


  // Obteniendo informacion desde ubidots
  inwifi = ubidots.get(DEVICE_LABEL, LAB_inwifi);
      
  if (inwifi==0){               //INDUCIR DESACTIVACIÓN
      digitalWrite(PIN_in1,LOW);
      digitalWrite(PIN_in2,HIGH);
      Serial.println("EMERGENCIA");
  }
  else if (inwifi==1){          //INDUCIR ACTIVACIÓN  
      digitalWrite(PIN_in1,HIGH);
      digitalWrite(PIN_in2,LOW);
      Serial.println("ALARMA");
  }
  else if (inwifi==2){          //INDUCIR ALARMA
      digitalWrite(PIN_in1,LOW);
      digitalWrite(PIN_in2,LOW);
      Serial.println("ACTIVO");
  }
  else if (inwifi==3){          //INDUCIR EMERGENCIA
      digitalWrite(PIN_in1,HIGH);
      digitalWrite(PIN_in2,HIGH);
      Serial.println("INACTIVO");
  }
  
  if (inwifi != ERROR_VALUE){
    Serial.println("Recepción EXITOSA "+String(inwifi));
  }
  else{
    Serial.println("Error de lectura del LED desde Ubidots");
  }

  // Enviando información
  bool bufferSent = false;
  bufferSent = ubidots.send(); 
  

   if (bufferSent) {
  // Do something if values were sent properly
   Serial.println("Valores enviados por el dispositivo");
  }
  delay(200);
  
  
}
