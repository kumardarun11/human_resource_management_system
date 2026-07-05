# 🏢 Human Resource Management System (HRMS)

A modern Human Resource Management System (HRMS) designed to simplify and automate day-to-day organizational operations through secure REST APIs and a mobile-first architecture.

The project aims to provide a complete solution for employee management, attendance tracking, leave management, payroll processing, department administration, authentication, and analytics.

The backend has been fully implemented using Laravel and extensively tested through Postman. The mobile application is currently under active development using Flutter and will consume the backend APIs.

## 📌 Project Overview

Managing employees manually becomes increasingly difficult as organizations grow. This HRMS provides a centralized platform that enables administrators and employees to perform essential HR-related operations efficiently.

The system follows a RESTful architecture where Laravel serves as the backend API while Flutter is used to build the cross-platform mobile application.

The architecture focuses on:

- Secure authentication
- Role-based authorization
- Modular backend design
- REST API development
- Scalability
- Maintainability
- Mobile-first development

## 🚀 Current Project Status

| Module | Status |
|---------|--------|
| Laravel Backend | ✅ Completed |
| REST APIs | ✅ Completed |
| Database Design | ✅ Completed |
| Authentication | ✅ Completed |
| Postman API Testing | ✅ Completed |
| Flutter Mobile Structure | 🚧 Initialized |
| Flutter UI Development | 🚧 In Progress |
| API Integration | 🚧 In Progress |

# ✨ Backend Features

The backend has been fully implemented and tested.

It currently provides complete REST APIs for:

- Authentication
- Employee Management
- Department Management
- Attendance Management
- Leave Management
- Payroll Management
- Dashboard Analytics
- Role-Based Access Control

## 🔐 Authentication Module

Implemented using Laravel Sanctum.

Features include:

- User Registration
- Secure Login
- Logout
- Email Verification
- Password Reset
- Forgot Password
- Change Password
- Token Refresh
- Profile API
- Secure Password Hashing
- Personal Access Tokens

## 👨‍💼 Employee Management

Complete CRUD operations are available.

Features:

- Create Employee
- View Employee Details
- Update Employee Information
- Delete Employee
- Employee Listing
- Department Mapping
- Employee Profile Management

## 🏢 Department Management

Department APIs provide centralized department administration.

Features:

- Create Department
- View Department
- Update Department
- Delete Department
- Department Listing
- Employee Association

## 📅 Attendance Management

Attendance has been implemented with business logic.

Features:

- Employee Check-In
- Employee Check-Out
- Attendance History
- Attendance Listing
- Daily Attendance
- Late Arrival Detection
- Half-Day Detection
- Working Hour Calculation
- Attendance Statistics

## 📝 Leave Management

Employees can submit leave requests while administrators manage approvals.

Features:

- Apply Leave
- View Leave Requests
- Leave History
- Approve Leave
- Reject Leave
- Pending Leave Tracking
- Leave Status Management

## 💰 Payroll Management

Payroll APIs are fully implemented.

Features:

- Payroll Listing
- Payroll Details
- Payslip Download API
- Payroll Summary

## 📊 Dashboard

Separate dashboards have been implemented for different user roles.

### 👨‍💼 Admin Dashboard

- Total Employees
- Total Departments
- Attendance Summary
- Leave Summary
- Payroll Summary
- Organization Statistics

### 👤 Employee Dashboard

- Personal Attendance
- Leave Summary
- Attendance Statistics
- Personal Overview

## 🛡 Security

Security has been considered throughout backend development.

Implemented features:

- Laravel Sanctum Authentication
- Role-Based Middleware
- Request Validation
- Password Hashing
- Protected API Routes
- Authenticated Endpoints
- Secure JSON Responses

## 🧪 Backend Testing

All backend APIs have been thoroughly tested using Postman.

The following modules have been validated:

- Authentication
- Employee APIs
- Department APIs
- Attendance APIs
- Leave APIs
- Payroll APIs
- Dashboard APIs
- Middleware
- Authorization
- Validation

## 🛠 Technology Stack

### Backend

- Laravel
- PHP
- MySQL
- Laravel Sanctum

### Mobile

- Flutter
- Dart

### Tools

- Postman
- Git
- GitHub
- Composer
- VS Code

## 📂 Project Structure

```text
human_resource_management_system/
│
├── backend/
│   ├── app/
│   ├── database/
│   ├── routes/
│   ├── config/
│   ├── public/
│   └── ...
│
├── mobile/
│   ├── lib/
│   ├── assets/
│   ├── android/
│   ├── ios/
│   └── ...
│
└── README.md
```
# 📱 Mobile Application

The Flutter application has been initialized and the project structure has been organized.

The following modules are planned and currently under development:

- Authentication Screens
- Admin Dashboard
- Employee Dashboard
- Attendance Module
- Leave Management
- Payroll Module
- Employee Profile
- Department Module
- API Integration
- Push Notifications

Backend APIs are fully prepared for Flutter integration.

# 🔮 Future Enhancements

Planned improvements include:

- Face Recognition Attendance
- QR Based Attendance
- Biometric Integration
- Push Notifications
- Real-Time Dashboard
- Salary Slip PDF Generation
- Performance Evaluation
- Employee Analytics
- Holiday Calendar
- Dark Mode
- Multi-language Support

# 📸 Screenshots

> Screenshots of the mobile application and API testing will be added as development progresses.

# 🤝 Contributing

Contributions, suggestions, and improvements are always welcome.

Feel free to fork the repository, create a feature branch, and submit a pull request.

Please ensure code quality, documentation, and testing standards are maintained.

# 📄 License

This project is developed for educational and portfolio purposes.

Feel free to explore the source code and learn from the implementation.