import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../constants/dimens.dart' as dimensions;
import '../constants/strings.dart';
import '../utils/methods.dart';
import '../api/api_calls.dart';
import '../authentication/firebase_auth.dart';
import '../constants/colors.dart';
import '../utils/routes.dart';
import '../widgets/stateless_widgets.dart';

String countryCode = '+91', phoneNumber = '';

class OTPVerification extends StatefulWidget {
  final String code, phone, name, email;
  const OTPVerification(this.code, this.phone, this.name, this.email, {super.key});

  @override
  OTPVerificationState createState() => OTPVerificationState();
}

class OTPVerificationState extends State<OTPVerification> {

  bool hasError = false, isReturn = false;
  late Timer _timer;
  int _start = 59;
  String? fcmToken = '';

  FirebaseAuth auth = FirebaseAuth.instance;
  String phoneNumber = '', verificationId = '';

  final controllerOTP = TextEditingController();
  FocusNode focusNodeOTP = FocusNode();
  StreamController<ErrorAnimationType>? errorController;
  final formKey = GlobalKey<FormState>();

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    phoneNumber = widget.code + widget.phone;
    startTimer();
    FirebaseAuthentication.initializeFirebase().then((value) => sendOTP());
    Methods.getFCMToken().then((value) => fcmToken = value);
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    controllerOTP.dispose();
    super.dispose();
  }

  signInWithPhoneAuthCredential(phoneAuthCredential) async {
    try {
      final authCredential = await auth.signInWithCredential(phoneAuthCredential);

      debugPrint("User: ${authCredential.toString()}");

      if(authCredential.user != null){
        ApiCalls.callSignUp(widget.name, widget.email, phoneNumber, fcmToken, Strings.stringTypeEmail);
      }

    } on FirebaseAuthException catch (e) {
      debugPrint('User error: ${e.message}');
      Methods.showError('Error: ${e.message}');
      isReturn = true;
    }
  }

  @override
  Widget build(BuildContext context) {

    Methods.setDimensions(context);

    return Scaffold(
      backgroundColor: ColorList.colorAccent,
      body: GestureDetector(
        onTap: () => SystemChannels.textInput.invokeMethod('TextInput.hide'),
        child: WillPopScope(
          child: Stack(
            children: [
              StatelessWidgets.getSplashBackground(0.5),
              Center(
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(dimensions.px10),
                  children: [
                    Text(
                      Strings.stringOTPVerificationHeader,
                      style: TextStyle(
                        color: ColorList.colorAccent,
                        fontSize: dimensions.px25,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: dimensions.px17),
                    RichText(
                      text: TextSpan(
                          text: Strings.stringOTPVerificationMessage,
                          children: [
                            TextSpan(
                                text: phoneNumber,
                                style: TextStyle(
                                  color: ColorList.colorAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: dimensions.px15,
                                )
                            ),
                          ],
                          style: TextStyle(
                            color: ColorList.colorAccent,
                            fontSize: dimensions.px15,
                          )
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: dimensions.px10),
                    Center(
                      child: GestureDetector(
                        onLongPress: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content:
                                  Text(Strings.stringOTPVerificationPaste),
                                  actions: [
                                    TextButton(
                                        onPressed: () async {
                                          var copiedText = await Clipboard.getData("text/plain");
                                          if (copiedText!.text!.isNotEmpty) {
                                            controllerOTP.text = copiedText.text!;
                                          }
                                          Routes.navigateToLastPage();
                                        },
                                        child: Text(Strings.stringYes)),
                                    TextButton(
                                        onPressed: () {
                                          Routes.navigateToLastPage();
                                        },
                                        child: Text(Strings.stringNo))
                                  ],
                                );
                              });
                        },
                        child: Form(
                          key: formKey,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: dimensions.px10,
                              horizontal: dimensions.px30,
                            ),
                            child: PinCodeTextField(
                              appContext: context,
                              pastedTextStyle: const TextStyle(
                                color: ColorList.colorBlue,
                                fontWeight: FontWeight.bold,
                              ),
                              length: 6,
                              obscureText: false,
                              obscuringCharacter: '*',
                              /*obscuringWidget: const FlutterLogo(
                              size: 24,
                            ),*/
                              blinkWhenObscuring: false,
                              animationType: AnimationType.fade,
                              /*validator: (v) {
                              if (v!.length < 3) {
                                return "I'm from validator";
                              } else {
                                return null;
                              }
                            },*/
                              pinTheme: PinTheme(
                                shape: PinCodeFieldShape.box,
                                borderRadius: BorderRadius.circular(dimensions.px5 + dimensions.px3),
                                fieldHeight: dimensions.px45,
                                fieldWidth: dimensions.px40,
                                activeFillColor: ColorList.colorAccent,
                                selectedFillColor: ColorList.colorAccent,
                                inactiveFillColor: ColorList.colorAccent,
                              ),
                              cursorColor: ColorList.colorPrimary,
                              animationDuration: const Duration(milliseconds: 300),
                              enableActiveFill: true,
                              errorAnimationController: errorController,
                              controller: controllerOTP,
                              keyboardType: TextInputType.number,
                              boxShadows: [
                                BoxShadow(
                                  offset: const Offset(0, 1),
                                  color: ColorList.colorGreyBorder,
                                  blurRadius: dimensions.px10,
                                )
                              ],
                              onCompleted: (v) {
                                Methods.showToast(Strings.stringOTPVerificationMessageWait);
                                PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: controllerOTP.text);

                                signInWithPhoneAuthCredential(phoneAuthCredential);
                              },
                              beforeTextPaste: (text) {
                                debugPrint("Allowing to paste $text");
                                return true;
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: dimensions.px10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          Strings.stringOTPVerificationNoOTP,
                          style: TextStyle(
                            color: ColorList.colorAccent,
                            fontSize: dimensions.px15,
                          ),
                        ),
                        TextButton(
                          onPressed: (){
                            if (_start == 0) {
                              snackBar("OTP resend!!");
                              sendOTP();
                              setState(() {
                                _start = 59;
                                startTimer();
                              });
                            } else {
                              Methods.showToast("Please wait $_start seconds before resend OTP");
                            }
                          },
                          child: Text(
                            "RESEND",
                            style: TextStyle(
                              color: _start == 0 ? ColorList.colorBlue : ColorList.colorOrange,
                              fontWeight: FontWeight.bold,
                              fontSize: dimensions.px15,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          onWillPop: (){
            if(isReturn) {
              Routes.navigateToLastPage();
            }
            return Future.value(false);
          },
        ),
      ),
    );
  }

  snackBar(String? message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message!),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  sendOTP() async {
    await auth.verifyPhoneNumber(
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
        isReturn = true;
        Routes.navigateToLastPage();
      },
      codeSent: (verificationId, resendingToken) async {
        setState(() {
          this.verificationId = verificationId;
        });
      },
      codeAutoRetrievalTimeout: (verificationId) async {},
    );
  }
  
}