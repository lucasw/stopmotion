/**
 * Getting Started with Capture.
 * 
 * Reading and displaying an image from an attached Capture device. 
 */ 

import java.util.Date;

import processing.video.*;

Capture cam;

//PImage[] anim = new PImage[20];
ArrayList anim = new ArrayList();

int ind = 0;

void setup() {
  //size(1280, 720, P2D);
  size(1280, 480);//, P2D);

  String[] cameras = Capture.list();
  
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }
    
    // The camera can be initialized directly using an element
    // from the array returned by list():
    //cam = new Capture(this, cameras[0]);
    cam = new Capture(this, "name=/dev/video1,size=640x480,fps=10");
    //"name=/dev/video0,size=640x480,fps=10");
    cam.start();     
  }     

  frameRate(30);
  //for (int i =0; i < anim.length; i++) {
  //  anim[i] = createImage(640,480,RGB);
  //}
}

void saveFrames() {
  Date dt = new Date();
  long ts = dt.getTime();

  for (int i = 0; i < anim.size(); i++) {
    String name = "data/cur-" + ts + "_" + (10000+i) + ".png";
    ((PImage)anim.get(i)).save(name);
  }
  println("saved " + anim.size() + " frames");
}

int start_ind = 0;
int ind2=0;
boolean cap = false;
int speed = 5;

void keyPressed() {

  if (key == 'x') {
    saveFrames();
    anim.clear();
  }

  if (key == 'h') {
    speed --;
    if (speed < 1) { speed = 1; }
  }
  if (key == 'l') {
    speed++;
    if (speed < 1) { speed = 1; }
  }
  if (key == 'j') {
    start_ind--;
    if (start_ind < 0) { start_ind = 0; }
    println("start ind " + start_ind + " " + anim.size());
  }
  if (key == 'k') {
    start_ind++;
    if (start_ind > anim.size()-3) { start_ind = anim.size()-3; }
    if (start_ind < 0) { start_ind = 0; }
    println("start ind " + start_ind + " " + anim.size());
  }

  if (key == 'f') {
    cap = true;
  }

  if (key == 'p') {
    saveFrames();
   
  }

} //keyPressed

int count = 0;

void draw() {
  if (cam.available() == true) {
    //println("test");
    cam.read();
  
    image(cam, 0, 0, 640, 480);
    // The following does the same, and is faster when just drawing the image
    // without any additional resizing, transformations, or tint.
    //set(0, 0, cam);
    if (cap) {
      PImage tmp = createImage(640,480,RGB);
      tmp.copy(cam, 0, 0, 640,480, 0, 0, 640,480);
      anim.add(tmp);
      //anim[ind].copy(cam, 0, 0, 640,480, 0, 0, 640,480);
      //ind++;
      //ind = ind % anim.length;
      cap = false;
    }
  }

  //if (anim[ind2] != null) {
  if ((count % speed == 0) && (anim.size() > 0)) {
    ind2 = ind2 % anim.size();
    if (ind2 < start_ind) { ind2 = start_ind; }
    image((PImage)anim.get(ind2), 640,0,640,480);
    
    textSize(20);
    fill(0);
    text(ind2, 640, 30); 
    fill(255);
    text(ind2, 642, 31); 
    ind2++;
   
    noStroke();
    fill(0);
    rect(640, 475, 360, 5); 
    fill(255);
    rect(640, 476, 640*(ind2+1)/anim.size(), 3); 
    fill(128);
    rect(640, 476, 640*(start_ind)/anim.size(), 3); 
  }
  
  count++;
}
