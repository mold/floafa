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
boolean sendToArduino = false;

void setup() {
  size(w, h);
  Sonia.start(this);
  cSpc = new float[samples];
  if (sendToArduino) {
    serial = new SerialCom((new Serial(this, Serial.list()[0], 9600)));
  }
  sThread = new SampleThread(sps, samples);
  sThread.start();
  thread("readSerial");
}

void draw() {
  background(100, 100, 100);

  float[] spc = sThread.getSpectrum();
  float[] lvls = getLevels();

  background(0, 0, 0);

  // Update current spectrum to approach cSpc from SampleThread
  for (int i = 0; i < samples; i++) {
    cSpc[i] += (spc[i]-cSpc[i])/(fps-20);
  }

  // Let's make a line
  float[][] colors = new float[samples][3];
  for (int i = 0; i < cSpc.length; i++) {
    // Calculate color from spectrum
    colors[i][0] = cSpc[i]/500*255;
    colors[i][1] = cSpc[(i+1)%cSpc.length]/500*255;
    colors[i][2] = cSpc[(i+2)%cSpc.length]/500*255;
    fill(colors[i][0], colors[i][1], colors[i][2]);
    rect(i*(w/cSpc.length), 0, w/cSpc.length, h);
  }

  for (int i = 0; i < cSpc.length; i++) {
    line(i*(w/cSpc.length), 0, (i+1)*(w/cSpc.length), h-cSpc[i]/10);
  }

  if (sendToArduino) {
    serial.sendColors(colors);
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
  
  void readSerial(){
     while(serial.available()){
        println(serial.read());
     } 
  }

