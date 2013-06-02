/**
 * Getting Started with Capture.
 * 
 * Reading and displaying an image from an attached Capture device. 
 */ 

import java.util.Date;

import processing.video.*;

Capture cam;

PImage[] diff = new PImage[2];
ArrayList anim = new ArrayList();

int ind = 0;

void setup() {
  //size(1280, 720, P2D);
  size(1280, 720);//, P2D);

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
    //cam = new Capture(this, "name=/dev/video1,size=640x480,fps=10");
    cam = new Capture(this, "name=/dev/video0,size=640x480,fps=10");
    cam.start();     
  }     

  frameRate(30);
  //for (int i =0; i < anim.length; i++) {
  //  anim[i] = createImage(640,480,RGB);
  //}
}

int highest_saved_ind = 0;

void saveFrames() {
  Date dt = new Date();
  long ts = dt.getTime();
  int i = 0;
  for (i = highest_saved_ind; i < anim.size(); i++) {
    String name = "data/cur-" + ts + "_" + (10000+i) + ".png";
    ((PImage)anim.get(i)).save(name);
  }
  println("saved " + anim.size() + " - " + highest_saved_ind + " frames");
  highest_saved_ind = i;
}

int start_ind = 0;
int ind2 = 0;
boolean cap = false;
int speed = 5;

void keyPressed() {

  if (key == 'x') {
    saveFrames();
    anim.clear();
  }

  if (key == 'h') {
    speed--;
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
  boolean cap_new_frame = false;

  if (cam.available() == true) {
    //println("test");
    cam.read();
    cap_new_frame = true;
  
    image(cam, 0, 0, 640, 480);
    // The following does the same, and is faster when just drawing the image
    // without any additional resizing, transformations, or tint.
    //set(0, 0, cam);
    if (cap) {
      PImage tmp = createImage(cam.width, cam.height, RGB);
      tmp.copy(cam, 0, 0, tmp.width, tmp.height, 0, 0, 640, 480);
      anim.add(tmp);
      //anim[ind].copy(cam, 0, 0, 640,480, 0, 0, 640,480);
      //ind++;
      //ind = ind % anim.length;
      cap = false;
    }
  }

  //if (anim[ind2] != null) {
  if ((count % speed == 0) && (anim.size() > 0)) {
    
    PImage cur_frame;
    color text_col;
    String text;
    //if (false) {
    if (ind2 == anim.size() ) {
      // preview the current frame
      cur_frame = cam;  
      text_col = color(0,255,0);
      text = "preview";
    } else {
      ind2 = ind2 % anim.size();
      if (ind2 < start_ind) { ind2 = start_ind; }
      text = str(ind2);
      cur_frame = (PImage)anim.get(ind2);
      text_col = color(255);
    }
    
    image(cur_frame, 640, 0, 640, 480);
    
    textSize(20);
    fill(0);
    text(text, 640, 30); 
    fill(text_col);
    text(text, 642, 31); 
    ind2++;
   
    noStroke();
    fill(0);
    rect(640, 475, 360, 5); 
    fill(255);
    rect(640, 476, 640*(ind2+1)/anim.size(), 3); 
    fill(128);
    rect(640, 476, 640*(start_ind)/anim.size(), 3); 
  }
  text(anim.size(), 1200, 31); 
 
  // onion skin
  if ((cap_new_frame) && (anim.size() > 0)) {
    PImage preview = cam;
    PImage last = (PImage)anim.get(anim.size() - 1);
    PImage diff = createImage(cam.width, cam.height, RGB);

    preview.loadPixels();
    last.loadPixels();
    diff.loadPixels();
    for (int i = 0; i < cam.pixels.length; i++) {
      color c1 = preview.pixels[i];
      color c2 = last.pixels[i];
      float f1 = 0.5;
      float f2 = 0.5;
      float dr = (red(c1)*f1 + red(c2)*f2);
      float dg = (green(c1)*f1 + green(c2)*f2);
      float db = (blue(c1)*f1 + blue(c2)*f2);
     
      diff.pixels[i] = color(dr, dg, db);
    }
    diff.updatePixels();
    image(diff, 640+320, 480, 320, 240);
  }
  
  // image diff
  if ((cap_new_frame) && (anim.size() > 0)) {
    PImage preview = cam;
    PImage last = (PImage)anim.get(anim.size() - 1);
    PImage diff = createImage(cam.width, cam.height, RGB);

    preview.loadPixels();
    last.loadPixels();
    diff.loadPixels();
    // TBD use blend() instead
    for (int i = 0; i < cam.pixels.length; i++) {
      color c1 = preview.pixels[i];
      color c2 = last.pixels[i];
      float dr = (red(c1) - red(c2));
      float dg = (green(c1) - green(c2));
      float db = (blue(c1) - blue(c2));
      // this logic is presuming light/dark differences
      // means one image or another is preferred
      if (dr + dg + db > 40) {
        dr = red(c2); 
        dg = green(c2); 
        db = blue(c2); 
      }
      if (dr + dg + db < -40) {
        dr = red(c1); 
        dg = green(c1); 
        db = blue(c1); 
      }
      diff.pixels[i] = color(dr, dg, db);
    }
    diff.updatePixels();
    image(diff, 640, 480, 320, 240);
  }


  count++;
}
