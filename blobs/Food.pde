class Food {

  PVector pos;
  PVector vel;
  PVector acc;
  float size;

  Food() {
    pos = new PVector(random(width), random(height));
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);
    size = 5;
  }

  void display() {
    stroke(0);
    strokeWeight(2);
    fill(200, 225, 100);
    rect(pos.x + size / 2, pos.y + size / 2, size, size);
  }

  void update() {
    vel.add(acc);
    vel.limit(1);
    pos.add(vel);
    acc.mult(0);
    if (pos.x > width || pos.x < 0 || pos.y > height || pos.y < 0 ) {
     pos.x = random(width);
     pos.y = random(height);
    }
  }

  void attract(ArrayList<Cell> cels) {
    for (Cell cel : cels ) {
      float d = dist(pos.x, pos.y, cel.pos.x, cel.pos.y);
      float r = sqrt(cel.area / PI );
      if ( d < 15 + r) {
        PVector v_cop = pos.copy();
        PVector c_cop = cel.pos.copy();
        acc.add(c_cop.sub(v_cop) );
      }
    }
  }
}
