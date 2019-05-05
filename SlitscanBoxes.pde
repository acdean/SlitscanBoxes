// acd 2019
// slitscan of rotating boxes

int TRINKETS = 200;
ArrayList<Trinket> trinkets = new ArrayList<Trinket>();
int r; // global rotation
PImage slit;
float SCANSPEED = (1.0/16);  // the smaller the wider

static int WIDTH = 1000;
static int HEIGHT = 500;
static int FRAMES = WIDTH;

void settings() {
  size(WIDTH, HEIGHT, P3D);
}

void setup() {
  initScene();
}

void initScene() {
  trinkets.clear();
  for (int i = 0 ; i < TRINKETS ; i++) {
    trinkets.add(new Trinket()); 
  }
  r = 0;
  // image for the slits
  slit = createImage(FRAMES, HEIGHT, RGB);
}

void draw() {
  lights();
  directionalLight(256, 256, 256, 0, 1, 0);
  directionalLight(256, 256, 256, 0, -1, 0);
  background(0);
  //strokeWeight(5);
  noStroke();
  float f = frameCount;
  camera(0, 0, 0,
    cos(radians(f * SCANSPEED)), 0, sin(radians(f * SCANSPEED)),
    0, 1, 0);
  for (Trinket tr : trinkets) {
    pushMatrix();
    tr.draw();
    popMatrix();
  }
  slit.copy(g, width / 2, 0, 1, height, (frameCount - 1) % FRAMES, 0, 1, height);
  if ((frameCount % FRAMES) == 0) {
    // save, display and pause
    String filename = "slitscan_" + nf((int)random(10000), 4) + ".png";
    slit.save(filename);
    copy(slit, 0, 0, WIDTH, HEIGHT, 0, 0, WIDTH, HEIGHT);
    println("Saved as " + filename + ". Press any key.");
    noLoop();
  }
}

static final float SZ = 80;

// a rotating box
class Trinket {
  
  float x, y, z, rx, ry, rz, dx, dy, dz;
  color c;
  
  Trinket() {
    PVector p = PVector.random3D().mult(600);
    x = p.x;
    y = p.y;
    z = p.z;
    rx = (int)random(360);
    ry = (int)random(360);
    rz = (int)random(360);
    dx = random(-.2, .2);
    dy = random(-.2, .2);
    dz = random(-.2, .2);
    c = color(random(32, 256), random(32, 256), random(32, 256)); // coloured
//    c = color(192, 192, 192); // light grey
  }
  
  void draw() {
    rx += dx;
    ry += dy;
    rz += dz;
    translate(x, y, z);
    rotateX(radians(rx));
    rotateY(radians(ry));
    rotateZ(radians(rz));
    // coloured boxes
    fill(c);
    box(5 * SZ, 3 * SZ, 1 * SZ); 
    // wireframe
    //strokeWeight(5);
    //stroke(c);
    //noFill();
    //box(5 * SZ, 3 * SZ, 1 * SZ); 
  }
}

// press a key to restart
void keyPressed() {
  println("Generating...");
  initScene();
  loop();
}
