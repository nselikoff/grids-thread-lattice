// A simple Particle class

class Particle {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float lifespan;
  float pulsePhase;

  Particle(PVector l) {
    acceleration = new PVector(0,0,0);
    velocity = new PVector(random(-0.1,0.1),random(-0.1,0.1),random(-0.1,0.1));
    location = l.copy();
    lifespan = 255.0;
    pulsePhase = random(0.05, 0.1);
  }

  void run() {
    update();
    display();
  }

  // Method to update location
  void update() {
    velocity.add(acceleration);
    location.add(PVector.mult(velocity, particleVelocityMult));
    lifespan -= 2.0;
  }

  // Method to display
  void display() {
    float pulse = sin(frameCount * pulsePhase) * 0.5 + 0.5;
    //stroke(255, pulse * lifespan);
    //fill(255, pulse * lifespan);
    //emissive(lifespan);
    stroke(255, pulse * 255);
    fill(255);
    emissive(pulse * 255);
    //noFill();
    pushMatrix();
    translate(location.x, location.y, location.z);
    rotateX(lifespan * 0.01);
    rotateY(lifespan * 0.01);
    box(lifespan / 255);
    popMatrix();
  }
  
  // Is the particle still useful?
  boolean isDead() {
    if (lifespan < 0.0) {
      return true;
    } else {
      return false;
    }
  }
}