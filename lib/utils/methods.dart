import 'dart:io';

import 'package:get/get.dart';

import '../constants/dimens.dart' as dimensions;
import '../constants/colors.dart';
import '../utils/routes.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Methods {

  static initWidgetBinding(){
    WidgetsFlutterBinding.ensureInitialized();
  }

  static setDimensions(context) {
    dimensions.height = MediaQuery.of(context).size.height;
    dimensions.width = MediaQuery.of(context).size.width;
  }

  static initErrorWidget(){
    ErrorWidget.builder = (FlutterErrorDetails details) {
      showError(details.exceptionAsString());
      debugPrint(details.exceptionAsString());
      return Container(
        alignment: Alignment.center,
        child: Text(
          details.exceptionAsString(),
          style: const TextStyle(color: ColorList.colorOrange),
          textDirection: TextDirection.ltr,
        ),
      );
    };
  }

  static checkConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        showError('Internet connection not found!\nPlease connect to internet...');
        return false;
      }
    } on SocketException catch (_) {
      return false;
    }
  }

  static showError(msg) {
    Get.snackbar(
      'Alert!',
      msg,
      isDismissible: false,
      duration: const Duration(milliseconds: 4000),
      colorText: ColorList.colorOrange,
      backgroundColor: ColorList.colorGrey,
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.zero,
      borderRadius: 0,
      forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
      reverseAnimationCurve: Curves.easeOut,
    );
  }

  static showToast(msg) {
    Get.snackbar(
      'Message!',
      msg,
      isDismissible: false,
      duration: const Duration(milliseconds: 2000),
      colorText: ColorList.colorBlue,
      backgroundColor: ColorList.colorGrey,
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.zero,
      borderRadius: 0,
      forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
      reverseAnimationCurve: Curves.easeOut,
    );
  }

  static proceedToSplash() async {

    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool('isLoggedIn', false);

    /*String? accountType = pref.getString('account_type');

    if(accountType == "Google"){

    } else if(accountType == "Facebook"){

    } else if(accountType == "Apple"){

    }

    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      await auth.signOut();
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }*/

    Routes.navigateToSplash();
  }

  static callException(e) {
    Methods.showError('Exception: $e');
    debugPrint('Exception: $e');
    return false;
  }

  static getFCMToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('fcmToken').toString();
  }

  static processUserData(responseData, type) async {
    debugPrint(responseData.toString());
    var userData = responseData['user'];
    var userStatus = 1;//userData['user_status'];

    if(userStatus == 1){
      SharedPreferences pref = await SharedPreferences.getInstance();

      pref.setString('token', responseData['token']);
      pref.setString('user_id', userData['id']);
      pref.setString('user_full_name', userData['name']);
      pref.setString('user_email', userData['email']);
      pref.setString('user_phone', userData['phone_no']);
      pref.setString('user_role', userData['role']);
      pref.setString('login_type', type);
      pref.setBool('isLoggedIn', true);

      Routes.navigateToHomePage();

    } else {
      /*showGeneralDialog(
          barrierColor: ColorList.colorPrimary.withOpacity(0.6),
          transitionBuilder: (context, a1, a2, widget) {
            return Transform.scale(
              scale: a1.value,
              child: Opacity(
                opacity: a1.value,
                child: AlertDialog(
                  shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Dimensions.px17)
                  ),
                  title: Text(
                    'Error!!!',
                    style: TextStyle(
                      fontSize: Dimensions.px25,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  content: Text(
                    'Profile is de-activated!',
                    style: TextStyle(
                      fontSize: Dimensions.px18,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  actions: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: Dimensions.px10),
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(ColorList.colorGreen),
                        ),
                        child: const Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    )
                  ],
                ),
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 200),
          barrierDismissible: false,
          barrierLabel: '',
          context: context,
          pageBuilder: (context, animation1, animation2) {
            return Container();
          });*/
    }
  }

  static saveAlbumData(responseData, albumID) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(albumID, responseData);
  }

  static getURL(data){
    return Platform.isAndroid ? data['urlAndroid'] : Platform.isIOS ? data['urliOS'] : '';
  }

}