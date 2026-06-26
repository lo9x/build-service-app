# Build Service

Build Service is a Flutter application for finding construction specialists and publishing construction orders.

The project includes:
- Flutter web client
- Flutter Android client
- shared data model for users, specialists, orders, and responses
- two backend modes:
  - local REST API mode
  - Firebase Firestore mode for shared cloud data

## Main сценарии

Guest:
- browses specialists
- browses orders
- opens auth screen

Customer:
- registers and signs in
- creates an order
- browses specialists
- sees responses for own orders

Specialist:
- registers and signs in
- edits own profile
- browses orders
- sends a response to an order

## Screens

- home
- sign in
- registration
- specialists catalog
- specialist details
- orders catalog
- order details
- create order
- send response
- current user profile
- management panel for filling shared data from desktop

## Test accounts

- `admin@buildservice.ru` / `admin123456`
- `customer@test.ru` / `123456`
- `customer2@test.ru` / `123456`
- `specialist@test.ru` / `123456`
- `nikita@test.ru` / `123456`
- `alina@test.ru` / `123456`

## Local launch

1. Create local env file:

```powershell
Copy-Item .env.example .env
```

2. Install packages:

```powershell
flutter pub get
```

3. Run web locally:

```powershell
flutter run -d chrome
```

4. If you want the local REST API mode, run the backend in a separate terminal:

```powershell
powershell -ExecutionPolicy Bypass -File backend\start_api.ps1
```

## Firebase mode

The project now supports Firebase Firestore as the shared cloud data source.

When Firebase config is present, the app switches from local REST mode to Firestore mode automatically.

### What you need from Firebase Console

Open:
- Firebase Console
- your project
- `Project settings`
- `General`
- `Your apps`

Create at least:
- one Web app
- one Android app if you plan to build APK with the same cloud data

Then copy values into `.env`.

### Required `.env` fields for web

```env
FIREBASE_WEB_API_KEY=
FIREBASE_WEB_APP_ID=
FIREBASE_WEB_MESSAGING_SENDER_ID=
FIREBASE_WEB_PROJECT_ID=
FIREBASE_WEB_AUTH_DOMAIN=
FIREBASE_WEB_STORAGE_BUCKET=
```

### Required `.env` fields for Android

```env
FIREBASE_ANDROID_API_KEY=
FIREBASE_ANDROID_APP_ID=
FIREBASE_ANDROID_MESSAGING_SENDER_ID=
FIREBASE_ANDROID_PROJECT_ID=
FIREBASE_ANDROID_STORAGE_BUCKET=
```

### Optional Google sign-in

If you configure Google provider in Firebase Authentication, set:

```env
ENABLE_FIREBASE_GOOGLE_AUTH=true
```

### Firestore rules

The repository contains:
- `firestore.rules`
- `firestore.indexes.json`

Current rules are open for demo usage so the project can work quickly during coursework review.

Before real production use, these rules must be tightened.

## Build web

```powershell
flutter build web
```

Output:

```text
build/web
```

## Deploy to Firebase Hosting

1. Log in to Firebase CLI on your machine.
2. Make sure `.firebaserc` points to your Firebase project id.
3. Build web:

```powershell
flutter build web
```

4. Deploy:

```powershell
firebase deploy --only hosting,firestore
```

If `firebase` is not in PATH on Windows, use:

```powershell
C:\Users\User\AppData\Roaming\npm\firebase.cmd deploy --only hosting,firestore
```

After deploy, the site works independently from the computer on:

```text
https://build-service-app.web.app
```

## APK

After Android SDK is installed and configured:

```powershell
flutter build apk
```

APK path:

```text
build/app/outputs/flutter-apk/app-release.apk
```

Android will use Firebase only after you add Android Firebase config to `.env` or `google-services.json`.

## Security

These files are not committed:
- `.env`
- `.firebaserc`
- `google-services.json`
- `GoogleService-Info.plist`
- local backend data

This keeps local secrets and Firebase project bindings outside the repository.
