import 'package:flutter/material.dart';

import '../authentication/firebase_auth.dart';
import '../constants/colors.dart';
import '../constants/dimens.dart' as dimensions;
import '../constants/strings.dart';
import '../utils/methods.dart';
import '../widgets/login_dialog.dart';
import '../widgets/stateless_widgets.dart';

class Authentication extends StatefulWidget {

  const Authentication({super.key});

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {

    Methods.setDimensions(context);

    String? fcmToken = '';
    Methods.getFCMToken().then((value) => fcmToken = value);

    return Scaffold(
      body: WillPopScope(
        child: Stack(
          children: [
            StatelessWidgets.getSplashBackground(1.0),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(dimensions.px15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    height: dimensions.px45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(dimensions.px10),
                      color: ColorList.colorAccent,
                    ),
                    child: TextButton(
                      onPressed: () {
                        Login.showLoginDialog(context);
                      },
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(dimensions.px20, 0, dimensions.px10, 0),
                        child: Row(
                          children: [
                            Text(
                              Strings.stringContinueEmail,
                              style: TextStyle(
                                color: ColorList.colorPrimary,
                                fontSize: dimensions.px15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            Image.asset(
                              Strings.iconEmail,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: dimensions.px20,),
                  Container(
                    width: double.infinity,
                    height: dimensions.px45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: ColorList.colorAccent,
                    ),
                    child: TextButton(
                      onPressed: () {
                        setState(() => isLoading = true);
                        FirebaseAuthentication.loginGoogle(context, fcmToken)
                            .then((value) => setState(() => isLoading = false));
                      },
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(dimensions.px20, 0, dimensions.px17, 0),
                        child: Row(
                          children: [
                            Text(
                              Strings.stringContinueGoogle,
                              style: TextStyle(
                                color: ColorList.colorPrimary,
                                fontSize: dimensions.px15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            Image.asset(
                              Strings.iconGoogle,
                              height: dimensions.px18,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
            isLoading
              ? StatelessWidgets.getLoadingScreen(dimensions.height)
              : Container(),
          ],
        ),
        onWillPop: () => Future.value(true),
      ),
    );
  }

}