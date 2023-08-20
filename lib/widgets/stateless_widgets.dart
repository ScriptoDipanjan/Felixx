import 'package:felixx/constants/dimens.dart' as dimensions;
import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/strings.dart';

class StatelessWidgets {
  static getSplashBackground(opacity){
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: BoxDecoration(
        image: DecorationImage(
          colorFilter: ColorFilter.mode(
            ColorList.colorOrange.withOpacity(0.5),
            BlendMode.color,
          ),
          image: AssetImage(Strings.imageSplash),
          fit: BoxFit.cover,
        ),
      ),
      //child: Container()
    );
  }

  static getEmptyResult(isError, Function() prepareDashboardData){
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(Strings.imageNoResult, height: dimensions.px100, width: dimensions.px100,),
          SizedBox(height: dimensions.px15,),
          Text(
            Strings.stringErrorNoData,
            textAlign: TextAlign.center,
            style: TextStyle(
              height: 1.3,
              fontSize: dimensions.px17,
              color: ColorList.colorOrange,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.italic,
            ),
          ),
          Container (
            margin: isError ? EdgeInsets.only(top: dimensions.px15,) : EdgeInsets.zero,
            child: isError
              ? getRetryButton(prepareDashboardData)
              : Container(),

          )
        ],
      ),
    );
  }

  static getRetryButton(prepareDashboardData) =>
      GestureDetector(
        onTap: prepareDashboardData,
        child: Container(
          padding: EdgeInsets.all(dimensions.px10),
          alignment: Alignment.center,
          width: dimensions.px85,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: ColorList.colorBlue,
          ),
          child: Text(
            Strings.stringRetry,
            style: TextStyle(
              color: ColorList.colorAccent,
              fontSize: dimensions.px15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );

  static getLoadingScreen(height){
    return Container(
      height: height,
      color: ColorList.colorGreyBorder.withOpacity(0.5),
      child: const Center(
        child: CircularProgressIndicator(
          color: ColorList.colorBlue,
        ),
      ),
    );
  }
}