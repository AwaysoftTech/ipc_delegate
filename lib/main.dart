import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:ipc_delegates/core/utils/local_strings.dart';
import 'package:ipc_delegates/core/utils/messages.dart';
import 'package:ipc_delegates/core/utils/themes.dart';
import 'package:ipc_delegates/data/controller/common/theme_controller.dart';
import 'package:ipc_delegates/data/controller/localization/localization_controller.dart';
import 'package:ipc_delegates/core/route/route.dart';

import 'core/di_service/di_services.dart' as services;
import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  debugPrint('Background message: ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Register Firebase Messaging background handler
  if (!kIsWeb) {
    FirebaseMessaging.onBackgroundMessage(
      firebaseMessagingBackgroundHandler,
    );
  }

  final sharedPreferences = await SharedPreferences.getInstance();

  Get.lazyPut(() => sharedPreferences);

  Map<String, Map<String, String>> languages =
  await services.init();

  HttpOverrides.global = MyHttpOverrides();

  runApp(MyApp(languages: languages));
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  final Map<String, Map<String, String>> languages;

  const MyApp({super.key, required this.languages});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (theme) {
        return GetBuilder<LocalizationController>(
          builder: (localizeController) {
            return GetMaterialApp(
              title: LocalStrings.appName,
              debugShowCheckedModeBanner: false,
              defaultTransition: Transition.noTransition,
              transitionDuration:
              const Duration(milliseconds: 200),
              initialRoute: RouteHelper.splashScreen,
              navigatorKey: Get.key,
              theme: theme.darkTheme ? dark : light,
              getPages: RouteHelper().routes,
              locale: localizeController.locale,
              translations: Messages(languages: languages),
              fallbackLocale: Locale(
                localizeController.locale.languageCode,
                localizeController.locale.countryCode,
              ),
            );
          },
        );
      },
    );
  }
}
