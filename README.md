# 🩺 حالتي | Halati

<p align="center">
  <strong>Smart Health Tracking & Reporting Application</strong>
</p>

<p align="center">
  Track Symptoms • Monitor Health Patterns • Generate Reports • AI-Powered Summaries
</p>

<p align="center">
  Developed by <strong>Salma Alhababi</strong> & <strong>Buthaina Bin Humaid</strong>
</p>

---

## 📖 About Halati

**Halati (حالتي)** is a smart health tracking application designed to help users record, organize, monitor, and review their symptoms over time.

The application provides users with a simple and structured way to document health-related information such as symptoms, severity levels, affected body areas, recurrence, medications, dates, and personal notes.

Halati goes beyond basic symptom tracking by transforming recorded information into meaningful health reports containing statistics, symptom frequency, medication history, and AI-powered summaries.

The goal of Halati is to make personal health information easier to organize, understand, and review before discussing it with a healthcare professional.

> **Medical Disclaimer:** Halati is not a medical diagnostic system. It organizes and summarizes user-provided information and should not replace professional medical advice, diagnosis, or treatment.

---

# ✨ Features

## 🩺 Symptom Tracking

Users can record detailed information about their symptoms, including:

- Symptom type
- Location of pain or discomfort
- Severity level
- Date and time
- Whether the symptom is recurring
- Whether medication was taken
- Medication name
- Additional notes

Each record is stored in the application's backend and can later be accessed through the user's health history and reports.

---

## ➕ Add New Health Records

Halati provides a structured form for adding new symptoms.

Users can select or enter relevant information and save the record directly to the database.

This allows users to build a personal health history over time instead of relying on memory when reviewing previous symptoms.

---

## 📚 Health History

The application provides a dedicated health history interface where users can review previously recorded symptoms.

The history functionality allows users to:

- View recorded symptoms
- Review symptom details
- View symptom dates
- Review severity levels
- View medication information
- Read previously entered notes
- Search health records
- Filter records by time period

This creates an organized timeline of the user's recorded health information.

---

## 🔍 Search & Filtering

Halati includes search and filtering functionality to make navigating health records easier.

Users can search records using information such as:

- Symptom name
- Symptom location
- Notes
- Medication name

Records can also be filtered according to specific periods, allowing users to quickly locate relevant health information.

---

# 📊 Smart Health Reports

One of the main features of Halati is its health reporting system.

The application processes recorded symptom information and automatically generates useful statistics.

Health reports can include:

- Number of recorded symptom types
- Average symptom severity
- Number of recurring cases
- Most frequently recorded symptoms
- Number of occurrences for each symptom
- Medications used
- Report date range
- AI-generated health summary

This provides a more structured overview of the information recorded by the user.

---

## 📅 Custom Date Range Reports

Users can select a specific reporting period using:

```text
From Date → To Date
```

Halati then retrieves records associated with the selected period and generates statistics based on those records.

This allows users to create focused reports instead of always analyzing their complete health history.

For example:

```text
01 September 2026
        ↓
15 September 2026
        ↓
Retrieve Records
        ↓
Analyze Symptoms
        ↓
Calculate Statistics
        ↓
Generate Report
```

---

# 🤖 AI-Powered Health Summary

Halati integrates **Google Gemini** to generate a concise Arabic summary based on the health information recorded by the user.

The application prepares structured symptom information and sends relevant fields to the AI model.

The information can include:

- Symptom name
- Location
- Severity
- Whether the symptom is recurring
- Whether medication was taken
- Medication name
- Symptom date
- Notes

The generated summary can describe:

- Frequently recorded symptoms
- General recorded severity
- Recurring symptoms
- Medication usage
- Clear patterns supported by the recorded data

The summary is displayed as part of the health report.

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

Halati can dynamically generate a professional PDF report containing the user's recorded health information.

The generated report can include:

### Report Information

- Report title
- Selected reporting period
- Date range

### Health Statistics

- Number of symptom types
- Average severity
- Number of recurring symptoms

### Symptoms

- Recorded symptom names
- Number of occurrences

### Medications

- Recorded medications used during the selected period

### AI Summary

- AI-generated Arabic summary of the recorded information

### Medical Disclaimer

The PDF includes a clear statement explaining that the generated report summarizes recorded information and does not constitute a medical diagnosis.

---

# 🔔 Daily Health Reminders

Halati includes local notification functionality for supported Android environments.

The application can schedule a daily reminder encouraging users to record or review their health status.

Example notification:

> **حالتي 💙**  
> كيف حالتك اليوم؟

The notification system helps encourage consistent symptom tracking.

The current local notification implementation is designed primarily for **Android**.

---

# 🔐 Authentication System

Halati uses **Supabase Authentication** for account and authentication functionality.

The authentication flow includes:

