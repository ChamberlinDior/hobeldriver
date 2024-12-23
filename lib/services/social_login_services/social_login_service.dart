import 'dart:io';

import 'package:connect_app_driver/functions/print_function.dart';
import 'package:connect_app_driver/services/social_login_services/social_login_modal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SocialLoginServices {
  static Future<UserSocialLoginDetailModal?> signInWithGoogle() async {
    final firebaseAuth = FirebaseAuth.instance;
    GoogleSignIn googleSignIn;
    if (Platform.isAndroid) {
      googleSignIn = GoogleSignIn();
    } else {
      googleSignIn = GoogleSignIn(
          clientId:
              "603468115777-rmrtsspbvt1vu3kr35g2eonuhofiip9h.apps.googleusercontent.com");
    }

    googleSignIn.signOut();
    GoogleSignInAccount? googleAccount = await googleSignIn.signIn();
    myCustomPrintStatement('googleAccount $googleAccount');
    if (googleAccount != null) {
      GoogleSignInAuthentication googleAuth =
          await googleAccount.authentication;
      final authResult = await firebaseAuth.signInWithCredential(
        GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        ),
      );
      myCustomPrintStatement('the user data is ${authResult.user!.uid}');
      return UserSocialLoginDetailModal(
          idType: 1,
          emailId: authResult.user!.email!,
          googleId: authResult.user!.uid);
    } else {
      myCustomPrintStatement("Some thing went wrong");
      return null;
    }
  }

  static Future<UserSocialLoginDetailModal?> facebookLogin() async {
    // Create an instance of FacebookLogin
    final fb = FacebookAuth.instance;
    final res = await fb.login();
    // Check result status
    if (res.status == LoginStatus.success) {
      final AccessToken? accessToken =
          res.accessToken; // get accessToken for auth login
      final profile = await fb.getUserData(); // get profile of user

      myCustomPrintStatement('fb data Access token: ${accessToken?.token}');
      myCustomPrintStatement(
          'fb data Hello, ${profile["name"]}! You ID: ${profile["id"]}');
      myCustomPrintStatement(
          'fb data Your profile image: $profile["picture.width(200)"]');
      myCustomPrintStatement('fb data And your email is $profile["email"]');
      return UserSocialLoginDetailModal(
          idType: 1,
          emailId: profile["email"] ?? "",
          googleId: profile["id"] ?? "");
    } else if (res.status == LoginStatus.cancelled) {
      return null;
    } else if (res.status == LoginStatus.failed) {
      myCustomPrintStatement('Error while log in: ${res}');
      return null;
    }
    myCustomPrintStatement('Error while log in: ${res}');
    return null;
  }
}
