/*

      SNAKE GAME

Display the score 
Title screen with stuff ig? 
Boundaries 
Snake self collision
Apple collision 
Make the apple generate again 

 */ 

// Rows and columns for each block and its size // 
int rows; int columns; 
int sizeB = 10; // Block Size 
int appleAmt = 1; 

// Colors for the game // 
color bg = #03092b; 
color snakeColor = #ffab0f;  //#2DFF00;
color appleColor = #eb4034; 

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
  int len, dir = 3, x, y; // The length of the snake 
  ArrayList<pos> positions = new ArrayList<pos>(); // Tracks where the snake is  

  Snake(int length, int posx, int posy){
    len = length; 
    x = posx;
    y = posy; 
    for (int i = 0; i < length; i++){positions.add(new pos(x, y));} 
  } 

  void printPositions(){
    println("SNAKE POSITIONS"); 
    for(int i = 0; i < positions.size(); i++){
      println(" X:", positions.get(i).x, " Y:", positions.get(i).y); 
    }
    println(""); 
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

}

// Command that is not used anymore // 
void randomizeBlocks(){
  int y = 0; 
  for (int i = 0; i < rows; i++){
    int x = 0; 
      for (int j = 0; j < columns; j++){
        stroke(10);
        rect(x, y, sizeB, sizeB); 
        x += sizeB;      
      }
      y += sizeB;   
  }
}

Snake player = new Snake(40, 1, 1);  
ArrayList<Apple> apples = new ArrayList<Apple>();

void generateApple(){
  for(int i = 0; i < appleAmt; i++){
    apples.add(new Apple(parseInt(random(0, 89)), parseInt(random(0, 89)))); 
  }
}

void checkApple(){
  for (int i = 0; i < apples.size(); i++){
    if (apples.get(i).posX == player.x && apples.get(i).posY == player.y){
      println("GOT APPLE!!!");
      apples.remove(i); 
      player.lengthen(10); 
      apples.add(new Apple(parseInt(random(0, 89)), parseInt(random(0, 89)))); 
    }
  }
}

void drawApples(){
  for (int i = 0; i < apples.size(); i++){
    apples.get(i).drawApple(); 
  }
}

void setup() {
  size(900, 900);
  surface.setTitle("Snake Game");

  noStroke();  
  background(bg);

  println("ROWS:", height/sizeB);
  println("COLUMNS:", width/sizeB); 

  rows = height/sizeB; 
  columns = width/sizeB; 

  generateApple();
}

// Refresh timers// 
int last = 0; 
int m = 0; 

void draw() {  
  // Timer stuff // 
  m = millis()-last; 

  // every 50 milliseconds you move the snake a little // 
  if (millis() > last+75){
    last = millis();  
    player.move(player.dir); 
  }
  // Draw the apple and the snake // 
  checkApple();
  drawApples();
  player.drawSnake(); 
}

void keyPressed() {

  if (keyPressed) {

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
    if (key == 'q'){
      exit(); // q is for quit so when q is pressed leave the game thing. 
    }
  }
}  
