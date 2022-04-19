/*SNAKE GAME*/

// add boundaries and collision for them 
// ADD THE SETTINGS SO YOU CAN ADJUST THE THINS LKAJSDF;L KAJSDF ;LKJ

// Rows and columns for each block and its size // 
int rows; int columns; 
int sizeB = 10; // Block Size 
int appleAmt = 1; 
int gamestate = 0; // 0 is title screen, 1 game over, 2 is game, 3 is settings page to adjust everything 
int startLength = 10; 
int textS = 100; 
int score = 0;  
int snakeDelay = 50; // controls how frequent snake is moved 
int titleX = 80; int titleY = 80; // the title positions for the game

// Colors for the game // 
color bg = #03092b; 
color snakeColor = #2DFF00;
color appleColor = #eb4034; 
color scoreColor = #2DFF00;
color settingsColor = #A9A9A9; 
color grey = #C0C0C0;

// Game settings // 
boolean selfCollide = true; 
boolean teleportBorders = true; 

// Refresh timers// 
int last = 0; 
int m = 0; 
int lastGamestate = 0; 


/* Game font stuff */ 
PFont gameFont;

/* Prints the score on the bottom right */ 
void showScore(){
  textFont(gameFont);
  fill(bg); 
  rect(0, height-50, width, 50); // clear the thing before drawing a new one over it. 
  fill(scoreColor); 
  textSize(30);
  text(score, 0, height-10);
}

/* Position Class */
class pos{
  int x; int y; 
  pos(int x, int y){
    this.x = x; 
    this.y = y; 
  }
}

/* Apple class for snakes */ 
class Apple{
  int posX, posY; 
  Apple(int x, int y){
    posX = x; 
    posY = y; 
  }

  void drawApple(){
    fill(appleColor); 
    rect(posX*sizeB, posY*sizeB, sizeB, sizeB);     
  }

}

// Snake class for the player // 
class Snake{
  int len, dir = 3, x, y;  // The length of the snake 
  ArrayList<pos> positions = new ArrayList<pos>(); // Tracks where the snake is  

  Snake(int length, int posx, int posy){
    len = length; 
    x = posx;
    y = posy; 
    for (int i = 0; i < length; i++){ 
      positions.add(new pos(1,1)); 
      positions.set(i, new pos(x, y--));
    } 
  } 

  void printPositions(){
    println("SNAKE POSITIONS"); 
    for(int i = 0; i < positions.size(); i++){
      println(" X:", positions.get(i).x, " Y:", positions.get(i).y); 
    }
    println(""); 
  }

  void reset(){
    positions.clear();
    x = 20; y = 20;  
    for (int i = 0; i < startLength; i++){ 
      positions.add(new pos(0,0)); 
      positions.set(i, new pos(x, y--));
    } 
    dir = 3; 
  }

  void drawSnake(){
    for(int i = 0; i < positions.size(); i++){
      fill(snakeColor); 
      rect(positions.get(i).x * sizeB, positions.get(i).y * sizeB, sizeB, sizeB); 
    }
  }

  void changeDir(int direction){
    dir = direction; 
  }

  void move(int direction){
    dir = direction; 
    if (dir == 1){
      // Move up
      y -= 1; 
    } else if (dir == 2){
      // Move left
      x -= 1; 
    } else if (dir == 3){
      // Move down
      y+=1;  
    } else if (dir == 4){
      // Move right 
      x+=1; 
    }
    // Add a new coordinate into the thing then remove the last one // 
    pos remove = positions.get(positions.size()-1); 
    fill(bg); 
    rect(remove.x*sizeB, remove.y*sizeB, sizeB, sizeB); 
    positions.add(0, new pos(x, y)); 

    while (positions.size() > len){
      positions.remove(positions.size()-1); 
    }

  }

  void lengthen(int i){
    len+=i; 
  }

  void checkCollision(){
    if (selfCollide){
      for (int i = 0; i < positions.size(); i++){
        for (int j = 0; j < positions.size(); j++){
          if (j != i){
            if (positions.get(i).x == positions.get(j).x && positions.get(i).y == positions.get(j).y){
              println("SNAKE COLLIDED WITH ITSELF ", x, " ", y); 
              gamestate = 1; 
            }
          }
        }
      }
    }
    if (teleportBorders){
      if (x < 0){
        x = columns; 
      }
      if (y < 0){
        y = rows; 
      }
      if (x > columns){
        x = 0; 
      }
      if (y > rows){
        y = 0; 
      } 
    }
  }

}

class Button{
  int x, y;
  String msg;
  boolean state = false;   
  
  Button(String msg, int x, int y){
    this.msg = msg; this.x = x; this.y = y; 
  }
  
  void show(){
    textSize(30);
    if (state){
      fill(snakeColor); 
    } else {
      fill(appleColor); 
    } 
    rect(x, y, 40, 40); 
    fill(grey); 
    text(msg, x + 60, y+30);
  }

  void changeState(){
    if (mouseX > x && mouseX < x+40 && mouseY > y && mouseY < y+40){
      if (state == false){
        state = true; 
      } else {
        state = false; 
      }
    }
    this.show(); 
  }

  void setState(boolean newState){
    state = newState; 
  }

  boolean getState(){
    return state; 
  }

}

