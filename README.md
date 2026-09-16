# Flutter Firebase Provider App

A Flutter project demonstrating Firebase Authentication and Cloud Firestore using the Provider state-management pattern.

## Features

- Firebase initialization
- Email/password sign-up
- Email/password sign-in
- Sign-out
- Authentication state monitoring
- Cloud Firestore asset streams
- Firestore user-data reads
- Provider state management
- ChangeNotifier
- MultiProvider
- Consumer
- context.read
- context.watch
- Clean separation between authentication, repository, and UI logic

## Architecture

```text
                    MultiProvider
                         |
          +--------------+--------------+
          |                             |
     AuthService                 AssetRepository
   ChangeNotifier                 ChangeNotifier
          |                             |
   Firebase Auth                 Cloud Firestore
          |                             |
     AuthScreen                    HomeScreen
```

## AuthService

`AuthService` is responsible only for Firebase Authentication logic.

It handles:

- Sign up
- Sign in
- Sign out
- Authentication state changes
- Loading state
- Authentication errors

The service extends:

```dart
ChangeNotifier
```

UI widgets interact with the service through Provider instead of accessing `FirebaseAuth` directly.

Example:

```dart
context.read<AuthService>().signIn(
  email: email,
  password: password,
);
```

Reactive state can be consumed using:

```dart
context.watch<AuthService>()
```

## AssetRepository

`AssetRepository` is responsible only for Cloud Firestore read operations.

It handles:

- Fetching the real-time asset stream
- Fetching user data

It also extends:

```dart
ChangeNotifier
```

Example:

```dart
context
    .read<AssetRepository>()
    .getAssetsStream();
```

## Firestore Assets

Assets are stored in:

```text
assets/
```

Example fields:

```text
id
location
latitude
longitude
status
```

The asset stream is displayed using a `StreamBuilder`.

```text
Cloud Firestore
      |
      v
AssetRepository
      |
      v
Stream<List<AssetModel>>
      |
      v
HomeScreen
```

## Provider Setup

Both dependencies are provided at the root of the widget tree:

```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(
      create: (_) => AuthService(),
    ),
    ChangeNotifierProvider(
      create: (_) => AssetRepository(),
    ),
  ],
  child: const ProviderFirebaseApp(),
)
```

## Project Structure

```text
lib/
├── main.dart
├── firebase_options.dart
│
├── models/
│   └── asset_model.dart
│
├── repositories/
│   └── asset_repository.dart
│
├── services/
│   └── auth_service.dart
│
└── screens/
    ├── auth_screen.dart
    └── home_screen.dart
```

## Main Dependencies

```text
firebase_core
firebase_auth
cloud_firestore
provider
```

See `pubspec.yaml` for the installed versions.

## Run the Project

Install dependencies:

```bash
flutter pub get
```

Run static analysis:

```bash
flutter analyze
```

Run the application:

```bash
flutter run
```

## Code Quality

Format Dart code:

```bash
dart format lib
```

Check for analyzer issues:

```bash
flutter analyze
```

## Git Workflow

The project uses a GitFlow-style workflow:

```text
feature/* -> develop -> main
```

Example feature branch:

```text
feature/firebase-provider-setup
```

## Technologies

- Flutter
- Dart
- Firebase Core
- Firebase Authentication
- Cloud Firestore
- Provider
- Git
- GitHub
