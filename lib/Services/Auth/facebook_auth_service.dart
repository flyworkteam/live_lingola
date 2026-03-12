import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FacebookAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> signInWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login(
      permissions: ['email', 'public_profile'],
    );

    if (result.status != LoginStatus.success) {
      throw FirebaseAuthException(
        code: 'FACEBOOK_LOGIN_FAILED',
        message: result.message ?? 'Facebook login başarısız.',
      );
    }

    final accessToken = result.accessToken;
    if (accessToken == null) {
      throw FirebaseAuthException(
        code: 'FACEBOOK_ACCESS_TOKEN_NULL',
        message: 'Facebook access token alınamadı.',
      );
    }

    final OAuthCredential credential =
        FacebookAuthProvider.credential(accessToken.tokenString);

    return await _auth.signInWithCredential(credential);
  }
}
