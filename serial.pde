import controlP5.*;
import processing.serial.*;

ControlP5 controlP5;
String textValue = "";
String text2send = "";
String text2send_ = "";
Serial port = null;
boolean portSelected = false;
Textlabel txtlblWhichcom;

void setup( ) {
  size(470, 295);

  PFont font = createFont("arial", 20);
  controlP5 = new ControlP5(this);

  controlP5.addTextfield("Name")
    .setPosition(20, 220)
    .setSize(200, 40)
    .setFont(createFont("arial", 20))
    .setAutoClear(false)
    ;

  controlP5.addBang("Submit")
    .setPosition(240, 220)
    .setSize(80, 40)
    .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
    ;    

  textFont(font);

  ListBox l = controlP5.addListBox("myList", 20, 40, 80, 200);
  for (int i=0; i<Serial.list().length; i++) {
    l.addItem(Serial.list()[i], i);
  }
  txtlblWhichcom  = controlP5.addTextlabel("txtlblWhichcom","No Port Selected",150,50);
  textFont(font);
  intro();
}

void intro () {
  background(0);
  fill(255);
  text(controlP5.get(Textfield.class, "Name").getText(), 360, 130);
  text(textValue, 360, 180);
}

void draw() {
  background(128);
  if (portSelected) {
    
    if(!text2send.equals(text2send_) && !text2send.equals(null) && !text2send.equals("")) {
      println("text2send:" + text2send);
      port.write(text2send + "\n");
      //port.write("hallo\n");
      text2send_ = text2send;
    }
  }
}


void serialEvent(Serial p) {
  // do something when you recieve serial data
  String msg = p.readStringUntil(13);
  if (msg != null) {
    println(msg);
  }
}

void Submit() {
  text2send = controlP5.get(Textfield.class,"Name").getText();
}

void controlEvent(ControlEvent ce) {
  println(ce);

  if (ce.getName().equals("myList")) {
    int value = (int)ce.getValue();
    if (port != null) {
      println("port");
      port.stop();
      port = null;
    }

    port = new Serial(this, Serial.list()[value], 115200);
    port.bufferUntil(10);
    portSelected = true;
    txtlblWhichcom.setValue("Serial port selected: "+Serial.list()[value]);
    println("Serial port selected: "+Serial.list()[value]);
  }

  else if (ce.getName().equals("Name")) {
    if (ce.isAssignableFrom(Textfield.class)) {
      text2send = ce.getStringValue();
      println("controlEvent: accessing a string from controller '"
        +ce.getName()+"': "
        +ce.getStringValue()
        );
    }
  }
}