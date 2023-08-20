import 'dart:io';

import 'package:flutter/material.dart';

import 'api/http_overrides.dart';
import 'authentication/firebase_auth.dart';
import 'constants/colors.dart';
import 'utils/methods.dart';

import 'app.dart';

void main() {
  Methods.initWidgetBinding();

  FirebaseAuthentication.initializeFirebase();

  Methods.initErrorWidget();

  ColorList.setLockedPortrait();

  ColorList.setSystemUIOverlayTransparent();

  HttpOverrides.global = FelixxHttpOverrides();

  runApp(const FelixxApp());
}