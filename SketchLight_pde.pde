// Sketchup (sehr) Light
// Michael Budjan
// michael@budjan.de
// 1465287
// Bauinformatik, 6. Semester
// ________________________________________________________________________________________________________________________
//
// Plan2.jpg muss im sketchup ordner sein!
//
// Tastenkürzel
// ~~~~~~~~~~~~~~~~~
// n : neues Bild / neuen Plan laden (jpg)
// e : export als pdf und png


// ________________________________________________________________________________________________________________________
//
// benutzte beispiele:
// http://processing.org/learning/3d/texturecube.html                                      für den würfel
// http://forum.processing.org/topic/graph-inside-circle-ellipse                           für den export
// http://wiki.processing.org/w/Open_Files_through_a_GUI                                   für den dateibrowser
// http://www.sojamo.de/libraries/controlP5/examples/ControlP5window/ControlP5window.pde   für die controlP5-elemente
// _________________________________________________________________________________________________________________________




import processing.opengl.*;
import processing.pdf.*;
//import peasy.org.apache.commons.math.*;   // braucht man die?
import peasy.*;
//import peasy.org.apache.commons.math.geometry.*;  
import controlP5.*;
import javax.swing.*;  //für den filebrowser

// die startwerte für die p5 controller-werte
public int rot = 230;
public int gruen = 220;
public int blau = 200;
public int hoehe = 1;
public int groesse = 100;
public int horiz = 0;
public int vert = 0;
public float staerke = 1;
public boolean flug = false;
public boolean gitternetz = false;
public boolean orbit = false;
public boolean reset = false;
public boolean rand = false;


float rotxadd = 0.1; // variablen für den automatischen kamera-orbit
float rotyadd = 0.05;
float rotzadd = 0.2;
float rotx = 0;
float roty = 0;
float rotz = 0;

int i = 0;
int a = 1;
int kameraaktiv = 0;
String datumundzeit;
boolean exportieren = false;
boolean offnen = false;

ControlWindow controlWindow;
ControlP5 controlP5;    
PeasyCam cam;
PImage bild;

int[] coordsx = new int [100]; // array für die x koordinaten
int[] coordsy = new int [100]; // für die y koordinaten


void setup () {

  size(670, 450, OPENGL);
  hint(ENABLE_OPENGL_4X_SMOOTH);

  // bild = loadImage("plan1.jpg");
  bild = loadImage("plan2.jpg");

  cam = new PeasyCam(this, 900, 600, 0, 1000);
  cam.setMinimumDistance(250);
  cam.setMaximumDistance(2000);


  cam.setActive (false);                             // erstmal nicht aktiv
  cam.setWheelScale(3.0);                            // scroll geschw. der maus


  // hier alle p5 controller
  controlP5 = new ControlP5(this);
  controlP5.setAutoDraw(false);
  controlWindow = controlP5.addControlWindow("controlP5window", 20, 20, 220, 270);
  controlWindow.hideCoordinates();
  controlWindow.setBackground(color(30));

  Controller mySlider5 = controlP5.addSlider("groesse", 50, 200, 10, 40, 160, 10);
  Controller mySlider6 = controlP5.addSlider("horiz", 0, bild.width, 10, 60, 160, 10);  // man kann maximal so weit horizontal scrollen, wie breit das bild breit ist
  Controller mySlider7 = controlP5.addSlider("vert", 0, bild.height, 10, 80, 160, 10);  //                "         vertikal             "                  hoch  "
  Controller mySlider1 = controlP5.addSlider("hoehe", 1, 500, 10, 170, 160, 10);
  Controller mySlider8 = controlP5.addSlider("staerke", 0, 6, 10, 190, 160, 10);
  Controller mySlider2 = controlP5.addSlider("rot", 0, 255, 10, 210, 35, 10);
  Controller mySlider3 = controlP5.addSlider("gruen", 0, 255, 67, 210, 35, 10);
  Controller mySlider4 = controlP5.addSlider("blau", 0, 255, 135, 210, 35, 10);

  Controller myToggle1 = controlP5.addToggle("gitternetz", false, 10, 230, 20, 20);
  Controller myToggle2 = controlP5.addToggle("orbit", false, 110, 230, 20, 20);
  Controller myToggle4 = controlP5.addToggle("rand", false, 62, 230, 20, 20);
  Controller myToggle5 = controlP5.addToggle("flug", false, 140, 230, 20, 20);
  Controller myToggle3 = controlP5.addToggle("reset", false, 190, 230, 20, 20);

  mySlider8.setDecimalPrecision(1);
  mySlider1.setWindow(controlWindow);
  mySlider2.setWindow(controlWindow);
  mySlider3.setWindow(controlWindow);
  mySlider4.setWindow(controlWindow);
  mySlider5.setWindow(controlWindow);
  mySlider6.setWindow(controlWindow);
  mySlider7.setWindow(controlWindow);
  myToggle1.setWindow(controlWindow);
  myToggle2.setWindow(controlWindow);
  myToggle3.setWindow(controlWindow);  
  mySlider8.setWindow(controlWindow);
  myToggle4.setWindow(controlWindow);
  myToggle5.setWindow(controlWindow);



  Textfield field1 = controlP5.addTextfield("  P l a n  -  E i n s t e l l u n g e n", 10, 8, 200, 1);
  Textfield field2 = controlP5.addTextfield("  C u b e  -  E i n s t e l l u n g e n", 10, 140, 200, 1);
  field1.setWindow(controlWindow);
  field2.setWindow(controlWindow);

  controlWindow.setTitle("Einstellungen");
  //controlWindow.setUndecorated(true);
}


