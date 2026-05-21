# 🌱 DailyBit
**Sedikit setiap hari, besar hasilnya.**
A gamified habit tracker & daily diary app built with Flutter, inspired by Duolingo's bouncy and playful UI. Build better habits, journal your thoughts, and track your personal growth — one day at a time.
---
## ✨ Features
### 🎯 Habit Tracking
- **3 Habit Types** — Regular (daily routine), Negative (e.g. quit smoking), and One-Time TODO
- **Goal System** — Duration-based timer with countdown, repeat-based counter, or simple check-off
- **Time Scheduling** — Organize habits by Anytime, Morning, Afternoon, or Evening
- **Repeat Frequency** — Every Day, Week, Month, or Year
- **Color Customization** — 7 color palettes to personalize your habits
- **Current Focus** — Pin your most important habit as a hero card
### 🔥 Streak System
- Consecutive day tracking with animated fire icon
- Streak counter displayed on home and diary views
### 📔 Daily Diary
- Write daily journal entries with mood tracking
- **5 Mood Levels** — Horrible, Sad, Neutral, Happy, Amazing (with custom SVG emojis)
- Filter entries by time period and mood level
### 📊 History & Achievements
- **Calendar View** — Browse completed habits by date with Cupertino calendar
- **All Habits** — View all habits organized by time-of-day category
- **4 Achievements** — Wildfire 🔥, Early Bird 🌅, Scholar 📚, Legendary 🏆 — each with progress tracking
### 👤 Profile & Settings
- Editable display name and profile photo
- Stats dashboard (streak, completed, total habits)
- Daily reminder notifications at configurable time
- Selective data deletion
### ☁️ Cloud Sync
- Upload & restore all data to/from Firebase Firestore
- Debounced auto-sync after every change
- Auto-restore on login
- Profile photo stored in Firebase Storage
### 🔐 Authentication
- Email & Password sign up/sign in
- Google Sign-In
- Guest (anonymous) mode
- Password reset via email
---
## 🛠️ Tech Stack
|
 Category 
|
 Technology 
|
|
----------
|
-----------
|
|
**
Framework
**
|
 Flutter (SDK ^3.11.1) 
|
|
**
Language
**
|
 Dart 
|
|
**
State Management
**
|
 Provider 
|
|
**
Local Database
**
|
 Isar Plus (enhanced fork with web support) 
|
|
**
Cloud Backend
**
|
 Firebase (Auth, Firestore, Storage) 
|
|
**
UI Components
**
|
 Chiclet (3D buttons), FlexColorScheme, Flutter Animate 
|
|
**
Fonts
**
|
 Fredoka (headings), Nunito (body), Plus Jakarta Sans (onboarding) 
|
|
**
Notifications
**
|
 flutter_local_notifications + timezone 