class triButton{
  int a, b, c, x, y; String msg;
  triButton(int x, int y, int a, int b, int c, String msg){
    this.a = a;
    this.b = b;
    this.c = c;
    this.msg = msg;
    this.x = x; 
    this.y = y; 
    val = a; 
  } 

  // displays the triple button arrangement 
  void show(){
    if (a == val){
      
    }
    if (b == val){

    }
    if (c == val){

    }
  }

  void changeState(){

  }

  // retuns the value of the active button
  void getValue(){

  }


}

Snake player = new Snake(startLength, 20, 20);  
ArrayList<Apple> apples = new ArrayList<Apple>();
Button selfCollisionToggle = new Button("Self Collision", 50, 200); 
Button teleportBordersToggle = new Button("Teleport Borders", 50, 270); 

void generateApple(){
  for(int i = 0; i < appleAmt; i++){
    apples.add(new Apple(parseInt(random(0, rows-1)), parseInt(random(0, rows-1)))); 
  }
}

void checkApple(){
  for(int i = 0; i < apples.size(); i++){
    if (apples.get(i).posX == player.x && apples.get(i).posY == player.y){
      println("GOT APPLE!!!");
      apples.remove(i); 
      apples.add(new Apple(parseInt(random(0, rows-1)), parseInt(random(0, rows-1)))); 
      score+=1; 
      showScore(); 
    }
  }
}

void drawApples(){
  for (int i = 0; i < apples.size(); i++){
    apples.get(i).drawApple(); 
  }
}


void setup() {
  // setting up the window size and name 
  size(900, 900);
  surface.setTitle("Snake Game");
  
  // Rows and columns in the game 
  println("ROWS:", height/sizeB);
  println("COLUMNS:", width/sizeB); 
  rows = height/sizeB; 
  columns = width/sizeB; 
  
  // setting up button defaults 
  selfCollisionToggle.setState(selfCollide); 
  teleportBordersToggle.setState(teleportBorders); 

  // Display the title screen 
  if (gamestate == 0){
    gameFont = createFont("SourceCodePro-Black.ttf", 1);
    fill(snakeColor); 
    textFont(gameFont); 
    textSize(textS);
    background(bg); 
    text("Snake Game", titleX ,titleY); 
  }
}

void draw() {  
  if (gamestate == 0){
    // Title screen moment 
    if (lastGamestate != 0){
      fill(snakeColor); 
      background(bg); 
      textSize(textS);
      text("Snake Game", titleX , titleY); 
      println("\tGAME SETTINGS");
      println("SELF COLLIDE:", selfCollide);
      println("TELEPORT WALLS:", teleportBorders);  
    }
  }

  if (gamestate == 1){
    // Game over screen // 
      background(bg); 
      fill(255, 0, 0);
      textSize(textS);
      text("Game Over", titleX, titleY); 
  }

  if (gamestate == 2){
    // Actual game loop // 
    if (lastGamestate != 2){ // first game loop happens here 
      for(int i = 0; i < apples.size(); i++){apples.remove(i);} 
      noStroke();  
      player.reset(); 
      background(bg);
      generateApple();
    }
    // Timer stuff // 
    m = millis()-last; 

    // every 50 milliseconds you move the snake a little // 
    if (millis() > last+snakeDelay){
      last = millis();  
      player.move(player.dir); 
    }
    // Draw the apple and the snake // 
    checkApple();
    drawApples();
    player.checkCollision(); 
    player.drawSnake(); 
  }

  if (gamestate == 3){
    if (lastGamestate != 3){
      noStroke();  
      background(settingsColor);
      textSize(70); 
      fill(appleColor); 
      text("SETTINGS", titleX, titleY); 
      
      // Button stuff
      selfCollisionToggle.show();
      teleportBordersToggle.show(); 
    }
  }

  // Set the last gamestate variable to the gamestate after being used 
  lastGamestate = gamestate; 
}

void keyPressed() {

  if (gamestate == 0){
    if (keyPressed){
      gamestate = 2; 
    }
  }

  if (gamestate == 1){
    if (keyPressed){
      gamestate = 0; 
    }
  }

  if (keyPressed && gamestate == 2) {

    // For each directional key change the direction and move it based on that direction // 
    if (key == 'w') {
      println("UP"); 
      if (player.dir != 3){
        player.changeDir(1); 
      }
    }
    if (key == 'a') {
      println("LEFT"); 
      if (player.dir != 4){
        player.changeDir(2); 
      }  
    }
    if (key == 'd') {
      println("RIGHT");
      if (player.dir != 2){
        player.changeDir(4); 
      } 
    }
    if (key == 's') {
      println("DOWN");
      if (player.dir != 1){
        player.changeDir(3); 
      }
    }

    // is the user wants to quit bring them to game over screen 
    if (key == 'q'){
      for(int i = 0; i < apples.size(); i++){
        apples.remove(0); 
      }
      player.len = startLength; 
      gamestate = 1; // q is for quit so when q is pressed leave the game thing. 

    }

    if (key == 'E' || key == 'e'){
      gamestate = 3;
    }

  }

  if (gamestate == 3){
    if (key == 'q'){
      gamestate = 0;
    }
  }

}  

void mouseReleased() {
  if (gamestate == 3){
    // settings thing 
    selfCollisionToggle.changeState(); 
    selfCollide = selfCollisionToggle.getState(); 
    teleportBordersToggle.changeState(); 
    teleportBorders = teleportBordersToggle.getState(); 
  }
}