- User registration
- User login
- Authentication session handling
- Password recovery
- Password reset
- Authentication state monitoring

The application listens for authentication events and can redirect users to the appropriate screen when password recovery is requested.

---

# 🛠️ Technology Stack

Halati combines mobile development, backend services, artificial intelligence, API integration, database management, and document generation.

---

## 💙 Flutter

**Flutter** is the main application development framework used to build Halati.

Flutter is responsible for:

- User interface development
- Navigation
- Forms
- Responsive layouts
- User interaction
- State updates
- Application logic
- Cross-platform development

Using Flutter allows the project to share a single Dart codebase across supported platforms.

---

## 🎯 Dart

**Dart** is the programming language used throughout the application.

Dart is responsible for:

- Application logic
- Asynchronous operations
- Data processing
- API communication
- JSON processing
- UI behavior
- Database communication
- PDF generation
- Notification scheduling

---

## 🟢 Supabase

**Supabase** provides the backend infrastructure for Halati.

It is used primarily for:

### Authentication

Supabase Authentication handles:

- Sign up
- Login
- User sessions
- Password recovery
- Authentication events

### Database

The Supabase database stores health-related records entered through the application.

Symptom records can contain information such as:

```text
condition_name
location
severity
is_repeated
took_medicine
medicine_name
symptom_date
notes
```

### Database Operations

The application performs database operations including:

- Creating symptom records
- Reading symptom records
- Retrieving health history
- Filtering records by date
- Ordering records
- Generating report datasets

---

# 🌐 REST API Integration

Halati communicates with external services using HTTP-based APIs.

The Dart:

```text
http
```

package is used for API communication.

It handles:

- HTTP requests
- POST requests
- Request headers
- JSON request bodies
- API responses
- Status codes
- Error handling

This is primarily used for communication with the Google Gemini API.

---

# 🧠 Google Gemini API

**Google Gemini** provides the artificial intelligence functionality used by Halati.

The general workflow is:

```text
Health Records
      ↓
Flutter Application
      ↓
Prepare Structured Data
      ↓
JSON Encoding
      ↓
HTTP Request
      ↓
Google Gemini API
      ↓
AI-Generated Arabic Summary
      ↓
Health Report
```

This integration demonstrates how generative AI can be incorporated into an application while keeping its role limited to summarizing provided information.

---

# 🔄 JSON Processing

Halati uses JSON when exchanging structured information with external APIs.

The application uses:

```dart
dart:convert
```

for operations such as:

```dart
jsonEncode()
jsonDecode()
```

JSON is particularly important when communicating with Gemini and processing API responses.

---

# 📑 PDF Generation

Halati uses the Dart:

```text
pdf
```

package to dynamically generate health reports.

The PDF system supports:

- A4 documents
- Dynamic content
- Containers
- Borders
- Typography
- Arabic text
- Health statistics
- Symptom lists
- Medication lists
- AI summaries
- Medical disclaimers

Reports are generated programmatically based on the user's selected health records.

---

# 🖨️ Printing

The:

```text
printing
```

package works alongside the PDF package.

It provides functionality related to generated PDF documents on supported platforms.

Together, the two packages allow Halati to transform application data into a structured document.

---

# 🇸🇦 Arabic Language Support

Halati is designed primarily around an Arabic user experience.

The interface uses:

```dart
TextDirection.rtl
```

where appropriate to provide natural **Right-to-Left (RTL)** navigation and content presentation.

Arabic-compatible typography is also used when generating PDF reports.

This ensures that Arabic health information is displayed correctly both inside the application and in generated reports.

---

# 🔤 Typography

The application uses custom typography to maintain a consistent visual identity.

Font configuration is centralized within the project so that screens can share the same typography.

The PDF reporting system separately uses Arabic-compatible fonts to correctly render Arabic text.

---

# 🔔 flutter_local_notifications

The project uses:

```text
flutter_local_notifications
```

for Android local notifications.

It provides functionality for:

- Notification initialization
- Notification permission requests
- Android notification channels
- Scheduled notifications
- Daily reminders

---

# ⏰ Timezone

The:

```text
timezone
```

package is used alongside local notifications.

It provides date and time functionality needed for scheduled reminders.

For example:

```text
8:00 PM
   ↓
Schedule Notification
   ↓
Daily Health Reminder
```

---

# 🔑 Environment Variables

Halati uses:

```text
flutter_dotenv
```

to load environment configuration during development.

An `.env` file can contain values such as:

```env
my_url=YOUR_SUPABASE_URL
my_publishableKey=YOUR_SUPABASE_PUBLISHABLE_KEY
GEMINI_API_KEY=YOUR_GEMINI_API_KEY
```

The real `.env` file should **never be committed to GitHub**.

Instead, the repository should provide:

```text
.env_example
```

