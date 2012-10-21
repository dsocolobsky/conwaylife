/************************************************************           
    * Conway -- Conway's Game of life in Processing         *   
    *                                                       *   
    * Author:  Socolobsky, Dylan ("dysoco")                 *   
    *                                                       *   
    * Purpose:  Learning how to write Conway's Game of life *  
    *                                                       *   
    * Usage:                                                *   
    *      Compile and run with Processing                  *   
    ********************************************************/ 

// 2D Array of objects
Cell[][] grid;

// Number of columns and rows in the grid
int cols = 30;
int rows = 30;
// Alive cells in Grid
int livingCells = 0;
// Cell density in grid
float density = 0.15;
// Speed for game
int speed = 200;

/* ---------------------------------
   --       Cell Class            --
   --------------------------------*/
class Cell {
  // Local variables
  float x,y;   // x,y location
  float wd,ht;   // width and height
  float angle; // angle for oscillating brightness
  boolean alive; // State of cell
  int friends; // Neighbours who are alive

  // Cell Constructor
  Cell(float tX, float tY, float tWd, float tHt, float tAngle) {
    x = tX;
    y = tY;
    wd = tWd;
    ht = tHt;
    angle = tAngle;
    alive = false; // Start dead
    friends = 0;
  } 
  
  // Oscillation means increase angle
  void oscillate() {
    angle += 0.02; 
  }

  void display() {
    stroke(30,200,80); // Green Offset
    // Color calculated using sine wave
    //fill(127+127*sin(angle));
    
    if(alive){
      fill(0); // Black for living cells
    } else {
      fill(255);
    }

    rect(x,y,wd,ht); 
  }

  void update(){
    if (friends < 2 || friends > 3){
      alive = false;
    }

    if (!alive && friends == 3){
      alive = true;
    }
  }

}
/* --------------------------------------------------*/

void setup() {
  size(600,600);
  grid = new Cell[cols][rows];
  
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      // Initialize each object
      grid[i][j] = new Cell(i*20,j*20,20,20,i+j);
    }
  }
}

// TODO: Fix this, isn't precise
boolean outOfLimits(int x, int y){
  if(x < 1 || y < 1 || x > 28 || y > 28)
    return true;
  else
    return false;
}

void draw() {
  delay(speed);
  background(0);

  // Adds several random live cells
  for (int i = 0; i < cols * rows * density; i++){
    grid[(int)random(cols)][(int) random(rows)].alive = true;
  }

  // i = Columns, j = Rows  
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      // Oscillate and display each object
      grid[i][j].oscillate();
      grid[i][j].display();
    }
  }
  /* ------------------------------------
     --         MAIN LOOP              --
     ----------------------------------*/
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      if(!outOfLimits(i, j)){
        // CHECK FRIENDS
        if (grid[i-1][j-1].alive == true){
          grid[i][j].friends++;
        } else if (grid[i][j-1].alive == true){
          grid[i][j].friends++;
        } else if (grid[i+1][j-1].alive == true){
          grid[i][j].friends++;
        } else if (grid[i-1][j].alive == true){ 
          grid[i][j].friends++;
        } else if (grid[i+1][j].alive == true){
          grid[i][j].friends++;
        } else if (grid[i-1][j+1].alive == true){
          grid[i][j].friends++;
        } else if (grid[i][j+1].alive == true){
          grid[i][j].friends++;
        } else if (grid[i+1][j+1].alive == true)
          grid[i][j].friends++;
        }

        grid[i][j].update();

        // Check for living cells
        if (grid[i][j].alive){
          livingCells++;
        }

        // Grey screen if all cells are dead
        if (livingCells < 1){
          background(150);
        }
      }
    }
  }

