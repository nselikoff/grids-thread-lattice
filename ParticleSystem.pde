// A class to describe a group of Particles
// An ArrayList is used to manage the list of Particles 

class ParticleSystem {
  ArrayList<Particle> particles;
  PVector origin;
  float rate;

  ParticleSystem(PVector location) {
    setOrigin(location);
    particles = new ArrayList<Particle>();
    rate = 0;
  }

  void addParticle() {
    //if (rate > 0.5) {
      for (int i = 0; i < int(rate*20); i++) {
        particles.add(new Particle(origin));
      }
    //} else {
    //}
  }

  void run() {
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.run();
      if (p.isDead()) {
        particles.remove(i);
      }
    }
  }
  
  void setOrigin(PVector location) {
    origin = location.copy();
  }
  
  void setRate(float aRate) {
    rate = aRate;
  }
}