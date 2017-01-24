class DNA {

  ArrayList<Float> genes;

  DNA() {
    genes = new ArrayList<Float>();
    
    genes.add(random(1));
    genes.add(random(50, 300));
    genes.add(random(100, 254));
  }
  
  void mutate() {
   float a = genes.get(0) + random(-.01, .01);
   float b = genes.get(1) + random(-1, 1);
   float c = genes.get(2) + random(1, 1);
   
   constrain(a, 0, 1);
   constrain(b, 50, 300);
   constrain(c, 100, 255);
   
   genes.set(0, a);
   genes.set(1, b);
   genes.set(2, c);
  }
}
