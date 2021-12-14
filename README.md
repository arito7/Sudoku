# Sudoku
#### Video Demo:
#### Description:
A sudoku game made in lua using LOVE2D.

The game features 4 difficulty levels.
- Easy
- Medium
- Hard
- Extreme

#### Files
[BaseState.lua](src/states/BaseState.lua)

Template for States used within the StateMachine

[StartState.lua](src/states/StartState.lua)

Menu screen state.
Ability to choose difficulty or close application.

[PlayState.lua](src/states/PlayState.lua)

Game screen state.
Renders a sudoku board
- a timer on top right
- a pencil mode button 

[Board.lua](src/Board.lua)
Handles
- the logic for generating a random puzzle.
- inputs by user
- board rendering

[Cell.lua](src/Cell.lua)

Handles
- each cell Board.lua renders is an instance of this class
- all candidates provided for given cell
- highlighting depending on user selection

[StateMachine.lua](src/StateMachine.lua)

Manages the game states

[Constants.lua](src/Constants.lua)

Constants used in this application.
Difficulty settings and screen sizes can be changed here.

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
1. choose a number from a set containing the numbers 1 to 9
2. insert the number into current cell
3. check if the board is still valid
    if it is still valid
        repeat steps for next cell 
    if it is not valid
        repeat steps for this cell
            if we exhausted all numbers from the set return false
