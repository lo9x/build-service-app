# Build Service App

Build Service App is a Flutter MVP application for a construction services marketplace.
The app allows customers to create construction orders and specialists to browse orders and send responses.

## Project Goal

The purpose of the project is to demonstrate a working mobile MVP connected to a shared backend architecture through REST API.

The application supports two main roles:

- Customer
- Specialist

## Main Features

- user registration
- user login
- role selection during registration
- customer profile with company type and INN
- specialist profile editing
- specialists catalog
- specialist details page
- orders catalog
- order details page
- create order form
- send response to order
- current user profile
- loading, validation, and error states
- demo mode with mock data
- local `.env` configuration for safe secret handling

## Roles

### Guest

- can browse specialists
- can browse orders
- can open auth screen

### Customer

- can register and log in
- can create orders
- can view own order responses
- can manage personal profile data

### Specialist

- can register and log in
- can edit specialist questionnaire
- can browse orders
- can send responses to orders

## Tech Stack

- Flutter
- Dart
- Provider
- GoRouter
- Dio
- Flutter Secure Storage
- Firebase Authentication (optional for Google Sign-In)
- REST API
- JWT authentication

## Security

Sensitive configuration is not stored in the repository.

The project uses:

- `.env.example` for template configuration
- local `.env` for private values
- ignored Firebase config files
- no database credentials in the mobile client

Important: real database secrets must only be stored on the backend side.

## Demo Mode

By default, the app can work in demo mode with local mock data.

Test accounts:

- Customer: `customer@test.ru` / `123456`
- Specialist: `specialist@test.ru` / `123456`

## Expected API Endpoints

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

## Project Structure

```text
lib/
  app.dart
  main.dart
  config/
  core/
  features/
    auth/
    home/
    orders/
    profile/
    specialists/
  shared/
```

## How to Run

1. Install Flutter SDK
2. Open the project folder
3. Create local env file
4. Install dependencies
5. Run the app

Commands:

```bash
copy .env.example .env
flutter pub get
flutter run
```

To run in browser:

```bash
flutter run -d chrome
```

## Presentation Scenario

The application can be demonstrated in the following order:

1. registration/login
2. customer creates order
3. specialist opens orders catalog
4. specialist opens order details
5. specialist sends response
6. customer views response in order page

## Result

The project represents a complete Flutter MVP for coursework submission with a clean UI, role-based flows, demo support, and secure local configuration.
