<div align="center">

# 🏢 Human Resource Management System (HRMS)

### Enterprise Human Resource Management Platform

**Flutter • Laravel • Docker • Render • Aiven MySQL**

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Laravel](https://img.shields.io/badge/Laravel-FF2D20?style=for-the-badge&logo=laravel&logoColor=white)
![PHP](https://img.shields.io/badge/PHP-777BB4?style=for-the-badge&logo=php&logoColor=white)
![MySQL](https://img.shields.io/badge/Aiven-MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Render](https://img.shields.io/badge/Render-46E3B7?style=for-the-badge&logo=render&logoColor=black)
![REST API](https://img.shields.io/badge/REST-API-009688?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-Production%20Ready-success?style=for-the-badge)

</div>

---

## 📌 Overview

The **Human Resource Management System (HRMS)** is a modern full-stack enterprise application designed to digitize and streamline day-to-day human resource operations through a secure, scalable, and API-driven architecture.

Built using **Laravel**, **Flutter**, and **MySQL**, the platform provides dedicated **Admin** and **Employee** workflows for authentication, employee lifecycle management, attendance tracking, leave management, payroll administration, departmental organization, and role-based dashboard analytics.

Unlike traditional monolithic HR solutions, HRMS follows a **mobile-first client-server architecture**, where Flutter applications communicate with a production-deployed Laravel REST API over HTTPS. This separation of concerns enables scalability, maintainability, and future expansion to additional platforms such as Flutter Web without changing the backend.

The project demonstrates practical implementation of modern software engineering concepts including RESTful API development, role-based authorization, secure authentication with Laravel Sanctum, cloud database integration, Docker-based deployment, and production hosting on Render.

---

## 🔗 Project Resources

| Resource | Status |
|----------|--------|
| 🌐 Backend API | Production Live |
| 🔌 REST API | Available |
| 📱 Android APK | Available in GitHub Releases |
| 🌍 Flutter Web Admin Portal | 🚧 In Development |

## 🏗️ System Architecture

```text
                         Flutter Ecosystem

                  Android           iOS
                      │              │
                      └──────┬───────┘
                             │
                 HTTPS REST API + JSON
                             │
                             ▼
      ┌─────────────────────────────────────────┐
      │      Laravel 12 REST Backend            │
      │                                         │
      │  • Authentication (Sanctum)             │
      │  • Business Logic                       │
      │  • Role-Based Authorization             │
      │  • REST API Endpoints                   │
      └──────────────────┬──────────────────────┘
                         │
                Dockerized Deployment
                         │
                         ▼
                 Render Cloud Platform
                         │
                         ▼
      ┌─────────────────────────────────────────┐
      │          Aiven Managed MySQL            │
      │                                         │
      │ Employees │ Attendance │ Leave          │
      │ Payroll   │ Departments │ Users         │
      └─────────────────────────────────────────┘
```

### ✨ Architectural Highlights

- RESTful API-first backend architecture
- Secure Laravel Sanctum authentication
- Role-based authorization for Admin and Employee workflows
- Production deployment on Render
- Managed cloud database using Aiven MySQL
- Dockerized backend deployment
- Mobile-first Flutter application
- Modular and scalable backend architecture
- Persistent session restoration
- Future-ready for Flutter Web integration

---

## 📈 Project Metrics

| Metric | Value |
|---------|------:|
| 👥 User Roles | 2 |
| 📦 Core Modules | 8 |
| 🔌 REST API Endpoints | 50+ |
| 📱 Flutter Screens | 30+ |
| 🗄 Database Tables | 10+ |
| ☁️ Deployment Platforms | 2 |
| 🔐 Authentication System | Laravel Sanctum |
| 🌐 Backend Status | Production Live |

---

# 🚀 Project Status

| Component | Status |
|------------|--------|
| Laravel Backend | ✅ Production Ready |
| REST API | ✅ Live |
| Flutter Android Application | ✅ Completed |
| Flutter iOS Support | ✅ Completed |
| Authentication & Authorization | ✅ Completed |
| Employee Management | ✅ Completed |
| Department Management | ✅ Completed |
| Attendance Management | ✅ Completed |
| Leave Management | ✅ Completed |
| Payroll Management | ✅ Completed |
| Dashboard Analytics | ✅ Completed |
| Session Restoration | ✅ Completed |
| API Integration | ✅ Completed |
| Docker Containerization | ✅ Completed |
| Cloud Database (Aiven MySQL) | ✅ Live |
| Backend Hosting (Render) | ✅ Live |
| HTTPS REST API | ✅ Live |
| Production Testing | ✅ Completed |
| Flutter Web Admin Portal | 🚧 Planned |

---

# ☁️ Live Deployment

The HRMS backend is deployed to a production cloud environment, enabling secure communication between the Flutter mobile application and the Laravel REST API over HTTPS. The deployment architecture is designed to be scalable, maintainable, and ready for future expansion to additional client platforms such as Flutter Web.

| Component | Details |
|-----------|---------|
| 🚀 Backend Hosting | Render Cloud Platform |
| 🗄️ Database | Aiven Managed MySQL |
| 🐳 Containerization | Docker |
| 🌐 API Architecture | RESTful API |
| 🔒 Authentication | Laravel Sanctum |
| 🔐 Communication Protocol | HTTPS |
| 📱 Client Platforms | Flutter Android & iOS |
| 🔄 Data Format | JSON |
| 📡 API Status | 🟢 Live |
| ☁️ Deployment Status | 🟢 Production Ready |

> The production deployment follows an API-first architecture where all client applications communicate with a centralized Laravel backend through secure HTTPS endpoints.

---

# 🏗️ Deployment Architecture

The application follows a modern cloud deployment pipeline, separating development, deployment, backend services, and cloud infrastructure for improved scalability and maintainability.

```text
                    👨‍💻 Developer
                          │
                          ▼
                 GitHub Repository
                          │
              Push / Commit Changes
                          │
                          ▼
                 Docker Container Build
                          │
                          ▼
                 Render Cloud Platform
                          │
          ┌───────────────┴───────────────┐
          │                               │
          ▼                               ▼
 Laravel REST API                 Background Services
 Authentication                   Business Logic
 Authorization                    REST Endpoints
                          │
                          ▼
                Aiven Managed MySQL
                          │
                          ▼
          ┌───────────────┴───────────────┐
          │                               │
          ▼                               ▼
      Flutter Android                Flutter iOS
      Mobile Client                  Mobile Client
                          │
                 HTTPS + JSON REST APIs
```

### 🔄 Request Flow

```text
Flutter Mobile
      │
HTTPS Request
      │
      ▼
Render (Laravel REST API)
      │
Business Logic
      │
      ▼
Aiven MySQL
      │
Database Response
      │
      ▼
JSON Response
      │
      ▼
Flutter Mobile
```

### ✨ Deployment Highlights

- Dockerized Laravel backend
- Production deployment on Render
- Managed cloud database using Aiven MySQL
- Secure HTTPS communication
- JSON-based REST APIs
- Token-based authentication using Laravel Sanctum
- Stateless API architecture
- Mobile-first cloud infrastructure
- Future-ready for Flutter Web integration

---

# ✨ Core Features

HRMS is designed as a complete enterprise HR platform that streamlines employee management through secure authentication, role-based access control, automated workflows, and a mobile-first architecture.

## 📦 Functional Modules

| Module | Description |
|---------|-------------|
| 🔐 Authentication | Secure login, registration, OTP verification, password management, and session restoration using Laravel Sanctum. |
| 👨‍💼 Employee Management | Complete employee lifecycle management including creation, updates, department assignment, and profile management. |
| 🏢 Department Management | Organize departments, assign employees, and maintain organizational structure. |
| 📅 Attendance Management | Employee check-in/check-out, attendance history, working-hour calculation, and attendance analytics. |
| 📝 Leave Management | Leave application, approval workflow, leave history, and status tracking. |
| 💰 Payroll Management | Salary computation, earnings, deductions, payroll records, and employee salary access. |
| 📊 Dashboards | Dedicated Admin and Employee dashboards with role-specific analytics and navigation. |
| 👤 Employee Profile | Secure profile management with authenticated access to employee information. |
| 🛡 Security | Token-based authentication, role-based authorization, protected APIs, and secure session management. |

---

## 🔐 Authentication & Session Management

Authentication is powered by **Laravel Sanctum**, providing secure token-based authentication and persistent session management for mobile clients.

### Features

- User Registration
- Secure Login & Logout
- OTP Verification
- Email Verification Workflow
- Forgot Password
- Password Reset
- Change Password
- Personal Access Tokens
- Secure Password Hashing
- Role-Based Authentication
- Session Restoration
- Token Revocation
- Server-Side Session Validation

### Authentication Flow

```text
Application Launch
        │
        ▼
Retrieve Stored Token
        │
        ▼
GET /api/profile
        │
        ▼
Validate Sanctum Token
        │
        ▼
Determine User Role
        │
 ┌──────┴────────┐
 ▼               ▼
Admin         Employee
Dashboard     Dashboard
```

> Session restoration ensures authenticated users remain signed in securely until logout or token invalidation.

---

## 👨‍💼 Employee Management

The employee module enables administrators to manage the complete employee lifecycle through secure REST APIs.

### Capabilities

- Employee Registration
- Employee Listing
- Employee Details
- Update Employee Information
- Delete Employee
- Department Assignment
- Designation Management
- Employment Status Management
- Profile Management
- Administrator-Provisioned Employee Accounts

---

## 🏢 Department Management

The department module centralizes organizational structure and employee allocation.

### Capabilities

- Create Department
- View Departments
- Update Department
- Delete Department
- Department Codes
- Department Descriptions
- Employee Association

---

## 📅 Attendance Management

The attendance module provides real-time attendance monitoring for both employees and administrators.

### Employee

- Check-In
- Check-Out
- Attendance History
- Daily Status
- Working Hours
- Attendance Statistics

### Administrator

- Organization-wide Attendance
- Attendance Monitoring
- Employee Attendance Records
- Attendance History

### Automated Attendance Logic

- Late Arrival Detection
- Half-Day Detection
- Working Hour Calculation
- Attendance Status Generation

---

## 📝 Leave Management

The leave module implements a complete approval workflow between employees and administrators.

### Employee

- Apply Leave
- Select Leave Type
- Choose Leave Dates
- Submit Leave Reason
- View Leave History
- Track Leave Status

### Administrator

- Review Leave Requests
- Approve Leave
- Reject Leave
- Monitor Leave Status

### Leave Workflow

```text
Employee
     │
Submit Request
     │
Pending
     │
─────┼────────
     │
Approved
     │
Rejected
```

---

## 💰 Payroll Management

The payroll module enables administrators to manage salary records while allowing employees to securely access their payroll information.

### Administrator

- Create Payroll
- Update Payroll
- Salary Configuration
- Earnings Management
- Deductions Management
- Payroll Remarks
- Payment Status
- Payment Method

### Employee

- View Payroll
- Salary Details
- Gross Salary
- Net Salary
- Payment Status
- Payslip Information

### Payroll Formula

```text
Gross Salary
      =
Basic Salary
+ Allowances
+ Bonus
+ Overtime

Net Salary
      =
Gross Salary
− Tax
− Provident Fund
− Other Deductions
```

The backend prevents duplicate payroll records for the same employee and payroll period.

---

## 📊 Role-Based Dashboards

HRMS provides dedicated dashboards tailored to each user role.

### 👨‍💼 Administrator Dashboard

- Employee Analytics
- Department Overview
- Attendance Summary
- Leave Management
- Payroll Management
- Organization Statistics
- Administrative Navigation

### 👤 Employee Dashboard

- Personal Profile
- Attendance
- Leave Management
- Payroll
- Password Management
- Secure Logout

---

## 👤 Employee Profile

Employees can securely access and manage their personal information through authenticated APIs.

### Profile Information

- Employee ID
- Name
- Email
- Phone Number
- Department
- Designation
- Employment Status
- Personal Information

---

## 🛡 Security

Security is implemented across the entire application stack using modern authentication and authorization mechanisms.

### Security Features

- Laravel Sanctum Authentication
- Personal Access Tokens
- Role-Based Authorization
- Protected REST APIs
- Request Validation
- Secure Password Hashing
- Bearer Token Authentication
- Profile Validation
- Token Revocation
- Secure Session Restoration
- Logout Cleanup
- Navigation Protection

---

# 🧪 Testing

The HRMS platform has been thoroughly tested to ensure reliable communication between the Flutter mobile application, Laravel backend, and cloud-hosted MySQL database. Testing focused on authentication, business logic, API validation, role-based authorization, and end-to-end mobile integration.

## ✅ API Testing

Backend APIs were validated using **Postman** to verify request handling, authentication, authorization, validation rules, and business logic.

### Validated APIs

- User Registration
- OTP Verification
- Login & Logout
- Session Restoration
- Profile API
- Change Password
- Employee Management APIs
- Department Management APIs
- Attendance APIs
- Leave Management APIs
- Payroll APIs
- Dashboard APIs
- Protected Route Authorization
- Middleware Validation
- Request Validation
- Role-Based API Access

---

## 📱 Mobile Integration Testing

The Flutter application was tested against the production Laravel REST API to verify complete end-to-end functionality.

### Validated Scenarios

- Flutter → Laravel API Communication
- Authentication Flow
- Session Restoration
- Secure Token Storage
- Dashboard Navigation
- CRUD Operations
- Role-Based Routing
- Real-Time API Responses
- Error Handling
- Logout & Session Cleanup

---

## 🧪 Testing Environment

| Component | Status |
|------------|--------|
| Postman API Testing | ✅ Completed |
| Android Emulator Testing | ✅ Completed |
| Flutter Integration Testing | ✅ Completed |
| Laravel Backend Testing | ✅ Completed |
| Production REST API Validation | ✅ Completed |
| Authentication Testing | ✅ Completed |
| Authorization Testing | ✅ Completed |
| End-to-End Workflow Testing | ✅ Completed |

---

# 🛠 Technology Stack

| Layer | Technology |
|--------|------------|
| **Mobile Application** | Flutter, Dart |
| **State Management & Networking** | Dio, Shared Preferences |
| **Backend Framework** | Laravel 12 |
| **Programming Language** | PHP |
| **Authentication** | Laravel Sanctum |
| **Database** | Aiven MySQL |
| **ORM** | Eloquent ORM |
| **API Architecture** | RESTful APIs |
| **Containerization** | Docker |
| **Cloud Hosting** | Render |
| **Development Tools** | Android Studio, VS Code |
| **Version Control** | Git, GitHub |
| **Testing Tools** | Postman |
| **Package Managers** | Composer, Flutter CLI |

---

# 🚀 Production Features

The project is designed and deployed following modern software engineering practices, making it suitable for real-world deployment and future scalability.

| Feature | Status |
|----------|--------|
| 🐳 Dockerized Laravel Backend | ✅ |
| ☁️ Production Deployment on Render | ✅ |
| 🗄️ Aiven Managed MySQL Database | ✅ |
| 🌐 HTTPS Enabled REST APIs | ✅ |
| 🔐 Laravel Sanctum Authentication | ✅ |
| 👥 Role-Based Access Control | ✅ |
| 🔑 Bearer Token Authentication | ✅ |
| 📱 Flutter Mobile Integration | ✅ |
| 🔄 Persistent User Sessions | ✅ |
| 📡 JSON REST Communication | ✅ |
| 🔒 Protected API Routes | ✅ |
| ⚙️ Cloud Database Connectivity | ✅ |
| 📈 Modular & Scalable Architecture | ✅ |
| 🚀 Production Ready Backend | ✅ |

## 🔌 REST API Overview

| Module | Status |
|--------|--------|
| Authentication | ✅ |
| Employee | ✅ |
| Department | ✅ |
| Attendance | ✅ |
| Leave | ✅ |
| Payroll | ✅ |
| Dashboard | ✅ |
| Profile | ✅ |

### Production Highlights

- Docker-based backend deployment
- Cloud-hosted Laravel REST API
- Managed MySQL database using Aiven
- Secure HTTPS communication
- Stateless REST API architecture
- Token-based authentication using Laravel Sanctum
- Role-based authorization
- Persistent mobile sessions
- Modular backend design for scalability
- Ready for future Flutter Web integration

---

# 📂 Project Structure

```text
human_resource_management_system/
│
├── backend/
│   ├── app/
│   │   ├── Http/
│   │   │   ├── Controllers/
│   │   │   ├── Middleware/
│   │   │   └── Requests/
│   │   ├── Models/
│   │   ├── Services/
│   │   └── Providers/
│   │
│   ├── database/
│   │   └── migrations/
│   │
│   ├── routes/
│   │   └── api.php
│   │
│   ├── config/
│   ├── public/
│   └── Dockerfile
│
├── mobile/
│   ├── lib/
│   │   ├── app/
│   │   ├── core/
│   │   │   ├── api/
│   │   │   ├── storage/
│   │   │   └── utils/
│   │   │
│   │   └── features/
│   │       ├── auth/
│   │       ├── dashboard/
│   │       ├── employee/
│   │       ├── attendance/
│   │       ├── leave/
│   │       ├── payroll/
│   │       └── admin/
│   │
│   ├── assets/
│   ├── android/
│   ├── ios/
│   └── pubspec.yaml
│
├── docker-compose.yml
├── LICENSE
└── README.md
```

---

# 📱 Mobile Application

The Flutter mobile application follows a role-based architecture, providing dedicated experiences for administrators and employees while communicating securely with the production Laravel REST API.

## 👨‍💼 Administrator Workflow

```text
Login
   │
   ▼
Admin Dashboard
   ├── Employee Management
   ├── Department Management
   ├── Attendance Management
   ├── Leave Requests
   ├── Payroll Management
   ├── Profile
   ├── Change Password
   └── Logout
```

## 👤 Employee Workflow

```text
Login
   │
   ▼
Employee Dashboard
   ├── My Profile
   ├── Attendance
   ├── Apply Leave
   ├── Leave History
   ├── Payroll
   ├── Change Password
   └── Logout
```

### Mobile Application Highlights

- Flutter-based cross-platform application
- Secure authentication using Laravel Sanctum
- HTTPS communication with production backend
- Dio-powered REST API integration
- Persistent session restoration
- Role-based navigation
- Secure local token storage
- Mobile-first architecture

---

# 🛣 Roadmap

| Version | Planned Feature | Status |
|----------|-----------------|--------|
| v1.0 | Flutter Mobile Application | ✅ Completed |
| v1.0 | Laravel REST API | ✅ Completed |
| v1.0 | Docker Deployment | ✅ Completed |
| v1.0 | Cloud Database | ✅ Completed |
| v1.1 | Flutter Web Admin Portal | 🚧 In Progress |
| v1.2 | Push Notifications | 📅 Planned |
| v1.2 | PDF Payslip Generation | 📅 Planned |
| v1.3 | Face Recognition Attendance | 📅 Planned |
| v1.3 | QR-Based Attendance | 📅 Planned |
| v2.0 | Employee Analytics Dashboard | 📅 Planned |
| v2.0 | Holiday Calendar | 📅 Planned |
| v2.0 | Multi-Language Support | 📅 Planned |
| v2.0 | Dark Mode | 📅 Planned |

---

# 📸 Screenshots

> Screenshots will be added to demonstrate the complete workflow of the application.

### 🔐 Authentication

- Login
- Registration
- OTP Verification

### 👨‍💼 Administrator

- Dashboard
- Employee Management
- Department Management
- Attendance
- Leave Management
- Payroll

### 👤 Employee

- Dashboard
- My Profile
- Attendance
- Leave History
- Payroll

### 🧪 API Testing

- Postman Collections
- Authentication APIs
- CRUD APIs
- Protected Endpoints

---

# 🤝 Contributing

Contributions are welcome.

If you would like to improve the project:

1. Fork the repository.
2. Create a feature branch.
3. Implement and test your changes.
4. Commit your changes.
5. Submit a Pull Request.

Please ensure your contributions follow the existing architecture and coding standards.

---

# 📄 License

This project is licensed under the **MIT License**.

See the **LICENSE** file for complete license details.

---

# 👨‍💻 Project Purpose

The Human Resource Management System was developed to demonstrate modern full-stack software engineering practices through the implementation of a scalable, production-ready enterprise application.

The project showcases:

- RESTful API Development
- Laravel Backend Engineering
- Flutter Cross-Platform Development
- Cloud Database Integration
- Docker Containerization
- Production Deployment
- Role-Based Access Control
- Secure Authentication with Laravel Sanctum
- Mobile-to-Backend API Integration
- Modular Application Architecture

This repository serves as both a learning resource and a demonstration of full-stack application development using modern technologies and deployment practices.
