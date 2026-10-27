-- ====================================================================
-- Campus Event & Student Activity Management Portal
-- Database Schema for XAMPP MySQL (phpMyAdmin)
-- Total Lines: ~35 lines
-- ====================================================================

CREATE DATABASE IF NOT EXISTS campusevent_db;
USE campusevent_db;

-- 1. Users Table (Students & Administrators)
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    role VARCHAR(20) NOT NULL DEFAULT 'STUDENT',
    roll_no VARCHAR(30),
    department VARCHAR(80)
);

-- 2. Events Table
CREATE TABLE IF NOT EXISTS events (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    category VARCHAR(50) NOT NULL,
    venue VARCHAR(120) NOT NULL,
    event_date DATE NOT NULL,
    event_time VARCHAR(20) NOT NULL,
    capacity INT NOT NULL DEFAULT 50,
    registered_count INT NOT NULL DEFAULT 0
);

-- 3. Registrations Table
CREATE TABLE IF NOT EXISTS registrations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    event_id INT NOT NULL,
    reg_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY unique_user_event (user_id, event_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE CASCADE
);

-- Pre-seeded Sample Data
INSERT IGNORE INTO users (id, name, email, password, role, roll_no, department) VALUES
(1, 'Dean Student Welfare', 'admin@cu.edu.in', 'admin123', 'ADMIN', 'ADM-01', 'Administration'),
(2, 'Arpit Sharma', 'arpit@cu.edu.in', 'student123', 'STUDENT', '23MCA1001', 'MCA Data Science'),
(3, 'Priya Verma', 'priya@cu.edu.in', 'student123', 'STUDENT', '23MCA1042', 'MCA AI');

INSERT IGNORE INTO events (id, title, category, venue, event_date, event_time, capacity, registered_count) VALUES
(1, 'CU TechFest: AI & Cloud Hackathon', 'Technical', 'Seminar Hall 3, Block 4', '2026-11-15', '10:00 AM', 100, 1),
(2, 'Rhythm: Annual Inter-Dept Cultural Fest', 'Cultural', 'Main Auditorium', '2026-11-20', '05:00 PM', 300, 1),
(3, 'Big Data Analytics with Apache Spark', 'Workshop', 'Lab 12, Block 3', '2026-11-25', '11:00 AM', 50, 0),
(4, 'CU Inter-Department Football Cup', 'Sports', 'Sports Complex Ground', '2026-12-02', '09:00 AM', 80, 0);

INSERT IGNORE INTO registrations (user_id, event_id) VALUES (2, 1), (3, 2);
