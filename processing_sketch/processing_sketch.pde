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

    Slider1 = cp5.addSlider("PWM 1", 0, 255, 0, 50, 125, 255, 12)
                  .setPosition((width / 2), (height / 2))
                  .setDecimalPrecision(0)
                  .setSize(255, 50)
                  .setRange(0, 255)
                  .setFont(font);

    Slider2 = cp5.addSlider("PWM 2", 0, 255, 0, 50, 125, 255, 12)
                  .setPosition((width / 2), (height / 2) + 125)
                  .setDecimalPrecision(0)
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
