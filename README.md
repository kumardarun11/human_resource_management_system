# 🏢 Human Resource Management System (HRMS)

A full-stack Human Resource Management System built with **Laravel, Flutter, and MySQL** to simplify employee administration and day-to-day HR operations through a RESTful, mobile-first architecture.

The system provides separate **Admin** and **Employee** workflows for employee management, attendance, leave requests, payroll, departments, authentication, and dashboard analytics.

> This project was developed as an educational, hackathon, and portfolio project to demonstrate full-stack development, REST API integration, role-based authorization, and cross-platform mobile application development.

---

## 📌 Project Overview

Managing employees and HR operations manually becomes increasingly difficult as an organization grows.

HRMS provides a centralized system where administrators can manage organizational resources while employees can access and manage their personal HR activities.

The application follows a client-server architecture:

```text
┌──────────────────────────┐
│   Flutter Mobile App     │
│                          │
│  Admin + Employee UI     │
└────────────┬─────────────┘
             │
             │ REST API / JSON
             │ Bearer Authentication
             ▼
┌──────────────────────────┐
│      Laravel API         │
│                          │
│ Authentication           │
│ Business Logic           │
│ Role-Based Middleware    │
└────────────┬─────────────┘
             │
             ▼
┌──────────────────────────┐
│          MySQL           │
│                          │
│ Employees                │
│ Attendance               │
│ Leave                    │
│ Payroll                  │
│ Departments              │
└──────────────────────────┘
```

The architecture focuses on:

- Secure authentication
- Role-based authorization
- RESTful API design
- Mobile-first development
- Modular backend architecture
- API-driven client integration
- Maintainability
- Scalability

---

## 🚀 Project Status

| Module | Status |
|---|---|
| Laravel Backend | ✅ Completed |
| REST APIs | ✅ Completed |
| Database Design | ✅ Completed |
| Authentication | ✅ Completed |
| Role-Based Authorization | ✅ Completed |
| Postman API Testing | ✅ Completed |
| Flutter Mobile Application | ✅ Completed |
| Flutter UI Development | ✅ Completed |
| Backend API Integration | ✅ Completed |
| Admin Mobile Workflow | ✅ Completed |
| Employee Mobile Workflow | ✅ Completed |
| Session Restoration | ✅ Completed |
| Final Integration Testing | ✅ Completed |

---

# ✨ Core Features

## 🔐 Authentication & Session Management

Authentication is implemented using **Laravel Sanctum** with token-based API access.

Features include:

- User Registration
- Secure Login
- Logout
- Email Verification Logic
- OTP Verification
- Forgot Password API
- Password Reset API
- Change Password
- Profile API
- Secure Password Hashing
- Personal Access Tokens
- Role-Based Login Routing
- Persistent Mobile Sessions
- Server-Side Session Validation
- Sanctum Token Revocation

The Flutter application restores authenticated sessions by validating the stored token against the Laravel profile API.

```text
Application Start
        ↓
Check Stored Token
        ↓
GET /api/profile
        ↓
Validate Sanctum Token
        ↓
Retrieve User Role
        ↓
┌───────────────┬────────────────┐
│     Admin     │    Employee    │
▼               ▼
Admin           Employee
Dashboard       Dashboard
```

> Email delivery and mobile password-reset deep-link handling are considered deployment-stage integrations. The current development environment focuses on API and authentication-flow validation.

---

## 👨‍💼 Employee Management

Administrators can manage employee accounts directly from the mobile application.

Features include:

- Create Employee
- View Employee Details
- Update Employee Information
- Delete Employee
- Employee Listing
- Department Mapping
- Designation Management
- Employment Status
- Employee Profile Management
- Admin-Provisioned Employee Accounts

Accounts provisioned by administrators can be used directly for employee login.

---

## 🏢 Department Management

The department module provides centralized organizational structure management.

Features include:

- Create Department
- View Departments
- Update Department
- Delete Department
- Department Listing
- Department Code Management
- Department Description
- Employee Association

---

## 📅 Attendance Management

The attendance module implements employee attendance tracking and administrative monitoring.

### Employee Features

- Employee Check-In
- Employee Check-Out
- Attendance History
- Daily Attendance Status
- Working Hour Tracking
- Personal Attendance Statistics

### Admin Features

- Organization Attendance Listing
- Daily Attendance Monitoring
- Employee Attendance Details
- Attendance History

Backend attendance logic supports:

- Late Arrival Detection
- Half-Day Detection
- Working Hour Calculation
- Attendance Status Management

---

## 📝 Leave Management

Employees can submit leave requests while administrators review and manage them.

### Employee Features

- Apply for Leave
- Select Leave Type
- Leave Date Selection
- Add Leave Reason
- View Leave History
- Track Leave Status

### Admin Features

- View Leave Requests
- Review Pending Requests
- Approve Leave
- Reject Leave
- Monitor Leave Status

Supported leave states include:

```text
Pending
Approved
Rejected
```

---

## 💰 Payroll Management

The payroll module supports salary record management for administrators and payroll visibility for employees.

### Admin Features

- View Payroll Records
- Create Employee Payroll
- Select Employee
- Define Payroll Month and Year
- Configure Basic Salary
- Add Allowances
- Add Bonus and Overtime
- Configure Tax
- Configure Provident Fund
- Add Other Deductions
- Calculate Gross Salary
- Calculate Net Salary
- Define Payment Status
- Define Payment Method
- Add Payroll Remarks

### Employee Features

- View Personal Payroll
- View Salary Details
- View Gross Salary
- View Net Salary
- View Payment Status
- Access Payslip Information

Payroll calculations include:

