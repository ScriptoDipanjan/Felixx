import 'package:felixx/activity/album_viewer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../activity/authentication.dart';
import '../activity/home.dart';
import '../activity/otp_verification.dart';
import '../activity/splash.dart';

class Routes {

  static navigateToLastPage() {
    Get.back();
  }

  static navigateToNextPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    prefs.setBool('isFirstRun', false);

    Get.offAll(
      () => isLoggedIn ? const Home() : const Authentication(),
      transition: Transition.rightToLeftWithFade,
      duration: const Duration(milliseconds: 750),
      curve: Curves.fastOutSlowIn,
    );
  }

  static navigateToHomePage() {
    Get.offAll(
      () => const Home(),
      transition: Transition.rightToLeftWithFade,
      duration: const Duration(milliseconds: 750),
      curve: Curves.fastOutSlowIn,
    );
  }

  static navigateToSplash() {
    Get.offAll(
      () => const Splash(),
      transition: Transition.rightToLeftWithFade,
      duration: const Duration(milliseconds: 750),
      curve: Curves.fastOutSlowIn,
    );
  }

  static navigateToOTP(country, phone, name, email) {
    Get.to(() => OTPVerification(country, phone, name, email));
  }

  static navigateToAlbumView(albumData) {
    Get.to(() => AlbumView(albumData));
  }

}