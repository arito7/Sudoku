# Sudoku
#### Video Demo: https://youtu.be/qmKu8yqhQaM
#### Description:
A sudoku game made in lua using LOVE2D.

The game features 4 difficulty levels.
- Easy
- Medium
- Hard
- Extreme

#### Files
[BaseState.lua](src/states/BaseState.lua)
- Template for States used within the StateMachine

[StartState.lua](src/states/StartState.lua)
- Menu screen state.
- Ability to choose difficulty or close application.

[PlayState.lua](src/states/PlayState.lua)
- Game screen state.
- Renders a sudoku board
- a timer on top right
- a pencil mode button 

[Board.lua](src/Board.lua)
- the logic for generating a random puzzle.
- inputs by user
- board rendering

[Cell.lua](src/Cell.lua)
- each cell Board.lua renders is an instance of this class
- all candidates provided for given cell
- highlighting depending on user selection

[StateMachine.lua](src/StateMachine.lua)
- Manages the game states

[Constants.lua](src/Constants.lua)
- Constants used in this application.
- Difficulty settings and screen sizes can be changed here.

[Util.lua](src/Util.lua)
- Custom utility functions used

#### Process
I started by building a sudoku solver.
My initial approach was to solve this as a human would.
This approach worked for easy to medium difficulty puzzles but was 
not viable on extreme difficulty puzzles as the methods for solving 
a cell become increasingly abstract and difficult.
Ultimately I decided on a more brute force approach using recursion.
In order to make this recursive approach possible I converted
the 2d array into a 1 dimensional array containg all 81 cells.

Pseduocode

```
1. choose a number from a set containing the numbers 1 to 9
2. insert the number into current cell
3. check if the board is still valid
    if it is still valid
        repeat steps for next cell 
    if it is not valid
        repeat steps for this cell using the next number in the set
            if we exhausted all numbers from the set return false
            
```

##### Key Points for Solver Algorithm
- This solver is able to solve the purported 'hardest sudoku board' in around 1 second.
- A key point to optimizing this algorithm was making the function that checks validity of an input;
as light as possible. 
This validity check function is called every time a new value is inserted into
a cell and has to iterate through all 81 entities in the array of cells.
The optimal way was to check all conditions in one iteration and making the loosest check conditions 
come first which would allow for quicker iterations.
- Another key point was determining all possible candidates for each cell before passing it to the algorithm.
This allows the algorithm to choose only valid values from the list of candidates, and iterate through them until the board is solved.

#### Generation of a random Sudoku board
- Due to the nature of this algorithm it is able to generate a valid random Sudoku board as long as an array with only empty values
is passed and selecting a random number between 1 to 9 each iteration allowing for a random board.
- After a random board is generated a certain number of mirrored cells are masked (masking: displays as an empty cell for the user to solve)
The number of cells to be masked are determined by the difficulty selected. 
Difficulty is simply defined by the number of cells masked, the higher the difficulty the more cells are masked.
eg: mirror cell for cell 1 is cell 81. mirror cell for 40 is 42 *absolute value from center cell 41; is the mirrored cell
Rather than randomnly masking cells; this method of masking allows the board to be a solvable board.
- After masking, rows and columns within the same quadrant are shuffled. These shuffles of rows and columns retain the validity of the board.
eg: row 1, 2, 3 are in the same quadrant, two rows are randomnly selected and swapped.
eg: columns 4, 5, 6 are in the same quadrant, two columns are randomly selected and swapped.

#### Known areas with room for improvement
- The generated puzzle is solvable but is not necessarily a puzzle with a unique solution. (A unique solution puzzle will only have 1 way to solve the puzzle)
- Difficulty is only determined by the number of masked cells. Instead difficulty can be weighted by the techniques required to solve the board.




