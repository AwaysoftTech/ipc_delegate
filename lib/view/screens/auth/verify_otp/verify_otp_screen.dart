import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:ipc_delegates/core/utils/images.dart';
import 'package:ipc_delegates/core/utils/local_strings.dart';
import 'package:ipc_delegates/core/utils/url_container.dart';
import 'package:ipc_delegates/data/controller/auth/verify_otp_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ipc_delegates/core/utils/dimensions.dart';
import 'package:ipc_delegates/core/utils/style.dart';
import 'package:ipc_delegates/data/repo/auth/verify_otp_repo.dart';
import 'package:ipc_delegates/data/services/api_service.dart';
import 'package:ipc_delegates/view/components/buttons/rounded_button.dart';
import 'package:ipc_delegates/view/components/buttons/rounded_loading_button.dart';
import 'package:ipc_delegates/view/components/text-form-field/custom_text_field.dart';
import 'package:ipc_delegates/core/utils/color_resources.dart';

class VerifyOtpScreen extends StatefulWidget
{
  const VerifyOtpScreen({super.key});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _fcmToken = '';
  @override
  void initState()
  {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(VerifyOtpRepo(apiClient: Get.find()));
    Get.put(VerifyOtpController(verifyOtpRepo: Get.find()));

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_)
    {
      Get.find<VerifyOtpController>().initData();
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context)
  {
    String mobile = "";
    String mobileOtp = "";

    // Extract the arguments as a map
    final arguments = ModalRoute.of(context)!.settings.arguments;

    // Make sure it's the type you expect
    Map<String, dynamic>? argsMap;
    if (arguments != null && arguments is Map<String, dynamic>) {
      argsMap = arguments;

      mobile = argsMap['mobile'];
      mobileOtp = argsMap['mobileOtp'];
    }

    return SafeArea(
      child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: GetBuilder<VerifyOtpController>(
            builder: (controller) => SingleChildScrollView(
              child: Stack(
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
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 140.0, bottom: 30.0),
                          child: Center(
                            child: CachedNetworkImage(
                                imageUrl: '${UrlContainer.systemImgUrl}${controller.appLogo}',
                                height: 200,
                                fit: BoxFit.fitHeight,
                                errorWidget: (ctx, object, trx) {
                                  return Image.asset(
                                    MyImages.verifyOtp,
                                    height: 200,
                                  );
                                },
                                placeholder: (ctx, trx) {
                                  return Image.asset(
                                    MyImages.verifyOtp,
                                    height: 200,
                                  );
                                }),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 30.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(LocalStrings.mobile_verify.tr,
                                  style: mediumOverLarge.copyWith(
                                      fontSize: Dimensions.fontMegaLarge,
                                      color: Colors.white),
                                ),
                                Text(
                                  '${LocalStrings.mobile_verify_des.tr}${mobile ?? ''}',
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
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 25.0),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CustomTextField(
                                      animatedLabel: true,
                                      needOutlineBorder: true,
                                      labelText: LocalStrings.enterOtp.tr,
                                      hintText: LocalStrings.enterOtp.tr,
                                      textInputType: TextInputType.number,
                                      inputAction: TextInputAction.done,
                                      controller: controller.otpController,
                                      onSuffixTap: () {},
                                      onChanged: (value) {
                                        return;
                                      },
                                      validator: (value) {
                                        if (controller
                                            .otpController.text.isEmpty) {
                                          return LocalStrings.enterOtp.tr;
                                        } else {
                                          return null;
                                        }
                                      }),
                                  const SizedBox(height: Dimensions.space25),
                                  controller.submitLoading
                                      ? const RoundedLoadingBtn()
                                      : RoundedButton(
                                          press: () {
                                            if (_formKey.currentState!.validate())
                                            {
                                              controller.userVerifyOTP('${mobile ?? ''}', '${mobileOtp ?? ''}', '${_fcmToken ?? ''}');
                                            }
                                          },
                                          text: LocalStrings.verifyNow.tr,
                                        ),
                                  const SizedBox(height: Dimensions.space40)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: AppBar(
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back_ios,
                            color: Colors.white),
                        onPressed: () => Get.back(),
                      ),
                      backgroundColor: Colors.transparent,
                      elevation: 0.0, //No shadow
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
