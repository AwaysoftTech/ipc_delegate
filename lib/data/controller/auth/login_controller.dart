import 'dart:convert';
import 'package:ipc_delegates/core/utils/local_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ipc_delegates/core/helper/shared_preference_helper.dart';
import 'package:ipc_delegates/core/route/route.dart';
import 'package:ipc_delegates/data/model/auth/login/login_model.dart';
import 'package:ipc_delegates/data/model/global/response_model/response_model.dart';
import 'package:ipc_delegates/data/repo/auth/login_repo.dart';
import 'package:ipc_delegates/view/components/snack_bar/show_custom_snackbar.dart';

import 'package:ipc_delegates/view/components/dialog/basic_dialog.dart';
import 'package:ipc_delegates/core/utils/images.dart';
import 'package:ipc_delegates/data/model/auth/login/verify_otp_model.dart';
import 'package:ipc_delegates/view/components/dialog/progress_dialog.dart';

class LoginController extends GetxController
{
  LoginRepo loginRepo;

  final FocusNode mobileFocusNode = FocusNode();

  TextEditingController mobileController = TextEditingController(text: '');

  List<String> errors = [];
  String? mobile;
  String? mobileOtp;

  bool isLoading = true;
  String? appLogo = '';

  LoginController({required this.loginRepo});

  void initData() async {
    isLoading = true;
    update();
    appLogo = loginRepo.apiClient.sharedPreferences.getString(SharedPreferenceHelper.appLogo);

    isLoading = false;
    update();
  }

  bool isSubmitLoading = false;
  void loginUser(BuildContext context) async
  {
    isSubmitLoading = true;
    update();

    ResponseModel model = await loginRepo.loginUser(mobileController.text.toString());
    if (model.statusCode == 200)
    {
      LoginModel loginModel = LoginModel.fromJson(jsonDecode(model.responseJson));
      if (loginModel.success!)
      {
        String s_sucess = loginModel.message ?? '';
        mobile = loginModel.data?.mobile ?? '';
        mobileOtp = loginModel.data?.mobileOtp ?? '';

        CustomSnackBar.success(successList: [s_sucess]);

        checkAndGotoOtpScreen(loginModel);
      }
      else {
        String s_error = loginModel.message ?? '';

        const BasicAlertDialog().basicAlertDialog(context, () {Get.back();},
            title: s_error,
            image: MyImages.error);
      }
    } else {
      CustomSnackBar.error(errorList: [model.message]);
    }
    isSubmitLoading = false;
    update();
  }

  void loginUsingQR(BuildContext context, String registration_number, String device_token) async
  {
    isSubmitLoading = true;
    update();

    if (registration_number == '')
    {
      String s_no_qr = "No QR Number Found";
      CustomSnackBar.error(errorList: [s_no_qr]);
    }
    else
    {
      const ProgressDialog().showProgressDialog(context);

      ResponseModel model = await loginRepo.loginUsingQr(registration_number, device_token);
      if (model.statusCode == 200)
      {
        const ProgressDialog().hideProgressDialog(context);

        var otpVal = 'verify res...: ${model.responseJson.toString()} ';
        print(otpVal);

        VerifyLoginModel loginModel = VerifyLoginModel.fromJson(jsonDecode(model.responseJson));
        if (loginModel.success!)
        {
          CustomSnackBar.success(successList: [loginModel.message!.tr]);

          checkAndGotoDashboard(loginModel);
        }
        else {
          CustomSnackBar.error(errorList: [loginModel.message!.tr]);
        }
      }
      else {
        const ProgressDialog().hideProgressDialog(context);
        CustomSnackBar.error(errorList: [(model.message.tr)]);
      }
    }

    isSubmitLoading = false;
    update();
  }

  Future<void> checkAndGotoOtpScreen(LoginModel responseModel) async {
    // Create a map with different types of data
    Map<String, dynamic> args = {
      'mobile': mobile,
      'mobileOtp': mobileOtp
    };

    Get.offAndToNamed(RouteHelper.verifyOTPScreen, arguments: args);
  }

  Future<void> checkAndGotoDashboard(VerifyLoginModel responseModel) async
  {
    await loginRepo.apiClient.sharedPreferences.setBool(SharedPreferenceHelper.isLogin, true);

    await loginRepo.apiClient.sharedPreferences.setString(
        SharedPreferenceHelper.eventId, responseModel.data?.eventId ?? '');

    await loginRepo.apiClient.sharedPreferences.setString(
        SharedPreferenceHelper.attendeeId,
        responseModel.data?.attendeeId.toString() ?? '');

    await loginRepo.apiClient.sharedPreferences.setString(
        SharedPreferenceHelper.registrationNumber, responseModel.data?.registrationNumber ?? '');
    await loginRepo.apiClient.sharedPreferences.setString(
        SharedPreferenceHelper.attendeeName, responseModel.data?.attendeeName ?? '');
    await loginRepo.apiClient.sharedPreferences.setString(
        SharedPreferenceHelper.attendeeMobile, responseModel.data?.attendeeMobile ?? '');
    await loginRepo.apiClient.sharedPreferences.setString(
        SharedPreferenceHelper.emailId, responseModel.data?.emailId ?? '');
    await loginRepo.apiClient.sharedPreferences.setString(
        SharedPreferenceHelper.attendeePhoto, responseModel.data?.attendeePhoto ?? '');

    Get.offAndToNamed(RouteHelper.dashboardScreen);
  }

  void clearTextField() {
    mobileController.text = '';

    update();
  }
}
