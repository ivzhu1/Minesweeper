import de.bezier.guido.*;
int NUM_ROWS = 20, NUM_COLS = 20;
int NUM_MINES = 45;
int mineCount = NUM_MINES;
boolean end = false;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
  size(400, 430);
  textAlign(CENTER, CENTER);

  // make the manager
  Interactive.make( this );

  //your code to initialize buttons goes here
  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  for (int r=0; r<NUM_ROWS; r++) {
    for (int c=0; c<NUM_COLS; c++) {
      buttons[r][c] = new MSButton(r, c);
    }
  }

  setMines();
}
public void setMines()
{
  while (mines.size() < NUM_MINES)
  {
    int r = (int)(Math.random()*NUM_ROWS);
    int c = (int)(Math.random()*NUM_COLS);
    if (!mines.contains(buttons[r][c]))
      mines.add(buttons[r][c]);
  }
} 

public void draw ()
{
  background(133, 129, 127);
  fill(255);
  text("Mines: " + mineCount, 370, 20); // CODE BOMBS MINES - NUMFLAGGED
  if (isWon() == true) {
    displayWinningMessage();
    fill(3, 252, 240);
    text("You Win!", 200, 20);
  }
  if (isWon() == false && end == true) {
    fill(255, 0, 0);
    text("You Lose!", 200, 17);
  }
}
public boolean isWon()
{
  for (int r = 0; r<NUM_ROWS; r++)
    for (int c = 0; c<NUM_COLS; c++)
      if (!mines.contains(buttons[r][c]) && buttons[r][c].clicked == false)
        return false;
  return true;
}
public void displayLosingMessage()
{
  end = true;
}
public void displayWinningMessage()
{
  end = true;
}
public boolean isValid(int r, int c)
{
  if (r>=0 && r<NUM_ROWS && c>=0 && c<NUM_COLS)
    return true;
  return false;
}
public int countMines(int row, int col)
{
  int numMines = 0;
  for (int r = row-1; r<=row+1; r++) {
    for (int c = col-1; c<=col+1; c++)
      if (isValid(r, c)==true)
        if (mines.contains(buttons[r][c]) == true)
          numMines+=1;
  }
  return numMines;
}
public class MSButton
{
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean clicked, flagged;
  private String myLabel;

  public MSButton ( int row, int col )
  {
    width = 400/NUM_COLS;
    height = 400/NUM_ROWS;
    myRow = row;
    myCol = col; 
    x = myCol*width;
    y = myRow*height+30;
    myLabel = "";
    flagged = clicked = false;
    Interactive.add( this ); // register it with the manager
  }

  // called by manager
  public void mousePressed () 
  {
    if (end == false) {
      if (mouseButton == RIGHT && clicked == false) {
        if (flagged == true) {
          flagged = false;
          mineCount += 1;
        } else {
          flagged = true;
          mineCount -= 1;
        }
      }
      if (flagged == false) {
        if (mouseButton == LEFT) {
          clicked = true;
          if (mines.contains(this))
            displayLosingMessage();
          else if (countMines(myRow, myCol) > 0) {
            setLabel(countMines(myRow, myCol));
            clicked = true;
          } else
            for (int r = this.myRow-1; r<=this.myRow+1; r++) {
              for (int c = this.myCol-1; c<=this.myCol+1; c++) {
                if (isValid(r, c) && !buttons[r][c].isClicked()) {
                  if (buttons[r][c].flagged == true) {
                    buttons[r][c].flagged = false;
                    mineCount += 1;
                  }
                  buttons[r][c].mousePressed();
                }
              }
            }
        }
      }
    }
  }
  public boolean isClicked() {
    return clicked;
  }
  public void draw () 
  {    
    if (flagged)
      fill(0);
    else if ( clicked && mines.contains(this) && end == true ) {
      fill(255, 0, 0);
      for (int r = 0; r<mines.size(); r++) {
        mines.get(r).flagged = false;
        mines.get(r).clicked = true;
      }
    } else if ( clicked && mines.contains(this) ) 
      fill(255, 0, 0);
    else if (clicked)
      fill( 200 );
    else 
    fill( 100 );

    rect(x, y, width, height);
    if (end == false) {
      fill(0);
    } else {
      fill(64, 0, 138);
    }
    text(myLabel, x+width/2, y+height/2);
  }
  public void setLabel(String newLabel)
  {
    myLabel = newLabel;
  }
  public void setLabel(int newLabel)
  {
    myLabel = ""+ newLabel;
  }
  public boolean isFlagged()
  {
    return flagged;
  }
}
