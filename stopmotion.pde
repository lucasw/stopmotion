/**
 * Getting Started with Capture.
 * 
 * Reading and displaying an image from an attached Capture device. 
 */ 

import java.util.Date;

import processing.video.*;

Capture cam;

ArrayList anim = new ArrayList();

int save_count = 0;
int ind = 0;

Date dt = new Date();
long ts = dt.getTime();

int cap_w = 640;
int cap_h = 360;

void setup() {
  //size(1280, 720, P2D);
  size(cap_w * 2, cap_h * 2);

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
    //cam = new Capture(this, "name=/dev/video1,size=1920x1080,fps=5");
    //cam = new Capture(this, "name=/dev/video1,size=1504x832,fps=5");
    //cam = new Capture(this, "name=/dev/video1,size=2592x1944,fps=2");
    //cam = new Capture(this, "name=/dev/video1,size=640x480,fps=10");
    cam = new Capture(this, "name=/dev/video0,size=640x480,fps=10");
    cam.start();     
  }     

  frameRate(30);
}

int highest_saved_ind = 0;

void saveFrames() {
  int i = 0;
  for (i = highest_saved_ind; i < anim.size(); i++) {
    String name = "data/cur-" + ts + "_" + (10000+i) + ".jpg";
    print(name + "\n");
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
    //saveFrames();
    anim.clear();
    highest_saved_ind = 0;
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
    //saveFrames();
   
  }

} //keyPressed

int count = 0;

float colorDist(color c1, color c2) {
  float dr = (red(c1) - red(c2));
  float dg = (green(c1) - green(c2));
  float db = (blue(c1) - blue(c2));

  return (dr + dg + db);
}
     
void draw() {
  boolean cap_new_frame = false;

  PImage cam_thumb = createImage(cap_w, cap_h, RGB);
  cam_thumb.copy(cam, 
      0, 0, cam.width, cam.height, 
      0, 0, cam_thumb.width, cam_thumb.height);

  if (cam.available() == true) {
    //println("test");
    cam.read();
    cap_new_frame = true;
  
    image(cam, 0, 0, cap_w, cap_h);
    // The following does the same, and is faster when just drawing the image
    // without any additional resizing, transformations, or tint.
    //set(0, 0, cam);
    if (cap) {
      anim.add(cam_thumb);
      
      String name = "data/cur_" + ts + "_" + (10000 + save_count++) + ".jpg";
      print(name + "\n");
      cam.save(name);

      //saveFrames();
      //anim[ind].copy(cam, 0, 0, 640,480, 0, 0, 640,480);
      //ind++;
      //ind = ind % anim.length;
      cap = false;
    }
  }

  final int h = cap_h; //height - cap_h;
  final int w = cap_w; //h * cap_w / cap_h;

  //if (anim[ind2] != null) {
  if ((count % speed == 0) && (anim.size() > 0)) {
    
    PImage cur_frame;
    color text_col;
    String text;
    //if (false) {
    if (ind2 == anim.size() ) {
      // preview the current frame
      cur_frame = cam_thumb;  
      text_col = color(0,255,0);
      text = "preview";
    } else {
      ind2 = ind2 % anim.size();
      if (ind2 < start_ind) { ind2 = start_ind; }
      text = str(ind2);
      cur_frame = (PImage)anim.get(ind2);
      text_col = color(255);
    }
    
    image(cur_frame, cap_w, 0, cap_w, cap_h);
    
    textSize(20);
    fill(0);
    text(text, cap_w, 30); 
    fill(text_col);
    text(text, cap_w + 2, 31); 
    ind2++;
   
    noStroke();
    // position in animation bar
    fill(0);
    rect(cap_w, cap_h-4, cap_w, 5); 
    fill(255);
    rect(cap_w, cap_h-3, cap_w * (ind2+1)/anim.size(), 3); 
    fill(128);
    rect(cap_w, cap_h-3, cap_w * (start_ind)/anim.size(), 3); 
  }
  text(anim.size(), 1200, 31); 
 
  // onion skin
  if ((cap_new_frame) && (anim.size() > 1)) {
    PImage preview = cam_thumb;
    PImage last = (PImage)anim.get(anim.size() - 1);
    PImage last2 = (PImage)anim.get(anim.size() - 2);
    PImage diff = createImage(cam_thumb.width, cam_thumb.height, RGB);

    // TBD could use blend OVERLAY instead, almost the same
    preview.loadPixels();
    last.loadPixels();
    last2.loadPixels();
    diff.loadPixels();
    for (int i = 0; i < cam_thumb.pixels.length; i++) {
      color c1 = preview.pixels[i];
      color c2 = last.pixels[i];
      color c3 = last2.pixels[i];
      float f1 = 0.37;
      float f2 = 0.33;
      float f3 = 0.3;
      float color_dist = colorDist(c1, c2);
      
      // try out highlighting difference somewhat,
      // not satisfied with it though
      /*if (abs(color_dist) > 20) {
        f1 = 0.8;
        f2 = 0.15;
        f3 = 0.05;
      }*/

      float dr = red(c1)*f1   + red(c2)*f2   + red(c3)*f3;
      float dg = green(c1)*f1 + green(c2)*f2 + green(c3)*f3;
      float db = blue(c1)*f1  + blue(c2)*f2  + blue(c3)*f3;
     
      diff.pixels[i] = color(dr, dg, db);
    }
    diff.updatePixels();
    image(diff, width - w*2, cap_h, w, h);
  }
 
  //////////////////////////////////////
  // image diff
  if ((cap_new_frame) && (anim.size() > 0)) {
    PImage preview = cam_thumb;
    PImage last = (PImage)anim.get(anim.size() - 1);
    PImage diff = createImage(cam_thumb.width, cam_thumb.height, RGB);
    
    if (true) {
    preview.loadPixels();
    last.loadPixels();
    diff.loadPixels();
    // TBD use blend() instead
    for (int i = 0; i < cam_thumb.pixels.length; i++) {
      color c1 = preview.pixels[i];
      color c2 = last.pixels[i];
      //float color_dist = colorDist(c1, c2);
      float dr = (red(c1) - red(c2));
      float dg = (green(c1) - green(c2));
      float db = (blue(c1) - blue(c2));
      // this logic is presuming light/dark differences
      // means one image or another is preferred
      // if there is a light background (like a lit green screen)
      // then this logic works well
      if (dr + dg + db > 40) {
        dr = red(c2) * 1.1; 
        dg = green(c2) * 0.7; 
        db = blue(c2) * 0.7; 
      }
      if (dr + dg + db < -40) {
        dr = red(c1) * 0.8; 
        dg = green(c1) * 1.1; 
        db = blue(c1) * 0.8; 
      }
      final float fr = 0.6;
      diff.pixels[i] = color(dr * fr, dg * fr, db * fr);
    }
    diff.updatePixels();
    } else {
      //PImage tmp = createImage(cam_thumb.width, cam_thumb.height, RGB);
      diff.copy(last, 0, 0, last.width, last.height, 0, 0, diff.width, diff.height);
      diff.blend(preview, 0, 0, last.width, last.height, 0, 0, diff.width, diff.height, DIFFERENCE);
    }
    image(diff, cap_w, cap_h, w, h);
  }
  // end diff

  count++;
}
