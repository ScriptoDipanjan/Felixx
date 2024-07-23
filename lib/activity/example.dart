import 'package:felixx/bookfx/book_fx.dart';
import 'package:felixx/bookfx/book_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:felixx/constants/colors.dart';
import 'package:felixx/constants/strings.dart';
import 'package:felixx/widgets/stateless_widgets.dart';
import 'package:flutter/material.dart';
import 'package:felixx/constants/dimens.dart' as dimensions;


/// 自定义
class CustomWidget extends StatefulWidget {
  final List images;
  const CustomWidget(this.images, {Key? key}) : super(key: key);

  @override
  State<CustomWidget> createState() => _CustomWidgetState();
}

class _CustomWidgetState extends State<CustomWidget> {
  BookController bookController = BookController();

  /*List images = [
    'assets/images/splash.jpg',
    'assets/images/placeholder.png',
    'assets/images/splash.jpg',
    'assets/images/placeholder.png',
    'assets/images/placeholder.png',
    'assets/images/splash.jpg',
    'assets/images/placeholder.png',
  ];*/

  @override
  void initState(){
    super.initState();
    debugPrint("albumID: ${widget.images}");
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
    return Placeholder(
      child: BookFx(
        size: Size(
          dimensions.height * 1.1,
          dimensions.width,
        ),
        pageCount: widget.images.length,
        currentBgColor: ColorList.colorGrey,
        images: widget.images,
        currentPage: (index) {
          return Container(
            color: ColorList.colorPrimary,
            alignment: Alignment.center,
            child: CachedNetworkImage(
              imageUrl: "${Strings.urlMain}/${widget.images.elementAt(index)['images']}",
              height: dimensions.width,
              fit: BoxFit.contain,
              progressIndicatorBuilder: (context, url, progress) => StatelessWidgets.getLoadingScreen(dimensions.height),
            ),
          );
        },
        lastCallBack: (index) {
          debugPrint('previous $index');
        },
        nextCallBack: (index) {
          debugPrint('next $index');
        },
        nextPage: (index) {
          return Container(
            color: ColorList.colorPrimary,
            alignment: Alignment.center,
            child: CachedNetworkImage(
              imageUrl: "${Strings.urlMain}/${widget.images.elementAt(index)['images']}",
              height: dimensions.width,
              fit: BoxFit.contain,
            ),
          );
        },
        controller: bookController,
      ),
    );
    /*return Row(
      children: [
        Placeholder(
          child: BookFx(
            size: Size(
              MediaQuery.of(context).size.height/2,
              MediaQuery.of(context).size.width,
            ),
            pageCount: widget.images.length,
            currentPage: (index) {
              return Image.network(
                "${Strings.urlMain}/${widget.images.elementAt(index)['images']}",
                fit: BoxFit.fill,
                width: MediaQuery.of(context).size.width,
                height: double.infinity,

              );
            },
            lastCallBack: (index) {
              print('xxxxxx上一页  $index');
            },
            nextCallBack: (index) {
              print('next $index');
            },
            nextPage: (index) {
              return Image.network(
                "${Strings.urlMain}/${widget.images.elementAt(index)['images']}",
                fit: BoxFit.fill,
                width: MediaQuery.of(context).size.width,
                height: double.infinity,
              );
            },
            controller: bookController,
          ),
        ),
        /*Placeholder(
          child: BookFx(
            size: Size(
              MediaQuery.of(context).size.height/2,
              MediaQuery.of(context).size.width,
            ),
            pageCount: widget.images.length,
            currentPage: (index) {
              return Image.network(
                "${Strings.urlMain}/${widget.images.elementAt(index)['images']}",
                fit: BoxFit.fill,
                width: MediaQuery.of(context).size.width,
                height: double.infinity,

              );
            },
            lastCallBack: (index) {
              print('xxxxxx上一页  $index');
            },
            nextCallBack: (index) {
              print('next $index');
            },
            nextPage: (index) {
              return Image.network(
                "${Strings.urlMain}/${widget.images.elementAt(index)['images']}",
                fit: BoxFit.fill,
                width: MediaQuery.of(context).size.width,
                height: double.infinity,
              );
            },
            controller: bookController,
          ),
        ),*/
      ],
    );*/
  }
}