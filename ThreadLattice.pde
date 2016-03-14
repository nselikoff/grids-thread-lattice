class ThreadLattice {
  HE_Mesh mesh;
  HE_Selection selection;
  HE_Face face;
  HEM_Extrude extrude;

  ThreadLattice() {
    createLattice();
  }
  
  void draw(WB_Render3D render) {
    fill(255);
    emissive(0);
    noStroke();
    render.drawFaces(mesh);
  }
  
  HE_Mesh getMesh() {
    return mesh;
  }
  
  void createLattice() {
    HEC_Cube creator = new HEC_Cube()
     .setRadius(10);
    
    mesh = new HE_Mesh(creator);
    
    selection = new HE_Selection(mesh);
    
    // select a face from the initial mesh
    HE_Face[] faces = mesh.getFacesAsArray();
    mesh.deleteFace(faces[5]);
    face = faces[3];
    selection.add(face);
  
    // extrude the selection some # of times
    extrude = new HEM_Extrude().setDistance(20);
    for (int i = 0; i < 2; i++) {
      mesh.modifySelected(extrude, selection);
    }
  
    selection.clear();
  
    // pick a specific neighbor of the same face
    List<HE_Face> neighbors = face.getNeighborFaces();
    face = neighbors.get(0);
    selection.add(face);
    
    // extrude some # of times
    for (int j = 0; j < 2; j++) {
      mesh.modifySelected(extrude, selection);
    }
  
    selection.clear();
  
    // pick a specific neighbor of the same face
    neighbors = face.getNeighborFaces();
    face = neighbors.get(1);
    selection.add(face);
    
    // extrude some # of times
    for (int j = 0; j < 2; j++) {
      mesh.modifySelected(extrude, selection);
    }
  
    selection.clear();
  
    // pick a specific neighbor of the same face
    neighbors = face.getNeighborFaces();
    face = neighbors.get(3);
    selection.add(face);
    
    // extrude some # of times
    for (int j = 0; j < 2; j++) {
      mesh.modifySelected(extrude, selection);
    }
  
    selection.clear();
  
    // pick a specific neighbor of the same face
    neighbors = face.getNeighborFaces();
    face = neighbors.get(1);
    selection.add(face);
    
    // extrude some # of times
    for (int j = 0; j < 2; j++) {
      mesh.modifySelected(extrude, selection);
    }
  
    selection.clear();
  
    // pick a specific neighbor of the same face
    neighbors = face.getNeighborFaces();
    face = neighbors.get(3);
    selection.add(face);
    
    // extrude some # of times
    for (int j = 0; j < 1; j++) {
      mesh.modifySelected(extrude, selection);
    }
  
    // delete the extra face
    mesh.deleteFace(face);
  
    //clean-up mesh
    mesh.clean();
    
    mesh.modify(new HEM_Wireframe().setStrutRadius(1.0).setStrutFacets(4).setMaximumStrutOffset(5).setTaper(false));

  }
};