# 🩺 حالتي | Halati

<p align="center">
  <strong>Smart Health Tracking & AI-Powered Reporting Application</strong>
</p>

<p align="center">
  Track Symptoms • Review History • Monitor Health Patterns • Generate PDF Reports • AI-Powered Summaries
</p>

<p align="center">
  <strong>Final Project — Flutter Bootcamp</strong>
</p>

<p align="center">
  Designed & Developed by<br>
  <strong>Salma Alhababi — سلمى الحبابي</strong><br>
  <strong>Buthaina Bin Humaid — بثينة بن حميد</strong>
</p>

---

## 💙 About Halati

**Halati (حالتي)** is a smart Arabic health tracking application built with **Flutter**.

The application helps users record and organize their symptoms, monitor health patterns, manage medical appointments, review their health history, and generate structured health reports.

Halati combines **Flutter, Dart, Supabase, Google Gemini AI, REST APIs, PDF generation, and local notifications** to provide a complete and easy-to-use health tracking experience.

> **Medical Disclaimer:** Halati organizes and summarizes user-provided health information. It is not a diagnostic system and does not replace professional medical advice, diagnosis, or treatment.

---

# 🎬 App Demo

<p align="center">
  <img src="halati_demo.gif" width="300" alt="Halati App Demo">
</p>

<p align="center">
  <a href="halati_demo.mp4">
    <strong>▶️ Watch Full App Demo</strong>
  </a>
</p>

---

# 📱 Application Preview

## 🔐 Authentication

<p align="center">
  <img src="signup.png" width="230" alt="Create Account">
  &nbsp;&nbsp;
  <img src="login.png" width="230" alt="Login">
  &nbsp;&nbsp;
  <img src="forgot_password.png" width="230" alt="Forgot Password">
</p>

<p align="center">
  <strong>Create Account • Login • Password Recovery</strong>
</p>

Halati provides a complete authentication flow using **Supabase Authentication**.

Users can create an account, log in securely, recover their password, and maintain their authenticated session inside the application.

The application also supports **Guest Mode**, allowing users to explore available public sections before signing in.

---

# 🏠 Home Dashboard

<p align="center">
  <img src="home.png" width="300" alt="Halati Home Screen">
</p>

The home screen gives users a simple overview of their recorded health information.

It provides quick access to:

- Upcoming medical appointments
- Symptoms recorded during the month
- Average symptom severity
- Latest recorded symptoms
- Notifications
- Health history
- Health reports
- Profile
- Adding a new symptom

---

# 🔔 Notifications

<p align="center">
  <img src="notifications.png" width="300" alt="Halati Notifications">
</p>

Halati includes local notification functionality to encourage consistent health tracking.

The application can schedule a daily reminder asking users to record or review their health status.

Example:

> **حالتي 💙**  
> كيف حالتك اليوم؟

The notification system uses **flutter_local_notifications** and **timezone** for scheduling.

---

# ➕ Add New Symptom

<p align="center">
  <img src="add_symptom.png" width="300" alt="Add New Symptom">
</p>

Halati provides a structured form that allows users to record detailed information about their symptoms.

Users can enter:

- Symptom type
- Pain or symptom location
- Date and time
- Severity level
- Whether the symptom is recurring
- Whether medication was taken
- Medication name
- Additional notes

Each symptom is stored in the application's backend and associated with the authenticated user.

---

# 📚 Health History

<p align="center">
  <img src="history.png" width="300" alt="Health History">
</p>

The **Health History** screen provides an organized timeline of previously recorded symptoms.

Users can:

- View previous symptoms
- Review symptom dates
- Review severity levels
- View medication information
- Read previous notes
- Search health records
- Filter records by time period
- Open individual symptom details

This allows users to review their health information without relying only on memory.

---

# 🔍 Search & Filtering

Halati includes search and filtering functionality to make navigating health records easier.

Users can search records using information such as:

- Symptom name
- Symptom location
- Notes
- Medication name

Records can also be filtered according to a selected period.

---

# 📊 Smart Health Reports

<p align="center">
  <img src="report_stats.png" width="300" alt="Health Report Statistics">
</p>

One of the main features of Halati is its **Smart Health Reporting System**.

The application processes recorded symptom information and automatically calculates useful statistics.

Reports can include:

- Number of symptom types
- Average symptom severity
- Number of recurring cases
- Most frequently recorded symptoms
- Number of occurrences for each symptom
- Medication history
- Selected report period
- AI-generated health summary

---

# 📅 Custom Date Range Reports

