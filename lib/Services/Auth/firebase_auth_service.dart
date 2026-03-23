import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FacebookAuth _facebookAuth;

  FirebaseAuthService({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
    FacebookAuth? facebookAuth,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn(),
        _facebookAuth = facebookAuth ?? FacebookAuth.instance;

  Future<String> signInWithGoogleAndGetIdToken() async {
    try {
      debugPrint('FIREBASE AUTH SERVICE: Google sign-in started');

      final googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        throw Exception('Google sign in cancelled');
      }

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      final firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        throw Exception('Firebase user is null');
      }

      final idToken = await firebaseUser.getIdToken(true);

      if (idToken == null || idToken.isEmpty) {
        throw Exception('Firebase ID token could not be created');
      }

      debugPrint('FIREBASE AUTH SERVICE: Google sign-in success');
      return idToken;
    } catch (e, st) {
      debugPrint('FIREBASE AUTH SERVICE GOOGLE ERROR: $e');
      debugPrintStack(stackTrace: st);
      rethrow;
    }
  }

  Future<String> signInWithFacebookAndGetIdToken() async {
    try {
      debugPrint('FIREBASE AUTH SERVICE: Facebook sign-in started');

      final result = await _facebookAuth.login();

      if (result.status == LoginStatus.cancelled) {
        throw Exception('Facebook sign in cancelled');
      }

      if (result.status != LoginStatus.success || result.accessToken == null) {
        throw Exception(
          result.message?.isNotEmpty == true
              ? result.message!
              : 'Facebook sign in failed',
        );
      }

      final credential = FacebookAuthProvider.credential(
        result.accessToken!.tokenString,
      );

      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      final firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        throw Exception('Firebase user is null');
      }

      final idToken = await firebaseUser.getIdToken(true);

      if (idToken == null || idToken.isEmpty) {
        throw Exception('Firebase ID token could not be created');
      }

      debugPrint('FIREBASE AUTH SERVICE: Facebook sign-in success');
      return idToken;
    } catch (e, st) {
      debugPrint('FIREBASE AUTH SERVICE FACEBOOK ERROR: $e');
      debugPrintStack(stackTrace: st);
      rethrow;
    }
  }

  Future<String> signInWithAppleAndGetIdToken() async {
    try {
      debugPrint('FIREBASE AUTH SERVICE: Apple sign-in started');

      final isAvailable = await SignInWithApple.isAvailable();
      debugPrint('FIREBASE AUTH SERVICE: Apple isAvailable -> $isAvailable');

      if (!isAvailable) {
        throw Exception('Apple sign in is not available');
      }

      final rawNonce = _generateNonce();
      final hashedNonce = _sha256OfString(rawNonce);

      debugPrint('FIREBASE AUTH SERVICE: requesting Apple credential');

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: const [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: hashedNonce,
      );

      debugPrint('FIREBASE AUTH SERVICE: Apple credential received');
      debugPrint(
        'FIREBASE AUTH SERVICE: userIdentifier -> ${appleCredential.userIdentifier}',
      );
      debugPrint(
        'FIREBASE AUTH SERVICE: email -> ${appleCredential.email}',
      );
      debugPrint(
        'FIREBASE AUTH SERVICE: givenName -> ${appleCredential.givenName}',
      );
      debugPrint(
        'FIREBASE AUTH SERVICE: familyName -> ${appleCredential.familyName}',
      );
      debugPrint(
        'FIREBASE AUTH SERVICE: identityToken is null -> ${appleCredential.identityToken == null}',
      );
      debugPrint(
        'FIREBASE AUTH SERVICE: authorizationCode empty -> ${appleCredential.authorizationCode.isEmpty}',
      );

      final identityToken = appleCredential.identityToken;
      if (identityToken == null || identityToken.isEmpty) {
        throw Exception('Apple identity token is null');
      }

      final oauthCredential = OAuthProvider('apple.com').credential(
          idToken: identityToken,
          rawNonce: rawNonce,
          accessToken: appleCredential.authorizationCode);

      debugPrint(
        'FIREBASE AUTH SERVICE: signing into Firebase with Apple credential',
      );

      final userCredential =
          await _firebaseAuth.signInWithCredential(oauthCredential);

      final firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        throw Exception('Firebase user is null');
      }

      final idToken = await firebaseUser.getIdToken(true);
      if (idToken == null || idToken.isEmpty) {
        throw Exception('Firebase ID token could not be created');
      }

      debugPrint(
        'FIREBASE AUTH SERVICE: Apple Firebase sign-in success -> uid: ${firebaseUser.uid}',
      );

      return idToken;
    } on SignInWithAppleAuthorizationException catch (e, st) {
      debugPrint('FIREBASE AUTH SERVICE APPLE AUTH EXCEPTION: $e');
      debugPrintStack(stackTrace: st);

      if (e.code == AuthorizationErrorCode.canceled) {
        throw Exception('Apple sign in cancelled');
      }

      if (e.code == AuthorizationErrorCode.failed) {
        throw Exception('Apple authorization failed');
      }

      if (e.code == AuthorizationErrorCode.invalidResponse) {
        throw Exception('Apple invalid response');
      }

      if (e.code == AuthorizationErrorCode.notHandled) {
        throw Exception('Apple sign in not handled');
      }

      if (e.code == AuthorizationErrorCode.notInteractive) {
        throw Exception('Apple sign in not interactive');
      }

      throw Exception(
        'Apple authorization exception: ${e.code.name} - ${e.message}',
      );
    } on FirebaseAuthException catch (e, st) {
      debugPrint(
          'FIREBASE AUTH SERVICE APPLE FIREBASE ERROR: ${e.code} - ${e.message}');
      debugPrintStack(stackTrace: st);

      throw Exception('Firebase Apple auth failed: ${e.code} - ${e.message}');
    } catch (e, st) {
      debugPrint('FIREBASE AUTH SERVICE APPLE ERROR: $e');
      debugPrintStack(stackTrace: st);
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
        _facebookAuth.logOut(),
      ]);
    } catch (e, st) {
      debugPrint('FIREBASE AUTH SERVICE SIGNOUT ERROR: $e');
      debugPrintStack(stackTrace: st);
      rethrow;
    }
  }

  User? get currentUser => _firebaseAuth.currentUser;

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
    return sha256.convert(bytes).toString();
  }
}
