#include <Servo.h>

const int trigPin = 2;
const int echoPin = 3;

long duration;
int distance;
Servo myServo;

void setup() {
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT); 
  Serial.begin(9600);

  myServo.attach(9);  
  myServo.write(90);  
  delay(500);
}

void loop() {
  // 10° → 170° tarama
  for (int angle = 10; angle <= 170; angle += 4) {  
    myServo.write(angle);
    delay(100);  // servo yetişsin diye bekleme
    distance = calculateDistance();
    
    // RADAR formatında veri gönder
    Serial.print(angle);
    Serial.print(",");
    Serial.print(distance);
    Serial.print(".");
  }

  // 170° → 10° geri dönüş
  for (int angle = 170; angle >= 10; angle -= 4) {  
    myServo.write(angle);
    delay(100);  
    distance = calculateDistance();

    Serial.print(angle);
    Serial.print(",");
    Serial.print(distance);
    Serial.print(".");
  }
}

// Mesafe hesaplama fonksiyonu
int calculateDistance() { 
  digitalWrite(trigPin, LOW); 
  delayMicroseconds(2);

  digitalWrite(trigPin, HIGH); 
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);

  duration = pulseIn(echoPin, HIGH, 20000); 
  distance = duration * 0.034 / 2;

  if (distance == 0 || distance > 200) {  
    distance = 200; // max 200 cm ölçsün
  }

  return distance;
}
