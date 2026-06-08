# Build Service App

Flutter MVP приложения для сервиса поиска строительных специалистов и заказов.

## Что реализовано

- регистрация пользователя с выбором роли
- вход по email и паролю
- вход и регистрация через Google
- главная страница с понятным сценарием
- каталог специалистов с фильтрами
- карточка специалиста
- каталог заказов с фильтрами
- страница заказа
- создание заказа для заказчика
- отклик на заказ для специалиста
- профиль текущего пользователя
- редактирование анкеты специалиста
- состояния загрузки, пустых списков, ошибок и валидации

## Технологии

- Flutter
- Dart
- `provider`
- `go_router`
- `dio`
- `flutter_secure_storage`
- `firebase_auth`
- `google_sign_in`

## Режимы работы

По умолчанию приложение запускается в demo-режиме:

- `USE_MOCK_API=true`
- данные берутся из встроенного mock-репозитория
- можно сразу проверять сценарии без backend

Для подключения реального backend используйте:

```bash
flutter run --dart-define=USE_MOCK_API=false --dart-define=API_BASE_URL=http://10.0.2.2:3000
```

## Тестовые аккаунты

- Заказчик: `customer@test.ru` / `123456`
- Специалист: `specialist@test.ru` / `123456`

## Структура проекта

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

## Быстрый запуск

В этой среде Flutter SDK не был доступен, поэтому проект подготовлен вручную. После установки Flutter выполните:

```bash
flutter create .
flutter pub get
flutter run
```

Если открываете проект в Android Studio, сначала также выполните `flutter create .` в корне проекта, чтобы Flutter сгенерировал платформенные папки `android/`, `ios/`, `web/` и служебные файлы.

## Подключение Google Firebase Authentication

По умолчанию Google-вход работает в demo-режиме, чтобы проект запускался даже без Firebase.

Чтобы включить реальный Google Sign-In:

1. Создайте Firebase-проект.
2. Подключите Android-приложение.
3. Выполните `flutterfire configure`.
4. Замените содержимое `lib/config/firebase_options.dart` на реальные настройки.
5. Добавьте `google-services.json` в `android/app/`.
6. Запустите приложение с флагом:

```bash
flutter run --dart-define=ENABLE_FIREBASE_GOOGLE_AUTH=true
```

## Ожидаемые API-эндпоинты

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

Все защищённые запросы отправляются с JWT-токеном в заголовке `Authorization: Bearer <token>`.

## GitHub

Пример команд для публикации:

```bash
git init
git checkout -b android
git add .
git commit -m "feat: flutter construction service app"
git remote add origin https://github.com/<username>/<repository>.git
git push -u origin android
```

## Что ещё можно доделать

- screenshots основных экранов после запуска на эмуляторе
- сборка APK через `flutter build apk`
- чат между заказчиком и специалистом
- избранные специалисты
- тёмная тема
