import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ipc_delegates/core/helper/shared_preference_helper.dart';
import 'package:ipc_delegates/core/route/route.dart';
import 'package:ipc_delegates/core/utils/local_strings.dart';
import 'package:ipc_delegates/data/model/auth/login/verify_otp_model.dart';
import 'package:ipc_delegates/data/model/global/response_model/response_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ipc_delegates/data/repo/auth/verify_otp_repo.dart';
import 'package:ipc_delegates/view/components/snack_bar/show_custom_snackbar.dart';

class VerifyOtpController extends GetxController
{
  VerifyOtpRepo verifyOtpRepo;

  VerifyOtpController({required this.verifyOtpRepo});

  bool submitLoading = false;
  bool isLoading = true;
  String? appLogo = '';
  TextEditingController otpController = TextEditingController();

  void initData() async {
    isLoading = true;
    update();
    appLogo = verifyOtpRepo.apiClient.sharedPreferences.getString(SharedPreferenceHelper.appLogo);

    isLoading = false;
    update();
  }

  void userVerifyOTP(String mobile, String sended_otp, String _fcmToken) async
  {
    submitLoading = true;
    update();

    String mobile_number = mobile;
    String sended_otp_value = sended_otp;
    String device_token = _fcmToken;
    String entered_otp_value = otpController.text;

    if (entered_otp_value.isEmpty)
    {
      CustomSnackBar.error(errorList: [LocalStrings.enterOtp.tr]);
    }
    else if (entered_otp_value.compareTo(sended_otp_value) != 0)
    {
      String s_invalid_otp = "You have Entered In-Valid OTP";
      CustomSnackBar.error(errorList: [s_invalid_otp]);
    }
    else
    {
      ResponseModel model = await verifyOtpRepo.verifyOtp(mobile_number, device_token);
      if (model.statusCode == 200)
      {
        var otpVal = 'verify res...: ${model.responseJson.toString()} ';
        print(otpVal);

        VerifyLoginModel loginModel = VerifyLoginModel.fromJson(jsonDecode(model.responseJson));
        if (loginModel.success!)
        {
          CustomSnackBar.success(successList: [loginModel.message!.tr]);

          checkAndGotoNextStep(loginModel);
        }
        else {
          CustomSnackBar.error(errorList: [loginModel.message!.tr]);
        }
      }
      else {
        CustomSnackBar.error(errorList: [(model.message.tr)]);
      }
    }

    submitLoading = false;
    update();
  }

  Future<void> checkAndGotoNextStep(VerifyLoginModel responseModel) async
  {
    await verifyOtpRepo.apiClient.sharedPreferences.setBool(SharedPreferenceHelper.isLogin, true);

    await verifyOtpRepo.apiClient.sharedPreferences.setString(
        SharedPreferenceHelper.eventId, responseModel.data?.eventId ?? '');

    await verifyOtpRepo.apiClient.sharedPreferences.setString(
        SharedPreferenceHelper.attendeeId,
        responseModel.data?.attendeeId.toString() ?? '');

    await verifyOtpRepo.apiClient.sharedPreferences.setString(
        SharedPreferenceHelper.registrationNumber, responseModel.data?.registrationNumber ?? '');
    await verifyOtpRepo.apiClient.sharedPreferences.setString(
        SharedPreferenceHelper.attendeeName, responseModel.data?.attendeeName ?? '');
    await verifyOtpRepo.apiClient.sharedPreferences.setString(
        SharedPreferenceHelper.attendeeMobile, responseModel.data?.attendeeMobile ?? '');
    await verifyOtpRepo.apiClient.sharedPreferences.setString(
        SharedPreferenceHelper.emailId, responseModel.data?.emailId ?? '');
    await verifyOtpRepo.apiClient.sharedPreferences.setString(
        SharedPreferenceHelper.attendeePhoto, responseModel.data?.attendeePhoto ?? '');

    Get.offAndToNamed(RouteHelper.dashboardScreen);
  }



}
