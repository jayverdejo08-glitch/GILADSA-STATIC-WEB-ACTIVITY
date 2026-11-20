# 02. CRUD Operation Map

This document outlines the comprehensive CRUD (Create, Read, Update, Delete) mappings for every table in the **GILADSA** (Gamified Interactive Learning Atlas for Data Structures and Algorithms System) database. It defines user actions, user interface screens, HTTP routes, SQL queries, and validation rules.

---

## 1. Entity: `STUDENT` (Student Account & Authentication)

| Operation | User Action | UI Screen | HTTP Method & Route | Target DB Query | Notes / Validation |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Create** | Student submits the registration form | `prototype/register.html` | `POST /api/students` | `INSERT INTO STUDENT (First_Name, Last_Name, Email, Password_Hash, Program, Year_Level, Role) VALUES (?, ?, ?, ?, ?, ?, 'student')` | Email must be unique. Password is encrypted using bcrypt before insertion. |
| **Read (List)** | Admin/Instructor views enrolled students | `prototype/admin-students.html` | `GET /api/students?program=BSIT&page=1` | `SELECT Student_ID, First_Name, Last_Name, Email, Program, Year_Level, Role, Created_At FROM STUDENT ORDER BY Created_At DESC` | Password hash is excluded from response payload. Supports pagination & filtering. |
| **Read (Detail)** | Student views profile dashboard | `prototype/profile.html` | `GET /api/students/:id` | `SELECT Student_ID, First_Name, Last_Name, Email, Program, Year_Level, Role, Created_At FROM STUDENT WHERE Student_ID = ?` | Returns student details along with cumulative score and progress stats. |
| **Update** | Student edits account details or changes password | `prototype/profile-edit.html` | `PUT /api/students/:id` | `UPDATE STUDENT SET First_Name = ?, Last_Name = ?, Program = ?, Year_Level = ? WHERE Student_ID = ?` | Password changes route through dedicated re-hashing logic. |
| **Delete** | Admin removes or deactivates student record | `prototype/admin-students.html` | `DELETE /api/students/:id` | `DELETE FROM STUDENT WHERE Student_ID = ?` | Cascades deletion to associated attempts, level progress, and earned rewards. |

---

## 2. Entity: `DSA_TOPIC` (Data Structure & Algorithm Topics)

| Operation | User Action | UI Screen | HTTP Method & Route | Target DB Query | Notes / Validation |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Create** | Instructor adds a new DSA subject (e.g. Trees, Graphs) | `prototype/admin-topic-form.html` | `POST /api/topics` | `INSERT INTO DSA_TOPIC (Topic_Name, Topic_Description, Topic_Category) VALUES (?, ?, ?)` | Topic_Name is required (max 30 chars). |
| **Read (List)** | Student browses available topics in the Atlas | `prototype/atlas.html` | `GET /api/topics` | `SELECT * FROM DSA_TOPIC ORDER BY Topic_ID ASC` | Displays cards grouped by `Topic_Category` (e.g., Linear, Non-Linear, Sorting). |
| **Read (Detail)** | Student selects a topic to see lessons and algorithms | `prototype/topic-detail.html` | `GET /api/topics/:id` | `SELECT * FROM DSA_TOPIC WHERE Topic_ID = ?` | Aggregates child modules and visualization algorithms. |
| **Update** | Instructor updates topic description or category | `prototype/admin-topic-form.html?id=:id` | `PUT /api/topics/:id` | `UPDATE DSA_TOPIC SET Topic_Name = ?, Topic_Description = ?, Topic_Category = ? WHERE Topic_ID = ?` | Validates category name format. |
| **Delete** | Instructor deletes a topic | `prototype/admin-topics.html` | `DELETE /api/topics/:id` | `DELETE FROM DSA_TOPIC WHERE Topic_ID = ?` | Triggers cascade deletion to all modules and algorithms under this topic. |

---

## 3. Entity: `REWARD` (Achievements & Badges)

