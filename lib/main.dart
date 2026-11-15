
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DiagnosticScreen(),
    );
  }
}

class DiagnosticScreen extends StatelessWidget {
  const DiagnosticScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final size = MediaQuery.of(context).size;
            final orientation = MediaQuery.of(context).orientation;

            debugPrint('========== FLUTTER VIEW ==========');
            debugPrint('ORIENTATION: $orientation');
            debugPrint('SCREEN SIZE: $size');
            debugPrint('CONSTRAINTS: $constraints');
            debugPrint('==================================');

            return Center(
              child: Text(
                'FLUTTER RENDERING WORKING\n'
                    '$orientation\n'
                    '$size',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.yellow,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
