/*
Adafruit Arduino - Lesson 3. RGB LED
*/
 
int redPin = 11;
int greenPin = 10;
int bluePin = 9;
 
//uncomment this line if using a Common Anode LED
#define COMMON_ANODE
 
void setup()
{
  pinMode(redPin, OUTPUT);
  pinMode(greenPin, OUTPUT);
  pinMode(bluePin, OUTPUT);  
}
 
void loop()
{
  setColor(0, 29, 255);  // red
  delay(3000);
  setColor(74, 12, 232);  // green
  delay(3000);
  setColor(174, 0, 255);  // blue
  delay(3000);
  setColor(232, 12, 197);  // yellow
  delay(3000);  
  setColor(255, 55, 42);  // purple
  delay(3000);
}
 
void setColor(int red, int green, int blue)
{
  #ifdef COMMON_ANODE
    red = 255 - red;
    green = 255 - green;
    blue = 255 - blue;
  #endif
  analogWrite(redPin, red);
  analogWrite(greenPin, green);
  analogWrite(bluePin, blue); 
  
}