| Operation | User Action | UI Screen | HTTP Method & Route | Target DB Query | Notes / Validation |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Create** | Admin creates a new achievement badge | `prototype/admin-reward-form.html` | `POST /api/rewards` | `INSERT INTO REWARD (Reward_Name, Reward_Description, Points_Required) VALUES (?, ?, ?)` | Points_Required must be a non-negative integer. |
| **Read (List)** | Student views rewards catalog and unlocked trophies | `prototype/trophies.html` | `GET /api/rewards` | `SELECT * FROM REWARD ORDER BY Points_Required ASC` | Shows locked badges and threshold points needed. |
| **Read (Detail)** | Student clicks a badge to inspect unlock criteria | `prototype/reward-modal.html` | `GET /api/rewards/:id` | `SELECT * FROM REWARD WHERE Reward_ID = ?` | Returns badge badge requirements and description. |
| **Update** | Admin modifies reward criteria or name | `prototype/admin-reward-form.html?id=:id` | `PUT /api/rewards/:id` | `UPDATE REWARD SET Reward_Name = ?, Reward_Description = ?, Points_Required = ? WHERE Reward_ID = ?` | Updates requirements for future claims. |
| **Delete** | Admin removes an obsolete reward badge | `prototype/admin-rewards.html` | `DELETE /api/rewards/:id` | `DELETE FROM REWARD WHERE Reward_ID = ?` | Cascades delete to `STUDENT_REWARD` entries. |

---

## 4. Entity: `LEARNING_MODULE` (Ordered Topic Modules)

| Operation | User Action | UI Screen | HTTP Method & Route | Target DB Query | Notes / Validation |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Create** | Instructor adds module to topic | `prototype/admin-module-form.html` | `POST /api/modules` | `INSERT INTO LEARNING_MODULE (Topic_ID, Module_Title, Module_Description, Module_Order) VALUES (?, ?, ?, ?)` | Topic_ID must exist; Module_Order controls pedagogical progression. |
| **Read (List)** | Student views curriculum sequence for a topic | `prototype/topic-detail.html` | `GET /api/topics/:topic_id/modules` | `SELECT * FROM LEARNING_MODULE WHERE Topic_ID = ? ORDER BY Module_Order ASC` | Sorted by sequential order. |
| **Read (Detail)** | Student opens module overview page | `prototype/module-view.html` | `GET /api/modules/:id` | `SELECT * FROM LEARNING_MODULE WHERE Module_ID = ?` | Includes summary of included game levels. |
| **Update** | Instructor reorders or modifies module details | `prototype/admin-module-form.html?id=:id` | `PUT /api/modules/:id` | `UPDATE LEARNING_MODULE SET Module_Title = ?, Module_Description = ?, Module_Order = ? WHERE Module_ID = ?` | Re-indexes ordering sequence. |
| **Delete** | Instructor removes a learning module | `prototype/admin-modules.html` | `DELETE /api/modules/:id` | `DELETE FROM LEARNING_MODULE WHERE Module_ID = ?` | Cascades deletion to child levels and challenges. |

---

## 5. Entity: `GAME_LEVEL` (Playable Module Levels)

| Operation | User Action | UI Screen | HTTP Method & Route | Target DB Query | Notes / Validation |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Create** | Instructor creates a level in a module | `prototype/admin-level-form.html` | `POST /api/levels` | `INSERT INTO GAME_LEVEL (Module_ID, Level_Number, Level_Title, Difficulty) VALUES (?, ?, ?, ?)` | Difficulty must be 'Easy', 'Medium', or 'Hard'. |
| **Read (List)** | Student views roadmap/quest map of levels | `prototype/level-map.html` | `GET /api/modules/:module_id/levels` | `SELECT l.*, p.Progress_Status FROM GAME_LEVEL l LEFT JOIN STUDENT_LEVEL_PROGRESS p ON l.Level_ID = p.Level_ID AND p.Student_ID = ? ORDER BY l.Level_Number ASC` | Joins student progress to show locked/unlocked status. |
| **Read (Detail)** | Student clicks level node to launch briefing | `prototype/level-intro.html` | `GET /api/levels/:id` | `SELECT * FROM GAME_LEVEL WHERE Level_ID = ?` | Displays level objectives and available challenges. |
| **Update** | Instructor changes title, number, or difficulty | `prototype/admin-level-form.html?id=:id` | `PUT /api/levels/:id` | `UPDATE GAME_LEVEL SET Level_Number = ?, Level_Title = ?, Difficulty = ? WHERE Level_ID = ?` | Level_Number must remain unique per module. |
| **Delete** | Instructor removes a level | `prototype/admin-levels.html` | `DELETE /api/levels/:id` | `DELETE FROM GAME_LEVEL WHERE Level_ID = ?` | Removes child challenges and progress links. |

