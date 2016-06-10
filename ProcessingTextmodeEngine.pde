// Processing Textmode Engine
// Version 0.1 (initial release)
// by Don Miller / NO CARRIER
// http://www.no-carrier.com
// Have fun! :)

// Thanks, I will!
// This fork adds the option to limit colours to a CGA-style 16-colour palette.

PFont font;       // textmode font
PGraphics b;      // screen buffer
PImage img;       // used for face.png
boolean CGA = true; //draw using only CGA-style 16-colour palette
color[] CGApalette = new color[16];
int[] CGApaletteRGB = { 0,   0,   0,   //black
                        170, 0,   0,   //red 
                        0,   170, 0,   //green
                        170, 85,  0,   //brown
                        0,   0,   170, //blue
                        170, 0,   170, //magenta
                        0,   170, 170, //cyan
                        170, 170, 170, //grey
                        85,  85,  85,  //dark grey
                        255, 85,  85,  //bright red
                        85,  255, 85,  //bright green
                        255, 255, 85,  //yellow
                        85,  85,  255, //bright blue
                        255, 85,  255, //bright magenta
                        85,  255, 255, //cyan
                        255, 255, 255 };//white

int segSize;      // segment size, see renderTextMode tab for (lots) more detail 
int display = 3;  // choose which demo to display, starts with face image
float tick;       // counter, used for sin calcuations for shape rotation

boolean doDraw = true;      // draw or pause
boolean blockMode = false;  // block mode or ASCII mode
boolean fps = false;        // show FPS or not
boolean textMode = true;    // show buffer (stretched to fit screen) or textmode

void setup() {
  size(1024, 768, P2D);     // need to use P2D as renderer, as we use P3D for buffer
  img = loadImage("face.png");
  noSmooth();               // keep it blocky :)
  noCursor();               // don't need this!
  initTextmode();           // set up buffer, load font for textmode output
  for (int i=0; i<16; i++) {
    CGApalette[i] = color(CGApaletteRGB[i*3], CGApaletteRGB[i*3+1], CGApaletteRGB[i*3+2]); //create palette from RGB values
  }
}

void draw() {
  if (doDraw) {    
    tick = tick + 0.01;

    helloWorld();           // let's show off the textmode engine, shall we?

    // render options 
    if (textMode) {         // choose how to render:
      background(0);
      renderTextMode();     // display textmode...
    } else {
      background(0);
      image(b, 0, 0, width, height);  // ...or display buffer (stretched to fit screen)
    }
    if (fps) {
      fill(0); 
      rect(0, 0, 32, 16);
      fill(255);
      text(int(frameRate), 0, 0);
    }
  }
}

void helloWorld() {
  b.beginDraw();
  b.background(0);
  switch(display) {
  case 1: 
    drawImage();
    break;
  case 2:
    drawBox();    
    break;
  case 3:
    drawBoxFilled();    
    break;
  case 4:
    drawSphere();
    break;
  }
  b.endDraw();
}

void drawImage()  // draws and rotates a face image
{
  b.translate(b.width/2, b.height/2);
  b.rotateY((tick*100)*TWO_PI/360);
  b.translate(-img.width/2, -img.height/2);
  b.image(img, 0, 0);
}

void drawBox() {  // draws a wireframe cube with simple lighting
  b.lights();
  b.pushMatrix();
  b.translate(b.width/2, b.height/2, 0); 
  b.rotateY(tick);
  b.rotateX(-tick);
  b.noFill();
  b.strokeWeight(6);
  b.stroke(255, 255, 0);
  b.box(100);
  b.popMatrix();
}

void drawBoxFilled() {  // draws a filled cube with a spotlight
  b.spotLight(0, 255, 0, b.width/2, b.height/2, 400, 0, 0, -1, PI/4, 2);
  b.pushMatrix();
  b.translate(b.width/2, b.height/2, 0); 
  b.rotateY(tick);
  b.rotateX(-tick);
  b.fill(255);
  b.strokeWeight(6);
  b.stroke(255, 255, 0);
  b.box(100);
  b.popMatrix();
}

void drawSphere() {  // draws a filled sphere with a spotlight
  b.spotLight(255, 0, 0, b.width/2, b.height/2, 400, 0, 0, -1, PI/4, 2);
  b.pushMatrix();
  b.translate(b.width/2, b.height/2, 0);
  b.rotateY(-tick);
  b.rotateX(+tick);
  b.strokeWeight(4);
  b.stroke(255, 165, 0);
  b.fill(255);
  b.sphereDetail(10);
  b.sphere(80);
  b.popMatrix();
}

void keyPressed() {
  if (key == 'q') { 
    fps = !fps;
  }
  if (key == 'a') {
    blockMode = !blockMode;
  } 
  if (key == 'z') { 
    textMode = !textMode;
  }
  if (key == 'p') { 
    doDraw = !doDraw;
  }
  if (key == ' ') { // this is the spacebar ;)
    display++;
    if (display > 4) {
      display = 1;
    }
  }
}