|
---
## 📱 Screenshots
> Coming soon
---
## 🚀 Getting Started
### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) ^3.11.1
- [Android Studio](https://developer.android.com/studio) or [VS Code](https://code.visualstudio.com/)
- A Firebase project (for authentication & cloud sync)
### Installation
1. **Clone the repository**
   ```bash
   git clone https://github.com/Masykster/DailyBit.git
   cd DailyBit
   ```
2. **Set up Firebase configuration**
   This project requires Firebase config files that are **not included** in the repository for security reasons. You need to obtain these files:
   | File | Location | Purpose |
   |------|----------|---------|
   | `google-services.json` | `android/app/` | Android Firebase config |
   | `firebase_options.dart` | `lib/` | Flutter Firebase options |
   | `GoogleService-Info.plist` | `ios/Runner/` | iOS Firebase config (optional) |
   **Option A — Generate from your own Firebase project:**
   ```bash
   # Install FlutterFire CLI
   dart pub global activate flutterfire_cli
   # Configure (select Android & iOS)
   flutterfire configure
   ```
   **Option B — Request from the project owner:**
   Contact the repository maintainer to get the config files directly.
3. **Install dependencies**
   ```bash
   flutter pub get
   ```
4. **Generate native splash screen**
   ```bash
   dart run flutter_native_splash:create
   ```
5. **Run the app**
   ```bash
   flutter run
   ```
### Build APK
```bash
flutter build apk
```
The APK will be generated at:
```
build/app/outputs/flutter-apk/app-release.apk
```
---
## 📁 Project Structure
```
lib/
├── main.dart                     # App entry, theme, providers
├── firebase_options.dart         # Firebase configuration
├── models/
│   ├── habit.dart                # Habit data model (Isar)
│   ├── habit_log.dart            # Habit completion log (Isar)
│   └── diary_entry.dart          # Diary entry model (Isar)
├── providers/
│   ├── habit_provider.dart       # Habit state & streak logic
│   └── diary_provider.dart       # Diary entry state
├── screens/
│   ├── splash_screen.dart        # Animated splash + auth routing
│   ├── onboarding_screen.dart    # 4-page intro
│   ├── sign_in_screen.dart       # Login screen
│   ├── sign_up_screen.dart       # Registration screen
│   ├── forgot_password_screen.dart
│   ├── home_page.dart            # Bottom nav shell
│   └── views/
│       ├── home_view.dart        # Daily habit dashboard
│       ├── diary_view.dart       # Journal & mood tracking
│       ├── history_view.dart     # Calendar, all habits, achievements
│       └── me_view.dart          # Profile & settings
├── services/
│   ├── auth_service.dart         # Firebase authentication
│   ├── database_helper.dart      # Isar database operations
│   ├── sync_service.dart         # Cloud sync (Firestore)
│   └── notification_service.dart # Local notifications
├── utils/
│   ├── app_toast.dart            # Toast notification wrapper
│   ├── auth_error_mapper.dart    # Firebase error → user message
│   └── app_fonts.dart            # Font constants
└── widgets/
    ├── chiclet_habit_card.dart    # Main habit card with goal controls
    ├── home_widgets.dart         # Week selector, time filters
    ├── diary_widgets.dart        # Diary cards, mood data, filters
    ├── habit_card.dart           # Simple habit card
    └── task_card.dart            # Task card for calendar view
```
---
## 📦 Dependencies
<details>
<summary>Click to expand full dependency list</summary>
|
 Package 
|
 Version 
|
 Purpose 
|
|
---------
|
---------
|
---------
|
|
`provider`
|
 ^6.1.2 
|
 State management 
|
|
`isar_plus`
|
 ^1.2.5 
|
 Local database 
|
|
`isar_plus_flutter_libs`
|
 ^1.2.5 
|
 Isar native libraries 
|
|
`path_provider`
|
 ^2.1.5 
|
 File system paths 
|
|
`shared_preferences`
|
 ^2.2.3 
|
 Key-value storage (migration) 
|
|
`intl`
|
 ^0.20.2 
|
 Date formatting 
|
|
`google_fonts`
|
 ^6.2.1 
|
 Custom fonts 
|
|
`flutter_local_notifications`
|
 ^21.0.0 
|
 Local notifications 
|
|
`timezone`
|
 ^0.11.0 
|
 Timezone support 
|
|
`flutter_svg`
|
 ^2.2.4 
|
 SVG rendering 
|
|
`chiclet`
|
 ^1.2.1 
|
 3D animated buttons 
|
|
`font_awesome_flutter`
|
 ^11.0.0 
|
 FontAwesome icons 
|
|
`flutter_animate`
|
 ^4.5.2 
|
 Declarative animations 
|
|
`firebase_core`
|
 ^4.7.0 
|
 Firebase core 
|
|
`firebase_auth`
|
 ^6.4.0 
|
 Authentication 
|
|
`google_sign_in`
|
 ^6.2.1 
|
 Google OAuth 
|
|
`flutter_native_splash`
|
 ^2.4.7 
|
 Native splash screen 
|
|
`cupertino_calendar_picker`
|
 ^2.2.6 
|
 iOS-style calendar 
|
|
`persistent_bottom_nav_bar`
|
 ^6.2.1 
|
 Bottom navigation 
|
|
`flex_color_scheme`
|
 ^8.0.0 
|
 Material 3 theming 
|
|
`cloud_firestore`
|
 ^6.3.0 
|
 Cloud database 
|
|
`firebase_storage`
|
 ^13.0.0 
|
 File storage 
|
|
`image_picker`
|
 ^1.2.2 
|
 Photo picker 
|
|
`cherry_toast`
|
 ^1.13.0 
|
 Toast notifications 
|
|
`circular_countdown_timer`
|
 ^0.2.4 
|
 Countdown timer UI 
|
|
`introduction_screen`
|
 ^4.0.0 
|
 Onboarding flow 
|
</details>
---
## 🎨 Design
DailyBit follows a **Duolingo-inspired** design language:
- 🟢 **Duolingo Green** (`#58CC02`) as primary color
- 🔵 **Sky Blue** (`#1CB0F6`) as secondary color
- 🅰️ **Fredoka** for bold headings, **Nunito** for body text
- 🎮 **Chiclet 3D buttons** for interactive, bouncy feel
- ✨ **Smooth animations** throughout using `flutter_animate`
- 🌊 **Gradient backgrounds** and soft shadows
---
## 👥 Contributors
- **Masykster** — Creator & Developer
---
## 📄 License
This project is for educational and personal use.
---
<p align="center">
  <b>DailyBit</b> — Build better habits, one day at a time. 💪
</p>
