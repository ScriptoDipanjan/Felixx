import 'dart:math';

import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {

  final String title;
  const MyHomePage({required this.title, super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _rotationAnimation = Tween<double>(begin: 0.0, end: -0.785) // Adjust for desired rotation
        .animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Front page content
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) => Transform(
            alignment: Alignment.centerLeft,
            transform: Matrix4.identity()..rotateY(_rotationAnimation.value),
            child: child,
          ),
          child: Text('Front Page'),
        ),
        // Back page content (can be hidden initially)
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) => Transform(
            alignment: Alignment.centerRight,
            transform: Matrix4.identity()..rotateY(_rotationAnimation.value * -1),
            //opacity: 1.0 - _rotationAnimation.value, // Fade in as front page rotates
            child: child,
          ),
          child: Text('Back Page'),
        ),
        // Gesture detection (e.g., GestureDetector) to trigger animation
      ],
    );
  }
}