---

## 6. Entity: `CHALLENGE` (Level Tasks & Exercises)

| Operation | User Action | UI Screen | HTTP Method & Route | Target DB Query | Notes / Validation |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Create** | Instructor creates a challenge inside a level | `prototype/admin-challenge-form.html` | `POST /api/challenges` | `INSERT INTO CHALLENGE (Level_ID, Challenge_Title, Challenge_Type, Instructions, Max_Points) VALUES (?, ?, ?, ?, ?)` | Challenge_Type: 'Puzzle', 'Coding', or 'Quiz'. Max_Points > 0. |
| **Read (List)** | Instructor manages challenges for a level | `prototype/admin-challenges.html` | `GET /api/levels/:level_id/challenges` | `SELECT * FROM CHALLENGE WHERE Level_ID = ?` | Lists challenge titles, types, and max points. |
| **Read (Detail)** | Student opens challenge gameplay stage | `prototype/challenge-view.html` | `GET /api/challenges/:id` | `SELECT * FROM CHALLENGE WHERE Challenge_ID = ?` | Returns instructions and triggers puzzle/coding loader. |
| **Update** | Instructor updates instructions or max score | `prototype/admin-challenge-form.html?id=:id` | `PUT /api/challenges/:id` | `UPDATE CHALLENGE SET Challenge_Title = ?, Challenge_Type = ?, Instructions = ?, Max_Points = ? WHERE Challenge_ID = ?` | Validates non-empty title and instructions. |
| **Delete** | Instructor deletes a challenge | `prototype/admin-challenges.html` | `DELETE /api/challenges/:id` | `DELETE FROM CHALLENGE WHERE Challenge_ID = ?` | Cascades delete to PUZZLE, CODING_CHALLENGE, and ATTEMPTS. |

---

## 7. Entity: `PUZZLE` (Interactive Visual Puzzles)

| Operation | User Action | UI Screen | HTTP Method & Route | Target DB Query | Notes / Validation |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Create** | Instructor attaches puzzle logic to a challenge | `prototype/admin-puzzle-form.html` | `POST /api/challenges/:challenge_id/puzzle` | `INSERT INTO PUZZLE (Challenge_ID, Puzzle_Type, Puzzle_Data, Correct_Answer) VALUES (?, ?, ?, ?)` | Challenge_ID is unique (1-to-1 relationship with CHALLENGE). |
| **Read (List)** | Instructor audits puzzle repository | `prototype/admin-puzzles.html` | `GET /api/puzzles` | `SELECT p.*, c.Challenge_Title FROM PUZZLE p JOIN CHALLENGE c ON p.Challenge_ID = c.Challenge_ID` | Displays puzzle types (e.g. Stack Reversal, Binary Search Tree Traversal). |
| **Read (Detail)** | Game engine fetches puzzle board configuration | `prototype/puzzle-canvas.html` | `GET /api/challenges/:challenge_id/puzzle` | `SELECT * FROM PUZZLE WHERE Challenge_ID = ?` | `Correct_Answer` evaluated server-side upon student submission. |
| **Update** | Instructor modifies puzzle data or correct answer | `prototype/admin-puzzle-form.html?id=:id` | `PUT /api/puzzles/:id` | `UPDATE PUZZLE SET Puzzle_Type = ?, Puzzle_Data = ?, Correct_Answer = ? WHERE Puzzle_ID = ?` | Validates JSON format of `Puzzle_Data`. |
| **Delete** | Instructor disassociates puzzle configuration | `prototype/admin-puzzles.html` | `DELETE /api/puzzles/:id` | `DELETE FROM PUZZLE WHERE Puzzle_ID = ?` | Removes puzzle configuration. |

---

## 8. Entity: `CODING_CHALLENGE` (Algorithm Coding Problems)