containing placeholder values only.

Example:

```env
my_url=YOUR_SUPABASE_URL
my_publishableKey=YOUR_SUPABASE_PUBLISHABLE_KEY
GEMINI_API_KEY=YOUR_GEMINI_API_KEY
```

---

# 📱 Responsive Design

Halati uses responsive screen dimensions to adapt interface elements to different screen sizes.

Reusable screen-size utilities help calculate dimensions dynamically instead of relying entirely on fixed pixel values.

This improves the consistency of the application across different device sizes.

---

# 🎨 UI/UX Design

Halati follows a consistent visual design system.

Reusable values are centralized for elements such as:

- Primary colors
- Background colors
- Card colors
- Text colors
- Borders
- Fonts
- Spacing

The application also uses reusable widgets for shared interface components.

This helps maintain consistency across the application's screens.

---

# 🧩 Reusable Components

Reusable Flutter widgets and utilities are used throughout the application.

Examples include:

- Custom bottom navigation
- Screen size utilities
- Shared color constants
- Shared font constants

This reduces duplicated code and improves maintainability.

---

# 🏗️ Project Structure

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
│   ├── fonts/
│   ├── images/
│   └── ...
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
│   │   └── report_screen.dart
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
├── .env_example
├── .gitignore
├── pubspec.yaml
└── README.md
```

---

# 🧱 System Architecture

The general architecture of Halati can be represented as:

```text
                 ┌─────────────────────────┐
                 │          User           │
                 └────────────┬────────────┘
                              │
                              ▼
                 ┌─────────────────────────┐
                 │      Flutter UI         │
                 │         Dart            │
                 └────────────┬────────────┘
                              │
            ┌─────────────────┼─────────────────┐
            │                 │                 │
            ▼                 ▼                 ▼
    ┌───────────────┐ ┌──────────────┐ ┌───────────────┐
    │   Supabase    │ │ Google       │ │ PDF Generator │
    │   Backend     │ │ Gemini API   │ │               │
    └───────┬───────┘ └──────────────┘ └───────────────┘
            │
       ┌────┴─────┐
       │          │
       ▼          ▼
Authentication  Database
```

---

# 🔄 Application Workflow

A typical user flow through Halati is:

```text
Launch Application
        ↓
Splash Screen
        ↓
Create Account / Login
        ↓
Home Screen
        ↓
Record New Symptom
        ↓
Save Record
        ↓
Supabase Database
        ↓
Health History
        ↓
Search / Filter
        ↓
Select Report Period
        ↓
Generate Health Statistics
        ↓
Generate AI Summary
        ↓
Create PDF Health Report
```

---

# 📊 Health Data Processing

Halati processes retrieved health records locally to generate useful report statistics.

The application can calculate information such as:

```text
Number of Symptom Types
Average Severity
Repeated Cases
Symptom Frequency
Medication List
Report Date Range
```

For example, records with the same symptom name can be grouped together to determine how frequently that symptom was recorded.

---

# 🔒 Security & Privacy Considerations

Because Halati handles user-provided health information, security and privacy are important considerations.

## Environment Variables

Sensitive configuration values should not be committed to Git.

The following should be included in `.gitignore`:

```gitignore
.env
```

---

## API Keys

Real API keys should never be stored in:

```text
README.md
.env_example
Git commits
Public repositories
```

If a secret is accidentally committed, it should be rotated.

---

## Supabase Security

For production environments, Supabase **Row Level Security (RLS)** should be configured carefully so that authenticated users can access only records they are authorized to access.

---

## Production AI Security

Environment variables bundled with a Flutter client should **not be considered secure storage for production secrets**.

Even when `.env` is excluded from GitHub, values included in a compiled client application may potentially be recovered.

A stronger production architecture would be:

```text
Flutter App
     ↓
Secure Backend / Server Function
     ↓
