# Peace - Mental Health & Wellness App

A comprehensive Flutter-based mobile application designed to support mental health and wellness through mood tracking, standardized mental health assessments, and personalized analytics.

**Website & APK download:** https://gowthamaanp.github.io/peace_app/ (served from [docs/](docs/) via GitHub Pages)
**Privacy Policy:** https://gowthamaanp.github.io/peace_app/privacy-policy.html

## 🌟 Features

### Core Features

- **🔐 Phone Authentication**: Secure Firebase phone authentication with OTP verification
- **😊 Daily Mood Tracking**: Track your daily mood with emoji-based logging and streak tracking
- **📊 Mental Health Assessments**:
  - DASS-21 (Depression, Anxiety, Stress Scale)
  - PHQ-9 (Patient Health Questionnaire)
- **📈 Analytics Dashboard**: Visualize mood trends and assessment history with interactive charts
- **💬 Motivational Quotes**: Daily inspirational quotes to uplift your spirits
- **🌓 Theme Support**: Light and dark theme modes with seamless switching
- **🔔 Emergency Contacts**: Quick access to emergency support contacts

### User Profile Management

- Complete profile setup and editing
- Personal information management
- Emergency contact configuration
- Preferred contact method selection

### Assessment Features

- **DASS-21 Assessment**: Comprehensive evaluation of depression, anxiety, and stress levels
- **PHQ-9 Assessment**: Multi-section questionnaire for mental health screening
- Test history tracking and results visualization
- Score comparison and trend analysis

## 🛠️ Technology Stack

### Framework & Language

- **Flutter**: ^3.9.2 SDK
- **Dart**: Cross-platform development

### Backend Services

- **Firebase Core**: ^4.1.1 - Firebase initialization
- **Firebase Auth**: ^6.1.0 - Phone authentication
- **Cloud Firestore**: ^6.0.2 - Real-time database for user data

### State Management & Storage

- **Provider**: ^6.1.2 - State management solution
- **Shared Preferences**: ^2.3.4 - Local data persistence

### UI Components & Libraries

- **FL Chart**: ^1.1.0 - Interactive charts for analytics
- **Pinput**: ^5.0.0 - OTP input field
- **Internet Connection Checker**: ^3.0.1 - Network connectivity monitoring
- **Permission Handler**: ^12.0.1 - Runtime permissions
- **URL Launcher**: ^6.3.2 - External link handling
- **Intl**: ^0.20.2 - Internationalization and date formatting

### Development Tools

- **Flutter Launcher Icons**: ^0.14.4 - App icon generation
- **Flutter Lints**: ^5.0.0 - Code quality and style enforcement

## 📱 Project Structure

```
lib/
├── main.dart                          # App entry point
├── core/
│   ├── config/
│   │   ├── config.dart
│   │   └── firebase_options.dart      # Firebase configuration
│   ├── constants/                     # App-wide constants
│   └── theme/                         # Theme management
│       ├── app_theme.dart
│       ├── theme_helper.dart
│       ├── theme_manager.dart
│       └── theme_provider.dart
├── models/
│   ├── quote.dart                     # Quote model
│   ├── test_results.dart              # Assessment results model
│   └── user.dart                      # User profile model
├── screens/
│   ├── home_screen.dart               # Main dashboard
│   ├── test_history_screen.dart       # Assessment history
│   ├── assessments/
│   │   ├── dass/                      # DASS-21 assessment screens
│   │   └── phq/                       # PHQ-9 assessment screens
│   ├── auth/
│   │   ├── phone_login_screen.dart    # Phone authentication
│   │   └── otp_verification_screen.dart
│   ├── common/
│   │   ├── splash_screen.dart
│   │   └── no_internet_connection_screen.dart
│   ├── profile/                       # Profile management screens
│   └── tabs/                          # Tab-based navigation screens
│       └── analytics_tab.dart         # Analytics dashboard
├── services/
│   ├── firebase_auth_service.dart     # Authentication logic
│   ├── firestore_service.dart         # Firestore operations
│   ├── mood_tracking_service.dart     # Mood tracking functionality
│   └── user_profile_service.dart      # User profile operations
├── utils/
│   ├── permission_handler.dart        # Permission management
│   └── utils.dart                     # Utility functions
└── widgets/
    ├── loading_widget.dart            # Loading indicators
    └── widgets.dart                   # Reusable UI components
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.9.2 or higher)
- Dart SDK
- Android Studio / VS Code with Flutter extensions
- Firebase project setup

### Installation

1. **Clone the repository**

   ```bash
   git clone <repository-url>
   cd peace
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Firebase Setup**

   - Create a new Firebase project
   - Enable Phone Authentication in Firebase Console
   - Enable Cloud Firestore
   - Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Place configuration files in respective directories
   - Update `lib/core/config/firebase_options.dart` with your Firebase configuration

