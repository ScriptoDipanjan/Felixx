import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ColorList {
  static const colorPrimary = Color(0xFF000000);
  static const colorPrimaryDark = Color(0xFF000000);
  static const colorAccent = Color(0xFFFFFFFF);
  static const colorOrange = Color(0xFFFF7F00);
  static const colorBlue = Color(0xFF0094FE);
  static const colorGrey = Color(0xFF505050);
  static const colorGreyBorder = Color(0xFFC5C5C5);

  static setSystemUIOverlayTransparent() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // status bar color
        systemNavigationBarColor: Colors.transparent, // navigation bar color
      ),
    );
  }

  static setSystemUIOverlayNormal() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // status bar color
        systemNavigationBarColor: colorBlue, // navigation bar color
      ),
    );
  }

  static setEnabledSystemUIMode() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
  }

  static setEnabledSystemUIModeHidden() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [],
    );
  }

  static setLockedPortrait() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  static setLockedLandscape() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }
}