Users can select a specific reporting period.

```text
From Date
    ↓
To Date
    ↓
Retrieve Health Records
    ↓
Analyze Symptoms
    ↓
Calculate Statistics
    ↓
Generate Report
```

This allows users to generate focused reports for a specific period instead of analyzing their complete health history every time.

---

# 🤖 AI-Powered Health Summary

<p align="center">
  <img src="ai_summary.png" width="300" alt="AI Health Summary">
</p>

Halati integrates **Google Gemini AI** to generate a concise Arabic summary based on health information recorded by the user.

The application prepares structured information such as:

- Symptom name
- Symptom location
- Severity
- Recurrence
- Medication usage
- Medication name
- Symptom date
- Notes

The information is sent to the AI model through an HTTP request.

The generated summary can highlight:

- Frequently recorded symptoms
- General recorded severity
- Recurring symptoms
- Medication usage
- Patterns supported by the recorded information

---

## 🛡️ AI Safety

The AI integration is intentionally designed as a **summarization feature rather than a diagnostic system**.

The AI is instructed to:

- Summarize only the provided information
- Avoid medical diagnosis
- Avoid claiming that the user has a particular disease
- Avoid inventing missing information
- Avoid unsupported conclusions
- Keep the summary concise and professional

The purpose of the AI feature is to organize recorded health information, not replace healthcare professionals.

---

# 📄 PDF Health Reports

<p align="center">
  <img src="pdf_report_1.png" width="390" alt="PDF Health Report Page 1">
  &nbsp;&nbsp;
  <img src="pdf_report_2.png" width="390" alt="PDF Health Report Page 2">
</p>

Halati can dynamically generate a professional Arabic **PDF health report** containing the user's recorded information.

The generated report can include:

### 📅 Report Information

- Report title
- Selected reporting period
- Date range

### 📊 Health Statistics

- Number of symptom types
- Average severity
- Number of recurring symptoms

### 🩺 Symptoms

- Recorded symptom names
- Number of occurrences

### 💊 Medications

- Medications recorded during the selected period

### 🤖 AI Summary

- AI-generated Arabic summary

### ⚠️ Medical Disclaimer

The generated PDF clearly explains that the report summarizes recorded information and does not constitute a medical diagnosis.

---

# 📅 Appointment Management

<p align="center">
  <img src="appointment.png" width="300" alt="Appointment Management">
</p>

Halati allows users to store information about upcoming medical appointments.

Appointment information can include:

- Appointment date
- Doctor name
- Clinic name
- Additional notes

The upcoming appointment can also be displayed directly on the home screen.

---

# 👤 Profile

<p align="center">
  <img src="profile.png" width="300" alt="Halati Profile">
</p>

The profile screen provides access to account and application settings.

Users can access:

- Personal information
- Medical appointments
- Notifications
- Help & Support
- Privacy Policy
- Account management

Users can also select their profile image.

---

# 📝 Personal Information

<p align="center">
  <img src="personal_info.png" width="300" alt="Personal Information">
</p>

The Personal Information screen allows authenticated users to review and manage their account information.

---

# 💬 Help & Support

<p align="center">
  <img src="help_support.png" width="300" alt="Help and Support">
</p>

Halati includes a dedicated **Help & Support** section.

It provides answers to common questions about using the application, including:

- How to record a symptom
- How to review previous symptoms
- How to add an appointment
- How to manage account information

---

# 🔐 Privacy Policy

<p align="center">
  <img src="privacy.png" width="300" alt="Privacy Policy">
</p>

Halati includes a dedicated privacy section explaining how user information is handled within the application.

Because Halati handles user-provided health information, privacy and secure data handling are important parts of the project.

---

# 🚪 Account Management

<p align="center">
  <img src="logout.png" width="300" alt="Logout Confirmation">
</p>

Authenticated users can securely sign out of their account.

The application also supports **Guest Mode**.

Guests can explore available public sections of the application, while features that require personal health information are protected until the user signs in.

---

# ✨ Key Features

| Feature | Description |
|---|---|
| 🩺 **Symptom Tracking** | Record detailed health symptoms |
| ➕ **Add Health Records** | Add severity, location, medication and notes |
| 📚 **Health History** | Review previously recorded symptoms |
| 🔍 **Search & Filter** | Search and filter health records |
| 📊 **Health Analytics** | Calculate statistics and symptom patterns |
| 🤖 **AI Summary** | Generate Arabic summaries using Gemini |
| 📄 **PDF Reports** | Export structured Arabic health reports |
| 📅 **Appointments** | Save upcoming medical appointments |
| 🔔 **Notifications** | Daily health reminders |
| 🔐 **Authentication** | Account management with Supabase |
| 👤 **Guest Mode** | Explore public sections without an account |
| 🇸🇦 **Arabic RTL** | Arabic-first user interface |
| 📱 **Responsive Design** | Adaptable interface for different screen sizes |

