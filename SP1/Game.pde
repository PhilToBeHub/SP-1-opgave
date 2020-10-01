import java.util.Random;

class Game
{
  private Random rnd;
  private final int width;
  private final int height;
  private int[][] board;
  private Keys keys;
  private Keys2 keys2;
  private int playerLife;
  private int player2Life;
  private int playerPoint;
  private int player2Point;
  private Dot player;
  private Dot player2;
  private Dot[] enemies;
  private Dot[] food;
 



  Game(int width, int height, int numberOfEnemies, int numberOfFood)
  {
    if (width < 10 || height < 10)
    {
      throw new IllegalArgumentException("Width and height must be at least 10");
    }
    if (numberOfEnemies < 0)
    {
      throw new IllegalArgumentException("Number of enemies must be positive");
    } 
    this.rnd = new Random();
    this.board = new int[width][height];
    this.width = width;
    this.height = height;
    keys = new Keys();
    keys2 = new Keys2();
    player = new Dot(0, 0, width-1, height-1);
    player2 = new Dot(0, 19, width-1, height-1);
    enemies = new Dot[numberOfEnemies];
    food = new Dot[numberOfFood];
    for (int i = 0; i < numberOfEnemies; ++i)
    {
      enemies[i] = new Dot(width-1, height-1, width-1, height-1);
    }
    for (int i = 0; i < numberOfFood; ++i)
    {
      food[i] = new Dot(width-1, height-1, width-1, height-1);
    }
    this.playerLife = 100;
    this.player2Life = 100;
    this.playerPoint = 0;
    this.player2Point = 0;
  }

  public int getWidth()
  {
    return width;
  }

  public int getHeight()
  {
    return height;
  }

  public int getPlayerLife()
  {
    return playerLife;
  }

  public int getPlayer2Life() {
    return player2Life;
  }

  public int getPlayerPoint() {
    return playerPoint;
  }

  public int getPlayer2Point() {
    return player2Point;
  }

  public void onKeyPressed(char ch)
  {
    keys.onKeyPressed(ch);
  }

  public void onKeyReleased(char ch)
  {
    keys.onKeyReleased(ch);
  }

  public void onKeyPressed2(int code)
  {
    keys2.onKeyPressed(code);
  }

  public void onKeyReleased2(int code)
  {
    keys2.onKeyReleased(code);
  }

  public void update()
  {
    updatePlayer();
    updatePlayer2();
    updateEnemies();
    updateFood();
    checkForCollisions();
    clearBoard();
    populateBoard();
    gameEnd();
  }



  public int[][] getBoard()
  {
    //ToDo: Defensive copy?
    return board;
  }

  private void clearBoard()
  {
    for (int y = 0; y < height; ++y)
    {
      for (int x = 0; x < width; ++x)
      {
        board[x][y]=0;
      }
    }
  }

  private void updatePlayer()
  {
    //Update player
    if (keys.wDown() && !keys.sDown())
    {
      player.moveUp();
    }
    if (keys.aDown() && !keys.dDown())
    {
      player.moveLeft();
    }
    if (keys.sDown() && !keys.wDown())
    {
      player.moveDown();
    }
    if (keys.dDown() && !keys.aDown())
    {
      player.moveRight();
    }
  }

  private void updatePlayer2()
  {
    //Update player
    if (keys2.wDown() && !keys2.sDown())
    {
      player2.moveUp();
    }
    if (keys2.aDown() && !keys2.dDown())
    {
      player2.moveLeft();
    }
    if (keys2.sDown() && !keys2.wDown())
    {
      player2.moveDown();
    }
    if (keys2.dDown() && !keys2.aDown())
    {
      player2.moveRight();
    }
  }

