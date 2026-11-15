import 'dart:io';
import 'dart:ui';

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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    debugPrint('FLUTTER ERROR: ${details.exception}');
    debugPrint('${details.stack}');
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('PLATFORM ERROR: $error');
    debugPrint('$stack');
    return true;
  };

  debugPrint('STEP 1: Flutter started');

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  debugPrint('FIREBASE APP COUNT: ${Firebase.apps.length}');
  debugPrint('FIREBASE APP NAME: ${Firebase.app().name}');
  debugPrint('FIREBASE PROJECT: ${Firebase.app().options.projectId}');
  debugPrint('FIREBASE APP ID: ${Firebase.app().options.appId}');

  // Register Firebase Messaging background handler
  if (!kIsWeb) {
    FirebaseMessaging.onBackgroundMessage(
      firebaseMessagingBackgroundHandler,
    );
  }

  debugPrint('STEP 3: Initializing SharedPreferences');

  final sharedPreferences = await SharedPreferences.getInstance();

  Get.put<SharedPreferences>(
    sharedPreferences,
    permanent: true,
  );

  debugPrint('STEP 4: Initializing services');

  final languages = await services.init();

  debugPrint('STEP 5: Services initialized');
  debugPrint('Languages loaded: ${languages.length}');

  HttpOverrides.global = MyHttpOverrides();

  debugPrint('STEP 6: Calling runApp');

  runApp(MyApp(languages: languages));

  debugPrint('STEP 3: runApp executed');
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  debugPrint('Background message: ${message.messageId}');
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
