import processing.serial.*;

class SerialCom {
  Serial s;

  public SerialCom(Serial s) {
    this.s = s;
  }

  public void sendColors(float[][] colors) {
    for (int i = 0; i < colors.length; i++) {
      // send rgb values!
      s.write(Math.round(colors[i][0]));
      s.write(Math.round(colors[i][1]));
      s.write(Math.round(colors[i][2]));
    }
  }
}

