
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  debugPrint('TEST 1: Flutter initialized');

  runApp(
    const ColoredBox(
      color: Colors.red,
      child: Center(
        child: ColoredBox(
          color: Colors.yellow,
          child: Padding(
            padding: EdgeInsets.all(30),
            child: Text(
              'FLUTTER RENDERING WORKING',
              style: TextStyle(
                fontSize: 26,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    ),
  );

  WidgetsBinding.instance.addPostFrameCallback((_) {
    debugPrint('TEST 3: FIRST FRAME COMPLETED');

    for (final view in WidgetsBinding.instance.platformDispatcher.views) {
      debugPrint('VIEW SIZE: ${view.physicalSize}');
      debugPrint('DEVICE PIXEL RATIO: ${view.devicePixelRatio}');
    }
  });
}
