Player player;


void setup() {
  size(1280, 720, P2D);
  smooth();

  player = new Player();
}

void draw() {
  player.status();
  
  player.status = "infected";
  
  player.status();
  
  player.status = "recovered";
  
  player.status();
  noLoop();
}