```text
Total Earnings
    =
Basic Salary
+ House Allowance
+ Medical Allowance
+ Transport Allowance
+ Bonus
+ Overtime

Total Deductions
    =
Tax
+ Provident Fund
+ Other Deductions

Net Salary
    =
Total Earnings
- Total Deductions
```

The backend prevents duplicate payroll records for the same employee, payroll month, and payroll year.

---

## 📊 Role-Based Dashboards

Separate mobile dashboards are available for administrators and employees.

### 👨‍💼 Admin Dashboard

The Admin Dashboard provides organizational information and administrative navigation.

Features include:

- Total Employee Summary
- Department Summary
- Attendance Overview
- Leave Summary
- Payroll Overview
- Employee Management
- Department Management
- Attendance Management
- Leave Request Management
- Payroll Management
- Change Password
- Secure Logout

### 👤 Employee Dashboard

The Employee Dashboard provides quick access to personal HR functions.

Features include:

- Employee Overview
- Personal Profile
- Attendance
- Leave Management
- Payroll
- Change Password
- Secure Logout

---

## 👤 Employee Profile

Employees can access their profile information directly from the mobile application.

Profile information includes:

- Employee ID
- Name
- Email
- Phone
- Department
- Designation
- Employment Status
- Personal Information

The profile is retrieved through authenticated Laravel APIs.

---

## 🛡 Security

Security is implemented across both the backend and mobile authentication flow.

Implemented features include:

- Laravel Sanctum Authentication
- Personal Access Tokens
- Role-Based Middleware
- Admin Authorization
- Employee Authorization
- Protected API Routes
- Request Validation
- Secure Password Hashing
- Bearer Token Authentication
- Authenticated Profile Validation
- Token Revocation During Logout
- Local Authentication Storage Cleanup
- Navigation Stack Cleanup After Logout
- Server-Validated Session Restoration

---

## 🧪 Testing

The backend APIs were tested using **Postman** and integrated with the Flutter mobile application.

Validated modules include:

- Registration
- OTP Verification
- Login
- Logout
- Session Restoration
- Role-Based Dashboard Routing
- Employee APIs
- Department APIs
- Attendance APIs
- Leave APIs
- Payroll APIs
- Dashboard APIs
- Profile API
- Change Password
- Middleware
- Authorization
- Request Validation
- Flutter-to-Laravel API Integration

The mobile application was tested using an Android emulator with real Laravel API requests.

---

## 🛠 Technology Stack

### Backend

- PHP
- Laravel
- Laravel Sanctum
- Eloquent ORM
- REST APIs

### Mobile Application

- Flutter
- Dart
- Dio
- Shared Preferences

### Database

- MySQL

### Development & Testing Tools

- Postman
- Git
- GitHub
- Composer
- Flutter CLI
- Android Studio
- Android Emulator
- VS Code
- XAMPP
- phpMyAdmin

---

## 📂 Project Structure

```text
human_resource_management_system/
│
├── backend/
│   ├── app/
│   │   ├── Http/
│   │   │   ├── Controllers/
│   │   │   ├── Middleware/
│   │   │   └── Requests/
│   │   └── Models/
│   │
│   ├── database/
│   │   └── migrations/
│   │
│   ├── routes/
│   │   └── api.php
│   │
│   ├── config/
│   └── public/
│
├── mobile/
│   ├── lib/
│   │   ├── app/
│   │   ├── core/
│   │   │   ├── api/
│   │   │   └── storage/
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
├── LICENSE
└── README.md
```

---

# 📱 Mobile Application

The Flutter mobile application provides separate workflows based on the authenticated user's role.

## Admin Mobile Workflow

```text
Login
  ↓
Admin Dashboard
  ├── Employee Management
  ├── Department Management
  ├── Attendance Management
  ├── Leave Request Management
  ├── Payroll Management
  ├── Change Password
  └── Logout
```

## Employee Mobile Workflow

```text
Login
  ↓
Employee Dashboard
  ├── My Profile
  ├── Attendance
  ├── Apply Leave
  ├── Leave History
  ├── Payroll
  ├── Change Password
  └── Logout
```

The mobile application communicates with Laravel through JSON-based REST APIs using Dio.

Authentication tokens and session metadata are stored locally for session restoration.

---

# 🔮 Future Enhancements

Potential future improvements include:

- SMTP-Based OTP Delivery
- Mobile Password Reset Deep Linking
- Face Recognition Attendance
- QR-Based Attendance
- Biometric Authentication
- Push Notifications
- Real-Time Dashboard Updates
- PDF Salary Slip Generation
- Performance Evaluation
- Employee Analytics
- Holiday Calendar
- Dark Mode
- Multi-Language Support
- Production API Deployment
- Containerized Deployment
- Limited Web Administration Dashboard

---

# 📸 Screenshots

Mobile application and API testing screenshots can be added to showcase:

- Login and Registration
- OTP Verification
- Admin Dashboard
- Employee Dashboard
- Employee Management
- Attendance
- Leave Management
- Payroll Management
- API Testing

---

# 🤝 Contributing

Contributions, suggestions, and improvements are welcome.

To contribute:

1. Fork the repository.
2. Create a feature branch.
3. Implement and test your changes.
4. Commit your changes with a descriptive message.
5. Submit a pull request.

Please maintain code quality and follow the existing project structure.

---

# 📄 License

This project is licensed under the **MIT License**.

See the `LICENSE` file for complete license information.

---

## 👨‍💻 Project Purpose

HRMS was developed as an **educational, and portfolio project** focused on practical full-stack application development.

The project demonstrates:

- REST API Development
- Laravel Backend Engineering
- Flutter Mobile Development
- MySQL Database Design
- Role-Based Authorization
- API Integration
- Authentication and Session Management
- Modular Application Architecture

The source code is available for learning, experimentation, and further development.