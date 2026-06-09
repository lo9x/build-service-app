# Build Service App

Flutter MVP for a construction marketplace with shared REST API, role-based flows, mock/demo mode, and secure local configuration through `.env`.

## Features

- registration with role selection
- login with email and password
- Google sign-in flow for Firebase mode
- home screen with role-based actions
- specialists catalog with filters
- specialist profile details
- orders catalog with filters
- order details page
- order creation for customers
- response submission for specialists
- current user profile
- specialist profile editing
- loading, validation, empty-state, and error handling

## Security Rules

- We do not commit real Firebase configuration, database secrets, service account keys, or backend credentials.
- Local values live in `.env`, which is ignored by git.
- The repository contains only `.env.example`.
- For Android and iOS, local Firebase files such as `google-services.json` and `GoogleService-Info.plist` are ignored too.

Important:
Client-side Flutter apps must never contain real database passwords or server secrets. Those belong only in the backend `.env`. In the mobile app, only public client configuration should be used, and all sensitive operations must go through your Node.js backend.

## Tech Stack

- Flutter
- Dart
- Provider
- GoRouter
- Dio
- flutter_secure_storage
- flutter_dotenv
- Firebase Auth
- Google Sign-In

## Local Env Setup

1. Copy `.env.example` to `.env`
2. Fill in local values
3. Run the app

Example:

```bash
copy .env.example .env
```

## Demo Mode

By default the app is expected to run in mock mode:

- `USE_MOCK_API=true`
- built-in demo data is used
- you can test flows without backend

Test accounts in mock mode:

- Customer: `customer@test.ru` / `123456`
- Specialist: `specialist@test.ru` / `123456`

## Real Backend Mode

To connect the shared backend, set:

```env
USE_MOCK_API=false
API_BASE_URL=http://10.0.2.2:3000
```

Expected endpoints:

- `POST /api/auth/register`
- `POST /api/auth/login`
- `POST /api/auth/google`
- `GET /api/specialists`
- `GET /api/specialists/:id`
- `POST /api/specialists`
- `PUT /api/specialists/:id`
- `GET /api/orders`
- `GET /api/orders/:id`
- `POST /api/orders`
- `POST /api/responses`
- `GET /api/responses/order/:id`

Protected requests must send:

```text
Authorization: Bearer <jwt>
```

## Firebase Setup

Google sign-in is disabled by default and can stay disabled in demo mode.

To enable real Firebase Auth:

1. Create a Firebase project
2. Add your Android app there
3. Put local values into `.env`
4. Place `google-services.json` locally into `android/app/`
5. Start the app with:

```env
ENABLE_FIREBASE_GOOGLE_AUTH=true
```

Do not push:

- `.env`
- `google-services.json`
- `GoogleService-Info.plist`
- service account json files

## Project Structure

```text
lib/
  app.dart
  main.dart
  config/
  core/
    models/
    network/
    services/
    storage/
  features/
    auth/
    home/
    orders/
    profile/
    specialists/
  shared/
    theme/
    widgets/
```

## Run

Flutter SDK was not available in this environment, so the project was prepared manually. After Flutter is installed, run:

```bash
flutter create .
flutter pub get
flutter run
```

If you want Android specifically:

```bash
flutter run -d android
```

If you only want to preview UI quickly after Flutter installation:

```bash
flutter run -d chrome
```

## GitHub

Recommended flow:

```bash
git checkout android
git add .
git commit -m "feat: flutter construction service app"
git push -u origin android
```

## Current Limitation

The source code is ready, but I could not execute `flutter pub get`, `flutter run`, or build APK in this environment because Flutter SDK is not installed here yet. Once Flutter is installed on your machine, the next step is to generate platform folders and run the app locally.
