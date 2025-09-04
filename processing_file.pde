import processing.serial.*;

Serial myPort;
String angle="", distance="", data="", noObject;
float pixsDistance;
int iAngle, iDistance;
int index1=0;

void setup() {
  size(1280, 800);   
  smooth();
  
  
  myPort = new Serial(this,"COM5",9600);  
  myPort.bufferUntil('.');
  
  textFont(createFont("Arial", 32)); 
}

void draw() {
  fill(0,10);
  noStroke();
  rect(0, 0, width, height);

  fill(98,245,31);
  drawRadar(); 
  drawLine();
  drawObject();
  drawText();
}

void serialEvent (Serial myPort) {
  data = myPort.readStringUntil('.');
  if (data != null) {
    data = data.trim();
    index1 = data.indexOf(",");
    if (index1 > 0) {
      angle = data.substring(0, index1);
      distance = data.substring(index1+1);
      iAngle = int(angle);
      iDistance = int(distance);
      println("Data: " + data);

    }
  }
}

void drawRadar() {
  pushMatrix();
  translate(width/2, height-80); 
  noFill();
  strokeWeight(2);
  stroke(98,245,31);

  // Daireler (daha büyük ölçek)
  arc(0,0,800,800,PI,TWO_PI);
  arc(0,0,600,600,PI,TWO_PI);
  arc(0,0,400,400,PI,TWO_PI);
  arc(0,0,200,200,PI,TWO_PI);

  // Açı çizgileri
  for(int a=0;a<=180;a+=30){
    line(0,0,400*cos(radians(a)),-400*sin(radians(a)));
  }
  popMatrix();
}

void drawObject() {
  if(iDistance>0 && iDistance<60){   
    pushMatrix();
    translate(width/2, height-80);
    strokeWeight(10);
    stroke(255,0,0);
    pixsDistance = iDistance*10; 
    point(pixsDistance*cos(radians(iAngle)),
          -pixsDistance*sin(radians(iAngle)));
    popMatrix();
  }
}

void drawLine() {
  pushMatrix();
  translate(width/2, height-80);
  strokeWeight(2);
  stroke(0,255,0);
  line(0,0,400*cos(radians(iAngle)),
             -400*sin(radians(iAngle)));
  popMatrix();
}

void drawText() {
  fill(0);
  noStroke();
  rect(0, height-50, width, 50);

  fill(98,245,31);
  textSize(22);

  if(iDistance>60 || iDistance==0) noObject="Out of Range";
  else noObject=iDistance+" cm";

  text("Angle: " + iAngle + "°", 30, height-20);
  text("Distance: " + noObject, 350, height-20);
}
