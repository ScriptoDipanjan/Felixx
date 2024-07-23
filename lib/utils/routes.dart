import 'package:felixx/activity/example.dart';
import 'package:felixx/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turn_page_transition/turn_page_transition.dart';

import '../activity/album_cover.dart';
import '../activity/album_body.dart';
import '../activity/album_back.dart';
import '../activity/authentication.dart';
import '../activity/home.dart';
import '../activity/otp_verification.dart';
import '../activity/splash.dart';

import 'package:felixx/constants/dimens.dart' as dimensions;

class Routes {

  static navigateToLastPage() {
    Get.back();
  }

  static navigateToNextPage() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    //bool isOnboard = prefs.getBool('isOnboard') ?? false;
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    prefs.setBool('isFirstRun', false);

    Get.offAll(
      //() => const Onboard(),
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

  static navigateToAlbumCover(albumData) {
    //Get.to(() => AlbumCover(bannerImage, albumData));
    Get.to(() => CustomWidget(albumData));
  }

  static navigateToAlbumBody(context, bannerImage, albumData) {
    debugPrint('ratio: ${dimensions.ratio}');
    debugPrint('animationTransitionPoint: ${dimensions.animationTransitionPoint}');
    //Get.to(() => const MyHomePage(title: '',));
    //Get.to(() => CustomWidget());
    /*Navigator.of(context).push(
        TurnPageRoute(
          overleafColor: ColorList.colorGrey,
          animationTransitionPoint: dimensions.animationTransitionPoint,
          transitionDuration: const Duration(milliseconds: 300),
          builder: (context) => AlbumBody(bannerImage, albumData),
        )
    );*/
  }

  static navigateToAlbumBack(context, bannerImage, albumData) {
    Navigator.of(context).push(
        TurnPageRoute(
          overleafColor: ColorList.colorGrey,
          animationTransitionPoint: dimensions.animationTransitionPoint,
          transitionDuration: const Duration(milliseconds: 300),
          builder: (context) => AlbumBack(bannerImage, albumData),
        )
    );
  }

}