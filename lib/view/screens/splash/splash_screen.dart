import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:ipc_delegates/core/utils/util.dart';
import 'package:ipc_delegates/data/controller/common/theme_controller.dart';
import 'package:ipc_delegates/data/controller/localization/localization_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ipc_delegates/core/utils/images.dart';
import 'package:ipc_delegates/data/controller/splash/splash_controller.dart';
import 'package:ipc_delegates/data/services/api_service.dart';
import 'package:ipc_delegates/core/utils/dimensions.dart';
import 'package:ipc_delegates/core/utils/style.dart';
import 'package:ipc_delegates/core/utils/color_resources.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:ipc_delegates/core/utils/notification/notification_service.dart';

class SplashScreen extends StatefulWidget
{
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
{
  final formKey = GlobalKey<FormState>();

  @override
  void initState()
  {
    Get.put(ApiClient(sharedPreferences: Get.find()));

    ThemeController themeController = ThemeController(sharedPreferences: Get.find());
    MyUtils.splashScreenUtils(themeController.darkTheme);

    Get.put(LocalizationController(sharedPreferences: Get.find()));
    final controller = Get.put(SplashController(splashRepo: Get.find(), localizationController: Get.find()));
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.gotoNextPage();
    });
  }

  @override
  void dispose() {
    ThemeController themeController = ThemeController(sharedPreferences: Get.find());
    MyUtils.allScreensUtils(themeController.darkTheme);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetBuilder<SplashController>(
        builder: (controller) => Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: Center(
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding:
                      const EdgeInsets.only(top: 180.0, bottom: 20.0),
                      child: Center(
                        child: Image.asset(MyImages.appLogos, height: 160),
                      ),
                    ),
                    const SizedBox(height: Dimensions.space1),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.space20,
                            vertical: Dimensions.space5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('75th IPC Delegate',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: Dimensions.space20),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.space20,
                            vertical: Dimensions.space30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                          SpinKitChasingDots(
                          color: ColorResources.primaryColor,
                          size: 40.0),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: Dimensions.space40),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.space20,
                            vertical: Dimensions.space30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Powered by',
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                            const SizedBox(height: Dimensions.space10),
                            Text('Operant Pharmacy Federation',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

          ),
        ),
      ),
    );
  }
}

