import 'package:felixx/constants/dimens.dart' as dimensions;
import 'package:felixx/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:country_code_picker/country_code_picker.dart';

import '../constants/colors.dart';
import '../constants/strings.dart';
import '../utils/methods.dart';

class Login {
  static showLoginDialog(context){

    final controllerName = TextEditingController();
    final controllerEmail = TextEditingController();
    final controllerPhone = TextEditingController();
    FocusNode focusNodeName = FocusNode();
    FocusNode focusNodeEmail = FocusNode();
    FocusNode focusNodePhone = FocusNode();

    bool statEnabled = true;
    String country = '+91';
    RegExp regexEmail = RegExp(Strings.patternEmail);
    
    /*Get.bottomSheet(
      isScrollControlled: true,
      enableDrag: false,
      isDismissible: false,
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState){
          return GestureDetector(
            onTap: () => SystemChannels.textInput.invokeMethod('TextInput.hide'),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(dimensions.px25)),
                color: ColorList.colorAccent,
              ),
              padding: EdgeInsets.only(
                top: dimensions.px15,
                left: dimensions.px15,
                bottom: MediaQuery.of(context).viewInsets.bottom,
                right: dimensions.px15,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  //SizedBox(height: dimensions.px5),
                  /*Text(
                    Strings.stringContinueEmailHeader,
                    style: TextStyle(
                      fontSize: dimensions.px20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),*/
                  SizedBox(height: dimensions.px20),
                  TextFormField(
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(dimensions.px10)),
                        borderSide: const BorderSide(color: ColorList.colorGrey, width: 2),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(dimensions.px10)),
                        borderSide: const BorderSide(color: ColorList.colorGreyBorder, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(dimensions.px10)),
                        borderSide: const BorderSide(color: ColorList.colorGrey, width: 2),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(dimensions.px10)),
                        borderSide: const BorderSide(color: ColorList.colorGreyBorder, width: 2),
                      ),
                      labelText: Strings.stringName,
                      labelStyle: const TextStyle(color: ColorList.colorGrey),
                      alignLabelWithHint: true,
                    ),
                    enabled: statEnabled,
                    controller: controllerName,
                    keyboardType: TextInputType.name,
                    maxLines: 1,
                    cursorColor: ColorList.colorPrimary,
                    focusNode: focusNodeName,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: dimensions.px15),
                  TextFormField(
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(dimensions.px10)),
                        borderSide: const BorderSide(color: ColorList.colorGrey, width: 2),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(dimensions.px10)),
                        borderSide: const BorderSide(color: ColorList.colorGreyBorder, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(dimensions.px10)),
                        borderSide: const BorderSide(color: ColorList.colorGrey, width: 2),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(dimensions.px10)),
                        borderSide: const BorderSide(color: ColorList.colorGreyBorder, width: 2),
                      ),
                      labelText: Strings.stringEmail,
                      labelStyle: const TextStyle(color: ColorList.colorGrey),
                      alignLabelWithHint: true,
                    ),
                    enabled: statEnabled,
                    controller: controllerEmail,
                    keyboardType: TextInputType.emailAddress,
                    maxLines: 1,
                    cursorColor: ColorList.colorPrimary,
                    focusNode: focusNodeEmail,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: dimensions.px15),
                  Stack(
                    children: [
                      TextFormField(
                        controller: controllerPhone,
                        focusNode: focusNodePhone,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.done,
                        cursorColor: ColorList.colorPrimary,
                        maxLength: 10,
                        maxLines: 1,
                        decoration: InputDecoration(
                          hintText: Strings.stringPhone,
                          hintStyle: const TextStyle(color: ColorList.colorGrey),
                          labelText: Strings.stringPhone,
                          labelStyle: const TextStyle(color: ColorList.colorGrey),
                          alignLabelWithHint: true,
                          prefixIcon: Image.asset(
                            Strings.iconEmail,
                            height: dimensions.px5,
                            width: dimensions.px5,
                            color: ColorList.colorAccent,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(dimensions.px10)),
                            borderSide: const BorderSide(color: ColorList.colorGrey, width: 2),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(dimensions.px10)),
                            borderSide: const BorderSide(color: ColorList.colorGreyBorder, width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(dimensions.px10)),
                            borderSide: const BorderSide(color: ColorList.colorGrey, width: 2),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(dimensions.px10)),
                            borderSide: const BorderSide(color: ColorList.colorGreyBorder, width: 2),
                          ),
                        ),
                      ),
                      Container(
                        height: dimensions.px50 - dimensions.px3,
                        width: dimensions.px50,
                        padding: EdgeInsets.only(left: dimensions.px2 * 2),
                        alignment: Alignment.center,
                        child: CountryCodePicker(
                          onChanged: (code) => country = code.dialCode ?? '+91',
                          hideMainText: true,
                          showFlagMain: true,
                          showFlag: true,
                          initialSelection: 'IN',
                          hideSearch: false,
                          showCountryOnly: true,
                          showOnlyCountryWhenClosed: true,
                          alignLeft: false,
                          flagWidth: dimensions.px18,
                          padding: EdgeInsets.zero,
                          showDropDownButton: false,
                          showFlagDialog: true,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: dimensions.px15),
                  SizedBox(
                    width: double.infinity,
                    height: dimensions.px45,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: dimensions.width * 0.33,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(dimensions.px10),
                            color: ColorList.colorGreyBorder,
                          ),
                          child: TextButton(
                            onPressed: () {
                              Routes.navigateToLastPage();
                            },
                            child: Text(
                              Strings.stringCancel,
                              style: TextStyle(
                                color: ColorList.colorAccent,
                                fontSize: dimensions.px15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: dimensions.width * 0.55,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(dimensions.px10),
                            color: ColorList.colorBlue,
                          ),
                          child: TextButton(
                            onPressed: () {
                              if(controllerName.text.isNotEmpty && controllerEmail.text.isNotEmpty){
                                setModalState(() => statEnabled = false);
                                SystemChannels.textInput.invokeMethod('TextInput.hide');
                                FirebaseAuthentication.loginEmail();
                              } else if(controllerName.text.isEmpty){
                                Methods.showError(Strings.stringErrorName);
                                SystemChannels.textInput.invokeMethod('TextInput.show');
                                FocusScope.of(context).requestFocus(focusNodeName);
                              } else if(controllerEmail.text.isEmpty){
                                Methods.showError(Strings.stringErrorEmail);
                                SystemChannels.textInput.invokeMethod('TextInput.show');
                                FocusScope.of(context).requestFocus(focusNodeEmail);
                              }
                            },
                            child: !statEnabled
                                ? const Center(
                              child: CircularProgressIndicator(
                                color: ColorList.colorAccent,
                              ),
                            )
                                : Text(
                              Strings.stringProceed,
                              style: TextStyle(
                                color: ColorList.colorAccent,
                                fontSize: dimensions.px15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: dimensions.px20),
                ],
              ),
            ),
          );
        },
      ),
    );*/

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        enableDrag: false,
        isDismissible: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(dimensions.px20),
          ),
        ),
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState){
              return GestureDetector(
                onTap: () => SystemChannels.textInput.invokeMethod('TextInput.hide'),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(
                    top: dimensions.px18,
                    left: dimensions.px15,
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                    right: dimensions.px15,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: dimensions.px5),
                      Text(
                        Strings.stringContinueEmailHeader,
                        style: TextStyle(
                          fontSize: dimensions.px20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: dimensions.px15),
                      TextFormField(
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(dimensions.px10)),
                            borderSide: const BorderSide(color: ColorList.colorGrey, width: 2),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(dimensions.px10)),
                            borderSide: const BorderSide(color: ColorList.colorGreyBorder, width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(dimensions.px10)),
                            borderSide: const BorderSide(color: ColorList.colorGrey, width: 2),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(dimensions.px10)),
                            borderSide: const BorderSide(color: ColorList.colorGreyBorder, width: 2),
                          ),
                          labelText: Strings.stringName,
                          labelStyle: const TextStyle(color: ColorList.colorGrey),
                          alignLabelWithHint: true,
                        ),
                        enabled: statEnabled,
                        controller: controllerName,
                        textCapitalization: TextCapitalization.words,
                        keyboardType: TextInputType.name,
                        maxLines: 1,
                        cursorColor: ColorList.colorPrimary,
                        focusNode: focusNodeName,
                        textInputAction: TextInputAction.next,
                      ),
                      SizedBox(height: dimensions.px15),
                      TextFormField(
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(dimensions.px10)),
                            borderSide: const BorderSide(color: ColorList.colorGrey, width: 2),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(dimensions.px10)),
                            borderSide: const BorderSide(color: ColorList.colorGreyBorder, width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(dimensions.px10)),
                            borderSide: const BorderSide(color: ColorList.colorGrey, width: 2),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(dimensions.px10)),
                            borderSide: const BorderSide(color: ColorList.colorGreyBorder, width: 2),
                          ),
                          labelText: Strings.stringEmail,
                          labelStyle: const TextStyle(color: ColorList.colorGrey),
                          alignLabelWithHint: true,
                        ),
                        enabled: statEnabled,
                        controller: controllerEmail,
                        keyboardType: TextInputType.emailAddress,
                        maxLines: 1,
                        cursorColor: ColorList.colorPrimary,
                        focusNode: focusNodeEmail,
                        textInputAction: TextInputAction.next,
                      ),
                      SizedBox(height: dimensions.px15),
                      Stack(
                        children: [
                          TextFormField(
                            controller: controllerPhone,
                            focusNode: focusNodePhone,
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.done,
                            cursorColor: ColorList.colorPrimary,
                            maxLength: 10,
                            maxLines: 1,
                            enabled: statEnabled,
                            decoration: InputDecoration(
                              hintText: Strings.stringPhone,
                              hintStyle: const TextStyle(color: ColorList.colorGrey),
                              labelText: Strings.stringPhone,
                              labelStyle: const TextStyle(color: ColorList.colorGrey),
                              alignLabelWithHint: true,
                              prefixIcon: Image.asset(
                                Strings.iconEmail,
                                height: dimensions.px5,
                                width: dimensions.px5,
                                color: ColorList.colorAccent,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(dimensions.px10)),
                                borderSide: const BorderSide(color: ColorList.colorGrey, width: 2),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(dimensions.px10)),
                                borderSide: const BorderSide(color: ColorList.colorGreyBorder, width: 2),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(dimensions.px10)),
                                borderSide: const BorderSide(color: ColorList.colorGrey, width: 2),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(dimensions.px10)),
                                borderSide: const BorderSide(color: ColorList.colorGreyBorder, width: 2),
                              ),
                            ),
                          ),
                          Container(
                            height: dimensions.px50 - dimensions.px3,
                            width: dimensions.px50,
                            padding: EdgeInsets.only(left: dimensions.px2 * 2),
                            alignment: Alignment.center,
                            child: CountryCodePicker(
                              onChanged: (code) => country = code.dialCode ?? '+91',
                              hideMainText: true,
                              showFlagMain: true,
                              showFlag: true,
                              initialSelection: 'IN',
                              hideSearch: false,
                              showCountryOnly: true,
                              showOnlyCountryWhenClosed: true,
                              alignLeft: false,
                              flagWidth: dimensions.px18,
                              padding: EdgeInsets.zero,
                              showDropDownButton: false,
                              showFlagDialog: true,
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: dimensions.px15),
                      SizedBox(
                        width: double.infinity,
                        height: dimensions.px45,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: dimensions.width * 0.33,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(dimensions.px10),
                                color: ColorList.colorGreyBorder,
                              ),
                              child: TextButton(
                                onPressed: () {
                                  Routes.navigateToLastPage();
                                },
                                child: Text(
                                  Strings.stringCancel,
                                  style: TextStyle(
                                    color: ColorList.colorAccent,
                                    fontSize: dimensions.px15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: dimensions.width * 0.55,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(dimensions.px10),
                                color: ColorList.colorBlue,
                              ),
                              child: TextButton(
                                onPressed: () {
                                  if(controllerName.text.trim().isEmpty){
                                    Methods.showError(Strings.stringErrorName);
                                    SystemChannels.textInput.invokeMethod('TextInput.show');
                                    FocusScope.of(context).requestFocus(focusNodeName);
                                  } else if(controllerEmail.text.trim().isEmpty){
                                    Methods.showError(Strings.stringErrorEmail);
                                    SystemChannels.textInput.invokeMethod('TextInput.show');
                                    FocusScope.of(context).requestFocus(focusNodeEmail);
                                  } else if(!(controllerEmail.text.trim().contains(regexEmail))){
                                    Methods.showToast(Strings.stringErrorEmailValid);
                                    SystemChannels.textInput.invokeMethod('TextInput.show');
                                    FocusScope.of(context).requestFocus(focusNodeEmail);
                                  } else if(controllerPhone.text.trim().isEmpty || controllerPhone.text.length < 10){
                                    Methods.showError(Strings.stringErrorPhone);
                                    SystemChannels.textInput.invokeMethod('TextInput.show');
                                    FocusScope.of(context).requestFocus(focusNodePhone);
                                  } else if(controllerName.text.isNotEmpty
                                      && controllerEmail.text.isNotEmpty
                                      && controllerPhone.text.isNotEmpty){
                                    setModalState(() => statEnabled = false);
                                    SystemChannels.textInput.invokeMethod('TextInput.hide');
                                    Routes.navigateToOTP(
                                      country,
                                      controllerPhone.text.trim(),
                                      controllerName.text.trim(),
                                      controllerEmail.text.trim(),
                                    );
                                    Future.delayed(const Duration(seconds: 30), () => setModalState(() => statEnabled = true),);
                                  }
                                },
                                child: !statEnabled
                                    ? SizedBox(
                                        height: dimensions.px12,
                                        width: dimensions.px12,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color: ColorList.colorAccent,
                                            strokeWidth: dimensions.px2,
                                          ),
                                        ),
                                      )
                                    : Text(
                                        Strings.stringProceed,
                                        style: TextStyle(
                                          color: ColorList.colorAccent,
                                          fontSize: dimensions.px15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        )
                      ),
                      SizedBox(height: dimensions.px20),
                    ],
                  ),
                ),
              );
            },
          );
        }
    );
  }

}