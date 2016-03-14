class GeoLight {

  HE_Mesh tetrahedronA, tetrahedronB;

  float tetraScale = 1.0;
  float tetraRotate = 0.0;
  
  ArrayList<PVector> lightPositions;
  int nextPositionIndex;
  PVector nextPosition;
  float lightPositionX, lightPositionY, lightPositionZ;
  
  GeoLight() {
    init();
  }
  
  void update() {
    tetraScale = noise(frameCount * 0.03);
    tetraRotate += tetraScale * 0.1;
  }
  
  void draw() {
    lightFalloff(0,0,0.005);
    float intensity = geoLight.getIntensity();
    pointLight(intensity, intensity, intensity, lightPositionX, lightPositionY, lightPositionZ);
    
    pushMatrix();
    translate(lightPositionX, lightPositionY, lightPositionZ);
    rotateZ(tetraRotate);
    rotateY(frameCount * 0.06);
    scale(tetraScale);
    noStroke();
    fill(255, 196);
    emissive(255);
    render.drawFaces(tetrahedronA);
    render.drawFaces(tetrahedronB);
    popMatrix();
  }
  
  void nextPosition() {
    nextPositionIndex = (nextPositionIndex + 1) % lightPositions.size();
    nextPosition = lightPositions.get(nextPositionIndex);
    //Ani.to(lightPosition, 1.5, "x", nextPosition.x);
    //Ani.to(lightPosition, 1.5, "y", nextPosition.y);
    //Ani.to(lightPosition, 1.5, "z", nextPosition.z);
    Ani.to(this, 1.5, "lightPositionX", nextPosition.x);
    Ani.to(this, 1.5, "lightPositionY", nextPosition.y);
    Ani.to(this, 1.5, "lightPositionZ", nextPosition.z);
    
  }
  
  PVector getPosition() {
    return new PVector(lightPositionX, lightPositionY, lightPositionZ);
  }
  
  float getIntensity() {
    return tetraScale * 255;
  }
  
  void init() {
    //tetrahedron = new HE_Mesh(new HEC_Tetrahedron().setRadius(10));
    WB_Point[] points = new WB_Point[4];
    points[0] = new WB_Point(-10, 10, -10);
    points[1] = new WB_Point(10, 10, 10);
    points[2] = new WB_Point(-10, -10, 10);
    points[3] = new WB_Point(10, -10, -10);
    tetrahedronA = new HE_Mesh(new HEC_ConvexHull().setPoints(points));
    points[0] = new WB_Point(-10, 10, 10);
    points[1] = new WB_Point(10, 10, -10);
    points[2] = new WB_Point(10, -10, 10);
    points[3] = new WB_Point(-10, -10, -10);
    tetrahedronB = new HE_Mesh(new HEC_ConvexHull().setPoints(points));
    tetrahedronA.scale(0.92);
    tetrahedronB.scale(0.92);
    
    lightPositions = new ArrayList<PVector>();
    lightPositions.add(new PVector(0, 0, 0));
    lightPositions.add(new PVector(0, 40, 0));
    lightPositions.add(new PVector(0, 40, 40));
    lightPositions.add(new PVector(40, 40, 40));
    lightPositions.add(new PVector(40, 0, 40));
    lightPositions.add(new PVector(40, 0, 0));
    nextPositionIndex = 0;
    PVector lP = lightPositions.get(nextPositionIndex);
    lightPositionX = lP.x;
    lightPositionY = lP.y;
    lightPositionZ = lP.z;
  }
};