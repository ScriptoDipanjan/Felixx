import 'dart:async';

import 'package:felixx/api/api_calls.dart';
import 'package:felixx/utils/methods.dart';
import 'package:flutter/material.dart';
//import 'package:package_info_plus/package_info_plus.dart';

import '../constants/colors.dart';
import '../constants/dimens.dart' as dimensions;
import '../constants/strings.dart';
import '../utils/routes.dart';
import '../widgets/stateless_widgets.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  /*PackageInfo _packageInfo = PackageInfo(
    appName: Strings.stringUnknown,
    packageName: Strings.stringUnknown,
    version: Strings.stringUnknown,
    buildNumber: Strings.stringUnknown,
    buildSignature: Strings.stringUnknown,
  );*/

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
    ColorList.setSystemUIOverlayTransparent();
  }

  _initPackageInfo() async {
    /*final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });*/

    if(await Methods.checkConnection()) {
      ApiCalls.checkToken().then((status) => _startSplashScreenTimer());
    } else {
      _startSplashScreenTimer();
    }
  }

  @override
  void dispose() {
    ColorList.setEnabledSystemUIMode();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    Methods.setDimensions(context);

    return Scaffold(
      body: WillPopScope(
        child: Stack(
          children: [
            StatelessWidgets.getSplashBackground(1.0),
            Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(dimensions.px10),
                  color: ColorList.colorAccent.withOpacity(1),
                ),
                padding: EdgeInsets.all(dimensions.px5),
                child: Image.asset(Strings.imageLogo, height: 100, width: 100,),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.all(dimensions.px18),
                child: Container(
                  color: Colors.transparent,
                  child: Text(
                    _getVersion(),
                    style: const TextStyle(
                      decoration: TextDecoration.none,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        onWillPop: () => Future.value(false),
      ),
    );
  }

  _startSplashScreenTimer() async {
    return Timer(const Duration(seconds: 3), Routes.navigateToNextPage);
  }

  _getVersion() {
    return Strings.stringVersion;
    //return '${Strings.stringVersion}${_packageInfo.version}';
  }
}