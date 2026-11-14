
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  debugPrint('STEP 1: Flutter initialized');

  runApp(const MyApp());

  debugPrint('STEP 2: runApp executed');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('STEP 3: MyApp build executed');

    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Text(
            'IPC DELEGATE RUNNING',
            style: TextStyle(
              fontSize: 26,
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
