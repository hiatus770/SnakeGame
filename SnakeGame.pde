// SNAKE GAME THING // 


// Rows and columns for each block and its size // 
int rows; int columns; 
int sizeB = 10; 

// Width and height // 
int w; int h; 

// Colors for the game // 
color bg = #03092b; 
color snake = #2DFF00;

class Snake{
  int len; 
  Snake(int length){
    len = length; 
  } 
}

void displayBlocks(){
  int y = 0; 
  for (int i = 0; i < rows; i++){
    int x = 0; 
      for (int j = 0; j < columns; j++){
        //fill(1, random(10, 100), random(150, 255)); 
        //rect(x, y, sizeB, sizeB); 
        x += sizeB;      
      }
      y += sizeB;   
  }
  
}

Snake a = new Snake(10); 

void setup() {
  size(1000, 1000);
  h = height; w = width; 
  noStroke();  
  background(bg);
  println("ROWS:", h/sizeB);
  println("COLUMNS:", w/sizeB); 
  rows = height/sizeB; 
  columns = width/sizeB; 
}

// THE GAME GRID THING
int[][] grid; 

// Some loop thing // 
void draw() {  
  rows = height/sizeB; 
  columns = width/sizeB;
  
  displayBlocks(); 
}

void keyPressed() {
  
}  
