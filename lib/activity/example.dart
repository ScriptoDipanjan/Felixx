import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:felixx/constants/colors.dart';
import 'package:felixx/constants/strings.dart';
import 'package:flutter/material.dart';
import '../constants/dimens.dart' as dimensions;

class MyHomePage extends StatefulWidget {

  final String title;
  const MyHomePage({required this.title, Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _animation;
  AnimationStatus _animationStatus = AnimationStatus.dismissed;
  int page = 0;

  @override
  void initState() {
    super.initState();
    ColorList.setEnabledSystemUIModeHidden();
    ColorList.setLockedLandscape();
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _animation = Tween(end: 1.0, begin: 0.0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        _animationStatus = status;
        if (_animationController.isDismissed) {
          page--;
          debugPrint('$page');
        }
        if(_animationController.isCompleted) {
          page++;
          debugPrint('$page');
        }
      });
  }

  @override
  void dispose(){
    super.dispose();
    _animationController.dispose();
    ColorList.setLockedPortrait();
    ColorList.setEnabledSystemUIMode();
  }

  @override
  Widget build(BuildContext context) {

    debugPrint("Height: ${dimensions.height}");
    debugPrint("Width: ${dimensions.width}");

    return Scaffold(
      backgroundColor: ColorList.colorGrey,
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            // User swiped Left
            _animationController.reverse();
          } else if (details.primaryVelocity! < 0) {
            // User swiped Right
            _animationController.forward();
          }
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                color: Colors.blueAccent,
                width: dimensions.heightHalf,
                height: dimensions.heightOneThird,
                margin: EdgeInsets.only(left: dimensions.px15),
                child: CachedNetworkImage(
                  imageUrl: '${Strings.urlMain}/public/album/5399d1/58265.png',
                  fit: BoxFit.fitHeight,
                  alignment: Alignment.centerLeft,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                color: Colors.red.withOpacity(0.5),
                width: dimensions.heightHalf - dimensions.px15,
                height: dimensions.heightOneThird,
                margin: EdgeInsets.only(right: dimensions.px15),
                child: CachedNetworkImage(
                  imageUrl: '${Strings.urlMain}/public/album/5399d1/98904.png',
                  fit: BoxFit.fitHeight,
                  alignment: Alignment.centerRight,
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: dimensions.width,
              height: dimensions.heightOneThird,
              margin: EdgeInsets.symmetric(horizontal: dimensions.px5),
              //color: Colors.amber.withOpacity(0.25),
              child: Transform(
                alignment: FractionalOffset.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.0015)
                  ..rotateY(pi * _animation.value),
                child: GestureDetector(
                  /*onTap: () {
                      if (_animationStatus == AnimationStatus.dismissed) {
                        _animationController.forward();
                      } else {
                        _animationController.reverse();
                      }
                    },*/
                  child: _animation.value <= 0.5
                      ? Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      color: Colors.blueAccent,
                      width: dimensions.heightHalf,
                      height: dimensions.heightOneThird,
                      child: CachedNetworkImage(
                        imageUrl: '${Strings.urlMain}/public/album/5399d1/58265.png',
                        fit: BoxFit.fitHeight,
                        alignment: Alignment.centerRight,
                      ),
                    ),
                  )
                      :
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                        color: Colors.red.withOpacity(0.5),
                        width: dimensions.heightHalf + dimensions.px5,
                        height: dimensions.heightOneThird,
                        child: Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.rotationY(pi),
                          child: CachedNetworkImage(
                            imageUrl: '${Strings.urlMain}/public/album/5399d1/98904.png',
                            fit: BoxFit.fitHeight,
                            alignment: Alignment.centerLeft,
                          ),
                        )
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}