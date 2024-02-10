#define PWM1_PIN 5
#define PWM2_PIN 6

int ValuePWM1, ValuePWM2;
int ValueA0, ValueA1;

void setup() {

  // initialize serial and pwm pins
  Serial.begin(115200);
  pinMode(PWM1_PIN, OUTPUT);
  pinMode(PWM2_PIN, OUTPUT);
}

void loop() {

  // check for incoming serial data
  if (Serial.available() > 0) {
    ValuePWM1 = Serial.parseInt();
    ValuePWM2 = Serial.parseInt();
    Serial.read();
    analogWrite(4, ValuePWM1);
    analogWrite(5, ValuePWM2);
  }

  // read analog input, divide by 4 to make the range 0-255:
  int ValueA0 = analogRead(A0) / 4;
  int ValueA1 = analogRead(A1) / 4;

  // send values to serial data
  Serial.print(ValueA0);
  Serial.print(',');
  Serial.println(ValueA1);

  delay(500);
}
