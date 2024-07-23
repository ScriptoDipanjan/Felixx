import 'package:flutter/material.dart';

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.greenAccent,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Second Page'),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('back to first page'),
            ),
          ],
        ),
      ),
    );
  }
}