  private void updateEnemies()
  {
    for (int i = 0; i < enemies.length; ++i)
    {
      //Should we follow or move randomly?
      //2 out of 3 we will follow..
      if (rnd.nextInt(3) < 2)
      {
        //We follow
        int dx = 0, dy = 0, dx2 = 0, dy2 = 0;
        if (i < enemies.length/2) {
          dx2 = player2.getX() - enemies[i].getX();
          dy2 = player2.getY() - enemies[i].getY();
        } else {
          dx = player.getX() - enemies[i].getX();
          dy = player.getY() - enemies[i].getY();
        }
        if (abs(dx) > abs(dy) || abs(dx2) > abs(dy2))
        {
          if (dx > 0 || dx2 > 0)
          {
            //Player is to the right
            enemies[i].moveRight();
          } else
          {
            //Player is to the left
            enemies[i].moveLeft();
          }
        } else if (dy > 0 || dy2 > 0)
        {
          //Player is down;
          enemies[i].moveDown();
        } else
        {//Player is up;
          enemies[i].moveUp();
        }
      } else
      {
        //We move randomly
        int move = rnd.nextInt(4);
        if (move == 0)
        {
          //Move right
          enemies[i].moveRight();
        } else if (move == 1)
        {
          //Move left
          enemies[i].moveLeft();
        } else if (move == 2)
        {
          //Move up
          enemies[i].moveUp();
        } else if (move == 3)
        {
          //Move down
          enemies[i].moveDown();
        }
      }
    }
  }

  private void populateBoard()
  {
    //Insert player
    board[player.getX()][player.getY()] = 1;

    // player 2 inserted here aswell, but how
    board[player2.getX()][player2.getY()] = 4;
    //Insert enemies
    for (int i = 0; i < enemies.length; ++i)
    {
      board[enemies[i].getX()][enemies[i].getY()] = 2;
    }
    for (int i = 0; i < food.length; i++) {
      board[food[i].getX()][food[i].getY()] = 3;
    }
  }

  private void checkForCollisions()
  {
    //Check enemy collisions
    for (int i = 0; i < enemies.length; ++i)
    {
      if (enemies[i].getX() == player.getX() && enemies[i].getY() == player.getY())
      {
        //We have a collision
        --playerLife;
      }
    }
    for (int i = 0; i < enemies.length; ++i)
    {
      if (enemies[i].getX() == player2.getX() && enemies[i].getY() == player2.getY())
      {
        //We have a collision
        --player2Life;
      }
    }
    for (int i = 0; i < food.length; ++i)
    {
      if (food[i].getX() == player.getX() && food[i].getY() == player.getY())
      {
        //We have a collision
        ++playerPoint;
        food[i].setX((int)random(0,width));
        food[i].setY((int)random(0,height));
      }
    }

    for (int i = 0; i < food.length; ++i)
    {
      if (food[i].getX() == player2.getX() && food[i].getY() == player2.getY())
      {
        //We have a collision
        ++player2Point;
        food[i].setX((int)random(0,width));
        food[i].setY((int)random(0,height));
      }
    }
  }

  private void updateFood() {
    for (int i = 0; i < food.length; ++i)
    {
      //Should we follow or move randomly?
      //2 out of 3 we will follow..
      if (rnd.nextInt(2) < 3)
      {

        int dx = 0, dy = 0, dx2 = 0, dy2 = 0;
        if (i < enemies.length/2) {
          dx2 = player2.getX() - enemies[i].getX();
          dy2 = player2.getY() - enemies[i].getY();
        } else {
          dx = player.getX() - enemies[i].getX();
          dy = player.getY() - enemies[i].getY();
        }

        if (abs(dx) < abs(dy) || abs(dx2) < abs(dy2))
        {
          if (dx < 0 || dx2 < 0)
          {
            //Player is to the right
            food[i].moveRight();
          } else
          {
            //Player is to the left
            food[i].moveLeft();
          }
        } else if (dy < 0 || dy2 < 0)
        {
          //Player is down;
          food[i].moveDown();
        } else
        {//Player is up;
          food[i].moveUp();
        }
      } else
      {
        //We move randomly
        int move = rnd.nextInt(4);
        if (move == 0)
        {
          //Move right
          food[i].moveRight();
        } else if (move == 1)
        {
          //Move left
          food[i].moveLeft();
        } else if (move == 2)
        {
          //Move up
          food[i].moveUp();
        } else if (move == 3)
        {
          //Move down
          food[i].moveDown();
        }
      }
    }
  }

  public void gameEnd() {
    if (playerLife <= 0 || player2Life <= 0) {
      noLoop();
    }

    if (playerPoint == 15 || player2Point == 15) {
      noLoop();
    }
  }
}
