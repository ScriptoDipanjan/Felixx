import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'activity/splash.dart';

class FelixxApp extends StatelessWidget {
  const FelixxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      home: Splash(),
      debugShowCheckedModeBanner: false,
    );
  }
}