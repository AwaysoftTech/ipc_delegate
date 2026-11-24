
import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:ipc_delegates/core/utils/color_resources.dart';
import 'package:ipc_delegates/core/utils/images.dart';
import 'package:ipc_delegates/core/utils/local_strings.dart';
import 'package:ipc_delegates/core/utils/url_container.dart';
import 'package:ipc_delegates/data/controller/auth/verify_otp_controller.dart';
import 'package:ipc_delegates/data/repo/auth/verify_otp_repo.dart';
import 'package:ipc_delegates/data/services/api_service.dart';
import 'package:ipc_delegates/view/components/buttons/rounded_button.dart';
import 'package:ipc_delegates/view/components/buttons/rounded_loading_button.dart';
import 'package:ipc_delegates/view/components/text-form-field/custom_text_field.dart';

class VerifyOtpScreen extends StatefulWidget {
  const VerifyOtpScreen({super.key});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _fcmToken = '';

  StreamSubscription<String>? _tokenSubscription;

  String mobile = '';
  String mobileOtp = '';

  @override
  void initState() {
    super.initState();

    if (!Get.isRegistered<ApiClient>()) {
      Get.put(ApiClient(sharedPreferences: Get.find()));
    }

    if (!Get.isRegistered<VerifyOtpRepo>()) {
      Get.put(VerifyOtpRepo(apiClient: Get.find()));
    }

    if (!Get.isRegistered<VerifyOtpController>()) {
      Get.put(VerifyOtpController(verifyOtpRepo: Get.find()));
    }

    final arguments = Get.arguments;

    if (arguments is Map) {
      mobile = arguments['mobile']?.toString() ?? '';
      mobileOtp = arguments['mobileOtp']?.toString() ?? '';
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Get.find<VerifyOtpController>().initData();
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

      _tokenSubscription =
          FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
            if (!mounted) return;

            setState(() {
              _fcmToken = newToken;
            });
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
    final isDark = theme.brightness == Brightness.dark;

    final primaryColor = theme.colorScheme.primary;
    final backgroundColor = theme.scaffoldBackgroundColor;
    final textColor = theme.colorScheme.onSurface;

    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: GetBuilder<VerifyOtpController>(
          builder: (controller) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 35),
                    decoration: BoxDecoration(
                      color: ColorResources.appBarColor,
                      image: const DecorationImage(
                        image: AssetImage(MyImages.login),
                        fit: BoxFit.cover,
                        opacity: 0.12,
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(32),
                        bottomRight: Radius.circular(32),
                      ),
                    ),
                    child: Column(
                      children: [
                        // Back button
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            onPressed: () => Get.back(),
                            icon: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        // OTP illustration
                        Container(
                          height: 150,
                          width: 150,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.3),
                              width: 1.5,
                            ),
                          ),
                          child: CachedNetworkImage(
                            imageUrl:
                            '${UrlContainer.systemImgUrl}${controller.appLogo}',
                            fit: BoxFit.contain,
                            placeholder: (context, url) {
                              return Image.asset(
                                MyImages.verifyOtp,
                                fit: BoxFit.contain,
                              );
                            },
                            errorWidget: (context, url, error) {
                              return Image.asset(
                                MyImages.verifyOtp,
                                fit: BoxFit.contain,
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 24),

                        Text(
                          LocalStrings.mobile_verify.tr,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.3,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          '${LocalStrings.mobile_verify_des.tr}$mobile',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withValues(alpha: 0.85),
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 18),

                        // Mobile number chip
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.25),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.phone_android_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                mobile,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Form section
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 28, 20, 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Enter verification code',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: textColor,
                            fontWeight: FontWeight.w800,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          'Please enter the OTP sent to your registered mobile number.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 24),

                        // OTP card
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: isDark
                                ? theme.colorScheme.surface
                                : theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: theme.colorScheme.outlineVariant
                                  .withValues(alpha: 0.6),
                            ),
                            boxShadow: [
                              if (!isDark)
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                            ],
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.password_rounded,
                                      color: primaryColor,
                                      size: 21,
                                    ),
                                    const SizedBox(width: 9),
                                    Text(
                                      'One-Time Password',
                                      style:
                                      theme.textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 18),

                                CustomTextField(
                                  animatedLabel: true,
                                  needOutlineBorder: true,
                                  labelText: LocalStrings.enterOtp.tr,
                                  hintText: LocalStrings.enterOtp.tr,
                                  textInputType: TextInputType.number,
                                  inputAction: TextInputAction.done,
                                  controller: controller.otpController,
                                  onSuffixTap: () {},
                                  onChanged: (value) {},
                                  validator: (value) {
                                    if (value == null ||
                                        value.trim().isEmpty) {
                                      return LocalStrings.enterOtp.tr;
                                    }
                                    return null;
                                  },
                                ),

                                const SizedBox(height: 24),

                                SizedBox(
                                  width: double.infinity,
                                  child: controller.submitLoading
                                      ? const RoundedLoadingBtn()
                                      : RoundedButton(
                                    press: () {
                                      if (_formKey.currentState!
                                          .validate()) {
                                        controller.userVerifyOTP(
                                          mobile,
                                          mobileOtp,
                                          _fcmToken ?? '',
                                        );
                                      }
                                    },
                                    text: LocalStrings.verifyNow.tr,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Security note
                        Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: primaryColor.withValues(alpha: 0.07),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.shield_outlined,
                                color: primaryColor,
                                size: 22,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Your verification code is confidential. Do not share it with anyone.',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
