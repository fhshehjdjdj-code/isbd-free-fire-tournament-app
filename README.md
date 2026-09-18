# ISBD Free Fire Tournament App

A Flutter-based mobile application for Free Fire tournament registration and management.

## Features
- Tournament listing
- Player registration form
- Team name and UID fields
- Dark mobile app UI
- Provider-based state management

## Tech Stack
- Flutter
- Dart
- Provider
- Firebase-ready structure

## Run Locally

1. Install Flutter SDK.
2. Clone the repository.
3. Run:

```bash
flutter pub get
flutter run
```

## Project Structure

```text
lib/
├── main.dart
├── models/
│   ├── tournament_model.dart
│   └── user_model.dart
├── providers/
│   ├── tournament_provider.dart
│   └── user_provider.dart
├── screens/
│   ├── home_screen.dart
│   ├── registration_screen.dart
│   └── tournament_list_screen.dart
└── services/  (future)
```

## Notes
This is a starter app for Android. You can later connect Firebase, admin panel, and live tournament APIs.
