#include <Ubidots.h>


const char* UBIDOTS_TOKEN = "";  // Put here your Ubidots TOKEN
const char* WIFI_SSID = "NAMEOFTHENET";      // Put here your Wi-Fi SSID
const char* WIFI_PASS = "PASSWORD";      // Put here your Wi-Fi password 

Ubidots ubidots(UBIDOTS_TOKEN, UBI_HTTP);

#define DEVICE_LABEL "10521c01f4f4"

#define LAB_inwifi "senal_bogota"
#define LAB_outwifi "senal_cucuta"// Se envía 1 señal, pues la interpretación ocurre en el ESP8266



#define PIN_LED_out D2
#define PIN_LED_out2 D3

#define PIN_in1 D5
#define PIN_in2 D6
#define PIN_in3 D7

bool outwifi, outwifi2;
int aux,aux1,inwifi2;
void setup() { 

  //Establecer conexión
  Serial.begin(115200);
  ubidots.wifiConnect(WIFI_SSID, WIFI_PASS);
  //ubidots.setDebug(true);  // Uncomment this line for printing debug  messages  

  inwifi2=0;
  
  outwifi=0;
  outwifi2=0;

  aux=0;
  aux1=0;



  pinMode(PIN_in1,OUTPUT);
  pinMode(PIN_in2,OUTPUT);
  pinMode(PIN_in3,OUTPUT);
  
  pinMode(PIN_LED_out,INPUT); 
  pinMode(PIN_LED_out2,INPUT);


  
  digitalWrite(PIN_in1,inwifi2);
  digitalWrite(PIN_in2,inwifi2);
  digitalWrite(PIN_in3,inwifi2);
  
  digitalRead(PIN_LED_out);    
  digitalRead(PIN_LED_out2);            
 }

void loop() {

  outwifi=digitalRead(PIN_LED_out);
  Serial.println("Pin D2: "+String(outwifi));
  
  
  outwifi2=digitalRead(PIN_LED_out2);
  Serial.println("Pin D3: "+String(outwifi2));

  if(outwifi==0 && outwifi2==0){
    aux=0;
  }
  else if (outwifi==0 && outwifi2==1){
    aux=1;
  }
  else if (outwifi==1 && outwifi2==0){
    aux=2;
  }
  else if (outwifi==1 && outwifi2==1){
    aux=3;
  }
  
  //Añadir variable para ENVIARLA
  ubidots.add(LAB_outwifi, aux); 


  // Obteniendo informacion desde ubidots
  inwifi2 = ubidots.get(DEVICE_LABEL, LAB_inwifi);
  
      
  if (inwifi2==0){               //INDUCIR DESACTIVACIÓN
      digitalWrite(PIN_in1,LOW);
      digitalWrite(PIN_in2,HIGH);

      digitalWrite(PIN_in3,LOW);
      
  }
  else if (inwifi2==1){          //INDUCIR ACTIVACIÓN  
      digitalWrite(PIN_in1,HIGH);
      digitalWrite(PIN_in2,LOW);

       digitalWrite(PIN_in3,LOW);
      
  }
  else if (inwifi2==2){          //INDUCIR ALARMA
      digitalWrite(PIN_in1,LOW);
      digitalWrite(PIN_in2,LOW);
      
      digitalWrite(PIN_in3,HIGH);//<-----------
  }
  else if (inwifi2==3){          //INDUCIR EMERGENCIA
      digitalWrite(PIN_in1,HIGH);
      digitalWrite(PIN_in2,HIGH);

      digitalWrite(PIN_in3,LOW);
     
  }
  else{                          //ESTADO DE NO INTERFERENCIA
      digitalWrite(PIN_in1,LOW);
      digitalWrite(PIN_in2,LOW);
      
      digitalWrite(PIN_in3,LOW);
  }



  

  if (inwifi2 != ERROR_VALUE){
    Serial.println("Recepción EXITOSA "+String(inwifi2));
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
