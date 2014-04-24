import pitaru.sonia_v2_9.*;

class SampleThread extends Thread {
  private long wait;
  private LiveInput li;
  private float[] spc;
  private boolean running;
  private int samples;

  public SampleThread(int samplesPerSecond, int samples) {
    wait = 1000/samplesPerSecond;
    this.samples = samples;
  }

  void start() {
    LiveInput.start(samples);
    Sample s = new Sample("chimes.wav");
    //s.connectLiveInput(true);
    //s.play();
    LiveInput.getSpectrum();
    spc = LiveInput.spectrum;
    running = true;
    super.start();
  }

  void run() {
    while (running) {
      LiveInput.getSpectrum();
      spc = LiveInput.spectrum;
      try {
        sleep(wait);
      }
      catch(Exception e) {
        println(e);
      }
    }
  }

  void quit() {
    running=false;
    interrupt();
  }

  float[] getSpectrum() {
    return spc;
  }
}