---

# 🛠️ Technology Stack

Halati combines mobile development, backend services, artificial intelligence, API integration, database management, notifications, and document generation.

| Technology / Package | Purpose |
|---|---|
| **Flutter** | Cross-platform application development |
| **Dart** | Main programming language |
| **Supabase** | Backend and database |
| **Supabase Authentication** | User authentication and password recovery |
| **Google Gemini API** | AI-generated health summaries |
| **HTTP** | REST API communication |
| **JSON** | Structured API data exchange |
| **pdf** | Dynamic PDF report generation |
| **printing** | PDF handling and export |
| **flutter_dotenv** | Environment configuration |
| **flutter_local_notifications** | Local health notifications |
| **timezone** | Notification scheduling |
| **Git** | Version control |
| **GitHub** | Source code collaboration |
| **VS Code** | Development environment |

---

# 🧠 Smart Report Workflow

```text
User Health Records
        ↓
Supabase Database
        ↓
Select Report Date Range
        ↓
Retrieve Records
        ↓
Analyze Symptoms
        ↓
Calculate Statistics
        ↓
Prepare Structured Data
        ↓
Google Gemini API
        ↓
Generate Arabic AI Summary
        ↓
Create PDF Health Report
```

---

# 🏗️ System Architecture

```text
                    ┌───────────────────────┐
                    │         User          │
                    └───────────┬───────────┘
                                │
                                ▼
                    ┌───────────────────────┐
                    │      Flutter UI       │
                    │         Dart          │
                    └───────────┬───────────┘
                                │
               ┌────────────────┼────────────────┐
               │                │                │
               ▼                ▼                ▼
        ┌─────────────┐  ┌─────────────┐  ┌─────────────┐
        │  Supabase   │  │   Google    │  │     PDF     │
        │   Backend   │  │  Gemini AI  │  │  Generator  │
        └──────┬──────┘  └─────────────┘  └─────────────┘
               │
          ┌────┴────┐
          │         │
          ▼         ▼
    Authentication Database
```

---

# 📁 Project Structure

```text
final_project/
│
├── android/
├── ios/
├── linux/
├── macos/
├── web/
├── windows/
│
├── assets/
│
├── lib/
│   │
│   ├── constants/
│   │   ├── colors.dart
│   │   └── fonts.dart
│   │
│   ├── screens/
│   │   ├── splash_screen.dart
│   │   ├── login_screen.dart
│   │   ├── signup_screen.dart
│   │   ├── reset_password_screen.dart
│   │   ├── home_screen.dart
│   │   ├── add_condition_screen.dart
│   │   ├── condition_detail_screen.dart
│   │   ├── history_screen.dart
│   │   ├── report_screen.dart
│   │   ├── appointment_screen.dart
│   │   ├── notifications_screen.dart
│   │   ├── profile_screen.dart
│   │   ├── personal_info_screen.dart
│   │   ├── help_support_screen.dart
│   │   └── privacy_policy_screen.dart
│   │
│   ├── services/
│   │   ├── database.dart
│   │   └── notification_service.dart
│   │
│   ├── utils/
│   │   └── screen_size.dart
│   │
│   ├── widgets/
│   │   └── custom_bottom_navigation.dart
│   │
│   └── main.dart
│
├── signup.png
├── login.png
├── forgot_password.png
├── home.png
├── notifications.png
├── profile.png
├── history.png
├── add_symptom.png
├── report_stats.png
├── ai_summary.png
├── pdf_report_1.png
├── pdf_report_2.png
├── appointment.png
├── personal_info.png
├── help_support.png
├── privacy.png
├── logout.png
├── halati_demo.gif
├── halati_demo.mp4
│
├── .env_example
├── .gitignore
├── pubspec.yaml
└── README.md
```

---

# 🔑 Environment Variables

Halati uses **flutter_dotenv** for environment configuration.

Create a `.env` file inside the project:

```env
my_url=YOUR_SUPABASE_URL
my_publishableKey=YOUR_SUPABASE_PUBLISHABLE_KEY
GEMINI_API_KEY=YOUR_GEMINI_API_KEY
```

The real `.env` file should **never be committed to GitHub**.

