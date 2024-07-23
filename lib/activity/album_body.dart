import 'package:felixx/constants/colors.dart';
import '../utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:turn_page_transition/turn_page_transition.dart';

class AlbumBody extends StatefulWidget{
  final String bannerImage;
  final List albumData;
  const AlbumBody(this.bannerImage, this.albumData, {super.key});

  @override
  State<AlbumBody> createState() => _AlbumBodyState();
}

class _AlbumBodyState extends State<AlbumBody> {
  bool isLoading = true;
  int indexCounter = 0;
  final controller = TurnPageController();

  @override
  void initState(){
    super.initState();
    ColorList.setEnabledSystemUIModeHidden();
    ColorList.setLockedLandscape();
    indexCounter = widget.albumData.length;
  }

  @override
  Widget build(BuildContext context) {
    final pages = List.generate(
      indexCounter,
          (index) {
        final b = 240 ~/ 10 * index;
        final color = Color.fromARGB(255, 48, 185, b);

        return _Page(index: index, color: color);
      },
    );

    return Scaffold(
      backgroundColor: ColorList.colorGrey,
      body: TurnPageView.builder(
        controller: controller,
        itemCount: indexCounter,
        itemBuilder: (context, index) {

          return GestureDetector(
            child: pages[index],
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity! > 0) {

                // User swiped Left
                debugPrint('Swiped Left');
                if(index > 0) {
                  controller.animateToPage(index - 1);
                } else {
                  Routes.navigateToLastPage();
                }

              } else if (details.primaryVelocity! < 0) {

                // User swiped Right
                navigateToAlbumBack(index);
                debugPrint('Swiped Right $index');

              }
            },

            onTap: (){
              navigateToAlbumBack(index);
            },
          );
        },
        overleafColorBuilder: (index) {
          final b = 150 ~/ 10 * index;
          return Color.fromARGB(255, 0, 100, b);
        },
        animationTransitionPoint: 0.5,
      ),
    );
  }

  void navigateToAlbumBack(index) {
    if(index < indexCounter) {
      controller.animateToPage(index + 1);
    } else {
      debugPrint('else block $index');
      Routes.navigateToAlbumBack(context, widget.bannerImage, widget.albumData);
    }
  }
}

class _Page extends StatefulWidget {
  const _Page({
    required this.index,
    required this.color,
  });

  final int index;
  final Color color;

  @override
  State<_Page> createState() => _PageState();
}

class _PageState extends State<_Page> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.color,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                'page: ${widget.index + 1}',
                style: const TextStyle(fontSize: 30),
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'count: $count',
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => setState(() {
                        count++;
                      }),
                      child: const Text('Add'),
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
}