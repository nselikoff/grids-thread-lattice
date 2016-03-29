class ThreadLattice {
  HE_Mesh mMesh;
  HE_DynamicMesh mDynMesh;
  HE_Selection mSelection;
  HE_Face mFace;
  HEM_Extrude mExtrude;
  HEM_Wireframe mWireframe;

  List<PVector> mThreadPoints, mUnraveledThreadPoints;
  float mUnravelProgress = 0;

  int mNextFaceIndex = 0;
  List<PVector> mNextFaceDirection;
  PVector mHeadPosition;

  float mLatticeAlpha = 0, mLatticeAlphaMultiplier = 1;
  Ani mLatticeAlphaAni;

  PShader mLatticeShader;

  ThreadLattice() {
    mLatticeShader = loadShader("latticefrag.glsl", "latticevert.glsl");
    // mLatticeShader.set("fraction", 1.0);

    createLattice();

    // the order we want to extrude in
    // note -y is up b/c of Processing
    PVector R = new PVector(1, 0, 0),
            L = new PVector(-1, 0, 0),
            U = new PVector(0, -1, 0),
            D = new PVector(0, 1, 0),
            F = new PVector(0, 0, 1),
            B = new PVector(0, 0, -1);

    mNextFaceDirection = new ArrayList<PVector>();
    mNextFaceDirection.add(R.copy());
    mNextFaceDirection.add(U.copy());
    mNextFaceDirection.add(R.copy());
    mNextFaceDirection.add(B.copy());
    mNextFaceDirection.add(D.copy());
    mNextFaceDirection.add(R.copy());
    mNextFaceDirection.add(B.copy());
    mNextFaceDirection.add(U.copy());
    mNextFaceDirection.add(R.copy());
    mNextFaceDirection.add(B.copy());
    mNextFaceDirection.add(D.copy());
    mNextFaceDirection.add(B.copy());
    mNextFaceDirection.add(B.copy());
    mNextFaceDirection.add(U.copy());    
    mNextFaceDirection.add(B.copy());
    mNextFaceDirection.add(L.copy());
    mNextFaceDirection.add(D.copy());
    mNextFaceDirection.add(B.copy());
    mNextFaceDirection.add(L.copy());
    mNextFaceDirection.add(U.copy());
    mNextFaceDirection.add(B.copy());
    mNextFaceDirection.add(L.copy());
    mNextFaceDirection.add(D.copy());
    mNextFaceDirection.add(L.copy());
    mNextFaceDirection.add(L.copy());
    mNextFaceDirection.add(U.copy());
    mNextFaceDirection.add(L.copy());
    mNextFaceDirection.add(F.copy());
    mNextFaceDirection.add(D.copy());
    mNextFaceDirection.add(L.copy());
    mNextFaceDirection.add(F.copy());
    mNextFaceDirection.add(U.copy());
    mNextFaceDirection.add(L.copy());
    mNextFaceDirection.add(F.copy());
    mNextFaceDirection.add(D.copy());
    mNextFaceDirection.add(F.copy());
    mNextFaceDirection.add(F.copy());
    mNextFaceDirection.add(U.copy());
    mNextFaceDirection.add(F.copy());
    mNextFaceDirection.add(R.copy());
    mNextFaceDirection.add(D.copy());
    mNextFaceDirection.add(F.copy());
    mNextFaceDirection.add(R.copy());
    mNextFaceDirection.add(U.copy());
    mNextFaceDirection.add(F.copy());
    mNextFaceDirection.add(R.copy());
    mNextFaceDirection.add(D.copy());
    mNextFaceDirection.add(R.copy());

    mThreadPoints = new ArrayList<PVector>();
    mThreadPoints.add(new PVector(0, 0, 0));
    mUnraveledThreadPoints = new ArrayList<PVector>();
    mUnraveledThreadPoints.add(new PVector(0, 0, 0));

    mHeadPosition = new PVector(0, 0, 0);
  }
  
  void draw(WB_Render3D render) {
    // Set DepthBufferEnable and DepthBufferWriteEnable to true
    hint(ENABLE_DEPTH_TEST);

    // Draw all opaque geometry
    stroke(255);
    strokeWeight(4);
    noFill();
    emissive(255);
    drawThread();

    // This is a compromise to get the thread to show through the faded/fading lattice, but have it properly drawn otherwise
    if (mLatticeAlpha * mLatticeAlphaMultiplier < 64.0) {
      // Leave DepthBufferEnable set to true, but change DepthBufferWriteEnable to false
      hint(DISABLE_DEPTH_TEST);
    }

    // Sort alpha blended objects by distance from the camera, then draw them in order from back to front
    fill(255, mLatticeAlpha * mLatticeAlphaMultiplier);
    emissive(0);
    noStroke();
    strokeWeight(1);
    
    // avoid a few frames of the underlying mesh being drawn before the modifiers are done updating
    if(mDynMesh.getNumberOfFaces() > 200 * mNextFaceIndex) {
      // shader(mLatticeShader);
      render.drawFaces(mDynMesh);
      // resetShader();
    }
  }

  void drawThread() {
    beginShape(LINES);
    for (int i = 0; i < mThreadPoints.size() - 1; i++) {
      PVector a0 = mThreadPoints.get(i);
      PVector a1 = mUnraveledThreadPoints.get(i);
      PVector b0 = mThreadPoints.get(i + 1);
      PVector b1 = mUnraveledThreadPoints.get(i + 1);
      PVector a = PVector.lerp(a0, a1, mUnravelProgress);
      PVector b = PVector.lerp(b0, b1, mUnravelProgress);
      for (int j = 0; j < 10; j++) {
        float x1 = lerp(a.x, b.x, j * 0.1);
        float y1 = lerp(a.y, b.y, j * 0.1);
        float z1 = lerp(a.z, b.z, j * 0.1);
        float x2 = lerp(a.x, b.x, (j + 1) * 0.1);
        float y2 = lerp(a.y, b.y, (j + 1) * 0.1);
        float z2 = lerp(a.z, b.z, (j + 1) * 0.1);
        vertex(x1 + noise(i, j, frameCount), y1 + noise(i, j, frameCount), z1 + noise(i, j, frameCount));
        vertex(x2 + noise(i, j + 1, frameCount), y2 + noise(i, j + 1, frameCount), z2 + noise(i, j + 1, frameCount));
      }
      // vertex(b.x, b.y, b.z);
    }
    endShape();

  }
  
  HE_Mesh getMesh() {
    return mDynMesh;
  }

  void setLatticeAlphaMultiplier(float alpha) {
    mLatticeAlphaMultiplier = alpha;
  }
  
  void createLattice() {

    HEC_Cube creator = new HEC_Cube()
     .setRadius(10);
    
    mMesh = new HE_Mesh(creator);

    mExtrude = new HEM_Extrude().setDistance(20);
    mWireframe = new HEM_Wireframe().setStrutRadius(1.0).setStrutFacets(4).setMaximumStrutOffset(5).setTaper(false);
    mSelection = new HE_Selection(mMesh);

    mDynMesh = new HE_DynamicMesh(mMesh);
    mDynMesh.add(mWireframe);
    updateDynMesh();
  }

  void updateDynMesh() {
    mDynMesh.setBaseMesh(mMesh);
    mDynMesh.update();    
  }

  void getNextFaceFromFaces( List<HE_Face> faces, PVector direction ) {
    for (HE_Face face : faces ) {
      WB_Coord n = face.getFaceNormal();
      if (n.xf() == direction.x && n.yf() == direction.y && n.zf() == direction.z) {
        mFace = face;
        return;
      }
    }
  }

  void expandLattice() {
    // println("expandLattice " + (mNextFaceIndex + 1));
    
    PVector direction = mNextFaceDirection.get(mNextFaceIndex);
    // if we're at the beginning, no face has been selected yet
    if (mSelection.getOuterEdges().isEmpty()) {
      // select a face from the initial mesh
      getNextFaceFromFaces(mMesh.getFaces(), direction);
    } else {  
      // pick a specific neighbor of the same face
      getNextFaceFromFaces(mFace.getNeighborFaces(), direction);
    }

    // update head position
    mHeadPosition.add(PVector.mult(direction, 40));

    // extend thread
    mUnraveledThreadPoints.add(new PVector(mThreadPoints.size() * 40, 0, 0));
    mThreadPoints.add(mHeadPosition.copy());

    mSelection.clear();
    mSelection.add(mFace);
  
    // extrude some # of times
    for (int j = 0; j < 2; j++) {
      mMesh.modifySelected(mExtrude, mSelection);
    }

    updateDynMesh();

    // set alpha to 0 and animate back in
    mLatticeAlpha = 0;
    mLatticeAlphaAni = Ani.to(this, 3.0, "mLatticeAlpha", 255.0);

    mNextFaceIndex = (mNextFaceIndex + 1) % mNextFaceDirection.size();

    if (mNextFaceIndex == 0 && mThreadPoints.size() > 1) {
      // we're at the beginning again; unravel the thread
      Ani.to(this, 60.0, "mUnravelProgress", 1.0);
    }
  }

  PVector getHeadPosition() {
    return mHeadPosition;
  }

  WB_Coord getLookAt() {
    if (mUnravelProgress == 0.0) {
      return getMesh().getCenter();
    } else {
      return new WB_Point(0, 0, 0);
    }
  }

};