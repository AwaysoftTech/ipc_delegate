
import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:ipc_delegates/core/route/route.dart';
import 'package:ipc_delegates/core/utils/color_resources.dart';
import 'package:ipc_delegates/core/utils/dimensions.dart';
import 'package:ipc_delegates/core/utils/images.dart';
import 'package:ipc_delegates/core/utils/local_strings.dart';
import 'package:ipc_delegates/data/controller/auth/login_controller.dart';
import 'package:ipc_delegates/data/repo/auth/login_repo.dart';
import 'package:ipc_delegates/data/services/api_service.dart';
import 'package:ipc_delegates/view/components/app-bar/custom_appbar.dart';
import 'package:ipc_delegates/view/components/buttons/rounded_button.dart';
import 'package:ipc_delegates/view/components/buttons/rounded_loading_button.dart';
import 'package:ipc_delegates/view/components/text-form-field/custom_text_field.dart';
import 'package:ipc_delegates/view/components/will_pop_widget.dart';
import 'package:ipc_delegates/view/screens/scan_qr/scan_qr_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();

  String? _fcmToken = '';

  StreamSubscription<String>? _tokenSubscription;

  @override
  void initState() {
    super.initState();

    if (!Get.isRegistered<ApiClient>()) {
      Get.put(ApiClient(sharedPreferences: Get.find()));
    }

    if (!Get.isRegistered<LoginRepo>()) {
      Get.put(LoginRepo(apiClient: Get.find()));
    }

    if (!Get.isRegistered<LoginController>()) {
      Get.put(LoginController(loginRepo: Get.find()));
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Get.find<LoginController>().initData();
      }
    });

    if (!kIsWeb) {
      _setupFCMToken();
    }
  }

  Future<void> _setupFCMToken() async {
    try {
      final token = await FirebaseMessaging.instance.getToken();

      if (!mounted) return;

      setState(() {
        _fcmToken = token;
      });

      debugPrint('FCM Token initialized');

      _tokenSubscription =
          FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
            if (!mounted) return;

            setState(() {
              _fcmToken = newToken;
            });

            debugPrint('FCM Token refreshed');
          });
    } catch (e) {
      debugPrint('FCM token error: $e');
    }
  }

  @override
  void dispose() {
    _tokenSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return WillPopWidget(
      nextRoute: '',
      child: SafeArea(
        child: Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: GetBuilder<LoginController>(
            builder: (controller) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    _buildHeader(context),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 30),
                      child: Column(
                        children: [
                          _buildLoginTitle(context),

                          const SizedBox(height: 20),

                          _buildMobileLogin(context, controller),

                          const SizedBox(height: 26),

                          _buildDivider(context),

                          const SizedBox(height: 26),

                          _buildQrLogin(context, controller),

                          const SizedBox(height: 28),

                          _buildPrivacyPolicy(context),

                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 35, 24, 35),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colors.primary,
            colors.primary.withValues(alpha: 0.78),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(35),
          bottomRight: Radius.circular(35),
        ),
      ),
      child: Column(
        children: [
          Container(
            height: 86,
            width: 86,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.17),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.25),
              ),
            ),
            child: Image.asset(
              MyImages.appLogos,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.event_available_rounded,
                color: Colors.white,
                size: 48,
              ),
            ),
          ),

          const SizedBox(height: 20),

          Text(
            LocalStrings.login.tr,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 29,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: 0.3,
            ),
          ),

          const SizedBox(height: 9),

          Text(
            LocalStrings.loginDesc.tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Colors.white.withValues(alpha: 0.88),
            ),
          ),

          const SizedBox(height: 17),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 13,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.verified_user_outlined,
                  size: 15,
                  color: Colors.white,
                ),
                SizedBox(width: 7),
                Text(
                  'Secure Event Access',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginTitle(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              height: 42,
              width: 42,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(
                Icons.phone_android_rounded,
                color: theme.colorScheme.primary,
                size: 23,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Login with Mobile',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Enter your registered WhatsApp number',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.hintColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMobileLogin(
      BuildContext context,
      LoginController controller,
      ) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: 0.35),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: theme.brightness == Brightness.dark ? 0.06 : 0.035,
            ),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocalStrings.mobile.tr,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 12),

            CustomTextField(
              animatedLabel: true,
              needOutlineBorder: true,
              controller: controller.mobileController,
              labelText: LocalStrings.mobile.tr,
              onChanged: (value) {},
              focusNode: controller.mobileFocusNode,
              textInputType: TextInputType.phone,
              inputAction: TextInputAction.done,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please Enter WhatsApp Number'.tr;
                }

                if (value.trim().length < 10) {
                  return 'Please enter a valid mobile number'.tr;
                }

                return null;
              },
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 54,
              child: controller.isSubmitLoading
                  ? const RoundedLoadingBtn()
                  : RoundedButton(
                color: theme.colorScheme.primary,
                text: LocalStrings.signIn.tr,
                press: () {
                  FocusScope.of(context).unfocus();

                  if (formKey.currentState!.validate()) {
                    controller.loginUser(context);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Divider(
            color: theme.dividerColor,
            thickness: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            LocalStrings.or.tr,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.hintColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: theme.dividerColor,
            thickness: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildQrLogin(
      BuildContext context,
      LoginController controller,
      ) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        children: [
          Container(
            height: 92,
            width: 92,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(23),
            ),
            child: Image.asset(
              MyImages.scan,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Icon(
                Icons.qr_code_scanner_rounded,
                color: colors.primary,
                size: 58,
              ),
            ),
          ),

          const SizedBox(height: 16),

          Text(
            'Login with QR Code',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 7),

          Text(
            'Scan your event QR code for quick access.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.hintColor,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 18),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: RoundedButton(
              color: colors.primary,
              text: LocalStrings.scanQr.tr,
              press: () async {
                FocusScope.of(context).unfocus();

                final scannedCode = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ScanQrScreen(),
                  ),
                );

                if (!mounted) return;

                if (scannedCode != null) {
                  controller.loginUsingQR(
                    context,
                    '$scannedCode',
                    _fcmToken ?? '',
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyPolicy(BuildContext context) {
    final theme = Theme.of(context);

    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          LocalStrings.iAgreeWith.tr,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.hintColor,
          ),
        ),
        TextButton(
          onPressed: () {
            const String from = 'privacy_policy';

            Get.toNamed(
              RouteHelper.privacyScreen,
              arguments: from,
            );
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            LocalStrings.policies.tr,
            style: TextStyle(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}
