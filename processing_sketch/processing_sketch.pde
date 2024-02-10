import processing.serial.*; //<>//
import controlP5.*;

Serial port;
ControlP5 cp5;
PFont font;
PImage img;
Gauge GaugeA0, GaugeA1;
Slider Slider1, Slider2;
int ValueA0 = 0, ValueA0Previous = -1, ValueA1 = 0, ValueA1Previous = -1;
int ValuePWM1 = 0, ValuePWM1Previous = -1;
int ValuePWM2 = 0, ValuePWM2Previous = -1;

void setup()
{
    size(1200, 600);
    printArray(Serial.list());
    port = new Serial(this, Serial.list()[0], 115200);

    font = createFont("Arial", 20);

    img = loadImage("logo.png");

    GaugeA0 = new Gauge(250,  //(width, begin, end, quotation scale, name gauge)
                        0,
                        255,
                        25,
                        "A0 value");
    GaugeA1 = new Gauge(250,
                        0, 
                        255, 
                        25, 
                        "A1 value");

    cp5 = new ControlP5(this);

    Slider1 = cp5.addSlider("Brightness 1", 0, 255, 0, 50, 125, 255, 12)
                  .setPosition((width / 2), (height / 2))
                  .setSize(255, 50)
                  .setRange(0, 255)
                  .setFont(font);

    Slider2 = cp5.addSlider("Brightness 2", 0, 255, 0, 50, 125, 255, 12)
                  .setPosition((width / 2), (height / 2) + 125)
                  .setSize(255, 50)
                  .setRange(0, 255)
                  .setFont(font);
}

void draw()
{

    // Displays the image at its actual size at point (0,0)
    image(img, 0, 0);

    // get slider values
    ValuePWM1 = int(Slider1.getValue());
    ValuePWM2 = int(Slider2.getValue());

    // check for pwm changes, and send serial data
    if ((ValuePWM1 != ValuePWM1Previous) || (ValuePWM2 != ValuePWM2Previous)) {
        port.write(ValuePWM1 + "," + ValuePWM2 + '\n');

        ValuePWM1Previous = ValuePWM1;
        ValuePWM2Previous = ValuePWM2;
    }

    // Check incoming serial string to update ValueA0 & A1
    if (port.available() > 0) {
        String command = port.readStringUntil('\n');
        if (command != null) {
            String[] s = split(command, ",");

            if (s.length == 2) {
                if (s[0].length() > 1) ValueA0 = Integer.parseInt(s[0].trim());
                if (s[1].length() > 1) ValueA1 = Integer.parseInt(s[1].trim());
            } 
        }
    }

    // update gauges
    drawGauges();
}

void drawGauges()
{
    //to save resource, only redraw when values has changed
    if (ValueA0 != ValueA0Previous) {
        GaugeA0.update(ValueA0);
        pushMatrix();
        translate(10, (height / 2));
        GaugeA0.display();
        popMatrix();
        ValueA0Previous = ValueA0;
    }
    if (ValueA1 != ValueA1Previous) {
        GaugeA1.update(ValueA1);
        pushMatrix();
        translate(270, (height / 2));
        GaugeA1.display();
        popMatrix();
        ValueA1Previous = ValueA1;
    }
}

class Gauge
{
    PVector gsize;   //width & height  gauge
    PVector gscale;  //start & end value scale
    PVector gneedle; //length  & angle needle
    int gsteps;
    float gline;
    String gname;

    Gauge(float tempx, float templow, float temphigh, float templine, String tempname)
    {
        float gwidth = tempx;
        float gheight = 26 * tempx / 35;
        float glow = templow;
        float ghigh = temphigh;
        gline = templine;
        gname = tempname;
        gsteps = int(temphigh - templow) + 1;
        gsize = new PVector(gwidth, gheight);
        gscale = new PVector(glow, ghigh);
        gneedle = new PVector(5 * gsize.y / 8, map(second(), 0, 59, radians(35), radians(145)));
    }

    void display()
    {
        noStroke();
        //backcover
        fill(50);
        rect(0, 0, gsize.x, gsize.y);
        fill(255);
        textAlign(CENTER);
        textSize(14);
        text(gname, gsize.x / 2, 15);
        //scale
        stroke(255, 200);
        //strokeWeight(2);
        for (int i = 0; i < gsteps; i++) {
            pushMatrix();
            translate(gsize.x / 2, 11 * gsize.y / 12);
            rotate(PI + map(i, gscale.x, gscale.y, radians(35), radians(145)));
            if (i % gline == 0) {
                line(gneedle.x - 5, 0, gneedle.x + 5, 0);
                translate(gneedle.x + 10, 0);
                rotate(HALF_PI);
                textSize(9);
                text(i, 0, 0);
            } else {
                point(gneedle.x, 0);
            }
            popMatrix();
        }
        noStroke();
        //needle
        stroke(255, 0, 0);
        //strokeWeight(3);
        pushMatrix();
        translate(gsize.x / 2, 11 * gsize.y / 12);
        rotate(PI + gneedle.y);
        line(0, 0, gneedle.x, 0);
        popMatrix();
        noStroke();
        //frontcover
        fill(150, 180);
        rect(0, 4.5 * gsize.y / 6, gsize.x, 1.5 * gsize.y / 6);
        fill(255, 0, 0);
        ellipseMode(CENTER);
        ellipse(gsize.x / 2, 11 * gsize.y / 12, 10, 10);
    }

    void update(float tempgval)
    {
        float gvalue = tempgval;
        gneedle.y = map(gvalue, gscale.x, gscale.y, radians(35), radians(145));
    }
}