| Operation | User Action | UI Screen | HTTP Method & Route | Target DB Query | Notes / Validation |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Create** | Instructor writes coding problem and test outputs | `prototype/admin-coding-form.html` | `POST /api/challenges/:challenge_id/coding` | `INSERT INTO CODING_CHALLENGE (Challenge_ID, Problem_Statement, Starter_Code, Expected_Output, Programming_Language) VALUES (?, ?, ?, ?, ?)` | Challenge_ID is unique (1-to-1). Default language: 'Python'. |
| **Read (List)** | Instructor views all coding exercises | `prototype/admin-coding.html` | `GET /api/coding-challenges` | `SELECT cc.*, c.Challenge_Title FROM CODING_CHALLENGE cc JOIN CHALLENGE c ON cc.Challenge_ID = c.Challenge_ID` | Useful for problem bank reusability. |
| **Read (Detail)** | Student loads browser code workspace | `prototype/ide-challenge.html` | `GET /api/challenges/:challenge_id/coding` | `SELECT Coding_Challenge_ID, Challenge_ID, Problem_Statement, Starter_Code, Programming_Language FROM CODING_CHALLENGE WHERE Challenge_ID = ?` | `Expected_Output` is kept secret from client payload to prevent client-side bypass. |
| **Update** | Instructor edits test cases or starter template | `prototype/admin-coding-form.html?id=:id` | `PUT /api/coding-challenges/:id` | `UPDATE CODING_CHALLENGE SET Problem_Statement = ?, Starter_Code = ?, Expected_Output = ?, Programming_Language = ? WHERE Coding_Challenge_ID = ?` | Validates starter code syntax. |
| **Delete** | Instructor deletes coding challenge entity | `prototype/admin-coding.html` | `DELETE /api/coding-challenges/:id` | `DELETE FROM CODING_CHALLENGE WHERE Coding_Challenge_ID = ?` | Removes problem data. |

---

## 9. Entity: `ALGORITHM` (DSA Algorithm Descriptions & Pseudocode)

| Operation | User Action | UI Screen | HTTP Method & Route | Target DB Query | Notes / Validation |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Create** | Instructor registers algorithm under topic | `prototype/admin-algorithm-form.html` | `POST /api/algorithms` | `INSERT INTO ALGORITHM (Topic_ID, Algorithm_Name, Algorithm_Description, Pseudocode) VALUES (?, ?, ?, ?)` | Topic_ID must be valid. Algorithm_Name max 30 chars. |
| **Read (List)** | Student browses algorithms in visualizer hub | `prototype/algorithms-hub.html` | `GET /api/topics/:topic_id/algorithms` | `SELECT * FROM ALGORITHM WHERE Topic_ID = ? ORDER BY Algorithm_Name ASC` | Displays available interactive visualizers (e.g. QuickSort, BFS, Dijkstra). |
| **Read (Detail)** | Student opens step-by-step visualizer screen | `prototype/visualizer.html` | `GET /api/algorithms/:id` | `SELECT * FROM ALGORITHM WHERE Algorithm_ID = ?` | Loads algorithm metadata alongside pseudocode panel. |
| **Update** | Instructor clarifies pseudocode or notes | `prototype/admin-algorithm-form.html?id=:id` | `PUT /api/algorithms/:id` | `UPDATE ALGORITHM SET Algorithm_Name = ?, Algorithm_Description = ?, Pseudocode = ? WHERE Algorithm_ID = ?` | Validates pseudocode lines formatting. |
| **Delete** | Instructor removes algorithm definition | `prototype/admin-algorithms.html` | `DELETE /api/algorithms/:id` | `DELETE FROM ALGORITHM WHERE Algorithm_ID = ?` | Cascades delete to corresponding visualization steps. |

---

## 10. Entity: `VISUALIZATION_STEP` (Step-by-Step Animation Frames)

