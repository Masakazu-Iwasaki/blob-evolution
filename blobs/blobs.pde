ArrayList<Cell> cells;
ArrayList<Food> foods;
int num = 50;
int counter = 0;

void setup() {
  size(600, 600);
  cells = new ArrayList<Cell>();
  foods = new ArrayList<Food>();
  for (int i = 0; i < num; i++) {
    cells.add(new Cell(new PVector(random(width), random(height))));
  }
  for (int i = 0; i < 50; i++ ) {
    foods.add(new Food());
  }
}

void draw() {
  counter ++;
  background(127);
  ArrayList tremove = new ArrayList();
  ArrayList tadd = new ArrayList();
  for (Cell cel : cells) {        
    cel.seek(cells, foods);
    cel.flee(cells);
    cel.update();
    cel.show();
    ArrayList<Cell> tr = cel.eat(cells, foods);
    for (Cell celll : tr ) {
      if (! tremove.contains(celll)) {
        tremove.add(celll);
      }
    }
    if (cel.area > cel.splitSize) {
      Cell c = new Cell(new PVector(cel.pos.x + random(-15, 15), cel.pos.y + random(-15, 15)));
      if (cel.area > 255 ) {
        cel.area = 255;
      }
      cel.area /= 2;
      c.area = cel.area;
      if (random(10) > 0.5 ) {
        c.dna.genes = new ArrayList<Float>(cel.dna.genes);
        c.dna.mutate();
        c.express_DNA();
      }

      tadd.add(c);
    }
  }
  for ( Food fud : foods ) {
    fud.display();
    fud.attract(cells);
    fud.update();
  }
  if (counter % 5 == 0 && foods.size() < 500) {
    foods.add(new Food());
    counter = 0;
  }
  cells.removeAll(tremove);
  cells.addAll(tadd);
}
