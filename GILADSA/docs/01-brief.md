# Project Brief: GILADSA (Gamified Interactive Learning Atlas for Data Structures and Algorithms System)

## 1. The problem
Many IT students at Partido State University find Data Structures and Algorithms hard because the concepts are abstract and difficult to visualize. Traditional lessons give them few hands-on ways to see how an algorithm works step by step, which leads to confusion and low motivation.

## 2. Users and what they need to do
| User role | What they need to do in the app |
|-----------|---------------------------------|
| Student | Create an account and log in, browse DSA topics and learning modules, play game levels, solve puzzles and coding challenges, watch step-by-step algorithm visualizations, track level progress, and earn rewards |
| Admin / Instructor  | Manage topics, modules, levels, challenges, algorithms and rewards, and review student attempts and progres   |

## 3. The database behind it
1. STUDENT: Stores each student’s account and profile (name, email, program, year level).
2. DSA_TOPIC: Stores the main DSA subjects, such as Stacks, Queues and Sorting.
3. LEARNING_MODULE: Stores the ordered lessons under each topic.
4. GAME_LEVEL: Stores the playable levels that belong to a module.
5. CHALLENGE: Stores the tasks in a level, with their type, instructions and maximum points.
6. PUZZLE: Stores the puzzle details for a challenge (optional, one per challenge).
7. CODING_CHALLENGE: Stores the problem statement, starter code and expected output for a coding challenge (optional, one per challenge).
8. ALGORITHM: Stores each algorithm’s name, description and pseudocode under a topic.
9. VISUALIZATION_STEP: Stores the ordered steps used to animate an algorithm.
10. ATTEMPT: Records each time a student submits an answer to a challenge, with score and correctness.
11. STUDENT_LEVEL_PROGRESS: Tracks each student’s status on each level (unlocked, in progress, completed).
12. REWARD: Stores the available rewards and achievements and the points required.
13. STUDENT_REWARD: Links students to the rewards they have earned.

## 4. Must-have features 
1. Register and log in students with secure password hashing.
2. Browse DSA topics, learning modules and game levels in order.
3. Play puzzles and coding challenges, and record every submission as an attempt with a score.
4. Visualize algorithms step by step using the stored visualization steps.
5. Track each student’s level progress and unlock the next level when one is completed.
Award rewards and achievements automatically when a student reaches the required points.

## 5. Nice-to-have features (only if there's time)
1. Display a leaderboard ranking students by points.
2. Build an admin dashboard for managing content and viewing class progress.
3. Render the learning areas as an explorable 3D environment (for example with Three.js).

## 6. Similar apps I looked at
1. VisuAlgo (visualgo.net): Borrow the step-by-step animation of algorithms with an explanation at each step, which matches our VISUALIZATION_STEP table.
2. CodeCombat (codecombat.com): Borrow the idea of learning to code by progressing through game levels with rewards