import 'package:flutter/foundation.dart';

import '../../../core/models/app_user.dart';
import '../../../core/models/auth_session.dart';
import '../../../core/services/app_repository.dart';
import '../../../core/services/google_auth_service.dart';
import '../../../core/storage/token_storage.dart';

class AuthController extends ChangeNotifier {
  AuthController({
    required AppRepository repository,
    required TokenStorage tokenStorage,
    GoogleAuthService? googleAuthService,
  })  : _repository = repository,
        _tokenStorage = tokenStorage,
        _googleAuthService = googleAuthService ?? GoogleAuthService();

  final AppRepository _repository;
  final TokenStorage _tokenStorage;
  final GoogleAuthService _googleAuthService;

  AppUser? _user;
  String? _token;
  bool _initialized = false;
  bool _isBusy = false;
  String? _error;

  AppUser? get user => _user;
  String? get token => _token;
  bool get initialized => _initialized;
  bool get isBusy => _isBusy;
  String? get error => _error;
  bool get isAuthenticated => _user != null && _token != null;
  bool get isCustomer => _user?.isCustomer ?? false;
  bool get isSpecialist => _user?.isSpecialist ?? false;

  Future<void> restoreSession() async {
    final stored = await _tokenStorage.readSession();
    if (stored != null) {
      _token = stored.token;
      _user = stored.user;
    }
    _initialized = true;
    notifyListeners();
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    return _perform(() async {
      final session = await _repository.login(email: email, password: password);
      await _setSession(session.token, session.user);
    });
  }

  Future<bool> register(RegisterRequest request) async {
    return _perform(() async {
      final session = await _repository.register(request);
      await _setSession(session.token, session.user);
    });
  }

  Future<bool> continueWithGoogle({
    required GoogleSignInProfile profile,
    required UserRole role,
    CustomerType? customerType,
    String? inn,
    String? verificationDocumentUrl,
  }) async {
    return _perform(() async {
      final googleIdentity = await _googleAuthService.signIn(
        fallbackProfile: profile,
      );
      final session = await _repository.signInWithGoogle(
        GoogleAuthRequest(
          googleIdToken: googleIdentity.idToken,
          name: googleIdentity.name,
          email: googleIdentity.email,
          city: googleIdentity.city,
          role: role,
          customerType: customerType,
          inn: inn,
          verificationDocumentUrl: verificationDocumentUrl,
        ),
      );
      await _setSession(session.token, session.user);
    });
  }

  Future<void> logout() async {
    _token = null;
    _user = null;
    _error = null;
    await _tokenStorage.clear();
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<void> refreshStoredUser(AppUser user) async {
    _user = user;
    if (_token != null) {
      await _tokenStorage.saveSession(
        AuthSession(token: _token!, user: user),
      );
    }
    notifyListeners();
  }

  Future<void> _setSession(String token, AppUser user) async {
    _token = token;
    _user = user;
    await _tokenStorage.saveSession(AuthSession(token: token, user: user));
  }

  Future<bool> _perform(Future<void> Function() action) async {
    _isBusy = true;
    _error = null;
    notifyListeners();
    try {
      await action();
      return true;
    } catch (error) {
      _error = error.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _isBusy = false;
      notifyListeners();
    }
  }
}
