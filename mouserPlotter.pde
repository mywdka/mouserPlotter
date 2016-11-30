import processing.serial.*;
Serial plotter1, plotter2;

int plotWidth = 11000;
int plotHeight = 7500;
int windowWidth = (plotWidth / 20);
int windowHeight = plotHeight / 20;

int prevX = 0;
int prevY = 0;

boolean penDown = false;

void setup(){
  size(1100, 375);
  plotter1 = new Serial(this, "COM1", 9600);
  plotter1.write("DF;");
  plotter1.write("IN;");
  plotter1.write("PG;");
  plotter1.write("PU " + 0 + "," + 0 + ";");
  plotter1.write("PU " + plotWidth + "," + 0 + ";");
  plotter1.write("PU " + plotWidth + "," + plotHeight + ";");
  plotter1.write("PU " + 0 + "," + plotHeight + ";");
  plotter1.write("PU " + 0 + "," + 0 + ";");
  
  plotter2 = new Serial(this, "COM2", 9600);
  plotter2.write("DF;");
  plotter2.write("IN;");
  plotter2.write("PG;");
  plotter2.write("PU " + 0 + "," + 0 + ";");
  plotter2.write("PU " + plotWidth + "," + 0 + ";");
  plotter2.write("PU " + plotWidth + "," + plotHeight + ";");
  plotter2.write("PU " + 0 + "," + plotHeight + ";");
  plotter2.write("PU " + 0 + "," + 0 + ";");
}

void draw(){
  boolean mouseChanged = false;
  int x = 0;
  int y = 0;
  
  x = mouseX;
  y = mouseY;
  
  if (x != prevX || y != prevY) {
    mouseChanged = true;
  }
  
  if (mouseChanged) {

      int scaledY = (int)map(y, 0, windowHeight, plotHeight, 0);
      int scaledX = (int)map((x < windowWidth) ? x : x - windowWidth, 0, windowWidth, 0, plotWidth);
      
      if (x < windowWidth) {
        if (penDown) {
          plotter1.write("PD ");
        } else {
          plotter1.write("PU ");
        }
        plotter1.write("" + scaledX + "," + scaledY + ";");
      } else {
        if (penDown) {
          plotter2.write("PD ");
        } else {
          plotter2.write("PU ");
        }
        plotter2.write("" + scaledX + "," + scaledY + ";");
      }
      
      if (penDown) {
        line(prevX, prevY, x, y);
      }
      prevX = x;
      prevY = y;
  }
}

void mousePressed() {
  penDown = true;
}

void mouseReleased() {
  penDown = false;
}