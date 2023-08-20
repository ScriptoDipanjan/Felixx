import 'dart:math';

import 'package:felixx/constants/colors.dart';
import 'package:flutter/material.dart';
import '../constants/dimens.dart' as dimensions;

class MyHomePage extends StatefulWidget {

  final String title;
  const MyHomePage({required this.title, Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _toggler = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        TextButton(
          onPressed: _onFlipCardPressed,
          child: const Text('change', style: TextStyle(color: Colors.white)),
        )
      ]),
      body: Center(
        child: SizedBox.square(
          dimension: 140,
          child: FlipCard(
            toggler: _toggler,
            frontCard: AppCard(title: 'Front'),
            backCard: AppCard(title: 'Back'),
          ),
        ),
      ),
    );
  }

  void _onFlipCardPressed() {
    setState(() {
      _toggler = !_toggler;
    });
  }
}

class AppCard extends StatelessWidget {
  final String title;

  const AppCard({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.deepPurple[400],
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 40.0,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class FlipCard extends StatelessWidget {
  final bool toggler;
  final Widget frontCard;
  final Widget backCard;

  const FlipCard({
    required this.toggler,
    required this.backCard,
    required this.frontCard,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 2000),
        transitionBuilder: _transitionBuilder,
        layoutBuilder: (widget, list) => Stack(children: [widget!, ...list]),
        switchInCurve: Curves.ease,
        switchOutCurve: Curves.ease.flipped,
        child: toggler
            ? SizedBox(key: const ValueKey('front'), child: frontCard)
            : SizedBox(key: const ValueKey('back'), child: backCard),
      ),
    );
  }

  Widget _transitionBuilder(Widget widget, Animation<double> animation) {
    final rotateAnimation = Tween(begin: pi, end: 0.0).animate(animation);
    return AnimatedBuilder(
      animation: rotateAnimation,
      child: widget,
      builder: (context, widget) {
        final isFront = ValueKey(toggler) == widget!.key;
        final rotationY = isFront ? rotateAnimation.value : min(rotateAnimation.value, pi * 0.5);
        return Transform(
          transform: Matrix4.rotationY(rotationY)..setEntry(3, 0, 0),
          alignment: Alignment.center,
          child: widget,
        );
      },
    );
  }
}