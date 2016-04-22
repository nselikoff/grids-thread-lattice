import wblut.processing.*;
import wblut.hemesh.*;
import wblut.geom.*;
import wblut.core.*;
import wblut.math.*;
import java.util.*;
import peasy.*;
import de.looksgood.ani.*;
import oscP5.*;
import netP5.*;
import codeanticode.syphon.*;

SyphonServer server;

OscP5 oscP5;
NetAddress myBroadcastLocation; 

PeasyCam cam;

WB_Render3D render;

ThreadLattice threadLattice;
GeoLight geoLight;
ParticleSystem ps;

float rotateX = 0;
float rotateY = 0;
float offsetX = -5;
double offsetZ = 10;
float particleVelocityMult = 1.72;

//int screenWidth = 1280, screenHeight = 289;
int screenWidth = 1920, screenHeight = 434;

void settings() {
  size(screenWidth, screenHeight, P3D);
  PJOGL.profile=1; // OpenGL 1.2 / 2.x context, for Syphon compatibility
}

void setup() {
  
  // Create syhpon server to send frames out.
  server = new SyphonServer(this, "thread_lattice");

  smooth(8);
  frameRate(60);

  Ani.init(this);

  render = new WB_Render3D(this);

  threadLattice = new ThreadLattice();

  geoLight = new GeoLight();
  
  ps = new ParticleSystem(new PVector(0, 0, 0));

  perspective(PI/8, float(width)/float(height), 1.0, 10000.0);
  cam = new PeasyCam(this, offsetZ);

  /* create a new instance of oscP5. 
   * 12000 is the port number you are listening for incoming osc messages.
   */
  oscP5 = new OscP5(this,12000);
}

void update() {
  geoLight.update();
  PVector geoLightPosition = geoLight.getPosition();
  ps.setOrigin(geoLightPosition);
  updateLightsAndCamera(geoLightPosition);
  ps.addParticle();
  ps.run();
}

void draw() {
  background(0);

  update();

  geoLight.draw();

  threadLattice.draw(render);
    
  server.sendScreen();
}

void updateLightsAndCamera(PVector geoLightPosition) {
  float[] currLookAt = cam.getLookAt();
  double currOffsetZ = cam.getDistance();
  WB_Coord lookAt = threadLattice.getLookAt();
  cam.lookAt(
    lerp(currLookAt[0], lookAt.xf(), 0.05), 
    lerp(currLookAt[1], lookAt.yf(), 0.05), 
    lerp(currLookAt[2], lookAt.zf(), 0.05), 
    lerp(currOffsetZ, offsetZ, 0.05),
    0
    );
  cam.rotateY(0.001);

  directionalLight(16, 32, 32, 1, 3, -1);
  directionalLight(64, 32, 16, -1, -3, 1);
}

void nextPosition() {
  threadLattice.expandLattice();
  geoLight.setPosition(threadLattice.getHeadPosition());
  offsetX = -offsetX;
}

/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  String addr = theOscMessage.addrPattern();
  String typetag = theOscMessage.typetag();
  float floatVal = 0;
  boolean boolVal = false;
  
  if (typetag.equals("f"))
    floatVal = theOscMessage.get(0).floatValue();
  else if (typetag.equals("b"))
    boolVal = theOscMessage.get(0).booleanValue();
  
  if (addr.equals("/FromVDMX/Slider1")) {
  }
  else if (addr.equals("/FromVDMX/Slider2")) {
  }
  else if (addr.equals("/FromVDMX/Slider3")) {
  }
  else if (addr.equals("/FromVDMX/Slider4")) {
  }
  else if (addr.equals("/FromVDMX/Slider5")) {
    // ps.setRate(floatVal);
  }
  else if (addr.equals("/FromVDMX/Slider6")) {
    // particleVelocityMult = map(floatVal, 0, 1, 1, 5);
  }
  else if (addr.equals("/FromVDMX/Slider7")) {
    offsetZ = map(floatVal, 0, 1, 10, 500);
  }
  else if (addr.equals("/FromVDMX/Slider8")) {
    threadLattice.setLatticeAlphaMultiplier(floatVal);
  }
  else if (addr.equals("/FromVDMX/S1")) {
     nextPosition(); 
  }
  else if (addr.equals("/FromVDMX/M1")) {
  }
  else if (addr.equals("/FromVDMX/R1")) {
  }

  // theOscMessage.print();
}

double lerp(double start, double end, double amt){
 return start + (end-start)*amt; 
}

// void keyPressed(KeyEvent e) {
//   nextPosition();
// }