| Operation | User Action | UI Screen | HTTP Method & Route | Target DB Query | Notes / Validation |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Create** | Instructor or automated parser seeds animation step | `prototype/admin-step-form.html` | `POST /api/algorithms/:algorithm_id/steps` | `INSERT INTO VISUALIZATION_STEP (Algorithm_ID, Step_Number, Step_Explanation, State_Data) VALUES (?, ?, ?, ?)` | Step_Number controls sequential playback. State_Data stores memory/array JSON state. |
| **Read (List)** | Interactive visualizer fetches playback animation | `prototype/visualizer.html` | `GET /api/algorithms/:algorithm_id/steps` | `SELECT * FROM VISUALIZATION_STEP WHERE Algorithm_ID = ? ORDER BY Step_Number ASC` | Read by playback slider, forward/backward step controls. |
| **Read (Detail)** | Visualizer jumps to specific step index | `prototype/visualizer.html` | `GET /api/steps/:id` | `SELECT * FROM VISUALIZATION_STEP WHERE Step_ID = ?` | Inspects state snapshot for a single step. |
| **Update** | Instructor adjusts step explanation or state snapshot | `prototype/admin-step-form.html?id=:id` | `PUT /api/steps/:id` | `UPDATE VISUALIZATION_STEP SET Step_Number = ?, Step_Explanation = ?, State_Data = ? WHERE Step_ID = ?` | Validates JSON array/tree state schema. |
| **Delete** | Instructor deletes invalid visualizer frame | `prototype/admin-steps.html` | `DELETE /api/steps/:id` | `DELETE FROM VISUALIZATION_STEP WHERE Step_ID = ?` | Removes specific step from the sequence. |

---

## 11. Entity: `ATTEMPT` (Student Challenge Submissions)

| Operation | User Action | UI Screen | HTTP Method & Route | Target DB Query | Notes / Validation |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Create** | Student clicks "Submit Solution" / "Run Tests" | `prototype/challenge-view.html` | `POST /api/attempts` | `INSERT INTO ATTEMPT (Student_ID, Challenge_ID, Submitted_Answer, Score, Is_Correct) VALUES (?, ?, ?, ?, ?)` | Evaluated by backend grader. Calculates Score and sets Is_Correct boolean. |
| **Read (List)** | Student reviews submission history; Instructor audits | `prototype/attempts-history.html` | `GET /api/students/:student_id/attempts` | `SELECT a.*, c.Challenge_Title FROM ATTEMPT a JOIN CHALLENGE c ON a.Challenge_ID = c.Challenge_ID WHERE a.Student_ID = ? ORDER BY a.Attempted_At DESC` | Shows submission timestamps, scores, and pass/fail badges. |
| **Read (Detail)** | Student reviews past code submission and test output | `prototype/attempt-result.html` | `GET /api/attempts/:id` | `SELECT * FROM ATTEMPT WHERE Attempt_ID = ?` | Ensures student can only inspect their own submission. |
| **Update** | Instructor manually overrides score or regrades | `prototype/admin-attempt-grade.html` | `PUT /api/attempts/:id` | `UPDATE ATTEMPT SET Score = ?, Is_Correct = ? WHERE Attempt_ID = ?` | Restricted to Instructor/Admin role. |
| **Delete** | Admin purges test/demo attempt record | `prototype/admin-attempts.html` | `DELETE /api/attempts/:id` | `DELETE FROM ATTEMPT WHERE Attempt_ID = ?` | Admin only; prevents score tampering. |

---

## 12. Entity: `STUDENT_LEVEL_PROGRESS` (Gamified Level Tracking)

| Operation | User Action | UI Screen | HTTP Method & Route | Target DB Query | Notes / Validation |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Create** | System unlocks Level 1 upon registration or unlocks next level | System trigger | `POST /api/progress` | `INSERT INTO STUDENT_LEVEL_PROGRESS (Student_ID, Level_ID, Progress_Status) VALUES (?, ?, 'unlocked')` | Prevents duplicate records for the same student-level pair. |
| **Read (List)** | Level map renders locks, active stars, and badges | `prototype/level-map.html` | `GET /api/students/:student_id/progress` | `SELECT * FROM STUDENT_LEVEL_PROGRESS WHERE Student_ID = ?` | Determines which levels are clickable and playable. |
| **Read (Detail)** | Level gatekeeper verifies student access | `prototype/level-intro.html` | `GET /api/students/:student_id/progress/:level_id` | `SELECT * FROM STUDENT_LEVEL_PROGRESS WHERE Student_ID = ? AND Level_ID = ?` | Verifies progress is not 'locked' before serving level content. |
| **Update** | Student completes all challenges in level; marks complete | System trigger on level finish | `PUT /api/progress/:id` | `UPDATE STUDENT_LEVEL_PROGRESS SET Progress_Status = 'completed', Completed_At = CURRENT_TIMESTAMP WHERE Progress_ID = ?` | Status changes to 'completed'; triggers reward point accumulation. |
| **Delete** | Instructor resets level progression for student retake | `prototype/admin-progress.html` | `DELETE /api/progress/:id` | `DELETE FROM STUDENT_LEVEL_PROGRESS WHERE Progress_ID = ?` | Resets level back to locked state. |

