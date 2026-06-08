import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../config/app_config.dart';
import '../../config/firebase_options.dart';
import '../network/api_exception.dart';

class GoogleSignInProfile {
  const GoogleSignInProfile({
    required this.name,
    required this.email,
    required this.city,
  });

  final String name;
  final String email;
  final String city;
}

class GoogleIdentity {
  const GoogleIdentity({
    required this.name,
    required this.email,
    required this.idToken,
    required this.city,
  });

  final String name;
  final String email;
  final String idToken;
  final String city;
}

class GoogleAuthService {
  bool _isInitialized = false;

  Future<GoogleIdentity> signIn({
    required GoogleSignInProfile fallbackProfile,
  }) async {
    if (!AppConfig.enableFirebaseGoogleAuth) {
      return GoogleIdentity(
        name: fallbackProfile.name,
        email: fallbackProfile.email,
        city: fallbackProfile.city,
        idToken: 'demo-google-token',
      );
    }

    if (!_isInitialized) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      _isInitialized = true;
    }

    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      throw const ApiException('Вход через Google отменён.');
    }

    final auth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: auth.accessToken,
      idToken: auth.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);

    final idToken = auth.idToken;
    if (idToken == null || idToken.isEmpty) {
      throw const ApiException('Не удалось получить Google token.');
    }

    return GoogleIdentity(
      name: googleUser.displayName ?? fallbackProfile.name,
      email: googleUser.email,
      idToken: idToken,
      city: fallbackProfile.city,
    );
  }
}
