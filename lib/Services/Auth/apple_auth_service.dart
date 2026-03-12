import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(
      length,
      (_) => charset[random.nextInt(charset.length)],
    ).join();
  }

  String _sha256OfString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<UserCredential> signInWithApple() async {
    try {
      debugPrint('APPLE AUTH SERVICE: started');

      final isAvailable = await SignInWithApple.isAvailable();
      debugPrint('APPLE AUTH SERVICE: isAvailable -> $isAvailable');

      if (!isAvailable) {
        throw Exception('Apple sign in is not available');
      }

      final rawNonce = _generateNonce();
      final hashedNonce = _sha256OfString(rawNonce);

      debugPrint('APPLE AUTH SERVICE: requesting Apple credential');

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: const [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: hashedNonce,
      );

      debugPrint('APPLE AUTH SERVICE: credential received');
      debugPrint(
        'APPLE AUTH SERVICE: identityToken is null -> ${appleCredential.identityToken == null}',
      );
      debugPrint(
        'APPLE AUTH SERVICE: authorizationCode empty -> ${appleCredential.authorizationCode.isEmpty}',
      );
      debugPrint(
        'APPLE AUTH SERVICE: userIdentifier -> ${appleCredential.userIdentifier}',
      );
      debugPrint(
        'APPLE AUTH SERVICE: givenName -> ${appleCredential.givenName}',
      );
      debugPrint(
        'APPLE AUTH SERVICE: familyName -> ${appleCredential.familyName}',
      );
      debugPrint(
        'APPLE AUTH SERVICE: email -> ${appleCredential.email}',
      );

      final identityToken = appleCredential.identityToken;
      if (identityToken == null || identityToken.isEmpty) {
        throw Exception('Apple identity token is null');
      }

      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: identityToken,
        rawNonce: rawNonce,
      );

      debugPrint('APPLE AUTH SERVICE: signing in with Firebase credential');

      final result = await _auth.signInWithCredential(oauthCredential);

      debugPrint(
        'APPLE AUTH SERVICE: Firebase sign-in success -> uid: ${result.user?.uid}',
      );

      return result;
    } catch (e, st) {
      debugPrint('APPLE AUTH SERVICE ERROR: $e');
      debugPrintStack(stackTrace: st);
      rethrow;
    }
  }
}
