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
### Handles
- the logic for generating a random puzzle.
- inputs by user
- board rendering
[Cell.lua](src/Cell.lua)
### Handles
- each cell Board.lua renders is an instance of this class
- all candidates provided for given cell
- highlighting depending on user selection
[StateMachine.lua](src/StateMachine.lua)
Manages the game states
[Constants.lua](src/Constants.lua)
Constants used in this application.
Difficulty settings and screen sizes can be changed here.
[Util.lua](src/Util.lua)
Custom utility functions used
