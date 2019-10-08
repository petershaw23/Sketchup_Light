import processing.opengl.*;
import controlP5.*;
import javax.swing.*; 
boolean orbit = false;
boolean oeffnen = false;
PImage a;


 // ArrayList to hold a dynamic number of points
    ArrayList <PVector> points = new ArrayList <PVector>();

    
 




// N Taste: Neues Bild öffnen
void keyPressed() {
  if (key == 'N' || key == 'n') { 
  oeffnen = true;
  }
 if (key == 'o' || key == 'O') { 
  orbit = true;
 }
}




void setup() {
  imageMode(CENTER);
  size(800, 800, OPENGL);
 hint(ENABLE_OPENGL_4X_SMOOTH);
 
 }
 
 

void draw() {

 
 if (orbit == true) {
   orbitmodus();
 }
 
  if (orbit == false) {
    zeichenmodus();
}
  
 


//dateibrowser ///////Quelle: http://wiki.processing.org/w/Open_Files_through_a_GUI ////////////////////////////////////////////////////////
if (oeffnen == true) {
  final JFileChooser fc = new JFileChooser(); 
  int returnVal = fc.showOpenDialog(this); // in response to a button click: 
    if (returnVal == JFileChooser.APPROVE_OPTION) { 
      File file = fc.getSelectedFile(); // see if it's an image (better to write a function and check for all supported extensions) 
      if (file.getName().endsWith("jpg")) { 
      a = loadImage(file.getPath());  // load the image using the given file path
      if (a != null) { 
      image(a,width/2,height/2);
       

    } 
  } else { 
    String lines[] = loadStrings(file); // just print the contents to the console note: loadStrings can take a Java File Object too 
    for (int i = 0; i < lines.length; i++) { 
      println(lines[i]);

    } 
  } 
}

    else { 
      println("Open command cancelled by user."); 
}

    oeffnen = false; 
 

}
}



void zeichenmodus () {
  
    

  
      // show all the rectangles from the points in the ArrayList
      for (int i=1; i<points.size(); i+=2) {
        PVector p1 = points.get(i-1);
        PVector p2 = points.get(i);
        line(p1.x,p1.y,p2.x,p2.y);
      }
      // show a rectangle from the last open point to the mouse
     // if (points.size() % 2 == 1) {
       // PVector p = points.get(points.size()-1);
       // line(p.x,p.y,mouseX,mouseY);
     // }
    }

    void mousePressed() {
      // on a mouse click add a point at the mouse position
      points.add( new PVector(mouseX,mouseY) );
    }






void orbitmodus () {
  
}

