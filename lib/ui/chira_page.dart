import 'package:flutter/material.dart';

class ChiraPage extends StatelessWidget {
  const ChiraPage({super.key, required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color,
      body: const Center(
        child: Row(
          children: [
            Text(
              "ω・。) ﾁﾗｯ",
              style: TextStyle(
                fontSize: 50,
              ),
            ),
            Expanded(child: SizedBox()),
          ],
        ),
      ),
    );
  }
}