import pitaru.sonia_v2_9.*;
import processing.serial.*;

Sample bubbles;
SampleThread sThread;

int w=1000, h=100;
int sps = 5; // desired samples per second
int samples = 8; // detail level for spectrum (power of 2)
int fps = 60; // frames (i.e. calls to draw()) per second
float[] cSpc; // Current spectrum array
//SerialCom serial;  
Serial sss;  // Serial connection
boolean sendToArduino = true;
int c;
color from, to;  // Color scale
float aggSound;  // The aggregated sound value (increases if the volume is constant/high over time)
float specmax = 2000.0;  // maximum allowed value for a spectrum index

void setup() {
  size(w, h);
  c=0;
  Sonia.start(this);
  cSpc = new float[samples];
  //  if (sendToArduino) {
  //    serial = new SerialCom(sss);
  //  }

  if (sendToArduino) {
    sss= new Serial(this, Serial.list()[5], 9600);
  }

  // Set color of interpolation
  colorMode(RGB, 255);
  from = color(0, 29, 255);
  to = color(255, 55, 42);

  // Start thread to sample the spectrum "sps" times a second
  sThread = new SampleThread(sps, samples);
  sThread.start();

  // Start thread to read from serial (debugging)
  thread("readSerial");
}

void draw() {
  background(100, 100, 100);

  float[] spc = sThread.getSpectrum();
  //println(spc[0]);
  float[] lvls = getLevels(); //Doesn't seem to be used atm

  updateAggSound();

  background(0, 0, 0);

  // Update current spectrum to approach cSpc from SampleThread

  for (int i = 0; i < samples; i++) {
    cSpc[i] += (spc[i]-cSpc[i])/(fps-20);
  }

  // Let's make a line
  float[][] colors = new float[samples][3];
  for (int i = 0; i < cSpc.length; i++) {
    if (cSpc[i] > specmax) {
      cSpc[i] = specmax;
    }

    // Calculate brightness from spectrum
    float brightness = Math.max(cSpc[i]/specmax, 0.2);

    // Calculate color that changes over time
    color thiscolor = lerpColor(from, to, aggSound);
    colorMode(HSB, 1.0);
    println(hue(thiscolor));
    thiscolor = color(hue(thiscolor), 1, brightness);
    colorMode(RGB, 255);
    colors[i][0] = red(thiscolor);
    colors[i][1] = green(thiscolor);
    colors[i][2] = blue(thiscolor);


    /*
    colors[i][0] = cSpc[i]/2000*255;*/
     println("Red: "+ colors[i][0] + ", original: " + cSpc[i]);
     println("Green: " + colors[i][1] + ", original: " + cSpc[(i+1)%cSpc.length]);
     println("Blue: " + colors[i][2] + ", original: " + cSpc[(i+2)%cSpc.length]);
    fill(colors[i][0], colors[i][1], colors[i][2]);
    rect(i*(w/cSpc.length), 0, w/cSpc.length, h);
  }

  for (int i = 0; i < cSpc.length; i++) {
    line(i*(w/cSpc.length), 0, (i+1)*(w/cSpc.length), h-h*cSpc[i]/specmax);
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

/**
 * Send colors to arduino as RGB
 */
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

/**
 * Updates the aggSound variable to get the color spectrum
 */
float updateAggSound() {
  int coolDownPeriodShort = 2;  // Number of seconds for "cooldown"
  int coolDownPeriodLong = 5;
  float level = LiveInput.getLevel();
  float threshold = 0.03;  // If level is above this, increase aggSound else decrease
  float changeUp = 1.0/coolDownPeriodLong/fps;
  float changeDown = 1.0/coolDownPeriodShort/fps;  // How much to change at each update

  if (level >= threshold) {
    aggSound = Math.min(aggSound+changeUp, 1);
  }
  else {
    aggSound = Math.max(aggSound-changeDown, 0);
  }

  return aggSound;
}
void readSerial() {
  println("asdasd");
  while (sss.available ()>0) {
    println(sss.readChar());
  }
}

