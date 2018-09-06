/**
 * Pacman Game
 * We_Make (C) 2018.
 */
import java.util.Deque;
import java.util.Iterator;
import java.util.LinkedList;
import oscP5.*;
import netP5.*;
import processing.video.*;
import spout.*;
import processing.sound.*;

// Sonido de ambiente.
SoundFile ambient;

// Spout connection.
Spout spout;

// Videos
Movie pressStartMovie;
Movie counterMovie;
Movie gameOverMovie;

// OSC Stuff
OscP5 osc;
NetAddress madMapper;

// Score
int score = 0;

// Lives
int lives = 2;

String ip = "192.168.0.2"; // localhost for testing

Pacman pacman, pacman2;
PImage img;//background image

// Ghosts images.
PImage f1, f2, f3, f4;

// Pacman images.
PImage pac1Image, pac2Image;

// First pacman positions.
PImage pac1Arr, pac1Ab, pac1Der, pac1Izq;
// Second pacman positions.
PImage pac2Arr, pac2Ab, pac2Der, pac2Izq;

// The stage of the game.
int gameStage = 0;

Pinky pinky;
Blinky blinky;
Clyde clyde;
Inky inky;

Tile[][] tiles = new Tile[31][28]; //note it goes y then x because of how I inserted the data

int[][] tilesRepresentation = {
  {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
  {1, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1},
  {1, 8, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 8, 1},
  {1, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
  {1, 0, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 0, 1},
  {1, 0, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 0, 1},
  {1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1},
  {1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 6, 1, 1, 6, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1},
  {1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 6, 1, 1, 6, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1},
  {1, 1, 1, 1, 1, 1, 0, 1, 1, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 1, 1, 0, 1, 1, 1, 1, 1, 1},
  {1, 1, 1, 1, 1, 1, 0, 1, 1, 6, 1, 1, 1, 1, 1, 1, 1, 1, 6, 1, 1, 0, 1, 1, 1, 1, 1, 1},
  {1, 1, 1, 1, 1, 1, 0, 1, 1, 6, 1, 1, 1, 1, 1, 1, 1, 1, 6, 1, 1, 0, 1, 1, 1, 1, 1, 1},
  {1, 1, 1, 1, 1, 1, 0, 6, 6, 6, 1, 1, 1, 1, 1, 1, 1, 1, 6, 6, 6, 0, 1, 1, 1, 1, 1, 1},
  {1, 1, 1, 1, 1, 1, 0, 1, 1, 6, 1, 1, 1, 1, 1, 1, 1, 1, 6, 1, 1, 0, 1, 1, 1, 1, 1, 1},
  {1, 1, 1, 1, 1, 1, 0, 1, 1, 6, 1, 1, 1, 1, 1, 1, 1, 1, 6, 1, 1, 0, 1, 1, 1, 1, 1, 1},
  {1, 1, 1, 1, 1, 1, 0, 1, 1, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 1, 1, 0, 1, 1, 1, 1, 1, 1},
  {1, 1, 1, 1, 1, 1, 0, 1, 1, 6, 1, 1, 1, 1, 1, 1, 1, 1, 6, 1, 1, 0, 1, 1, 1, 1, 1, 1},
  {1, 1, 1, 1, 1, 1, 0, 1, 1, 6, 1, 1, 1, 1, 1, 1, 1, 1, 6, 1, 1, 0, 1, 1, 1, 1, 1, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
  {1, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1},
  {1, 8, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 8, 1},
  {1, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1},
  {1, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 1},
  {1, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 1},
  {1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1},
  {1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1},
  {1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
  {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}};
//--------------------------------------------------------------------------------------------------------------------------------------------------

void setup() {
  size(448, 496, P3D);
  ambient = new SoundFile(this, "ambient.mp3");
  osc = new OscP5(this, 9000);
  madMapper = new NetAddress(ip, 8000);
  img = loadImage("map.jpg");
  pressStartMovie = new Movie(this, "pressStart.mov");
  counterMovie = new Movie(this, "counter.mov");
  gameOverMovie = new Movie(this, "gameOver.mov");
  pac1Arr = loadImage("pacman1Arr.png");
  pac1Ab = loadImage("pacman1Ab.png");
  pac1Izq = loadImage("pacman1Izq.png");
  pac1Der = loadImage("pacman1Der.png");
  pac2Arr = loadImage("pacman2Arr.png");
  pac2Ab = loadImage("pacman2Ab.png");
  pac2Izq = loadImage("pacman2Izq.png");
  pac2Der = loadImage("pacman2Der.png");
  f1 = loadImage("fantasma1.png");
  f2 = loadImage("fantasma2.png");
  f3 = loadImage("fantasma3.png");
  f4 = loadImage("fantasma4.png");
  pressStartMovie.loop();
  pac1Image = pac1Izq;
  pac2Image = pac2Izq;
  spout = new Spout(this);
  spout.createSender("We_Make");
  frameRate(100);
}
//--------------------------------------------------------------------------------------------------------------------------------------------------

void draw() {
  if (gameStage == 0) { // Press Start
    background(0);
    image(pressStartMovie, 0, 0);
  } else if (gameStage == 1) { // 3, 2, 1
    // Animación 3, 2, 1
    if(counterMovie.time() >= counterMovie.duration()) {
      gameStage = 2;
      //initiate tiles
      for (int i = 0; i< 28; i++) {
        for (int j = 0; j< 31; j++) {
          tiles[j][i] = new Tile(16*i +8, 16*j+8);
          switch(tilesRepresentation[j][i]) {
          case 1: //1 is a wall
            tiles[j][i].wall = true;
            break;
          case 0: // 0 is a dot
            tiles[j][i].dot = true;
            break;
          case 8: // 8 is a big dot
            tiles[j][i].bigDot = true;
            break;
          case 6://6 is a blank space
            tiles[j][i].eaten = true;
            break;
          }
        }
      }

      pacman = new Pacman(0); // image for pac1
      pacman2 = new Pacman(1); // image for pac2
      pinky = new Pinky();
      blinky = new Blinky();
      clyde = new Clyde();
      inky = new Inky();
      lives = 4;
      score = 0;
      pac1Image = pac1Izq;
      pac2Image = pac2Izq;
      ambient.loop();
    } else {
      image(counterMovie, 0,0);
    }
  } else if (gameStage == 2) { // Juego
    image(img,0,0);
    if (!pacman.gameOver) {
      stroke(255);

      for (int i = 0; i< 28; i++) {
        for (int j = 0; j< 31; j++) {
          tiles[j][i].show();
        }
      }

      pacman.move();
      pacman2.move();

      //move and show the ghosts
      inky.show();
      inky.move();

      clyde.show();
      clyde.move();

      pinky.show();
      pinky.move();

      blinky.show();
      blinky.move();

      //show pacman last so he appears over the path lines
      pacman.show();
      pacman2.show();

      // Print scores
      fill(255,255,0);
      textSize(16);
      text("Puntaje: " + score, 179, 230);
      text("Vidas: " + (lives+1), 179,250);
    } else {
      gameStage = 3;
      osc.send(new OscMessage("/cues/Bank 1/scenes/by_cell/col_2"), madMapper);
      gameOverMovie.stop();
      gameOverMovie.play();
      ambient.stop();
    }
  } else { // Game Over
    if (gameOverMovie.time() < gameOverMovie.duration()) {
      image(gameOverMovie, 0,0);
    } else {
      gameStage = 0;
      pressStartMovie.loop();
    }
  }
  // Send data to spout.
  spout.sendTexture();
}
//--------------------------------------------------------------------------------------------------------------------------------------------------

void keyPressed() {//controls for pacman
  if (gameStage == 2) {
    switch(key) {
      case CODED:
        switch(keyCode) {
          case UP:
            pacman.turnTo = new PVector(0, -1);
            pacman.turn = true;
            pac1Image = pac1Arr;
            break;
          case DOWN:
            pacman.turnTo = new PVector(0, 1);
            pacman.turn = true;
            pac1Image = pac1Ab;
            break;
          case LEFT:
            pacman.turnTo = new PVector(-1, 0);
            pacman.turn = true;
            pac1Image = pac1Izq;
            break;
          case RIGHT:
            pacman.turnTo = new PVector(1, 0);
            pacman.turn = true;
            pac1Image = pac1Der;
            break;
         }
         break;
     // Second Pacman
     // left
     case 'a':
     case 'A':
       pacman2.turnTo = new PVector(-1, 0);
       pacman2.turn = true;
       pac2Image = pac2Izq;
       break;
     // down
     case 's':
     case 'S':
       pacman2.turnTo = new PVector(0, 1);
       pacman2.turn = true;
       pac2Image = pac2Ab;
       break;
     // right
     case 'd':
     case 'D':
       pacman2.turnTo = new PVector(1, 0);
       pacman2.turn = true;
       pac2Image = pac2Der;
       break;
     // up
     case 'w':
     case 'W':
       pacman2.turnTo = new PVector(0, -1);
       pacman2.turn = true;
       pac2Image = pac2Arr;
       break;
    }
  } else if (gameStage == 0) {
    // Start game.
    switch(key) {
      case 'y':
      case 'Y':
        if (gameStage == 0){
          gameStage = 1;
          counterMovie.stop();
          counterMovie.play();
          pressStartMovie.stop();
        }
        break;
    }
  }
}
//--------------------------------------------------------------------------------------------------------------------------------------------------


//returns the nearest non wall tile to the input vector
//input is in tile coordinates
PVector getNearestNonWallTile(PVector target) {
  float min = 1000;
  int minIndexj = 0;
  int minIndexi = 0;
  for (int i = 0; i< 28; i++) {//for each tile
    for (int j = 0; j< 31; j++) {
      if (!tiles[j][i].wall) {//if its not a wall
        if (dist(i, j, target.x, target.y)<min) { //if its the current closest to target
          min =  dist(i, j, target.x, target.y);
          minIndexj = j;
          minIndexi = i;
        }
      }
    }
  }
  return new PVector(minIndexi, minIndexj);//return a PVector to the tile
}


//--------------------------------------------------------------------------------------------------------------------------------------------------
//returns the shortest path from the start node to the finish node
Path AStar(Node start, Node finish, PVector vel)
{
  LinkedList<Path> big = new LinkedList<Path>();//stores all paths
  Path extend = new Path(); //a temp Path which is to be extended by adding another node
  Path winningPath = new Path();  //the final path
  Path extended = new Path(); //the extended path
  LinkedList<Path> sorting = new LinkedList<Path>();///used for sorting paths by their distance to the target

  //startin off with big storing a path with only the starting node
  extend.addToTail(start, finish);
  extend.velAtLast = new PVector(vel.x, vel.y);//used to prevent ghosts from doing a u turn
  big.add(extend);


  boolean winner = false;//has a path from start to finish been found

  while (true) //repeat the process until ideal path is found or there is not path found
  {
    extend = big.pop();//grab the front path form the big to be extended
    if (extend.path.getLast().equals(finish)) //if goal found
    {
      if (!winner) //if first goal found, set winning path
      {
        winner = true;
        winningPath = extend.clone();
      } else { //if current path found the goal in a shorter distance than the previous winner
        if (winningPath.distance > extend.distance)
        {
          winningPath = extend.clone();//set this path as the winning path
        }
      }
      if (big.isEmpty()) //if this extend is the last path then return the winning path
      {
        return winningPath.clone();
      } else {//if not the current extend is useless to us as it cannot be extended since its finished
        extend = big.pop();//so get the next path
      }
    }


    //if the final node in the path has already been checked and the distance to it was shorter than this path has taken to get there than this path is no good
    if (!extend.path.getLast().checked || extend.distance < extend.path.getLast().smallestDistToPoint)
    {
      if (!winner || extend.distance + dist(extend.path.getLast().x, extend.path.getLast().y, finish.x, finish.y)  < winningPath.distance) //dont look at paths that are longer than a path which has already reached the goal
      {

        //if this is the first path to reach this node or the shortest path to reach this node then set the smallest distance to this point to the distance of this path
        extend.path.getLast().smallestDistToPoint = extend.distance;

        //move all paths to sorting form big then add the new paths (in the for loop)and sort them back into big.
        sorting = (LinkedList)big.clone();
        Node tempN = new Node(0, 0);//reset temp node
        if (extend.path.size() >1) {
          tempN = extend.path.get(extend.path.size() -2);//set the temp node to be the second last node in the path
        }

        for (int i =0; i< extend.path.getLast().edges.size(); i++) //for each node incident (connected) to the final node of the path to be extended
        {
          if (tempN != extend.path.getLast().edges.get(i))//if not going backwards i.e. the new node is not the previous node behind it
          {

            //if the direction to the new node is in the opposite to the way the path was heading then dont count this path
            PVector directionToNode = new PVector( extend.path.getLast().edges.get(i).x -extend.path.getLast().x, extend.path.getLast().edges.get(i).y - extend.path.getLast().y );
            directionToNode.limit(vel.mag());
            if (directionToNode.x == -1* extend.velAtLast.x && directionToNode.y == -1* extend.velAtLast.y ) {
            } else {//if not turning around
              extended = extend.clone();
              extended.addToTail(extend.path.getLast().edges.get(i), finish);
              extended.velAtLast = new PVector(directionToNode.x, directionToNode.y);
              sorting.add(extended.clone());//add this extended list to the list of paths to be sorted
            }
          }
        }


        //sorting now contains all the paths form big plus the new paths which where extended
        //adding the path which has the higest distance to big first so that its at the back of big.
        //using selection sort i.e. the easiest and worst sorting algorithm
        big.clear();
        while (!sorting.isEmpty())
        {
          float max = -1;
          int iMax = 0;
          for (int i = 0; i < sorting.size(); i++)
          {
            if (max < sorting.get(i).distance + sorting.get(i).distToFinish)//A* uses the distance from the goal plus the paths length to determine the sorting order
            {
              iMax = i;
              max = sorting.get(i).distance + sorting.get(i).distToFinish;
            }
          }
          big.addFirst(sorting.remove(iMax).clone());//add it to the front so that the ones with the greatest distance end up at the back
          //and the closest ones end up at the front
        }
      }
      extend.path.getLast().checked = true;
    }
    //if no more paths avaliable
    if (big.isEmpty()) {
      if (winner ==false) //there is not path from start to finish
      {
        println("No se pudo encontrar una ruta.");//error message
        return null;
      } else {//if winner is found then the shortest winner is stored in winning path so return that
        return winningPath.clone();
      }
    }
  }
}

// Read data from movie file.
void movieEvent(Movie m) {
  m.read();
}
