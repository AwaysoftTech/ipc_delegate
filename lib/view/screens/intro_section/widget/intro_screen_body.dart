
import 'package:flutter/material.dart';

class CustomPage extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;

  const CustomPage({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration Container
          Container(
            width: double.infinity,
            height: size.height * 0.38,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5FF),
              borderRadius: BorderRadius.circular(32),
            ),
            padding: const EdgeInsets.all(24),
            child: Image.asset(
              imagePath,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.image_not_supported_outlined,
                  size: 70,
                  color: Colors.grey,
                );
              },
            ),
          ),

          const SizedBox(height: 38),

          // Title
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.w800,
              color: Color(0xFF172554),
              height: 1.3,
              letterSpacing: -0.5,
            ),
          ),

          const SizedBox(height: 16),

          // Description
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Color(0xFF64748B),
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }
}
