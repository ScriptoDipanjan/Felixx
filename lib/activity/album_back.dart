import 'package:cached_network_image/cached_network_image.dart';
import 'package:felixx/constants/colors.dart';
import '../utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:turn_page_transition/turn_page_transition.dart';
import 'package:felixx/constants/dimens.dart' as dimensions;

class AlbumBack extends StatefulWidget{
  final String bannerImage;
  final List albumData;
  const AlbumBack(this.bannerImage, this.albumData, {super.key});

  @override
  State<AlbumBack> createState() => _AlbumBackState();
}

class _AlbumBackState extends State<AlbumBack> {
  List albumData = [];
  bool isLoading = true;
  final controller = TurnPageController();

  @override
  void initState(){
    super.initState();
    ColorList.setEnabledSystemUIModeHidden();
    ColorList.setLockedLandscape();
  }

  @override
  void dispose(){
    super.dispose();
    ColorList.setLockedPortrait();
    ColorList.setEnabledSystemUIMode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorList.colorPrimary,
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {

            // User swiped Left
            debugPrint('Swiped Left');
            //Routes.navigateToAlbumBody(context, widget.bannerImage, widget.albumData);

          } else if (details.primaryVelocity! < 0) {

            // User swiped Right
            ColorList.setLockedPortrait();
            ColorList.setEnabledSystemUIMode();
            Routes.navigateToHomePage();
            debugPrint('Swiped Right');

          }
        },
        child: Container(
          alignment: Alignment.center,
          child: CachedNetworkImage(
            imageUrl: widget.bannerImage,
            width: dimensions.heightHalf,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}