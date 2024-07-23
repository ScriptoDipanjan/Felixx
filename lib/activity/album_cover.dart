import 'package:cached_network_image/cached_network_image.dart';
import 'package:felixx/constants/colors.dart';
import '../utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:turn_page_transition/turn_page_transition.dart';
import 'package:felixx/constants/dimens.dart' as dimensions;

class AlbumCover extends StatefulWidget{
  final String bannerImage;
  final List albumData;
  const AlbumCover(this.bannerImage, this.albumData, {super.key});

  @override
  State<AlbumCover> createState() => _AlbumCoverState();
}

class _AlbumCoverState extends State<AlbumCover> {
  bool isLoading = true;
  final controller = TurnPageController();

  @override
  void initState(){
    super.initState();
    ColorList.setEnabledSystemUIModeHidden();
    ColorList.setLockedLandscape();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorList.colorPrimary,
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {

            // User swiped Left
            ColorList.setLockedPortrait();
            ColorList.setEnabledSystemUIMode();
            Routes.navigateToLastPage();
            debugPrint('Swiped Left');

          } else if (details.primaryVelocity! < 0) {

            // User swiped Right
            //Routes.navigateToAlbumBody(context, widget.bannerImage, widget.albumData);
            debugPrint('Swiped Right');
          }
        },
        onTap: (){
          //Routes.navigateToAlbumBody(context, widget.bannerImage, widget.albumData);
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