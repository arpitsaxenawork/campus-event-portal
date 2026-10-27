# 🎓 University Campus Event & Student Activity Management Portal

[![Java](https://img.shields.io/badge/Java-ED8B00?style=for-the-badge&logo=openjdk&logoColor=white)](https://www.oracle.com/java/)
[![Jakarta EE](https://img.shields.io/badge/Jakarta%20EE%2010-F37024?style=for-the-badge&logo=jakartaee&logoColor=white)](https://jakarta.ee/)
[![Apache Tomcat](https://img.shields.io/badge/Apache%20Tomcat%2010%2B-F8DC75?style=for-the-badge&logo=apachetomcat&logoColor=black)](https://tomcat.apache.org/)
[![MySQL](https://img.shields.io/badge/MySQL%208.x-4479A1?style=for-the-badge&logo=mysql&logoColor=white)](https://www.mysql.com/)
[![Apache NetBeans](https://img.shields.io/badge/Apache%20NetBeans-1B6AC6?style=for-the-badge&logo=apache&logoColor=white)](https://netbeans.apache.org/)
[![Maven](https://img.shields.io/badge/Maven%203.x-C71A36?style=for-the-badge&logo=apachemaven&logoColor=white)](https://maven.apache.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](LICENSE)

An enterprise-grade, lightweight **Full-Stack Java Web Application** for managing university campus events, student activity registrations, capacity limits, and digital ticket issuance. Built following the **Model-View-Controller (MVC Model 2)** architecture pattern with **Jakarta Servlets**, **JavaServer Pages (JSP)**, **JDBC**, and **MySQL (XAMPP)**.

Developed as a capstone project for **Advanced Internet Programming (AIP)**, **Master of Computer Applications (MCA 1st Semester)** at **Chandigarh University**.

---

## 📑 Table of Contents

- [Overview & Key Features](#-overview--key-features)
- [System Architecture (MVC Model 2)](#-system-architecture-mvc-model-2)
- [Tech Stack](#-tech-stack)
- [Project Directory Structure](#-project-directory-structure)
- [Prerequisites](#-prerequisites)
- [Step-by-Step Setup Guide](#-step-by-step-setup-guide)
  - [1. Database Configuration (XAMPP / phpMyAdmin)](#1-database-configuration-xampp--phpmyadmin)
  - [2. Open & Configure Project in Apache NetBeans](#2-open--configure-project-in-apache-netbeans)
  - [3. Deploy & Run](#3-deploy--run)
- [Demo Test Accounts](#-demo-test-accounts)
- [Database Schema](#-database-schema)
- [Academic Case Study & Viva Guide](#-academic-case-study--viva-guide)
- [Clone & Run Locally](#-clone--run-locally)
- [License](#-license)

---

## ✨ Overview & Key Features

### 👨‍🎓 Student Module
- **Public Event Explorer:** Browse campus events with dynamic category filtering (`All`, `Technical`, `Cultural`, `Workshop`, `Sports`).
- **Interactive Registration:** Single-click atomic seat reservation with real-time seat availability decrement.
- **Personalized Student Dashboard:** View enrolled events, schedules, and venues.
- **Booking Cancellation:** Free up seats atomically for other students with one click.
- **Digital E-Ticket Pass:** Generate and print admission passes directly with student credentials.

### 🛡️ Administrator Module
- **Event Lifecycle Management (CRUD):** Create, update, and delete campus events with defined capacity limits.
- **Live Capacity Tracking:** Monitor registered students vs. total capacity in real time.
- **Attendee Roster:** Access real-time student attendee lists for each event.
- **Direct Event Cancellation:** Safely remove events with automated cascading relationship updates.

### 🔒 Security & Robustness
- **Session-Based Authentication:** Protected student and admin portals using `HttpSession`.
- **SQL Injection Prevention:** 100% parameterized queries via JDBC `PreparedStatement`.
- **Client & Server-Side Validation:** Dual-layer validation for emails, passwords, and form inputs.
- **Failover Connection:** `DBUtil` includes automatic failover for local MySQL authentication.

---

## 🏛️ System Architecture (MVC Model 2)

```
┌─────────────────────────────────────────────────────────────┐
│                       Client Browser                        │
│          (HTML5, Modern CSS3, JavaScript Validation)        │
└──────────────────────────────▲──────────────────────────────┘
                               │ HTTP Request / Response
                               ▼
┌─────────────────────────────────────────────────────────────┐
│             Apache Tomcat 10+ Web Container                 │
│                                                             │
│   ┌─────────────────────────────────────────────────────┐   │
│   │               Controller (Jakarta Servlet)          │   │
│   │                  PortalServlet.java                 │   │
│   │    • Authentication & Session Management            │   │
│   │    • Event CRUD & Booking Logic                     │   │
│   │    • Request Routing & Error Handling               │   │
│   └──────────────────────┬───────────────▲──────────────┘   │
│                          │               │                  │
│       Forward to View    │               │  Data Transfer   │
│                          ▼               │                  │
│   ┌──────────────────────────────┐ ┌─────┴──────────────┐   │
│   │          View (JSP)          │ │  Model / Data Tier │   │
│   │  • index.jsp (Catalog)       │ │  • DBUtil.java     │   │
│   │  • login.jsp (Auth)          │ │  • JDBC Drivers    │   │
│   │  • dashboard.jsp (Student)   │ └─────────┬──────────┘   │
│   │  • admin.jsp (Admin Portal)  │           │              │
│   └──────────────────────────────┘           │              │
└──────────────────────────────────────────────┼──────────────┘
                                               │ JDBC (Port 3306)
                                               ▼
                         ┌───────────────────────────┐
                         │    MySQL / MariaDB        │
                         │   (campusevent_db)        │
                         │ • users                   │
                         │ • events                  │
                         │ • registrations           │
                         └───────────────────────────┘
```

---

## 🛠️ Tech Stack

| Layer | Technology | Details |
| :--- | :--- | :--- |
| **Language** | Java (JDK 17+) | Core backend logic & business workflows |
| **Server Engine** | Jakarta Servlet 6.0, JSP 3.1 | MVC Controller & dynamic presentation |
| **Web Server** | Apache Tomcat 10.1+ | Servlet & JSP container |
| **Build Tool** | Apache Maven 3.x | Dependency management & packaging (`.war`) |
| **IDE** | Apache NetBeans 18+ / 21+ | Native Java EE & Tomcat project integration |
| **Database** | MySQL 8.x / MariaDB (XAMPP) | Relational storage with foreign key constraints |
| **Connectivity**| JDBC (`mysql-connector-j-8.2.0`) | PreparedStatement connections & transactions |
| **Frontend** | HTML5, CSS3, JavaScript | Responsive card layout, badge design & client validation |

---

## 📂 Project Directory Structure

```
campus-event-portal/
├── .gitattributes             # Cross-platform line ending normalization
├── .gitignore                # Git ignore rules for Maven, NetBeans, Tomcat
├── LICENSE                   # MIT open-source license
├── README.md                 # Project documentation & setup guide
├── nb-configuration.xml      # NetBeans IDE deployment configurations
├── pom.xml                   # Maven dependencies (Servlet, JSP, MySQL driver)
│
├── database/
│   └── schema.sql            # MySQL database schema & pre-seeded demo records
│
├── docs/
│   └── CASE_STUDY_REPORT.md  # Comprehensive academic case study & viva guide
│
├── src/
│   └── java/
│       └── com/
│           └── campusevent/
│               ├── DBUtil.java         # JDBC Connection Manager with failover
│               └── PortalServlet.java  # Main MVC Controller Servlet
│
└── web/
    ├── META-INF/
    │   └── context.xml       # Tomcat context root configuration
    ├── WEB-INF/
    │   └── web.xml           # Deployment descriptor & session timeout
    ├── css/
    │   └── style.css         # Modern, responsive UI stylesheet
    ├── js/
    │   └── validation.js     # Form validation & quick-fill demo helpers
    ├── admin.jsp             # Admin control panel & attendee roster
    ├── dashboard.jsp         # Student dashboard & printable pass
    ├── index.jsp             # Public landing page & event browser
    └── login.jsp             # Dual student/admin authentication page
```

---

## ⚙️ Prerequisites

Before running the project, ensure you have the following installed on your machine:

1. **Java Development Kit (JDK):** Version 17 or higher ([Download JDK](https://www.oracle.com/java/technologies/downloads/)).
2. **XAMPP:** Apache + MySQL ([Download XAMPP](https://www.apachefriends.org/)).
3. **Apache NetBeans:** Version 18, 19, 20, or 21 ([Download NetBeans](https://netbeans.apache.org/download/)).
4. **Apache Tomcat:** Version 10.1.x or higher (configured inside NetBeans).

---

## 🚀 Step-by-Step Setup Guide

### 1. Database Configuration (XAMPP / phpMyAdmin)
1. Start the **XAMPP Control Panel**.
2. Click **Start** for both **Apache** and **MySQL**.
3. Open your browser and navigate to: `http://localhost/phpmyadmin/`.
4. Click the **SQL** tab at the top navigation bar.
5. Open [`database/schema.sql`](database/schema.sql), copy its entire content, paste it into the SQL window, and click **Go**.
   > *This automatically creates `campusevent_db` and seeds sample users, events, and bookings.*

> **Note on MySQL Credentials:**  
> The application uses default XAMPP credentials (`user: root`, `password: ""` on `localhost:3306`). If your MySQL server has a root password, [`DBUtil.java`](src/java/com/campusevent/DBUtil.java) includes an automatic fallback or you can update the `PASS` constant.

---

### 2. Open & Configure Project in Apache NetBeans
1. Launch **Apache NetBeans**.
2. Go to **File ➔ Open Project...**
3. Browse to and select the `campus-event-portal` folder. NetBeans will detect it as a Maven Web Application.
4. **Configure Tomcat Server (if not already set):**
   - In NetBeans, open the **Services** tab (Window ➔ Services).
   - Right-click **Servers ➔ Add Server...**
   - Select **Apache Tomcat or TomEE**, specify your Tomcat 10+ directory, and finish.
   - Right-click the project ➔ **Properties ➔ Run** ➔ Verify **Server** is set to **Apache Tomcat**.

---

### 3. Deploy & Run
1. Right-click the project in NetBeans and select **Clean and Build**.
2. Click the green **Run Project** button (or press **F6**).
3. NetBeans will package the `.war`, deploy to Tomcat, and open the application in your browser:
   ```
   http://localhost:8080/CampusEventPortal/
   ```

---

## 👥 Demo Test Accounts

The database comes pre-seeded with accounts for testing student and administrator roles:

| Role | Email Address | Password | Privileges / Features to Test |
| :--- | :--- | :--- | :--- |
| **Administrator** | `admin@cu.edu.in` | `admin123` | Create new events, delete events, inspect attendee rosters. |
| **Student 1** | `arpit@cu.edu.in` | `student123` | View enrolled events, book new events, cancel bookings, view pass. |
| **Student 2** | `priya@cu.edu.in` | `student123` | Browse events, test seat booking and duplicate booking prevention. |

> 💡 *Tip: On the `login.jsp` page, you can click the quick-fill links ("Fill Admin Credentials" or "Fill Student Credentials") to instantly populate the login form for testing!*

---

## 🗄️ Database Schema

The database consists of three normalized relational tables:

```
users (id PK, name, email UNIQUE, password, role, roll_no, department)
   │
   ├──< registrations (id PK, user_id FK, event_id FK, reg_date)
   │
events (id PK, title, category, venue, event_date, event_time, capacity, registered_count)
```

- **`users` Table:** Stores administrator and student profiles with department and roll numbers.
- **`events` Table:** Stores event details, scheduled dates, venue, total capacity, and registered counter.
- **`registrations` Table:** Junction table tracking student event enrollments with `UNIQUE (user_id, event_id)` constraint preventing double-booking and `ON DELETE CASCADE` maintaining referential integrity.

---

## 📚 Academic Case Study & Viva Guide

A detailed 750+ line academic report is included in [`docs/CASE_STUDY_REPORT.md`](docs/CASE_STUDY_REPORT.md). It contains:
- Complete **System Requirements Specification (SRS)**
- **DFD Level 0 & Level 1 Diagrams**
- **Use Case Diagrams & ER Modeling**
- **Testing Matrix & Test Cases**
- **Viva-Voce Questions & In-Depth Technical Answers** on Servlet lifecycle, JSP translation, JDBC connection pooling, and session tracking.

---

## 📥 Clone & Run Locally

To clone and set up this project locally:

```bash
git clone https://github.com/arpitsaxenawork/campus-event-portal.git
cd campus-event-portal
```

Then follow the [Step-by-Step Setup Guide](#-step-by-step-setup-guide) above to import the database into XAMPP and run the project in Apache NetBeans.

---

## 📄 License

This project is licensed under the [MIT License](LICENSE) - open for educational and academic use.

---

<p align="center">
  <b>Chandigarh University &bull; MCA 1st Semester &bull; Advanced Internet Programming (AIP)</b>
</p>
