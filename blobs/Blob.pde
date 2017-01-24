class  Cell {

  DNA dna;
  PVector pos;
  PVector vel;
  PVector acc;
  float c_seek;
  float c_flee;
  float maxforce;
  float maxvel;
  color c;
  float area;
  float vision;
  float splitSize;

  Cell(PVector pos_) {
    dna = new DNA();
    pos = pos_;
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);
    c_seek = dna.genes.get(0);
    c_flee = 1 - c_seek;
    vision = dna.genes.get(1);
    splitSize = dna.genes.get(2);
    c = color(map(c_seek, 0, 1, 0, 255), map(vision, 50, 300, 0, 255), map(splitSize, 100, 255, 0, 255));
    area = 50;
    maxforce = 50;
    maxvel = 1;
  }

  ArrayList eat(ArrayList<Cell> cells, ArrayList<Food> fuds) {

    ArrayList<Cell> to_remove = new ArrayList<Cell>();

    float r = sqrt(area/PI);

    for (int i = 0; i < cells.size(); i++) {
      Cell cel = cells.get(i);
      float cel_r = sqrt(cel.area/PI);

      if (dist(cel.pos.x, cel.pos.y, pos.x, pos.y) < (cel_r + r) && r > cel_r ) {
        to_remove.add(cel);
        area += cel.area;
      }

      if (cel.area < 5) {
        to_remove.add(cel);
      }
    }

    for (int i = fuds.size() - 1; i >= 0; i--) {
      Food fud = fuds.get(i);

      if (dist(fud.pos.x, fud.pos.y, pos.x, pos.y) < ((fud.size) + r)) {
        area += 1;
        fuds.remove(i);
      }
    }

    return to_remove;
  }

  void multiply() {
  }


  void express_DNA() {
    c_seek = dna.genes.get(0);
    c_flee = 1 - c_seek;
    vision = dna.genes.get(1);
    splitSize = dna.genes.get(2);
    c = color(map(c_seek, 0, 1, 0, 255), map(vision, 50, 300, 0, 255), map(splitSize, 100, 255, 0, 255));
  }


  void die() {
    area = .998 * area;
  }

  //void separate(ArrayList<Cell> cels) {
  //  PVector accu = new PVector(0, 0);
  //  for (Cell cel : cels) {
  //    float di = dist(pos.x, pos.y, cel.pos.x, cel.pos.y);
  //    if (cel.c == c && cel != this && di < 80) {
  //      map(di, 0, maxdist, 0, 1);
  //      float scale = 1 / di;
  //      PVector v = vel.copy();
  //      PVector p = pos.copy();
  //      PVector t = cel.pos.copy();
  //      PVector f = p.sub(t);
  //      f.normalize();
  //      f.mult(scale);
  //      accu.add(f);
  //    }
  //  }
  //  acc.add(accu);
  //}


  PVector steer(Cell cell, PVector pos) {
    PVector v = cell.vel.copy();
    PVector p = cell.pos.copy();
    PVector t = pos.copy();
    PVector f = t.sub(p);
    f.sub(v);
    f.normalize();
    return f;
  }



  void seek(ArrayList<Cell> cels, ArrayList<Food> foods) {
    PVector accu = new PVector(0, 0);
    for (Cell cel : cels) {
      float di = dist(pos.x, pos.y, cel.pos.x, cel.pos.y);
      if (cel.area < area && di < vision) {
        PVector tar = steer(this, cel.pos);
        float scale = 1 / dist(pos.x, pos.y, cel.pos.x, cel.pos.y);
        tar.mult(scale);
        accu.add(tar);
      }
    }

    for (Food fud : foods) {
      float di = dist(pos.x, pos.y, fud.pos.x, fud.pos.y);
      if (di < 200) {
        PVector tar = steer(this, fud.pos);
        float scale = 1 / dist(pos.x, pos.y, fud.pos.x, fud.pos.y);
        tar.mult(scale);
        accu.add(tar);
      }
    }

    acc.add(accu);
  }

  void flee(ArrayList<Cell> cels) {
    PVector accu = new PVector(0, 0);
    for (Cell cel : cels) {
      float di = dist(pos.x, pos.y, cel.pos.x, cel.pos.y);
      if (cel.area > area && di < vision) {
        float scale = 1 / dist(pos.x, pos.y, cel.pos.x, cel.pos.y);
        PVector v = vel.copy();
        PVector p = pos.copy();
        PVector t = cel.pos.copy();
        PVector f = p.sub(t); 
        f.normalize();
        f.mult(scale);
        accu.add(f);
      }
    }
    acc.add(accu);
  }

  //Cell CloseSmall(ArrayList<Cell> cells) {
  //  Cell best = new Cell(pos, c, r+1);
  //  for (Cell cell : cells) {
  //    float closest = 999999;
  //    if (cell.r < r && int(cell.c) != int(c)) {
  //      if (dist(cell.pos.x, cell.pos.y, pos.x, pos.y) < closest ) {
  //        closest = dist(cell.pos.x, cell.pos.y, pos.x, pos.y);
  //        best = cell;
  //      }
  //    }
  //  }
  //  return best;
  //}

  //Cell CloseBig(ArrayList<Cell> cells) {
  //  Cell best = new Cell(pos, c, r-1);
  //  for (Cell cell : cells) {
  //    float closest = 999999;
  //    if (cell.r > r && int(cell.c) != int(c)) {
  //      if (dist(cell.pos.x, cell.pos.y, pos.x, pos.y) < closest ) {
  //        closest = dist(cell.pos.x, cell.pos.y, pos.x, pos.y);
  //        best = cell;
  //      }
  //    }
  //  }
  //  return best;
  //}

  void update() {
    float r = sqrt(area/PI);
    acc.limit(maxforce);
    vel.add(acc);
    vel.limit(maxvel);
    pos.add(vel);
    acc.mult(0);

    if (pos.x - r < 0) {
      vel.x *= -1;
      pos.x = r + 1;
    }

    if (pos.x + r > width) {
      vel.x *= -1;
      pos.x = width - (r + 1);
    }

    if (pos.y - r < 0) {
      vel.y *= -1;
      pos.y = r + 1;
    }

    if (pos.y + r > height) {
      vel.y *= -1;
      pos.y = height - (r + 1);
    }
  }

  void show() {
    float r = sqrt(area / PI );
    fill(c);
    ellipse(pos.x, pos.y, r * 2, r * 2);
  }
}