void mousePressed () {

  coordsx[i] = mouseX;  //speichert die x und y coord der maus bei klick ins array
  coordsy[i] = mouseY;
  i = i + a;
  if (i == 4) {         // bei 4 klicks aufhören, das array zu befüllen
    a = 0;
  }
}


void keyPressed() {

  if (key == 'E' || key == 'e') { // e: exportieren
    exportieren = true;
  }

  if (key == 'N' || key == 'n') {  // n: Neues Bild oeffnen
    offnen = true;
  }
}





void draw() {




  if (exportieren) {
    datumundzeit = datumundzeit();
    PGraphicsPDF pdf = (PGraphicsPDF)beginRaw(PDF, datumundzeit + ".pdf");
  }

  if (rand == true) {
    stroke (255, 255, 255);
  }

  if (rand == false) {
    stroke (0, 0, 0);
  }

  if (orbit == true) {

    kameraaktiv = 1;
    cam.setActive (true);
  }

  if (flug == true) {
    if (rotx <  -55) rotxadd = - 0.1;
    if (rotx > 0) rotxadd = 0.1;
    if (roty <  -30) rotyadd = - 0.05;
    if (roty > 35) rotyadd = 0.05;
    if (rotz <  -40) rotzadd = - 0.2;
    if (rotz > 50) rotzadd = 0.2;
    rotx = rotx - rotxadd;
    roty = roty - rotyadd;
    rotz = rotz - rotzadd;
    cam.setRotations(radians (rotx), radians (roty), radians (rotz));
  }
  if (orbit == false) {
    kameraaktiv = 0;
    cam.setActive (false);
  }


  if (reset == true) {
    // vert = 0;
    // horiz = 0;
    // groesse = 100;
    background (230, 230, 230); 
    i = 0;
    a = 1;
    orbit = false;
    reset = false;
  }


  if (offnen == true) { //dateibrowser anfang ///////Quelle: http://wiki.processing.org/w/Open_Files_through_a_GUI ////////////////////////////////////////////////////////
    reset = true;
    final JFileChooser fc = new JFileChooser(); 
    int returnVal = fc.showOpenDialog(this); // in response to a button click: 
    if (returnVal == JFileChooser.APPROVE_OPTION) { 
      File file = fc.getSelectedFile(); // see if it's an image (better to write a function and check for all supported extensions) 
      if (file.getName().endsWith("jpg")) { 
        bild = loadImage(file.getPath());  // load the image using the given file path
        if (bild != null) { 
          image(bild, 0, 0);
          Controller mySlider6 = controlP5.addSlider("horiz", 0, bild.width, 10, 60, 160, 10);  // alter controller wird überschrieben: neuer bild.with und bild. height wert!
          Controller mySlider7 = controlP5.addSlider("vert", 0, bild.height, 10, 80, 160, 10);
          mySlider6.setWindow(controlWindow);
          mySlider7.setWindow(controlWindow);
        }
      } 
      else { 
        String lines[] = loadStrings(file); // just print the contents to the console note: loadStrings can take a Java File Object too 
        for (int i = 0; i < lines.length; i++) { 
          println(lines[i]);
        }
      }
    }

    else { 
      println("Open command cancelled by user.");
    }
    offnen = false;
  } //dateibrowser ende ///////Quelle: http://wiki.processing.org/w/Open_Files_through_a_GUI ////////////////////////////////////////////////////////



  if (kameraaktiv == 0) {
    strokeWeight(staerke);

    if (gitternetz == true) {
      noFill ();
    }
    if (gitternetz == false) {
      fill (rot, gruen, blau);
    }
    cam.beginHUD();    // dann zeichnet er immer genau auf die ebene der kamera wie bei einem heads up display, quasi 2D


      background (230, 230, 230);
    image(bild, horiz*-1.4, vert*-1.4, bild.width * groesse / 100, bild.height * groesse / 100); // horiz mal - 1,3: minus, weil verschiebung nach LINKS auf x-achse, 1,4 und nich 1,0 wegen spielraum für zoom



    ellipse(coordsx[0], coordsy[0], 5, 5);  //erstmal ellipsen
    ellipse(coordsx[1], coordsy[1], 5, 5);
    ellipse(coordsx[2], coordsy[2], 5, 5);
    ellipse(coordsx[3], coordsy[3], 5, 5);
    cam.endHUD();


    if (i == 4) {   //wenn man 4 punkte gezeichnet hat....
      cam.beginHUD();

      beginShape(QUADS);


      vertex(coordsx[0], coordsy[0], 1);  ///...wird aus den punkten die grundfläche gezeichnet
      vertex(coordsx[1], coordsy[1], 1);
      vertex(coordsx[2], coordsy[2], 1);
      vertex(coordsx[3], coordsy[3], 1);
      endShape(CLOSE);
      cam.endHUD();
    }
  }



  if (kameraaktiv == 1) {   // hier ist der HUD-befehl nicht dabei, damit man rotieren kann


    strokeWeight(staerke);

    // println (cam.getLookAt());
    //  println (cam.getDistance());

    background (230, 230, 230);
    image(bild, horiz*-1.4, vert*-1.4, bild.width * groesse / 100, bild.height * groesse / 100);  


    beginShape(QUADS);
    if (gitternetz == true) {
      noFill ();
    }
    if (gitternetz == false) {
      fill (rot, gruen, blau);
    }

    vertex(coordsx[0], coordsy[0], staerke+2);   //untere fläche, die gezeichnet wurde, z achse wert von staerke, damit es keine überchneideidung mit der planebene gibt
    vertex(coordsx[1], coordsy[1], staerke+2);
    vertex(coordsx[2], coordsy[2], staerke+2);
    vertex(coordsx[3], coordsy[3], staerke+2);


    vertex(coordsx[0], coordsy[0], staerke+2);  // Seitenfläche 1
    vertex(coordsx[1], coordsy[1], staerke+2);
    vertex(coordsx[1], coordsy[1], hoehe+staerke);   
    vertex(coordsx[0], coordsy[0], hoehe+staerke);


    vertex(coordsx[2], coordsy[2], staerke+2);  // Seitenfläche 2 gegenüber seitenfl 1
    vertex(coordsx[3], coordsy[3], staerke+2);
    vertex(coordsx[3], coordsy[3], hoehe+staerke);
    vertex(coordsx[2], coordsy[2], hoehe+staerke);


    vertex(coordsx[1], coordsy[1], staerke+2);  // fläche 3
    vertex(coordsx[2], coordsy[2], staerke+2);
    vertex(coordsx[2], coordsy[2], hoehe+staerke);
    vertex(coordsx[1], coordsy[1], hoehe+staerke);


    vertex(coordsx[0], coordsy[0], staerke+2);  // fläche 4 gegenüber fläche 3
    vertex(coordsx[3], coordsy[3], staerke+2);
    vertex(coordsx[3], coordsy[3], hoehe+staerke);
    vertex(coordsx[0], coordsy[0], hoehe+staerke);


    vertex(coordsx[0], coordsy[0], hoehe+staerke);  // obere fläche, deren höhe man verstellen kann
    vertex(coordsx[1], coordsy[1], hoehe+staerke);
    vertex(coordsx[2], coordsy[2], hoehe+staerke);
    vertex(coordsx[3], coordsy[3], hoehe+staerke);



    endShape(CLOSE);
  }


  if (exportieren == true) {
    endRaw();
    println("Exportiert!");
    exportieren = false;
    save(datumundzeit + ".png");
  }
}



String datumundzeit() {
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", Calendar.getInstance()); // für datum und uhrzeit (bennenung der pdf und png)
}