4. **Configure App Icons**

   ```bash
   flutter pub run flutter_launcher_icons
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

### Building for Release

**Android:**

```bash
flutter build apk --release
# or for app bundle
flutter build appbundle --release
```

**iOS:**

```bash
flutter build ios --release
```

## 📋 Configuration

### Firebase Configuration

Ensure your `firebase_options.dart` is properly configured with your Firebase project credentials.

### Permissions

The app requires the following permissions:

- Phone authentication
- Internet access
- Storage (for local data caching)

## 🎨 Theming

The app supports both light and dark themes with custom fonts:

- **OpenSans**: Primary font family (Light, Regular, Bold)
- **Teachers**: Secondary font family (Regular, Italic, Bold)

## 📊 Firestore Database Structure

```
users/
  {uid}/
    - name, email, phoneNumber, age, gender
    - emergencyContact, emergencyContactName
    - preferredContactMethod

    mood_entries/
      {entryId}/
        - emoji, label, timestamp

    mood_metadata/
      streak/
        - currentStreak, lastMoodDate

    test_results/
      {testId}/
        - testType (DASS, PHQ)
        - scores, timestamp, results
```

## 🔒 Firestore Security Rules

Rules live in [firestore.rules](firestore.rules) (scoped to `request.auth.uid == userId` for every document under `users/{userId}/**`). Deploy after any change:

```bash
firebase deploy --only firestore:rules
```

## 🌐 Website & Releasing a New APK

The [docs/](docs/) folder is a static site served by GitHub Pages (repo Settings → Pages → deploy from `main` / `docs`). To ship a new build:

```bash
flutter build apk --release
cp build/app/outputs/flutter-apk/app-release.apk docs/downloads/peace.apk
git add docs/downloads/peace.apk
git commit -m "Update downloadable APK"
```

## 🧪 Testing

Run tests using:

```bash
flutter test
```

## 📦 Dependencies Overview

| Package                     | Purpose                 |
| --------------------------- | ----------------------- |
| firebase_core               | Firebase initialization |
| firebase_auth               | User authentication     |
| cloud_firestore             | Database operations     |
| provider                    | State management        |
| fl_chart                    | Data visualization      |
| pinput                      | OTP input interface     |
| intl                        | Date/time formatting    |
| shared_preferences          | Local storage           |
| internet_connection_checker | Network monitoring      |

## 🤝 Contributing

This is an educational project. If you'd like to contribute:

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Open a Pull Request

## 📄 License

This project is part of a B.Tech academic pursuit.

## 🔗 Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Firebase Documentation](https://firebase.google.com/docs)
- [DASS-21 Information](https://www2.psy.unsw.edu.au/dass/)
- [PHQ-9 Information](https://www.apa.org/depression-guideline/patient-health-questionnaire.pdf)

## 📞 Support

For issues or questions related to this project, please open an issue in the repository.

---

**Built with ❤️ for mental health awareness and support**
