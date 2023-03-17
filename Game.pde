import javax.swing.JOptionPane;

// Objects required in the program
KeyHandler keyHandler;
Barrier[] barriers;
Player player;
Ship ship;

float barrierHeight;
float lastBarrierSpawnTime;
float lastDrawTime;
int spawnInterval = 30000;

void setup() {
  size(1280, 720);
  noStroke();
  lastDrawTime = millis();
  barrierHeight = 10;
  barriers = new Barrier[0];
  lastBarrierSpawnTime = -spawnInterval; // spawns barrier immediately
  keyHandler = new KeyHandler();
  ship = new Ship(keyHandler);

  String playerName = JOptionPane.showInputDialog(null, "Enter your name:", "Player Name", JOptionPane.QUESTION_MESSAGE);
  if (playerName == null || playerName.trim().isEmpty()) {
    playerName = "Player1";
  }

  player = new Player(playerName.trim(), 3);
}

void draw() {
  background(0);
  float deltaTime = (millis() - lastDrawTime)/1000;
  lastDrawTime = millis();

  if (millis() - lastBarrierSpawnTime >= spawnInterval) {
    addBarrier(new Barrier());
    lastBarrierSpawnTime = millis();
  }

  for (int i=0; i < barriers.length; i++) {
    if (barriers[i] == null) {
      continue;
    }

    Barrier b = barriers[i];
    b.update(deltaTime);
    b.display();

    if (b.getBoundingBox().hasCollided(ship.getBoundingBox())) {
      if (!ship.isColliding()) {
        println("collision");
        player.loseLife();
        ship.isColliding(true);
      }
    } else {
      ship.isColliding(false);
    }
  }


  //System.out.println("Size of the barriers array: " + barriers.length);

  ship.move(deltaTime);
  ship.update(deltaTime);
  ship.display();

  removeBarriers();

  //fill(255,0,0);
  textSize(20);
  textAlign(CENTER, CENTER);
  text("Missiles: " + ship.getMissileCount(), width / 2 - 250, 30);
  text("Player: " + player.getName(), width / 2 - 100, 30);
  text("Score: " + player.getScore(), width / 2 + 100, 30);
  text("Lives: " + player.getLives(), width / 2 + 250, 30);
}

public void addBarrier(Barrier b) {
  Barrier[] newArray = new Barrier[barriers.length+1];
  arrayCopy(barriers, newArray);
  newArray[barriers.length] = b;
  barriers = newArray;
}

private void removeBarriers() {
  for (int i = 0; i < barriers.length; i++) {
    Barrier b = barriers[i];
    if (b.getY() >= height) {
      System.out.println("Barriers no longer visible on screen: " + i);
      barriers = removeFromArray(barriers, i);
      i--; // Decrement index to account for removed item
    }
  }
}

private Barrier[] removeFromArray(Barrier[] array, int index) {
  Barrier[] newArray = new Barrier[array.length - 1];
  for (int i = 0, j = 0; i < array.length; i++) {
    if (i == index) {
      continue;
    }
    newArray[j++] = array[i];
  }
  return newArray;
}

public void keyPressed() {
  if (key == 'a' || key == 'A' || keyCode == LEFT) {
    keyHandler.setLeft(true);
  }
  if (key == 'd' || key == 'D' || keyCode == RIGHT) {
    keyHandler.setRight(true);
  }
  if (key == 'w' || key == 'W' || keyCode == UP) {
    keyHandler.setUp(true);
  }
  if (key == 's' || key == 'S' || keyCode == DOWN) {
    keyHandler.setDown(true);
  }
  if (key == ' ' || keyCode == 32) {
    keyHandler.setSpace(true);
  }
}

public void keyReleased() {
  if (key == 'a' || key == 'A' || keyCode == LEFT) {
    keyHandler.setLeft(false);
  }
  if (key == 'd' || key == 'D' || keyCode == RIGHT) {
    keyHandler.setRight(false);
  }
  if (key == 'w' || key == 'W' || keyCode == UP) {
    keyHandler.setUp(false);
  }
  if (key == 's' || key == 'S' || keyCode == DOWN) {
    keyHandler.setDown(false);
  }
  if (key == ' ' || keyCode == 32) {
    keyHandler.setSpace(false);
  }
}
