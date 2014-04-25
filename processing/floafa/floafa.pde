import pitaru.sonia_v2_9.*;
import processing.serial.*;

Sample bubbles;
SampleThread sThread;

int w=1000, h=100;
int sps = 5; // desired samples per second
int samples = 8; // detail level for spectrum (power of 2)
int fps = 60; // frames (i.e. calls to draw()) per second
float[] cSpc; // Current spectrum array
SerialCom serial;
Serial sss = new Serial(this, Serial.list()[5], 9600);
boolean sendToArduino = true;
int c;
color from = color(0, 29, 255);
color to = color(255, 55, 42);

void setup() {
  size(w, h);
  c=0;
  Sonia.start(this);
  cSpc = new float[samples];
  if (sendToArduino) {
    serial = new SerialCom(sss);
  }
  sThread = new SampleThread(sps, samples);
  sThread.start();
  thread("readSerial");
}

void draw() {
  background(100, 100, 100);

  float[] spc = sThread.getSpectrum();
  //println(spc[0]);
  float[] lvls = getLevels(); //Doesn't seem to be used atm

  background(0, 0, 0);

  // Update current spectrum to approach cSpc from SampleThread
  
  for (int i = 0; i < samples; i++) {
    cSpc[i] += (spc[i]-cSpc[i])/(fps-20);
  }

  // Let's make a line
  float[][] colors = new float[samples][3];
  for (int i = 0; i < cSpc.length; i++) {
    if (cSpc[i] > 2000){
      cSpc[i] = 2000;
    }
    // Calculate color from spectrum
    
    color thiscolor = lerpColor(from, to, cSpc[i]/2000);
    colors[i][0] = red(thiscolor);
    colors[i][1] = green(thiscolor);
    colors[i][2] = blue(thiscolor);
    
    /*
    colors[i][0] = cSpc[i]/2000*255;
    println("Red: "+ colors[i][0] + ", original: " + cSpc[i]);
    colors[i][1] = cSpc[(i+1)%cSpc.length]/2000*255;
    println("Green: " + colors[i][1] + ", original: " + cSpc[(i+1)%cSpc.length]);
    colors[i][2] = cSpc[(i+2)%cSpc.length]/2000*255;
    println("Blue: " + colors[i][2] + ", original: " + cSpc[(i+2)%cSpc.length]);*/
    fill(colors[i][0], colors[i][1], colors[i][2]);
    rect(i*(w/cSpc.length), 0, w/cSpc.length, h);
  }

  for (int i = 0; i < cSpc.length; i++) {
    line(i*(w/cSpc.length), 0, (i+1)*(w/cSpc.length), h-cSpc[i]/10);
  }

  if (sendToArduino) {
    sendColors(colors);
  }
}

float[] getLevels() {
  return new float[] {
    LiveInput.getLevel(0), LiveInput.getLevel(1)
    };
  }

  void stop() {
    LiveInput.stop();

    Sonia.stop();
    super.stop();
  }
void sendColors(float[][] colors) {
  if ((c++)>1) {
    for (int i = 0; i < colors.length; i++) {
      // send rgb values!
      sss.write((int)Math.round(colors[i][0]));
      sss.write((int)Math.round(colors[i][1]));
      sss.write((int)Math.round(colors[i][2]));
    }
    c=0;
  }
  sss.clear();
}
void readSerial() {
  println("asdasd");
  while (sss.available ()>0) {
    println(sss.readChar());
  }
}

