CREATE DATABASE IF NOT EXISTS giladsa_db;
USE giladsa_db;

-- =============================================================================
-- DROP TABLES (Reverse dependency order for clean re-execution)
-- =============================================================================
DROP TABLE IF EXISTS STUDENT_REWARD;
DROP TABLE IF EXISTS STUDENT_LEVEL_PROGRESS;
DROP TABLE IF EXISTS ATTEMPT;
DROP TABLE IF EXISTS VISUALIZATION_STEP;
DROP TABLE IF EXISTS ALGORITHM;
DROP TABLE IF EXISTS CODING_CHALLENGE;
DROP TABLE IF EXISTS PUZZLE;
DROP TABLE IF EXISTS CHALLENGE;
DROP TABLE IF EXISTS GAME_LEVEL;
DROP TABLE IF EXISTS LEARNING_MODULE;
DROP TABLE IF EXISTS REWARD;
DROP TABLE IF EXISTS DSA_TOPIC;
DROP TABLE IF EXISTS STUDENT;

-- =========================================
-- 1. STUDENT
-- =========================================
CREATE TABLE STUDENT (
    Student_ID INT AUTO_INCREMENT PRIMARY KEY,
    First_Name VARCHAR(30) NOT NULL,
    Last_Name VARCHAR(30) NOT NULL,
    Email VARCHAR(50) NOT NULL UNIQUE,
    Password_Hash VARCHAR(255) NOT NULL,  -- kept long: hashes (e.g. bcrypt) need 60+ characters
    Program VARCHAR(30) NOT NULL,
    Year_Level VARCHAR(20) NOT NULL,
    Role VARCHAR(20) DEFAULT 'student',  -- 'student', 'instructor', 'admin'
    Created_At DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- =========================================
-- 2. DSA_TOPIC
-- =========================================
CREATE TABLE DSA_TOPIC (
    Topic_ID INT AUTO_INCREMENT PRIMARY KEY,
    Topic_Name VARCHAR(30) NOT NULL,
    Topic_Description TEXT,
    Topic_Category VARCHAR(30)
) ENGINE=InnoDB;

-- =========================================
-- 3. REWARD
-- =========================================
CREATE TABLE REWARD (
    Reward_ID INT AUTO_INCREMENT PRIMARY KEY,
    Reward_Name VARCHAR(30) NOT NULL,
    Reward_Description TEXT,
    Points_Required INT NOT NULL DEFAULT 0
) ENGINE=InnoDB;

-- =========================================
-- 4. LEARNING_MODULE
-- =========================================
CREATE TABLE LEARNING_MODULE (
    Module_ID INT AUTO_INCREMENT PRIMARY KEY,
    Topic_ID INT NOT NULL,
    Module_Title VARCHAR(30) NOT NULL,
    Module_Description TEXT,
    Module_Order INT NOT NULL DEFAULT 1,

    CONSTRAINT FK_MODULE_TOPIC
        FOREIGN KEY (Topic_ID)
        REFERENCES DSA_TOPIC(Topic_ID)
        ON DELETE CASCADE
) ENGINE=InnoDB;

-- =========================================
-- 5. GAME_LEVEL
-- =========================================
CREATE TABLE GAME_LEVEL (
    Level_ID INT AUTO_INCREMENT PRIMARY KEY,
    Module_ID INT NOT NULL,
    Level_Number INT NOT NULL,
    Level_Title VARCHAR(30) NOT NULL,
    Difficulty VARCHAR(20) DEFAULT 'Easy',

    CONSTRAINT FK_LEVEL_MODULE
        FOREIGN KEY (Module_ID)
        REFERENCES LEARNING_MODULE(Module_ID)
        ON DELETE CASCADE
) ENGINE=InnoDB;

-- =========================================
-- 6. CHALLENGE
-- =========================================
CREATE TABLE CHALLENGE (
    Challenge_ID INT AUTO_INCREMENT PRIMARY KEY,
    Level_ID INT NOT NULL,
    Challenge_Title VARCHAR(30) NOT NULL,
    Challenge_Type VARCHAR(30) NOT NULL,  -- 'Puzzle', 'Coding', 'Quiz'
    Instructions TEXT,
    Max_Points INT NOT NULL DEFAULT 100,

    CONSTRAINT FK_CHALLENGE_LEVEL
        FOREIGN KEY (Level_ID)
        REFERENCES GAME_LEVEL(Level_ID)
        ON DELETE CASCADE
) ENGINE=InnoDB;

-- =========================================
-- 7. PUZZLE
-- =========================================
CREATE TABLE PUZZLE (
    Puzzle_ID INT AUTO_INCREMENT PRIMARY KEY,
    Challenge_ID INT NOT NULL UNIQUE,
    Puzzle_Type VARCHAR(30) NOT NULL,
    Puzzle_Data TEXT NOT NULL,
    Correct_Answer TEXT NOT NULL,

    CONSTRAINT FK_PUZZLE_CHALLENGE
        FOREIGN KEY (Challenge_ID)
        REFERENCES CHALLENGE(Challenge_ID)
        ON DELETE CASCADE
) ENGINE=InnoDB;

-- =========================================
-- 8. CODING_CHALLENGE
-- =========================================
CREATE TABLE CODING_CHALLENGE (
    Coding_Challenge_ID INT AUTO_INCREMENT PRIMARY KEY,
    Challenge_ID INT NOT NULL UNIQUE,
    Problem_Statement TEXT NOT NULL,
    Starter_Code TEXT,
    Expected_Output TEXT,
    Programming_Language VARCHAR(30) DEFAULT 'Python',

    CONSTRAINT FK_CODING_CHALLENGE
        FOREIGN KEY (Challenge_ID)
        REFERENCES CHALLENGE(Challenge_ID)
        ON DELETE CASCADE
) ENGINE=InnoDB;

-- =========================================
-- 9. ALGORITHM
-- =========================================
CREATE TABLE ALGORITHM (
    Algorithm_ID INT AUTO_INCREMENT PRIMARY KEY,
    Topic_ID INT NOT NULL,
    Algorithm_Name VARCHAR(30) NOT NULL,
    Algorithm_Description TEXT,
    Pseudocode TEXT,

    CONSTRAINT FK_ALGORITHM_TOPIC
        FOREIGN KEY (Topic_ID)
        REFERENCES DSA_TOPIC(Topic_ID)
        ON DELETE CASCADE
) ENGINE=InnoDB;

-- =========================================
-- 10. VISUALIZATION_STEP
-- =========================================
CREATE TABLE VISUALIZATION_STEP (
    Step_ID INT AUTO_INCREMENT PRIMARY KEY,
    Algorithm_ID INT NOT NULL,
    Step_Number INT NOT NULL,
    Step_Explanation TEXT NOT NULL,
    State_Data TEXT NOT NULL,

    CONSTRAINT FK_STEP_ALGORITHM
        FOREIGN KEY (Algorithm_ID)
        REFERENCES ALGORITHM(Algorithm_ID)
        ON DELETE CASCADE
) ENGINE=InnoDB;

-- =========================================
-- 11. ATTEMPT
-- =========================================
CREATE TABLE ATTEMPT (
    Attempt_ID INT AUTO_INCREMENT PRIMARY KEY,
    Student_ID INT NOT NULL,
    Challenge_ID INT NOT NULL,
    Submitted_Answer TEXT,
    Score DECIMAL(5,2) DEFAULT 0.00,
    Is_Correct BOOLEAN DEFAULT FALSE,
    Attempted_At DATETIME DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT FK_ATTEMPT_STUDENT
        FOREIGN KEY (Student_ID)
        REFERENCES STUDENT(Student_ID)
        ON DELETE CASCADE,

    CONSTRAINT FK_ATTEMPT_CHALLENGE
        FOREIGN KEY (Challenge_ID)
        REFERENCES CHALLENGE(Challenge_ID)
        ON DELETE CASCADE
) ENGINE=InnoDB;

-- =========================================
-- 12. STUDENT_LEVEL_PROGRESS
-- =========================================
CREATE TABLE STUDENT_LEVEL_PROGRESS (
    Progress_ID INT AUTO_INCREMENT PRIMARY KEY,
    Student_ID INT NOT NULL,
    Level_ID INT NOT NULL,
    Progress_Status VARCHAR(20) DEFAULT 'unlocked',  -- 'unlocked', 'in_progress', 'completed'
    Unlocked_At DATETIME DEFAULT CURRENT_TIMESTAMP,
    Completed_At DATETIME NULL,

    CONSTRAINT FK_PROGRESS_STUDENT
        FOREIGN KEY (Student_ID)
        REFERENCES STUDENT(Student_ID)
        ON DELETE CASCADE,

    CONSTRAINT FK_PROGRESS_LEVEL
        FOREIGN KEY (Level_ID)
        REFERENCES GAME_LEVEL(Level_ID)
        ON DELETE CASCADE
) ENGINE=InnoDB;

-- =========================================
-- 13. STUDENT_REWARD
-- =========================================
CREATE TABLE STUDENT_REWARD (
    Student_Reward_ID INT AUTO_INCREMENT PRIMARY KEY,
    Student_ID INT NOT NULL,
    Reward_ID INT NOT NULL,
    Earned_At DATETIME DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT FK_STUDENT_REWARD_STUDENT
        FOREIGN KEY (Student_ID)
        REFERENCES STUDENT(Student_ID)
        ON DELETE CASCADE,

    CONSTRAINT FK_STUDENT_REWARD_REWARD
        FOREIGN KEY (Reward_ID)
        REFERENCES REWARD(Reward_ID)
        ON DELETE CASCADE
) ENGINE=InnoDB;