---

## 13. Entity: `STUDENT_REWARD` (Earned Achievements)

| Operation | User Action | UI Screen | HTTP Method & Route | Target DB Query | Notes / Validation |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Create** | System awards achievement when student reaches required points | Automated point evaluation | `POST /api/student-rewards` | `INSERT INTO STUDENT_REWARD (Student_ID, Reward_ID) VALUES (?, ?)` | Unique constraint check to prevent duplicate reward grants. |
| **Read (List)** | Student checks trophy case in profile | `prototype/profile.html` | `GET /api/students/:student_id/rewards` | `SELECT sr.*, r.Reward_Name, r.Reward_Description FROM STUDENT_REWARD sr JOIN REWARD r ON sr.Reward_ID = r.Reward_ID WHERE sr.Student_ID = ? ORDER BY sr.Earned_At DESC` | Displays earned badges with unlock dates. |
| **Read (Detail)** | Student views badge certificate popup | `prototype/reward-popup.html` | `GET /api/student-rewards/:id` | `SELECT sr.*, r.Reward_Name, r.Reward_Description FROM STUDENT_REWARD sr JOIN REWARD r ON sr.Reward_ID = r.Reward_ID WHERE sr.Student_Reward_ID = ?` | Displays high-resolution badge artwork and date earned. |
| **Update** | Admin amends award timestamp or badge tier | `prototype/admin-rewards.html` | `PUT /api/student-rewards/:id` | `UPDATE STUDENT_REWARD SET Earned_At = ? WHERE Student_Reward_ID = ?` | Administrative audit adjustments only. |
| **Delete** | Admin revokes an illegitimate or test achievement | `prototype/admin-rewards.html` | `DELETE /api/student-rewards/:id` | `DELETE FROM STUDENT_REWARD WHERE Student_Reward_ID = ?` | Revokes reward from student profile. |

---

## Form Fields for the Two Most Important Tables

Below are the form field definitions for the two most critical tables in the system:
1. **`STUDENT`** (Student Account Registration & Profile Form)
2. **`CHALLENGE`** (Challenge Builder & Assignment Management Form)

### 1. `STUDENT` Table Form Fields (Registration / Account Form)
*Format: `column name → form control → required?`*

- `Student_ID` → Hidden input (`<input type="hidden">`) / Auto-generated → No
- `First_Name` → Text input (`<input type="text">`) → Required
- `Last_Name` → Text input (`<input type="text">`) → Required
- `Email` → Email input (`<input type="email">`) → Required
- `Password_Hash` → Password input (`<input type="password">`) → Required
- `Program` → Dropdown select (`<select>`) → Required
- `Year_Level` → Dropdown select (`<select>`) → Required
- `Role` → Radio buttons / Dropdown (`<select>`) → Required (Defaults to 'student')
- `Created_At` → System generated timestamp → No (Automatic)

| Column Name | Form Control | Required? | Validation / Options |
| :--- | :--- | :--- | :--- |
| `Student_ID` | `<input type="hidden">` | No | Auto-generated by database (`AUTO_INCREMENT`) |
| `First_Name` | `<input type="text" name="first_name">` | **Yes** | Max 30 chars, alphabetic characters & spaces |
| `Last_Name` | `<input type="text" name="last_name">` | **Yes** | Max 30 chars, alphabetic characters & spaces |
| `Email` | `<input type="email" name="email">` | **Yes** | Valid university email address (`@my.parsu.edu.ph`), unique |
| `Password_Hash` | `<input type="password" name="password">` | **Yes** | Min 8 chars, hashed via bcrypt before DB write |
| `Program` | `<select name="program">` | **Yes** | Options: `BSIT`, `BSCS`, `BSIS`, `BSEMC` |
| `Year_Level` | `<select name="year_level">` | **Yes** | Options: `1st Year`, `2nd Year`, `3rd Year`, `4th Year` |
| `Role` | `<select name="role">` | **Yes** | Options: `student`, `instructor`, `admin` (defaults to `student`) |
| `Created_At` | None (System timestamp) | No | Auto-populated by `DEFAULT CURRENT_TIMESTAMP` |

---

### 2. `CHALLENGE` Table Form Fields (Challenge Authoring Form)
*Format: `column name → form control → required?`*

