import 'package:felixx/utils/methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api_calls.dart';
import '../constants/strings.dart';

class FirebaseAuthentication {
  static initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    saveFCMToken();
    return firebaseApp;
  }

  static saveFCMToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? fcmToken = prefs.getString('fcmToken') ?? await FirebaseMessaging.instance.getToken();
    prefs.setString('fcmToken', fcmToken!);
  }

  static loginEmail(context, phoneNumber) async {
    /*await initializeFirebase().verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (phoneAuthCredential) async {
        signInWithPhoneAuthCredential(phoneAuthCredential);
      },
      verificationFailed: (verificationFailed) async {
        if (verificationFailed.code == 'invalid-phone-number') {
          Methods.showError('The provided phone number is not valid!');
        } else {
          Methods.showError('Error occurred! Please try again...');
        }
      },
      codeSent: (verificationId, resendingToken) async {
        Login.showOTPDialog(context, phoneNumber, verificationId);
      },
      codeAutoRetrievalTimeout: (verificationId) async {},
    );*/

    //https://pub.dev/packages/email_otp/example
  }

  /*static signInWithPhoneAuthCredential(phoneAuthCredential) async {
    try {
      final authCredential = await initializeFirebase().signInWithCredential(phoneAuthCredential);

      debugPrint("User: ${authCredential.toString()}");
      ApiCalls.callSignUp();

    } on FirebaseAuthException catch (e) {
      Methods.callException(e);
    } on Exception catch(e) {
      Methods.callException(e);
    }
  }*/

  static loginGoogle(context, fcmToken) async {
    try {
      FirebaseApp defaultApp = await initializeFirebase();
      FirebaseAuth auth = FirebaseAuth.instanceFor(app: defaultApp);

      final GoogleSignInAccount? googleSignInAccount = await GoogleSignIn().signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken
        );

        User? user = (await auth.signInWithCredential(credential)).user;
        debugPrint("Email: ${user?.email}");
        debugPrint("Name: ${user?.displayName}");
        debugPrint("Photo: ${user?.photoURL}");

        return await ApiCalls.callSignUp(user?.displayName ?? '', user?.email ?? '', '', fcmToken, 'google');
        //ApiCalls.doSocialAuth(context, ratio, width, user?.email ?? '', user?.displayName ?? '', user?.photoURL ?? '', 'Google', fcmToken);
      } else {
        Methods.showError(Strings.stringErrorContinueGoogle);
        return false;
      }

    } on FirebaseException catch(e) {
      return Methods.callException(e);
    } on Exception catch(e) {
      return Methods.callException(e);
    }
  }
}