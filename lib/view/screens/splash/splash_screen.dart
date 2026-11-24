import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ipc_delegates/core/utils/color_resources.dart';
import 'package:ipc_delegates/core/utils/images.dart';
import 'package:ipc_delegates/core/utils/util.dart';
import 'package:ipc_delegates/data/controller/common/theme_controller.dart';
import 'package:ipc_delegates/data/controller/localization/localization_controller.dart';
import 'package:ipc_delegates/data/controller/splash/splash_controller.dart';
import 'package:ipc_delegates/data/services/api_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;
  late final Animation<double> _fade;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    // Entrance animation
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fade = CurvedAnimation(parent: _anim, curve: Curves.easeOut);
    _scale = Tween<double>(begin: 0.85, end: 1).animate(
      CurvedAnimation(parent: _anim, curve: Curves.easeOutBack),
    );
    _anim.forward();

    // ---- Existing logic (unchanged) ----
    Get.put(ApiClient(sharedPreferences: Get.find()));

    final themeController = ThemeController(sharedPreferences: Get.find());

    MyUtils.splashScreenUtils(themeController.darkTheme);

    Get.put(LocalizationController(
      sharedPreferences: Get.find(),
    ));

    final controller = Get.put(
      SplashController(
        splashRepo: Get.find(),
        localizationController: Get.find(),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.gotoNextPage();
    });
  }

  @override
  void dispose() {
    _anim.dispose();

    final themeController = ThemeController(sharedPreferences: Get.find());

    MyUtils.allScreensUtils(themeController.darkTheme);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = ColorResources.primaryColor;
    final hsl = HSLColor.fromColor(primary);
    final darker =
    hsl.withLightness((hsl.lightness - 0.18).clamp(0.0, 1.0)).toColor();

    return GetBuilder<SplashController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: darker,
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [primary, darker],
              ),
            ),
            child: Stack(
              children: [
                // Decorative circles
                Positioned(
                  top: -90,
                  right: -70,
                  child: _circle(260, 0.08),
                ),
                Positioned(
                  top: 140,
                  left: -90,
                  child: _circle(180, 0.06),
                ),
                Positioned(
                  bottom: -110,
                  left: -60,
                  child: _circle(300, 0.07),
                ),
                SafeArea(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                          ),
                          child: FadeTransition(
                            opacity: _fade,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 28,
                                vertical: 24,
                              ),
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildBranding(primary),
                                  _buildBottom(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // --------------------------------------------------------------- Branding
  Widget _buildBranding(Color primary) {
    return Column(
      children: [
        const SizedBox(height: 50),
        ScaleTransition(
          scale: _scale,
          child: Container(
            width: 180,
            height: 180,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(44),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 40,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
            child: Image.asset(MyImages.appLogos, fit: BoxFit.contain),
          ),
        ),
        const SizedBox(height: 36),
        const Text(
          '75th IPC Delegate',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: 44,
          height: 4,
          decoration: BoxDecoration(
            color: ColorResources.secondaryColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          'Welcome to the Indian Pharmaceutical Congress',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.85),
            fontSize: 14,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  // ----------------------------------------------------------------- Bottom
  Widget _buildBottom() {
    return Column(
      children: [
        const SizedBox(height: 40),
        const SpinKitThreeBounce(color: Colors.white, size: 24),
        const SizedBox(height: 14),
        Text(
          'Preparing your experience...',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 32),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          ),
          child: Column(
            children: [
              Text(
                'POWERED BY',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Operant Pharmacy Federation',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _circle(double size, double opacity) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: opacity),
      ),
    );
  }
}