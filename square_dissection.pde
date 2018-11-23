import java.util.Map;

int s = 400;
float[] values = {0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1};
//float[] values = {0.4, 0.2};
Map<Integer, ArrayList<PVector>> map = new HashMap();

ArrayList<ArrayList<PVector>> polygonList = new ArrayList();

void setup () {
  size(500, 500, FX2D);

  rectMode(CENTER);

  init();




  //first iter


  noFill();
  stroke(0);
}

void init() {
  polygonList = new ArrayList();  
  ArrayList<PVector> list = new ArrayList();
  list.add(new PVector(0, 1));
  list.add(new PVector(1, 1));
  list.add(new PVector(1, 0));
  list.add(new PVector(0, 0));

  int r = floor(random(4));
  //int r = 0;

  int i1 = r % 4;
  int i2 = (r + 1) % 4;


  dissect(list, list.get(i1), list.get(i2), 0);
}

void mouseMoved() {
  randomSeed(floor(mouseX / 5) * 5 * 100);
  init();
  redraw();
}

void draw() {
  noLoop();
  background(255);
  translate(50, 50);

  stroke(0);


  for (ArrayList<PVector> poly : polygonList) {
    beginShape();
    fill(100 + random(155), 40,40);
    for (PVector p : poly) {
      vertex(p.x * s, p.y * s);
    }
    endShape(CLOSE);
  }

  //rect(s/2, s/2, s, s);
}

void dissect(ArrayList<PVector> pointList, PVector a, PVector b, int d) {
  ArrayList<PVector> poly = new ArrayList();
  if (d >= values.length) {
    polygonList.add(pointList);
    return;
  };

  PVector p1 = randomPointOnLine(a.x, a.y, b.x, b.y);
  poly.add(p1);
  pointList.add(p1);
  sortCCW(pointList, p1);

  float value = values[d];
  float sum_area = 0;

  ArrayList<PVector> pointListNext = new ArrayList<PVector>(pointList);

  for (int i = 0; i < pointList.size(); i++) {
    float ax = pointList.get(i).x;
    float ay = pointList.get(i).y;
    float bx = pointList.get((i+1) % pointList.size()).x;
    float by = pointList.get((i+1) % pointList.size()).y;
    float area = area(p1.x, p1.y, ax, ay, bx, by);


    sum_area += area;
    poly.add(pointListNext.get(0));
    pointListNext.remove(0);


    if (value < area) {
      float weight = value / area;
      PVector p2 = pointOnLine(ax, ay, bx, by, weight);
      poly.add(p2);
      pointListNext.add(p2);

      polygonList.add(poly);
      dissect(pointListNext, p2, p1, d + 1);

      break;
    } else {
      value -= area;
    }
  }
}

float area(float ax, float ay, float bx, float by, float cx, float cy) {
  return abs((ax * (by - cy) + bx * (cy - ay) + cx * (ay - by)) / 2);
} 

PVector pointOnLine(float ax, float ay, float bx, float by, float weight) {
  return new PVector(
    ax + (bx - ax) * weight, 
    ay + (by - ay) * weight
    );
}

PVector randomPointOnLine(float ax, float ay, float bx, float by) {
  float r = random(1);

  return new PVector(
    ax + (bx - ax) * r, 
    ay + (by - ay) * r
    );
}