Gemini API
```

For example, a server-side function can securely store the Gemini API key while the Flutter application communicates with that function.

---

# 📦 Main Technologies & Packages

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
| **printing** | PDF handling on supported platforms |
| **flutter_dotenv** | Environment configuration |
| **flutter_local_notifications** | Android local notifications |
| **timezone** | Scheduled notification timing |
| **Git** | Version control |
| **GitHub** | Source code collaboration |
| **VS Code** | Development environment |

---

# 🌐 Platform Support

| Platform | Application | Local Notifications |
|---|---:|---:|
| Android | ✅ | ✅ |
| Chrome / Web | ✅ | Not enabled |
| iOS | Flutter project structure available | Not currently the primary target |
| Windows | Flutter project structure available | Not currently the primary target |
| macOS | Flutter project structure available | Not currently the primary target |
| Linux | Flutter project structure available | Not currently the primary target |

The application checks whether it is running on Web before initializing the Android-focused local notification functionality.

---

# ⚙️ Getting Started

## Prerequisites

Make sure the following tools are installed:

- Flutter SDK
- Dart SDK
- Git
- VS Code or Android Studio
- Chrome
- Android Emulator or Android device

Verify your Flutter installation:

```bash
flutter doctor
```

---

## 1. Clone the Repository

```bash
git clone <YOUR_REPOSITORY_URL>
```

Navigate to the project:

```bash
cd final_project
```

---

## 2. Install Dependencies

Run:

```bash
flutter pub get
```

---

## 3. Configure Environment Variables

Create a file called:

```text
.env
```

inside the project.

Use `.env_example` as a template.

```env
my_url=YOUR_SUPABASE_URL
my_publishableKey=YOUR_SUPABASE_PUBLISHABLE_KEY
GEMINI_API_KEY=YOUR_GEMINI_API_KEY
```

Never place real credentials inside `.env_example`.

---

## 4. Run on Chrome

```bash
flutter run -d chrome
```

The application will run in Flutter Web mode.

Local Android notifications are skipped on Web.

---

## 5. Run on Android

Start an Android Emulator.

Check available devices:

```bash
flutter devices
```

Then run:

```bash
flutter run
```

Alternatively, select the Android Emulator directly from VS Code.

---

# 🧪 Useful Development Commands

### Install Dependencies

```bash
flutter pub get
```

### Analyze the Project

```bash
flutter analyze
```

### Run Tests

```bash
flutter test
```

### Clean Build Files

```bash
flutter clean
```

Then restore dependencies:

```bash
flutter pub get
```

### Run on Chrome

```bash
flutter run -d chrome
```

### View Available Devices

```bash
flutter devices
```

---

# 🌿 Git & GitHub Workflow

Halati is developed collaboratively using Git and GitHub.

Before starting work:

```bash
git pull
```

After completing and testing changes:

```bash
git status
git add .
git commit -m "Describe your changes"
git push
```

Developers should always review changes before committing and make sure no sensitive files are included.

---

# 🤝 Collaboration

Because Halati is a collaborative project, the development workflow emphasizes:

- Git version control
- GitHub collaboration
- Meaningful commit messages
- Pulling remote changes before pushing
- Merge conflict resolution
- Shared project architecture
- Reusable components
- Consistent coding style
- Secure handling of credentials

---

# 👩‍💻 Development Team

**Halati (حالتي)** was designed and developed collaboratively by:

| Developer | Role |
|---|---|
| **Salma Alhababi — سلمى الحبابي** | Software Developer |
| **Buthaina Bin Humaid — بثينة بن حميد** | Software Developer |

The project represents collaborative work across application design and development, including:

- Flutter development
- User interface implementation
- Supabase integration
- Database management
- Authentication
- REST API integration
- Google Gemini AI integration
- Health reporting
- PDF generation
- Notification functionality
- Testing and debugging
- Git and GitHub collaboration

---

# 🎓 Project Purpose

Halati was developed as an educational software project that applies multiple Computer Science and Software Engineering concepts within a real-world application.

The project demonstrates experience with:

```text
Mobile Application Development
          +
Backend Development
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
Responsive UI Development
          +
Version Control
```

Rather than focusing on a single technology, Halati demonstrates how multiple technologies can be integrated to build a complete software solution.

---

# 🚀 Future Improvements

Possible future improvements for Halati include:

- Moving Gemini API requests to a secure backend
- Strengthening user-specific database security
- Custom notification times
- Notification enable/disable settings
- Advanced health charts
- More detailed health trend visualization
- Enhanced report customization
- Secure report sharing
- Doctor-friendly report formats
- Additional health statistics
- Improved accessibility
- Additional localization
- Automated testing
- Improved error handling
- Offline capabilities
- Enhanced account settings
- Improved AI report customization

---

# ⚠️ Medical Disclaimer

**Halati is intended for health tracking and information organization purposes only.**

The application does not:

- Diagnose diseases or medical conditions
- Replace professional medical advice
- Replace a healthcare professional
- Recommend medical treatments
- Provide emergency medical services

AI-generated content within Halati is intended to summarize information entered into the application.

Users should consult qualified healthcare professionals regarding medical concerns, diagnosis, and treatment.

---

# 📄 License

This project was developed for **educational purposes**.

All rights to the project remain with its developers unless otherwise specified.

---

# 💙 Halati

<p align="center">
  <strong>حالتي | Halati</strong>
</p>

<p align="center">
  Smart Health Tracking & Reporting
</p>

<p align="center">
  <strong>Track • Understand • Organize</strong>
</p>

<p align="center">
  لا بأس، طهور إن شاء الله
</p>

<p align="center">
  Developed with 💙 by
  <br>
  <strong>Salma Alhababi & Buthaina Bin Humaid</strong>
</p>
