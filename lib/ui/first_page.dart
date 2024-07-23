import 'package:felixx/ui/second_page.dart';

import 'package:flutter/material.dart';
import 'package:turn_page_transition/turn_page_transition.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {

    final deviceSize = MediaQuery.of(context).size;
    final ratio = deviceSize.width / deviceSize.height;
    final animationTransitionPoint = ratio < 9 / 16 ? 0.5 : 0.2;

    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('First Page'),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('back to home page'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                TurnPageRoute(
                  overleafColor: Colors.grey,
                  animationTransitionPoint: animationTransitionPoint,
                  transitionDuration: const Duration(milliseconds: 300),
                  reverseTransitionDuration: const Duration(milliseconds: 300),
                  builder: (context) => const SecondPage(),
                ),
              ),
              child: const Text('go to second page'),
            ),
          ],
        ),
      ),
    );
  }
}