class AppConfig {
  static const bool useMockApi =
      bool.fromEnvironment('USE_MOCK_API', defaultValue: true);

  static const bool enableFirebaseGoogleAuth = bool.fromEnvironment(
    'ENABLE_FIREBASE_GOOGLE_AUTH',
    defaultValue: false,
  );

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:3000',
  );
}
