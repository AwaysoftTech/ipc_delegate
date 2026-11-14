import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  debugPrint('TEST 1: Flutter initialized');

  runApp(const RenderTestApp());
}

class RenderTestApp extends StatelessWidget {
  const RenderTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('TEST 2: Widget build');

    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.red,
        body: Center(
          child: ColoredBox(
            color: Colors.yellow,
            child: Padding(
              padding: EdgeInsets.all(30),
              child: Text(
                'FLUTTER RENDER TEST',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}