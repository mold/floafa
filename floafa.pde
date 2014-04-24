
import pitaru.sonia_v2_9.*;

Sample bubbles;

void setup() {
  size(100, 100);
  Sonia.start(this);
  bubbles = new Sample("bubbles.wav");
  //bubbles.play(); // play once
  LiveInput.start(128);
  bubbles.connectLiveInput(true);
  bubbles.play();
}

void draw() {
  background(100,100,100);
  LiveInput.getSpectrum(); // populate spectrum
  float[] spc = LiveInput.spectrum;
  background(spc[20], spc[20], spc[20]);
  for(int i = 0; i < spc.length; i++){
      line(i,100,i,100-spc[i]/10);
  }
  //println(spc[255]);
}

void stop() {
  LiveInput.stop();

  Sonia.stop();
  super.stop();
}

