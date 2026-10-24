import 'package:ipc_delegates/view/screens/auth/verify_otp//verify_otp_screen.dart';
import 'package:ipc_delegates/view/screens/auth/login/login_screen.dart';
import 'package:ipc_delegates/view/screens/dashboard/dashboard_screen.dart';
import 'package:ipc_delegates/view/screens/intro_section/onboard_intro_screen.dart';
import 'package:ipc_delegates/view/screens/menu/menu_screen.dart';
import 'package:ipc_delegates/view/screens/privacy_policy/privacy_policy_screen.dart';
import 'package:ipc_delegates/view/screens/profile/profile_screen.dart';
import 'package:ipc_delegates/view/screens/splash/splash_screen.dart';
import 'package:ipc_delegates/view/screens/event_session/event_session_detail_screen.dart';
import 'package:ipc_delegates/view/screens/event_area/event_area_screen.dart';
import 'package:ipc_delegates/view/screens/event/event_detail_screen.dart';
import 'package:ipc_delegates/view/screens/notification/notification_screen.dart';
import 'package:ipc_delegates/view/screens/speaker/speaker_screen.dart';
import 'package:ipc_delegates/view/screens/speaker/speaker_detail_screen.dart';
import 'package:ipc_delegates/view/screens/enquiry_us/enquiry_us_add_screen.dart';

import 'package:get/get.dart';

class RouteHelper {
  static const String splashScreen = "/splash_screen";
  static const String onboardScreen = '/onboard_screen';
  static const String loginScreen = "/login_screen";
  static const String verifyOTPScreen = "/verify_otp_screen";

  static const String dashboardScreen = "/dashboard_screen";
  static const String eventSessionDetailScreen = "/event_session_detail_screen";
  static const String settingsScreen = "/settings_screen";
  static const String profileScreen = "/profile_screen";
  static const String privacyScreen = "/privacy_screen";
  static const String eventAreaScreen = "/event_area_screen";
  static const String eventDetailScreen = "/event_detail_screen";
  static const String notificationScreen = "/notification_screen";
  static const String speakerScreen = "/speaker_screen";
  static const String speakerDetailScreen = "/speaker_detail_screen";
  static const String enquiryUsAddScreen = "/enquiry_us_add_screen";

  List<GetPage> routes = [
    GetPage(name: splashScreen, page: () => const SplashScreen()),
    GetPage(name: onboardScreen, page: () => const OnBoardIntroScreen()),
    GetPage(name: loginScreen, page: () => const LoginScreen()),
    GetPage(
        name: verifyOTPScreen,
        page: () => VerifyOtpScreen()),
    GetPage(name: dashboardScreen, page: () => const HomeScreen()),
    GetPage(
        name: eventSessionDetailScreen,
        page: () => EventSessionDetailScreen(id: Get.arguments)),
    GetPage(name: profileScreen, page: () => const ProfileScreen()),
    GetPage(name: settingsScreen, page: () => const MenuScreen()),
    GetPage(name: eventAreaScreen, page: () => const EventAreaScreen()),
    GetPage(name: eventDetailScreen, page: () => const EventDetailScreen()),
    GetPage(name: notificationScreen, page: () => const NotificationScreen()),
    GetPage(name: speakerScreen, page: () => const SpeakerScreen()),
    GetPage(
        name: speakerDetailScreen,
        page: () => SpeakerDetailScreen(id: Get.arguments)),
    GetPage(name: enquiryUsAddScreen, page: () => const EnquiryUsAddScreen()),
    GetPage(
        name: privacyScreen,
        page: () => PrivacyPolicyScreen(id: Get.arguments)),
  ];

}
