import 'dart:convert';

import 'package:felixx/constants/colors.dart';
import 'package:felixx/constants/dimens.dart' as dimensions;
import 'package:felixx/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AlbumView extends StatefulWidget {
  final List images;
  const AlbumView(this.images, {super.key});

  @override
  State<AlbumView> createState() => _AlbumViewState();
}

class _AlbumViewState extends State<AlbumView> {
  late WebViewController controller;
  String dataHtmlBody = '';

  @override
  void initState() {
    super.initState();
    //ColorList.setEnabledSystemUIModeHidden();
    ColorList.setLockedLandscape();

    for(int i=0; i<widget.images.length; i++){
      dataHtmlBody += '<div ${(i == 0 || i == widget.images.length - 1) ? 'class="hard" ' : ''}'
              'style = "background: url(\'data:image/png;base64, ${widget.images.elementAt(i)['image_encoded']}\'); '
              'background-size: cover;">'
            '</div>';
    }

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..enableZoom(false)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return request.url.startsWith('https://www.youtube.com/')
                ? NavigationDecision.prevent
                : NavigationDecision.navigate;
          },
        ),
      )
    ..loadHtmlString(
        utf8.decode(base64.decode(Strings.stringHtmlHeader))
            + dataHtmlBody
            + utf8.decode(base64.decode(Strings.stringHTMLFooter))
    );
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
      body: Center(
        child: Container(
          alignment: Alignment.center,
          height: dimensions.width,
          width: dimensions.height,
          child: WebViewWidget(controller: controller),
        ),
      ),
    );
  }
}