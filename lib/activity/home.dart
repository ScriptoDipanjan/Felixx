import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:scanning_effect/scanning_effect.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

import '../api/api_calls.dart';
import '../constants/colors.dart';
import '../constants/dimens.dart' as dimensions;
import '../constants/strings.dart';
import '../utils/methods.dart';
import '../utils/routes.dart';
import '../widgets/stateless_widgets.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DateTime currentBackPressTime = DateTime.now();
  bool isLoading = true, isError = false;
  String? userName = Strings.stringUser;
  List data = [];
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _getUserDetails();
    _prepareDashboardData();
  }

  @override
  Widget build(BuildContext context) {

    Methods.setDimensions(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorList.colorGrey,
        elevation: 15.0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Strings.stringWelcome,
              style: TextStyle(
                fontSize: dimensions.px12,
              ),
            ),
            SizedBox(height: dimensions.px2),
            Text(
              userName!,
              style: TextStyle(
                fontSize: dimensions.px17,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: dimensions.px5),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => _showLogoutDialog(),
            icon: const Icon(
              Icons.logout_outlined,
              color: ColorList.colorOrange,
            ),
          ),
        ],
      ),
      body: WillPopScope(
        onWillPop: onWillPop,
        child: GestureDetector(
          onTap: () => isDialOpen.value = false,
          child: isLoading
              ? StatelessWidgets.getLoadingScreen(dimensions.height)
              : data.isEmpty ? StatelessWidgets.getEmptyResult(isError, _prepareDashboardData) : _buildListView(),
        )
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        backgroundColor: ColorList.colorBlue,
        foregroundColor: ColorList.colorAccent,
        activeBackgroundColor: ColorList.colorOrange,
        activeForegroundColor: ColorList.colorAccent,
        buttonSize: Size(dimensions.px40, dimensions.px40),
        childrenButtonSize: Size(dimensions.px40, dimensions.px40),
        visible: true,
        closeManually: false,
        openCloseDial: isDialOpen,
        curve: Curves.easeInOutBack,
        overlayColor: ColorList.colorPrimary,
        overlayOpacity: 0.5,
        elevation: 15.0,
        shape: const CircleBorder(),
        spaceBetweenChildren: dimensions.px3,
        spacing: dimensions.px3,
        children: [
          SpeedDialChild(
            onTap: _addAlbumDialog,
            label: Strings.stringAddAnAlbum,
            backgroundColor: ColorList.colorBlue,
            foregroundColor: ColorList.colorAccent,
            child: const Icon(Icons.edit),
          ),
          SpeedDialChild(
            onTap: _scanAlbumDialog,
            label: Strings.stringScanAnAlbumCode,
            backgroundColor: ColorList.colorBlue,
            foregroundColor: ColorList.colorAccent,
            child: const Icon(Icons.camera_alt_outlined),
          ),
        ],
        onOpen: () => isDialOpen.value = true,
        onClose: () => isDialOpen.value = false,
      ),
    );
  }

  _getUserDetails() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      userName = pref.getString('user_full_name');
    });
  }

  Future<void> _prepareDashboardData() async {
    if(isError || !isLoading) {
      setState(() {
        isLoading = true;
        isError = false;
      });
    }

    _getDashboardData();
  }

  _getDashboardData() {
    ApiCalls.fetchAlbumList()
        .then((response){
      setState(() {
        if(response != '')  {
          data = json.decode(response)['albums'];
        } else {
          isError = true;
          debugPrint("isError: $isError");
        }
        isLoading = false;
      });
    });
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if(isDialOpen.value){
      isDialOpen.value = false;
      return Future.value(false);
    } else if (now.difference(currentBackPressTime) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      Methods.showToast(Strings.stringConfirmExit);
      return Future.value(false);
    }
    return Future.value(true);
  }

  _addAlbumDialog() {
    isDialOpen.value = false;
    if(!isLoading){
      final controllerID = TextEditingController();
      FocusNode focusNodeID = FocusNode();
      bool statEnabled = true;

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
                        Text(
                          Strings.stringAddAlbumHeader,
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
                            labelText: Strings.stringAlbumID,
                            labelStyle: const TextStyle(color: ColorList.colorGrey),
                            alignLabelWithHint: true,
                          ),
                          enabled: statEnabled,
                          controller: controllerID,
                          keyboardType: TextInputType.text,
                          maxLines: 1,
                          cursorColor: ColorList.colorPrimary,
                          focusNode: focusNodeID,
                          textInputAction: TextInputAction.next,
                        ),
                        SizedBox(height: dimensions.px15),
                        SizedBox(
                          width: double.infinity,
                          height: dimensions.px45,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: dimensions.widthOneThird,
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
                                width: dimensions.widthHalf,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(dimensions.px10),
                                  color: ColorList.colorBlue,
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    if(controllerID.text.isNotEmpty){
                                      setModalState(() => statEnabled = false);
                                      SystemChannels.textInput.invokeMethod('TextInput.hide');
                                      ApiCalls.albumAdd(controllerID.text)
                                          .then((status){
                                        Routes.navigateToLastPage();
                                        _prepareDashboardData();
                                      });
                                    } else {
                                      Methods.showError(Strings.stringErrorAlbumID);
                                      SystemChannels.textInput.invokeMethod('TextInput.show');
                                      FocusScope.of(context).requestFocus(focusNodeID);
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
                                    Strings.stringAddAlbum,
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
            );
          }
      );
    }
  }

  _scanAlbumDialog() {
    isDialOpen.value = false;
    if(!isLoading){
      bool statEnabled = true, torchEnabled = false;
      MobileScannerController controller = MobileScannerController(
        detectionSpeed: statEnabled ? DetectionSpeed.normal : DetectionSpeed.noDuplicates,
        facing: CameraFacing.back,
        torchEnabled: torchEnabled,
      );

      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          enableDrag: false,
          isDismissible: false,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(dimensions.px25),
            ),
          ),
          builder: (context) {
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState){
                return Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(dimensions.px25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        Strings.stringScanAlbumHeader,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: dimensions.px20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: dimensions.px25),
                      SizedBox(
                        height: dimensions.widthTwoThirdWithPadding,
                        width: dimensions.widthTwoThirdWithPadding,
                        child: Stack(
                          children: [
                            ScanningEffect(
                              scanningColor: ColorList.colorBlue,
                              borderLineColor: ColorList.colorBlue,
                              delay: const Duration(seconds: 1),
                              duration: const Duration(milliseconds: 1250),
                              scanningLinePadding: EdgeInsets.all(dimensions.px20),
                              child: MobileScanner(
                                controller: controller,
                                onDetect: (capture) {
                                  final List<Barcode> barcodes = capture.barcodes;
                                  for (final barcode in barcodes) {
                                    if(statEnabled) {
                                      debugPrint('Barcode found! ${barcode.rawValue}');
                                      ApiCalls.albumAdd(barcode.rawValue)
                                        .then((status) {
                                          controller.dispose();
                                          Routes.navigateToLastPage();
                                          _prepareDashboardData();
                                        }
                                      );
                                      setModalState(() => statEnabled = false);
                                    }
                                  }
                                },
                              ),
                            ),
                            statEnabled ? Container() : StatelessWidgets.getLoadingScreen(dimensions.width),
                          ],
                        ),
                      ),
                      SizedBox(height: dimensions.px25,),
                      SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Material(
                              elevation: 30.0,
                              color: Colors.transparent,
                              child: Container(
                                width: dimensions.px50,
                                height: dimensions.px50,
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: ColorList.colorOrange,
                                ),
                                child: GestureDetector(
                                  onTap: () => Routes.navigateToLastPage(),
                                  child: const Icon(
                                    Icons.close,
                                    color: ColorList.colorAccent,
                                  ),
                                ),
                              ),
                            ),
                            Material(
                              elevation: 30.0,
                              color: Colors.transparent,
                              child: Container(
                                width: dimensions.px50,
                                height: dimensions.px50,
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: ColorList.colorBlue,
                                ),
                                child: GestureDetector(
                                  onTap: () => setModalState(() {
                                    torchEnabled = !torchEnabled;
                                    controller.toggleTorch();
                                  }),
                                  child: Icon(
                                    torchEnabled ? Icons.flash_off : Icons.flash_on,
                                    color: ColorList.colorAccent,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
      );
    }
  }

  _buildListView() {
    return RefreshIndicator(
      onRefresh: () => _prepareDashboardData(),
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.all(dimensions.px15),
        itemCount: data.length,
        itemBuilder: (context, index) {
          return _buildImageColumn(index);
        },
      ),
    );
  }

  _buildImageColumn(index) {
    return GestureDetector(
      onTap: () async {
        Routes.navigateToAlbumView(data[index]['image_url'] + data[index]['banner'], data[index]['id']);
      },
      child: Container(
        height: dimensions.heightAlbumChild,
        width: double.infinity,
        margin: EdgeInsets.only(bottom: dimensions.px10),
        decoration: BoxDecoration(
          color: ColorList.colorGreyBorder,
          borderRadius: BorderRadius.circular(dimensions.px15),
          image: DecorationImage(
            image: AssetImage(Strings.imagePlaceholder,),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            const Center(
              child: CircularProgressIndicator(
                color: ColorList.colorBlue,
              ),
            ),
            Container(
              height: dimensions.heightAlbumChild,
              width: double.infinity,
              //margin: (index == data.length-1) ? EdgeInsets.zero : EdgeInsets.only(bottom: dimensions.px3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(dimensions.px15),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(data[index]['image_url'] + data[index]['banner'],),
                  fit: BoxFit.fitHeight,
                ),
              ),
              child: Container(
                padding: EdgeInsets.only(
                  left: dimensions.px20,
                  top: dimensions.px10,
                  right: dimensions.px10,
                  bottom: dimensions.px20,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(dimensions.px15),
                  gradient: LinearGradient(
                    begin: FractionalOffset.centerRight,
                    end: FractionalOffset.centerLeft,
                    colors: [
                      ColorList.colorGrey.withOpacity(0.0),
                      ColorList.colorPrimary,
                    ],
                    stops: const [0.0, 1.0],
                  ),
                ),
                width: dimensions.heightAlbumChild,
                child: Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: dimensions.px85),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Spacer(),
                          Text(
                            data[index]['name'],
                            style: TextStyle(
                              color: ColorList.colorAccent,
                              fontSize: dimensions.px20,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                          ),
                          SizedBox(height: dimensions.px5,),
                          Text(
                            Strings.stringPublishedBy + data[index]['creator_name'],
                            style: TextStyle(
                              color: ColorList.colorAccent,
                              fontSize: dimensions.px12,
                              fontWeight: FontWeight.normal,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Material(
                        elevation: 20.0,
                        color: Colors.transparent,
                        child: Container(
                          width: dimensions.px30,
                          height: dimensions.px30,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: ColorList.colorAccent,
                            border: Border.all(color: ColorList.colorOrange, width: 1.5),
                          ),
                          child: GestureDetector(
                            onTap: (){
                              _showMenuDialog(data[index]['album_id'], data[index]['qr_code']);
                            },
                            child: const Icon(
                              Icons.more_horiz,
                              color: ColorList.colorOrange,
                            ),
                            /*child: Image.asset(
                              Strings.iconDelete,
                              height: dimensions.px18,
                              width: dimensions.px15,
                            ),*/
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Material(
                            elevation: 20.0,
                            color: Colors.transparent,
                            child: Container(
                              width: dimensions.px35,
                              height: dimensions.px35,
                              margin: EdgeInsets.only(right: dimensions.px10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: ColorList.colorAccent,
                                border: Border.all(color: ColorList.colorOrange, width: 2),
                              ),
                              child: GestureDetector(
                                onTap: (){
                                  _shareAlbum(0, data[index]['album_id'], data[index]['name'], Methods.getURL(data[index]));
                                },
                                child: Image.asset(
                                  Strings.iconWhatsapp,
                                  height: dimensions.px17,
                                  width: dimensions.px17,
                                ),
                              ),
                            ),
                          ),
                          Material(
                            elevation: 20.0,
                            color: Colors.transparent,
                            child: Container(
                              width: dimensions.px35,
                              height: dimensions.px35,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: ColorList.colorAccent,
                                border: Border.all(color: ColorList.colorBlue, width: 2),
                              ),
                              child: GestureDetector(
                                onTap: (){
                                  _shareAlbum(1, data[index]['album_id'], data[index]['name'], Methods.getURL(data[index]));
                                },
                                child: Image.asset(
                                  Strings.iconEmail,
                                  color: ColorList.colorBlue,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _showMenuDialog(albumID, url) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      isDismissible: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(dimensions.px20),
        ),
      ),
      builder: (context) {
        return SizedBox(
          height: dimensions.px65,
          child: Column(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: dimensions.px50,
                  height: dimensions.px3,
                  margin: EdgeInsets.only(top: dimensions.px10),
                  decoration: BoxDecoration(
                    color: ColorList.colorGreyBorder,
                    borderRadius: BorderRadius.circular(dimensions.px10),
                  ),
                ),
              ),
              Wrap(
                children: [
                  /*ListTile(
                    leading: Container(
                      width: dimensions.px30,
                      height: dimensions.px30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: ColorList.colorAccent,
                        border: Border.all(color: ColorList.colorBlue, width: 2),
                      ),
                      child: Icon(
                        Icons.share,
                        color: ColorList.colorBlue,
                        size: dimensions.px20,
                      ),
                    ),
                    title: Text(
                      Strings.stringShareAlbum,
                      style: TextStyle(
                        color: ColorList.colorBlue,
                        fontSize: dimensions.px15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () {
                      _shareAlbum(albumID, url);
                      Routes.navigateToLastPage();
                    },
                  ),
                  Container(
                    height: dimensions.px1,
                    width: double.infinity,
                    color: ColorList.colorGreyBorder,
                  ),*/
                  ListTile(
                    leading: Container(
                      width: dimensions.px30,
                      height: dimensions.px30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: ColorList.colorAccent,
                        border: Border.all(color: ColorList.colorOrange, width: 2),
                      ),
                      child: Icon(
                        Icons.delete,
                        color: ColorList.colorOrange,
                        size: dimensions.px20,
                      ),
                    ),
                    title: Text(
                      Strings.stringRemoveAlbum,
                      style: TextStyle(
                        color: ColorList.colorOrange,
                        fontSize: dimensions.px15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () {
                      Routes.navigateToLastPage();
                      _removeAlbumDialog(albumID);
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  _shareAlbum(type, albumID, albumName, url) async {
    if(type == 0){
      String text = Uri.encodeComponent('${Strings.stringShareAlbumHeader}*$albumID*${Strings.stringShareAlbumURL} $url');

      String appUrl = "https://wa.me/?text=$text";
      Uri whatsapp = Uri.parse(appUrl);

      await launchUrl(
        whatsapp,
        mode: LaunchMode.externalNonBrowserApplication,
      );

    } else if(type == 1){

      String email = Uri.encodeComponent("");
      String subject = Uri.encodeComponent('${Strings.stringShareAlbum}: $albumName');
      String body = Uri.encodeComponent('${Strings.stringShareAlbumHeader}"$albumID"${Strings.stringShareAlbumURL} $url');

      String appUrl = "mailto:$email?subject=$subject&body=$body";
      Uri mail = Uri.parse(appUrl);

      await launchUrl(
        mail,
        mode: LaunchMode.externalNonBrowserApplication,
      );
    }
  }

  _removeAlbumDialog(albumID) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) =>
            Theme(
              data: ThemeData.dark(),
              child: CupertinoAlertDialog(
                insetAnimationDuration: const Duration(seconds: 5),
                insetAnimationCurve: Curves.easeOut,
                title: Text(Strings.stringRemoveAlbum),
                content: Text(Strings.stringAreYouSure),
                actions: <CupertinoDialogAction>[
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    onPressed: () {
                      Routes.navigateToLastPage();
                    },
                    child: Text(Strings.stringNo),
                  ),
                  CupertinoDialogAction(
                    isDestructiveAction: true,
                    onPressed: () {
                      Routes.navigateToLastPage();
                      setState(() {
                        isLoading = true;
                      });
                      ApiCalls.albumRemove(albumID).then((value) => _getDashboardData());
                    },
                    child: Text(Strings.stringYes),
                  ),
                ],
              ),
            ),
    );
  }

  _showLogoutDialog() {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) =>
          Theme(
            data: ThemeData.dark(),
            child: CupertinoAlertDialog(
              insetAnimationDuration: const Duration(seconds: 5),
              insetAnimationCurve: Curves.easeOut,
              title: Text(Strings.stringLogout),
              content: Text(Strings.stringAreYouSure),
              actions: <CupertinoDialogAction>[
                CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: () {
                    Routes.navigateToLastPage();
                  },
                  child: Text(Strings.stringNo),
                ),
                CupertinoDialogAction(
                  isDestructiveAction: true,
                  onPressed: () {
                    Routes.navigateToLastPage();
                    setState(() {
                      isLoading = true;
                    });
                    ApiCalls.callLogout();
                  },
                  child: Text(Strings.stringYes),
                ),
              ],
            ),
          ),
    );
  }
}