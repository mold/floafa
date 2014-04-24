
import pitaru.sonia_v2_9.*;

Sample bubbles;

int w=1000, h=100;

void setup() {
  size(w, h);
  Sonia.start(this);
  bubbles = new Sample("chimes.wav");
  //bubbles.play(); // play once
  LiveInput.start(8);
  //bubbles.connectLiveInput(true);
  //bubbles.play();
}

void draw() {
  background(100, 100, 100);
  LiveInput.getSpectrum(); // populate spectrum
  float[] spc = LiveInput.spectrum;
  float[] lvls = getLevels();
  //println(lvls[0]*255*10000);
  background(0, 0, 0);

  for (int i = 0; i < spc.length; i++) {
    line(i, 100, i, 100-spc[i]/10);
  }
  //println(spc[255]);

  // Let's make a line
  for (int i = 0; i < spc.length; i++) {
    // Calculate color from spectrum
    fill(spc[i]/500*255, spc[(i+1)%spc.length]/500*255, spc[(i+2)%spc.length]/500*255);
    rect(i*(w/spc.length),0,w/spc.length,h);
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