Add:

```gitignore
.env
```

to `.gitignore`.

The repository can provide an `.env_example` file containing placeholder values only.

---

# ⚙️ Getting Started

## 1. Clone the Repository

```bash
git clone <YOUR_REPOSITORY_URL>
```

Navigate to the project:

```bash
cd final_project
```

## 2. Install Dependencies

```bash
flutter pub get
```

## 3. Check Flutter Installation

```bash
flutter doctor
```

## 4. Configure Environment Variables

Create a `.env` file and configure the required Supabase and Gemini values.

## 5. Run on Chrome

```bash
flutter run -d chrome
```

## 6. Run on Android

Check available devices:

```bash
flutter devices
```

Then run:

```bash
flutter run
```

---

# 🔒 Security & Privacy

Because Halati handles user-provided health information, security and privacy are important considerations.

### Environment Variables

Sensitive configuration values should not be committed to Git.

```gitignore
.env
```

### API Keys

Real API keys should never be stored in:

```text
README.md
.env_example
Git commits
Public repositories
```

If a secret is accidentally committed, it should be rotated.

### Supabase Security

Supabase **Row Level Security (RLS)** should be configured so authenticated users can only access records they are authorized to access.

### Production AI Security

Environment variables bundled with a Flutter client should not be considered secure storage for production secrets.

A stronger production architecture would be:

```text
Flutter Application
        ↓
Secure Backend / Server Function
        ↓
Google Gemini API
```

---

# 🌐 Platform Support

| Platform | Application | Local Notifications |
|---|---:|---:|
| **Android** | ✅ | ✅ |
| **Chrome / Web** | ✅ | Not enabled |
| **iOS** | Flutter project available | Not primary target |
| **Windows** | Flutter project available | Not primary target |
| **macOS** | Flutter project available | Not primary target |
| **Linux** | Flutter project available | Not primary target |

---

# 🎓 Flutter Bootcamp Final Project

Halati was developed as a **Flutter Bootcamp Final Project** demonstrating practical experience with:

```text
Flutter Development
        +
Dart Programming
        +
Responsive UI
        +
Supabase Backend
        +
Database Integration
        +
Authentication
        +
REST APIs
        +
Artificial Intelligence
        +
PDF Generation
        +
Local Notifications
        +
Git & GitHub Collaboration
```

---

# 🚀 Future Improvements

Possible future improvements for Halati include:

- Secure server-side Gemini integration
- Advanced health charts
- More detailed health trend visualization
- Custom notification times
- Notification settings
- Enhanced report customization
- Secure report sharing
- Doctor-friendly report formats
- Additional health statistics
- Improved accessibility
- Offline capabilities
- Additional localization
- Automated testing
- Enhanced account settings

---

# 👩‍💻 Development Team

<table>
  <tr>
    <td align="center" width="50%">
      <h3>Salma Alhababi</h3>
      <strong>سلمى الحبابي</strong>
      <br><br>
      <strong>Design & Development</strong>
    </td>
    <td align="center" width="50%">
      <h3>Buthaina Bin Humaid</h3>
      <strong>بثينة بن حميد</strong>
      <br><br>
      <strong>Design & Development</strong>
    </td>
  </tr>
</table>

<p align="center">
  <strong>
    Halati was collaboratively designed and developed by
    Salma Alhababi and Buthaina Bin Humaid.
  </strong>
</p>

The project involved:

- Flutter development
- UI/UX design and implementation
- Supabase integration
- Database management
- Authentication
- REST API integration
- Google Gemini AI integration
- Health reporting
- PDF generation
- Notification functionality
- Responsive design
- Testing and debugging
- Git & GitHub collaboration

---

# ⚠️ Medical Disclaimer

**Halati is intended for health tracking and information organization purposes only.**

The application does not:

- Diagnose diseases or medical conditions
- Replace professional medical advice
- Replace healthcare professionals
- Recommend medical treatments
- Provide emergency medical services

AI-generated content within Halati is intended only to summarize information entered into the application.

Users should consult qualified healthcare professionals regarding medical concerns, diagnosis, and treatment.

---

# 💙 حالتي | Halati

<p align="center">
  <strong>Smart Health Tracking & Reporting</strong>
</p>

<p align="center">
  <strong>Track • Understand • Organize</strong>
</p>

<p align="center">
  <strong>لا بأس، طهور إن شاء الله</strong>
</p>

<p align="center">
  Developed with 💙 by
  <br>
  <strong>Salma Alhababi & Buthaina Bin Humaid</strong>
</p>

