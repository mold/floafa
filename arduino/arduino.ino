/*
Adafruit Arduino - Lesson 3. RGB LED
 */

// ledIndex 0 (spectrum 1)
int redPin = 11;
int greenPin = 10;
int bluePin = 9;

int pins[][3] = {{11,10,9},{16,15,14},{19,18,17}};

//uncomment this line if using a Common Anode LED
#define COMMON_ANODE

void setup()
{
  Serial.begin(9600);
  for(int i = 0; i < 3; i++){
    
   pinMode(pins[i][0], OUTPUT);
    pinMode(pins[i][1], OUTPUT);
     pinMode(pins[i][2], OUTPUT);
  
  }
  
}

void loop()
{
  while (Serial.available() > 8*4) {
    for (int i=0; i<8; i++){
      
      if(i==0){
        setColor(Serial.read(),Serial.read(),Serial.read(), 0);
      }
      else if(i==1){
        setColor(Serial.read(),Serial.read(),Serial.read(), 1);
      }
      else{
        Serial.read();
        Serial.read();
        Serial.read();
      }
    }
    Serial.flush();

  }

  //  setColor(0, 29, 255);  // red
  //  delay(3000);
  //  setColor(74, 12, 232);  // green
  //  delay(3000);
  //  setColor(174, 0, 255);  // blue
  //  delay(3000);
  //  setColor(232, 12, 197);  // yellow
  //  delay(3000);  
  //  setColor(255, 55, 42);  // purple
  //  delay(3000);
}

void setColor(int red, int green, int blue, int ledIndex)
{
#ifdef COMMON_ANODE
  red = 255 - red;
  green = 255 - green;
  blue = 255 - blue;
#endif
  analogWrite(pins[ledIndex][0], red);
  analogWrite(pins[ledIndex][1], green);
  analogWrite(pins[ledIndex][2], blue); 
}




