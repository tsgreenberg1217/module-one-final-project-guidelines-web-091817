# Flatiron School Module 1 - Final Project
# Created By: Todd Greenberg and Gene Yoo

## About

This project is intended to be a simple take on trivia through a user's Command Line Interface. There are 4 trivia formats from which a user can choose from: Single-player Survival, Multi-player Round Based, Multi-player Tic-Tac-Toe (i.e. Squares), and Multi-player "Jeopardy" spin-off. The project leverages the "Open Trivia Database" (src: https://opentdb.com/api_config.php), a free and open-source API, to provide multiple choice trivia questions across 32 categories ranging from film, music, movies, etc. (Note: Certain formats use questions stored in a locally seeded DB to reduce frequency of API requests)

### Game Formats

1. Survival - (1 Player)
    - Answer questions correctly to keep moving on. One miss and game over!
2. First to One-Hundred - (Up to 4 Players)
    - Classic multi-player trivia format
    - Players take turns answering questions of varying difficulty for points
    - First player to 100 points wins
3. Tic-Tac-Toe - (2 Players)
    - A spin on "Celebrity Squares" or "Tic-Tac-Toe"
    - Players take turns answering questions of varying difficulty
    - If correct answer, player can place a token on the Tic-Tac-Toe board
    - First to three in a row wins
4. Jeopardy - (Up to 4 Players)
    - A spin on "Jeopardy"
    - Players are presented 4 trivia categories to select questions from (12 questions total)
    - Questions vary in difficulty AND point-value based on position in the board
    - If correct answer, player scores points based on the question's board position
    - Player with the most total points after the board is cleared wins

#### Installation Guide
1. Before you start playing, there are a few applications you will need to have setup:
    - Git - For cloning a version of the GitHub project repository to your local computer
    - Rake - For running scripts to set up the local database relational tables, migrations, and associations
2. Open your computer's terminal and navigate to the repository you would like to download our project using the 'cd' or Change Directory command.
3. Within Terminal, run 'git clone <link to GitHub project page>' to clone our project to your local computer.
4. Within Terminal, run 'rake db:migrate' to create and associate the relational DB tables
5. Within Terminal, run 'rake seeds' to seed the local database with preliminary data
6. Within Terminal, run 'ruby bin/run.rb' to initialize the game prompts.
7. Follow the CLI prompts to navigate through the game and enjoy!

### Contributor's Guide
  - If you'd like to contribute to this project, please submit a GitHub pull request to the link provided below:
  - <PROVIDE LINK HERE>

#### License

##### Learn.co Educational Content License

Copyright (c) 2015 Flatiron School, Inc

The Flatiron School, Inc. owns this Educational Content. However, the Flatiron School supports the development and availability of educational materials in the public domain. Therefore, the Flatiron School grants Users of the Flatiron Educational Content set forth in this repository certain rights to reuse, build upon and share such Educational Content subject to the terms of the Educational Content License set forth [here](http://learn.co/content-license) (http://learn.co/content-license). You must read carefully the terms and conditions contained in the Educational Content License as such terms govern access to and use of the Educational Content.

Flatiron School is willing to allow you access to and use of the Educational Content only on the condition that you accept all of the terms and conditions contained in the Educational Content License set forth [here](http://learn.co/content-license) (http://learn.co/content-license).  By accessing and/or using the Educational Content, you are agreeing to all of the terms and conditions contained in the Educational Content License.  If you do not agree to any or all of the terms of the Educational Content License, you are prohibited from accessing, reviewing or using in any way the Educational Content.

##### MIT License

Copyright (c) [2017] [Todd Greenberg and Gene Yoo]

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
