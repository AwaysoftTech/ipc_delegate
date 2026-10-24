import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:ipc_delegates/core/helper/shared_preference_helper.dart';
import 'package:ipc_delegates/core/utils/local_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ipc_delegates/core/route/route.dart';
import 'package:ipc_delegates/core/utils/dimensions.dart';
import 'package:ipc_delegates/core/utils/color_resources.dart';
import 'package:ipc_delegates/core/utils/images.dart';
import 'package:ipc_delegates/core/utils/style.dart';
import 'package:ipc_delegates/core/utils/url_container.dart';
import 'package:ipc_delegates/data/controller/auth/login_controller.dart';
import 'package:ipc_delegates/data/repo/auth/login_repo.dart';
import 'package:ipc_delegates/data/services/api_service.dart';
import 'package:ipc_delegates/view/components/buttons/rounded_button.dart';
import 'package:ipc_delegates/view/components/buttons/rounded_loading_button.dart';
import 'package:ipc_delegates/view/components/text-form-field/custom_text_field.dart';
import 'package:ipc_delegates/view/components/text/default_text.dart';
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
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(LoginRepo(apiClient: Get.find()));
    Get.put(LoginController(loginRepo: Get.find()));

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<LoginController>().initData();
    });

    if (!kIsWeb)
    {
      _setupFCMToken();
    }

  }

  Future<void> _setupFCMToken() async {
    // Get the initial token
    String? token = await FirebaseMessaging.instance.getToken();
    setState(() {
      _fcmToken = token;
    });
    print("Initial FCM Token: $token");

    // Listen for token refreshes
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      setState(() {
        _fcmToken = newToken;
      });
      print("Refreshed FCM Token: $newToken");
      // You would typically send this new token to your server here
    });
  }

  @override
  void dispose()
  {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopWidget(
      nextRoute: '',
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: GetBuilder<LoginController>(
            builder: (controller) => SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: ColorResources.appBarColor,
                      image: DecorationImage(
                        alignment: Alignment.topCenter,
                        image: AssetImage(MyImages.login),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.space20,
                                vertical: Dimensions.space40),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  LocalStrings.login.tr,
                                  style: mediumOverLarge.copyWith(
                                      fontSize: Dimensions.fontMegaLarge,
                                      color: Colors.white),
                                ),
                                Text(
                                  LocalStrings.loginDesc.tr,
                                  style: regularDefault.copyWith(
                                      fontSize: Dimensions.fontDefault,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              )),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: Dimensions.space20),
                          child: Form(
                            key: formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CustomTextField(
                                  animatedLabel: true,
                                  needOutlineBorder: true,
                                  controller: controller.mobileController,
                                  labelText: LocalStrings.mobile.tr,
                                  onChanged: (value) {},
                                  focusNode: controller.mobileFocusNode,
                                  textInputType: TextInputType.number,
                                  inputAction: TextInputAction.done,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please Enter WhatsApp Number'.tr;
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                                const SizedBox(height: Dimensions.space20),
                                controller.isSubmitLoading
                                    ? const RoundedLoadingBtn()
                                    : RoundedButton(
                                        color: Colors.grey,
                                        text: LocalStrings.signIn.tr,
                                        press: () {
                                          if (formKey.currentState!.validate()) {
                                            controller.loginUser(context);
                                          }
                                        }),
                                const SizedBox(height: Dimensions.space20),
                                Text(LocalStrings.or.tr,
                                    overflow: TextOverflow.ellipsis,
                                    style: regularExtraLarge.copyWith(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .color!
                                            .withValues(alpha: 0.5),
                                        fontWeight: FontWeight.w400)),
                                const SizedBox(height: Dimensions.space20),
                                CircleAvatar(
                                  radius: 90,
                                  backgroundColor: Colors.grey[300],
                                  child: CircleAvatar(
                                    radius: 100,
                                    backgroundColor: Colors.transparent,
                                    child: Image.asset(
                                      MyImages.scan,
                                      height: 140,
                                      width: 140,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: Dimensions.space20),
                                RoundedButton(
                                    color: ColorResources.primaryColor,
                                    text: LocalStrings.scanQr.tr,
                                    press: () async
                                    {
                                      final scannedCode = await Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) => const ScanQrScreen()),
                                      );

                                      if (scannedCode != null) {
                                        // Do something with the scannedCode
                                        //debugPrint('Scanned QR code: $scannedCode');
                                        controller.loginUsingQR(context, '${scannedCode ?? ''}', '${_fcmToken ?? ''}');
                                      }
                                    }),
                                const SizedBox(height: Dimensions.space20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(LocalStrings.iAgreeWith.tr,
                                        overflow: TextOverflow.ellipsis,
                                        style: regularLarge.copyWith(
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .color!
                                                .withValues(alpha: 0.5),
                                            fontWeight: FontWeight.w400)),
                                    TextButton(
                                      onPressed: () {
                                        String from = 'privacy_policy';
                                        Get.toNamed(RouteHelper.privacyScreen, arguments: from);
                                      },
                                      child: Text(
                                          LocalStrings.policies.tr,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: regularLarge.copyWith(
                                              color: ColorResources.secondaryColor)),
                                    )
                                  ],
                                ),

                              ],
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
