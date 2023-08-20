import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:felixx/api/api_calls.dart';
import 'package:felixx/constants/dimens.dart' as dimensions;
import 'package:felixx/utils/methods.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../constants/colors.dart';
import '../constants/strings.dart';
import '../utils/routes.dart';

class AlbumView extends StatefulWidget{
  final String bannerImage, albumID;
  const AlbumView(this.bannerImage, this.albumID, {Key? key}) : super(key: key);

  @override
  State<AlbumView> createState() => _AlbumViewState();
}

class _AlbumViewState extends State<AlbumView> with TickerProviderStateMixin {

  List albumData = [];
  bool isLoading = true;
  int currentIndex = 0;
  late PageController pageController;
  late Animation animation;
  late AnimationController controllerFront;
  late AnimationController _animationController;
  late Animation _animation;
  AnimationStatus _animationStatus = AnimationStatus.dismissed;
  int page = 0;

  @override
  void initState(){
    super.initState();
    ColorList.setEnabledSystemUIModeHidden();
    ColorList.setLockedLandscape();
    pageController = PageController(initialPage: currentIndex);
    _getAlbumData();

    controllerFront = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    Tween tween = Tween(begin: dimensions.heightHalf - dimensions.heightHalf/2, end: dimensions.heightHalf);
    animation = tween.animate(controllerFront);
    animation.addListener(() {
      setState(() {
      });
    });

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
    pageController.dispose();
    ColorList.setLockedPortrait();
    ColorList.setEnabledSystemUIMode();
  }

  @override
  Widget build(BuildContext context) {

    Methods.setDimensions(context);

    return Scaffold(
      backgroundColor: ColorList.colorGrey,
      body: buildCover(),
    );
  }

  buildCover() {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! > 0) {
          // User swiped Left
          //_animationController.reverse();
          controllerFront.reverse();
          debugPrint('Swiped Left');
        } else if (details.primaryVelocity! < 0) {
          // User swiped Right
          //_animationController.forward();
          controllerFront.forward();
          debugPrint('Swiped Right');
        }
      },
      child: Stack(
          alignment: Alignment.center,
          children: [
            Stack(
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
            Positioned(
              width: dimensions.heightHalf,
              height: dimensions.heightOneThird,
              left: animation.value,
              top: (dimensions.height - dimensions.heightOneThird)/2,
              child: Center(
                child: Container(
                  alignment: Alignment.center,
                  width: dimensions.heightHalf,
                  height: dimensions.heightOneThird,
                  decoration: BoxDecoration(
                    color: ColorList.colorPrimary,
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(widget.bannerImage),
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                  child: isLoading
                      ? Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: dimensions.px20),
                            child: const CircularProgressIndicator(
                              color: ColorList.colorBlue,
                            ),
                          ),
                        )
                      : Container(),
                ),
              ),
            ),
          ]),
    );
  }

  buildViewer() {
    return Stack(
      children: [
        /*PhotoViewGallery.builder(
          scrollPhysics: const BouncingScrollPhysics(),
          builder: (BuildContext context, int index) {
            return PhotoViewGalleryPageOptions(
              imageProvider: CachedNetworkImageProvider('${Strings.urlMain}/${albumData[index]['images']}'),
              maxScale: 1.0,
              heroAttributes: PhotoViewHeroAttributes(tag: albumData[index]['images_id']),
            );
          },
          itemCount: albumData.length,
          loadingBuilder: (context, event) => Center(
            child: CircularProgressIndicator(
              color: ColorList.colorAccent,
              value: event == null
                  ? 0
                  : event.cumulativeBytesLoaded / event.expectedTotalBytes!.toInt(),
            ),
          ),
          //backgroundDecoration: widget.backgroundDecoration,
          pageController: pageController,
          onPageChanged: onPageChanged,
        ),*/
        /*Align(
          alignment: Alignment.bottomCenter,
          child: IconButton(
            icon: const Icon(
              Icons.skip_next_sharp,
              color: ColorList.colorRed,
            ),
            onPressed: (){
              pageController.animateToPage(
                currentIndex++,
                duration: const Duration(microseconds: 1),
                curve: Curves.linear,
              );
            },
          ),
        ),*/
      ],
    );
  }

  _getAlbumData(){
    ApiCalls.getAlbumDetails(widget.albumID)
        .then((data){
      setState(() {
        isLoading = false;
      });
      if(data != ''){
        setState(() {
          albumData = data.toList();
        });
      } else {
        Routes.navigateToLastPage();
      }
    });
  }

  onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

}

/*[
	{album_id: 4, images_id: 17, images: public/album/5399d1/58265.png},
	{album_id: 4, images_id: 18, images: public/album/5399d1/98904.png},
	{album_id: 4, images_id: 19, images: public/album/5399d1/42294.png}
]*/