- `Challenge_ID` → Hidden input (`<input type="hidden">`) / Auto-generated → No
- `Level_ID` → Dropdown select (`<select>`) → Required
- `Challenge_Title` → Text input (`<input type="text">`) → Required
- `Challenge_Type` → Dropdown select (`<select>`) → Required
- `Instructions` → Textarea / Rich text editor (`<textarea>`) → Required
- `Max_Points` → Number input (`<input type="number">`) → Required

| Column Name | Form Control | Required? | Validation / Options |
| :--- | :--- | :--- | :--- |
| `Challenge_ID` | `<input type="hidden">` | No | Auto-generated by database (`AUTO_INCREMENT`) |
| `Level_ID` | `<select name="level_id">` | **Yes** | Populated dynamically from `GAME_LEVEL` table |
| `Challenge_Title` | `<input type="text" name="challenge_title">` | **Yes** | Max 30 characters, descriptive title |
| `Challenge_Type` | `<select name="challenge_type">` | **Yes** | Options: `Puzzle`, `Coding`, `Quiz` |
| `Instructions` | `<textarea name="instructions">` | **Yes** | Markdown or rich text with problem constraints & rules |
| `Max_Points` | `<input type="number" name="max_points">` | **Yes** | Integer between 10 and 1000 (default: 100) |

*(Note: Companion submission form for student attempts on `ATTEMPT`: `Submitted_Answer` → Code editor / Textarea → Required; `Challenge_ID` → Hidden input → Required; `Score` and `Is_Correct` → Evaluator system).*

---

## Schema changes

The following schema adjustments were planned and incorporated into [`database/schema.sql`](../database/schema.sql) during prototype and application workflow development:

1. **Added `AUTO_INCREMENT` to all Primary Key IDs across all 13 tables:**
   - **Tables affected:** `STUDENT`, `DSA_TOPIC`, `REWARD`, `LEARNING_MODULE`, `GAME_LEVEL`, `CHALLENGE`, `PUZZLE`, `CODING_CHALLENGE`, `ALGORITHM`, `VISUALIZATION_STEP`, `ATTEMPT`, `STUDENT_LEVEL_PROGRESS`, `STUDENT_REWARD`.
   - **Why:** The original schema used bare `INT PRIMARY KEY` types without automatic sequencing. In a dynamic web application, forms submitting `POST` requests cannot manually compute consecutive IDs without concurrency collisions. Adding `AUTO_INCREMENT` allows MySQL to assign surrogate keys automatically upon insertion.

2. **Added `Role` column to `STUDENT` table:**
   - **Definition:** `Role VARCHAR(20) DEFAULT 'student'`
   - **Why:** `docs/01-brief.md` specifies two distinct user roles: *Students* (who play challenges, browse modules, and earn rewards) and *Admin / Instructors* (who create content and review attempts). Storing the user's role enables role-based access control (RBAC) across the web application.

3. **Added `DEFAULT CURRENT_TIMESTAMP` to DateTime columns:**
   - **Columns affected:** `STUDENT.Created_At`, `ATTEMPT.Attempted_At`, `STUDENT_LEVEL_PROGRESS.Unlocked_At`, and `STUDENT_REWARD.Earned_At`.
   - **Why:** Ensures timestamps are recorded automatically by the database engine at the exact moment of insertion, eliminating boilerplate date calculations in client-side form submissions.

4. **Added `ON DELETE CASCADE` foreign key actions:**
   - **Foreign keys affected:** Module-to-Topic, Level-to-Module, Challenge-to-Level, Puzzle-to-Challenge, CodingChallenge-to-Challenge, Step-to-Algorithm, Attempt-to-Student/Challenge, Progress-to-Student/Level, and Reward-to-Student/Reward.
   - **Why:** Prevents orphaned child records in the database when an instructor deletes a topic, module, or level during content management.

5. **Renamed conceptual `Password` to `Password_Hash VARCHAR(255)`:**
   - **Definition:** `Password_Hash VARCHAR(255) NOT NULL`
   - **Why:** Secure password hashing standards (e.g. bcrypt, Argon2) produce hashes requiring 60+ characters. Expanding the column from short text to `VARCHAR(255)` ensures hashes are never truncated and enforces modern password security best practices.
