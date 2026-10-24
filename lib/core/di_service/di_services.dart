import 'package:ipc_delegates/data/controller/localization/localization_controller.dart';
import 'package:ipc_delegates/data/repo/splash/splash_repo.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ipc_delegates/data/controller/common/theme_controller.dart';
import 'package:ipc_delegates/data/controller/splash/splash_controller.dart';
import 'package:ipc_delegates/data/services/api_service.dart';
import 'package:ipc_delegates/data/controller/auth/login_controller.dart';
import 'package:ipc_delegates/data/repo/auth/login_repo.dart';
import 'package:ipc_delegates/data/controller/auth/verify_otp_controller.dart';
import 'package:ipc_delegates/data/repo/auth/verify_otp_repo.dart';
import 'package:ipc_delegates/data/repo/dashboard/dashboard_repo.dart';
import 'package:ipc_delegates/data/controller/dashboard/dashboard_controller.dart';
import 'package:ipc_delegates/data/repo/profile/profile_repo.dart';
import 'package:ipc_delegates/data/controller/profile/profile_controller.dart';

import 'package:ipc_delegates/data/controller/event_session/event_session_controller.dart';
import 'package:ipc_delegates/data/repo/event_session/event_session_repo.dart';

import 'package:ipc_delegates/data/controller/event/event_controller.dart';
import 'package:ipc_delegates/data/repo/event/event_repo.dart';

import 'package:ipc_delegates/data/controller/event_area/event_area_controller.dart';
import 'package:ipc_delegates/data/repo/event_area/event_area_repo.dart';

import 'package:ipc_delegates/data/controller/notification/notification_controller.dart';
import 'package:ipc_delegates/data/repo/notification/notification_repo.dart';

import 'package:ipc_delegates/data/controller/speaker/speaker_controller.dart';
import 'package:ipc_delegates/data/repo/speaker/speaker_repo.dart';

import 'package:ipc_delegates/data/controller/privacy/privacy_controller.dart';
import 'package:ipc_delegates/data/repo/privacy/privacy_repo.dart';

import 'package:ipc_delegates/data/controller/session_quiz/session_quiz_controller.dart';
import 'package:ipc_delegates/data/repo/session_quiz/session_quiz_repo.dart';

Future<Map<String, Map<String, String>>> init() async
{
  /// Core
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences);
  Get.lazyPut(() => ApiClient(sharedPreferences: Get.find()));

  /// Repository
  Get.lazyPut(() => SplashRepo(apiClient: Get.find()));
  Get.lazyPut(() => LoginRepo(apiClient: Get.find()));
  Get.lazyPut(() => VerifyOtpRepo(apiClient: Get.find()));
  Get.lazyPut(() => DashboardRepo(apiClient: Get.find()));
  Get.lazyPut(() => ProfileRepo(apiClient: Get.find()));
  Get.lazyPut(() => PrivacyRepo(apiClient: Get.find()));
  Get.lazyPut(() => EventAreaRepo(apiClient: Get.find()));
  Get.lazyPut(() => EventSessionRepo(apiClient: Get.find()));
  Get.lazyPut(() => EventRepo(apiClient: Get.find()));
  Get.lazyPut(() => NotificationRepo(apiClient: Get.find()));
  Get.lazyPut(() => SpeakerRepo(apiClient: Get.find()));
  Get.lazyPut(() => SessionQuizRepo(apiClient: Get.find()));

  Get.lazyPut(() => SplashController(splashRepo: Get.find(), localizationController: Get.find()));
  Get.lazyPut(() => LoginController(loginRepo: Get.find()));
  Get.lazyPut(() => VerifyOtpController(verifyOtpRepo: Get.find()));
  Get.lazyPut(() => DashboardController(dashboardRepo: Get.find()));
  Get.lazyPut(() => ProfileController(profileRepo: Get.find()));
  Get.lazyPut(() => LocalizationController(sharedPreferences: Get.find()));
  Get.lazyPut(() => PrivacyController(privacyRepo: Get.find()));
  Get.lazyPut(() => EventAreaController(eventAreaRepo: Get.find()));
  Get.lazyPut(() => EventSessionController(eventSessionRepo: Get.find()));
  Get.lazyPut(() => EventController(eventRepo: Get.find()));
  Get.lazyPut(() => NotificationController(notificationRepo: Get.find()));
  Get.lazyPut(() => SpeakerController(speakerRepo: Get.find()));
  Get.lazyPut(() => SessionQuizController(sessionQuizRepo: Get.find()));
  Get.lazyPut(() => ThemeController(sharedPreferences: Get.find()));

  Map<String, Map<String, String>> language = {};
  language['en_US'] = {'': ''};

  return language;
}
