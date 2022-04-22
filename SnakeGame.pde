/*SNAKE GAME*/

// add the frame rate selection thing 
// add the random apple generation after a certain amount of time (make it ike 50% chance) 
// Display the state of the settings for each (put like ON over the green square and OFF over the red one)
// add eating apple animations 
// reverse draw the snake from tail to head
// color the head
// maybe add more gradients to the themes 


// Added save stuff
// Added themes, need to add theme chooser though!!!!

// Rows and columns for each block and its size
int rows; int columns; 
int sizeB = 5; // Block Size 
int appleAmt = 1; 
int gamestate = 0; // 0 is title screen, 1 game over, 2 is game, 3 is settings page to adjust everything 
int startLength = 10000; 
int textS = 100; 
int score; int highscore = 0;  
int snakeDelay = 1; // controls how frequent snake is moved 
int titleX = 80; int titleY = 80; // the title positions for the game
int theme; 

// Data saving stuff //

/*
first line is highscore from previous games:second line is setting state one :third line is setting state two
fourth line is the theme index 
 */

PrintWriter data; 

/* Colors for the game */
// 1 is normal, 2 is black and white, 3 is high contrast, 4 is gradient blue green, 
color[] BACKGROUND = new color[]{#03092b, #ffffff, #333333, #000000}; 
color[] SNAKE = new color[]{#69ff5e, #000000, #00bfff, #ffffff}; 
color[] APPLE = new color[]{#eb4034, #380000, #8cff00, #ffffff}; 
color[] SCORE = new color[]{#afff40, #380000, #00bfff, #ffffff}; 
color[] SETTINGTRUE = new color[]{ #5aff00,#d1ffb8,#69ff5e, #69ff5e}; 
color[] SETTINGFALSE = new color[]{#ff0000,#ff9e9e,#ff0550, #ff0550}; 
color[] HEAD = new  color[]{#69ff5e, #000000, #00bfff, #ffffff}; 
String[] NAME = new String[]{"Default", "Black and White", "High Contrast", "Gradient"}; 
color[] SETTINGS = new color[]{ #03092b, #ffffff, #333333, #000000}; 

/* Game settings */ 
boolean selfCollide = true; 
boolean teleportBorders = true; 

/* Refresh timers */ 
int last = 0; 
int m = 0; 
int lastGamestate = 0; 

/* Game font stuff */ 
PFont gameFont;

void saveData(){
  data = createWriter("data.txt");
  data.println(highscore);
  data.println(selfCollide);
  data.println(teleportBorders); 
  data.println(theme); 
  data.flush(); 
  data.close(); 
}

void loadData(){
  String[] loadedFile = loadStrings("data.txt");
  highscore = parseInt(loadedFile[0]); 
  selfCollide = parseBoolean(loadedFile[1]); 
  teleportBorders = parseBoolean(loadedFile[2]); 
  theme = parseInt(loadedFile[3]); 
}

/* Prints the score on the bottom right */ 
void showScore(){
  textFont(gameFont);
  fill(BACKGROUND[theme]); 
  rect(0, height-50, width, 50); // clear the thing before drawing a new one over it. 
  fill(SCORE[theme]); 
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
    fill(APPLE[theme]); 
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
    x = 20; y = 20; 
    dir = 3; 
  }

  void drawSnake(){
    for(int i = positions.size()-1; i >= 0; i--){
      if (i == 0){
        fill(HEAD[theme]); 
      } else if (SNAKE[theme] == APPLE[theme]){
        // if snake head is equal to apple color then do a little gradienting
        fill(i%255, i%255, 255-(i%255)); 
      } else {
        fill(SNAKE[theme]); 
      }
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
    fill(BACKGROUND[theme]); 
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
        if (i != 0){
          if (positions.get(i).x == x && positions.get(i).y == y){
            println("SNAKE COLLIDED WITH ITSELF ", x, " ", y); 
            gamestate = 1; 
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
        x = -1; 
      }
      if (y > rows){
        y = -1; 
      } 
    } else {
      if (x < 0){
        gamestate = 1;  
      }
      if (y < 0){
        gamestate = 1;  
      }
      if (x > columns){
        gamestate = 1; 
      }
      if (y > rows){
        gamestate = 1; 
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
      fill(SETTINGTRUE[theme]); 
    } else {
      fill(SETTINGFALSE[theme]); 
    } 
    rect(x, y, 40, 40); 
    fill(SCORE[theme]); 
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

class ClickButton{
  String msg; int x; int y; int min; int max; int state; 
  ClickButton(String msg, int x, int y, int min, int max){
    this.max = max;
    this.min = min;
    this.y = y;
    this.x = x;
    this.msg = msg;
<<<<<<< HEAD
    state = min;
=======
    state = theme;
>>>>>>> 2e471274efac0d398f7864c0aeaaef7fada54c5f
  }

  void setText(String newMsg){
    msg = newMsg; 
  }

  int getTheme(){
    return state; 
  }

  void show(){
    textSize(30);
    fill(SCORE[theme]); 
    rect(x, y, 40, 40); 
    fill(SCORE[theme]); 
    text(msg, x + 60, y+30);
  }

<<<<<<< HEAD
  boolean press(int i){
    if (mouseX > x && mouseX < x+40 && mouseY > y && mouseY < y+40){
      state+=i; 
      if (state > max){
        state = min; 
      }
=======
  boolean press(){
    if (mouseX > x && mouseX < x+40 && mouseY > y && mouseY < y+40){
      state++; 
      if (state > max){
        state = min; 
      }
      theme = state; 
>>>>>>> 2e471274efac0d398f7864c0aeaaef7fada54c5f
      saveData(); 
    return true; 
    }
    return false; 
  }
}

/* GAME CLASSES */ 
Snake player = new Snake(startLength, 20, 20);  
ArrayList<Apple> apples = new ArrayList<Apple>();
Button selfCollisionToggle = new Button("Self Collision", 50, 200); 
Button teleportBordersToggle = new Button("Teleport Borders", 50, 270); 
ClickButton themeButton = new ClickButton(NAME[theme], 50, 340, 0, 3); 
<<<<<<< HEAD
String display = String.format("FRAMERATE:%s", snakeDelay); 
ClickButton frameButton = new ClickButton(display, 50, 410, 0, 60); 
=======
>>>>>>> 2e471274efac0d398f7864c0aeaaef7fada54c5f

void generateApple(){
  for(int i = 0; i < appleAmt; i++){
    apples.add(new Apple(parseInt(random(0, rows-1)), parseInt(random(0, rows-1)))); 
  }
}

void checkApple(){
  for(int i = 0; i < apples.size(); i++){
    if (apples.get(i).posX == player.x && apples.get(i).posY == player.y){
      println("GOT APPLE!!!");
      player.lengthen(5); 
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
  size(700, 700);
  surface.setTitle("Snake Game");

  loadData(); 

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
    fill(SNAKE[theme]); 
    textFont(gameFont); 
    textSize(textS);
    background(BACKGROUND[theme]); 
    text("Snake Game", titleX ,titleY); 
  }

  themeButton.state = theme; 
}

void draw() {  
  // Title screen for the game 
  if (gamestate == 0){
    // Title screen moment 
    if (lastGamestate != 0){
      fill(SNAKE[theme]); 
      background(BACKGROUND[theme]); 
      textSize(textS);
      text("Snake Game", titleX , titleY); 
      println("\tGAME SETTINGS");
      println("SELF COLLIDE:", selfCollide);
      println("TELEPORT WALLS:", teleportBorders);  
    }
  }

  // Game over screen 
  if (gamestate == 1){
    // Game over screen // 
      background(BACKGROUND[theme]); 
      fill(APPLE[theme]);
      textSize(textS);
      text("Game Over", titleX, titleY); 
      player.len = startLength; 
      player.dir = 3; // make it move down
      textSize(textS-40); 
      text(String.format("SCORE %s", score), titleX+70, titleY+70); 
      if (score > highscore) {
        highscore = score; 
        saveData(); 
        text(String.format("NEW HIGHSCORE %s", score), titleX+70, titleY+70);
      } else {
        text(String.format("HIGHSCORE %s", highscore), titleX+70, titleY+140);
      }
      saveData(); 
  }

  // Game loop itself 
  if (gamestate == 2){
    // Actual game loop // 
    if (lastGamestate != 2){ // first game loop happens here 
      for(int i = 0; i < apples.size(); i++){apples.remove(i);} 
      noStroke();  
      player.reset(); 
      background(BACKGROUND[theme]);
      generateApple();
      score = 0; 
    }
    // Timer stuff // 
    m = millis()-last; 

    // every 50 milliseconds you move the snake a little // 
    if (millis() > last+snakeDelay){
      last = millis();  
      player.move(player.dir); 
      checkApple();
      player.checkCollision(); 
    }
    // Draw the apple and the snake // 
    drawApples();
    player.drawSnake(); 
  }

  // Settings page
  if (gamestate == 3){
    if (lastGamestate != 3){
      noStroke();  
      background(SETTINGS[theme]);
      textSize(70); 
      fill(SCORE[theme]); 
      text("SETTINGS", titleX, titleY); 
      
      // Button stuff
      selfCollisionToggle.show();
      teleportBordersToggle.show();
      themeButton.show();  
      frameButton.show(); 
    }
    saveData(); 
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
      if (player.dir != 3){
        player.changeDir(1); 
      }
    } else if (key == 'a') {
      if (player.dir != 4){
        player.changeDir(2); 
      }  
    } else if (key == 'd') {
      if (player.dir != 2){
        player.changeDir(4); 
      } 
    } else if (key == 's') {
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

    // Move to settings page. 
    if (key == 'E' || key == 'e'){
      gamestate = 3;
    }

  }

  if (gamestate == 3){
    if (key == 'q'){
      gamestate = 0;
    }
  }

  // For when trying to hide it or exit quickly just press [f] 
  if (key == 'f'){
    saveData(); 
    exit(); 
  }

}  

void mouseReleased() {
  if (gamestate == 3){
    /* All the settings buttons */ 
    selfCollisionToggle.changeState(); 
    selfCollide = selfCollisionToggle.getState(); 
    teleportBordersToggle.changeState(); 
    teleportBorders = teleportBordersToggle.getState(); 
      theme = themeButton.state; 
    if (themeButton.press(1)){
      noStroke();  
      background(SETTINGS[theme]);
      textSize(70); 
      fill(SCORE[theme]); 
      text("SETTINGS", titleX, titleY); 
      
      // Button stuff
      selfCollisionToggle.show();
      teleportBordersToggle.show();
      themeButton.setText(NAME[theme]); 
      themeButton.show(); 
      frameButton.show(); 
      println("PRESSED!"); 
    }
    if (frameButton.press(10)){
      fill(BACKGROUND[theme]); 
      rect(50, 410, 500, 500); 
      snakeDelay = frameButton.state; 
      String display = String.format("FRAMERATE:%s", snakeDelay); 
      frameButton.setText(display); 
      frameButton.show(); 

    }
  }
}
