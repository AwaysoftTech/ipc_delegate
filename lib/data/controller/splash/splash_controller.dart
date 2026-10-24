import 'dart:convert';

import 'package:ipc_delegates/core/utils/local_strings.dart';
import 'package:ipc_delegates/core/utils/messages.dart';
import 'package:ipc_delegates/data/controller/localization/localization_controller.dart';
import 'package:ipc_delegates/data/model/global/overview_model.dart';
import 'package:ipc_delegates/data/model/global/response_model/response_model.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ipc_delegates/core/helper/shared_preference_helper.dart';
import 'package:ipc_delegates/core/route/route.dart';
import 'package:ipc_delegates/data/repo/splash/splash_repo.dart';
import 'package:ipc_delegates/view/components/snack_bar/show_custom_snackbar.dart';
import 'package:flutter/material.dart';

class SplashController extends GetxController
{
  SplashRepo splashRepo;
  LocalizationController localizationController;
  bool isLoading = true;

  SplashController(
      {required this.splashRepo, required this.localizationController});

  gotoNextPage() async {
    await loadLanguage();
    bool isLogin = splashRepo.apiClient.sharedPreferences.getBool(SharedPreferenceHelper.isLogin) ?? false;
    bool isOnBoard = splashRepo.apiClient.sharedPreferences.getBool(SharedPreferenceHelper.onboardKey) ?? false;
    noInternet = false;
    update();

    var isOnBoards = 'isOnBoard...: ${isOnBoard} ';
    print(isOnBoards);

    getData(isLogin, isOnBoard);
  }

  bool noInternet = false;
  void getData(bool isLogin, bool isOnBoard) async
  {
    String attendee_id = "";
    ResponseModel response = await splashRepo.getOverviewData(attendee_id);

    var personInfoString = 'splash res...: ${response.statusCode} ';
    print(personInfoString);

    if (response.statusCode == 200)
    {
      OverviewModel model = OverviewModel.fromJson(jsonDecode(response.responseJson));

      if (model.success!)
      {
        await splashRepo.apiClient.sharedPreferences.setString(
            SharedPreferenceHelper.appTitle, model.data?.appName ?? '');

        await splashRepo.apiClient.sharedPreferences.setString(
            SharedPreferenceHelper.appLogo, model.data?.appLogo ?? '');

        await splashRepo.apiClient.sharedPreferences.setString(
            SharedPreferenceHelper.appLanguage, model.data?.language ?? '');

        await splashRepo.apiClient.sharedPreferences.setString(
            SharedPreferenceHelper.disableLogin,
            model.data?.disableLogin ?? '');

      } else {
        CustomSnackBar.error(errorList: [model.message!]);
      }
    }
    else {
      if (response.statusCode == 503)
      {
        noInternet = true;
        update();
      }
      CustomSnackBar.error(errorList: [response.message]);
    }

    isLoading = false;
    update();

    if (isOnBoard == false)
    {
      Future.delayed(const Duration(seconds: 2), ()
      {
        Get.offAndToNamed(RouteHelper.onboardScreen);
      });
    }
    else
    {
      if (isLogin)
      {
        Future.delayed(const Duration(seconds: 2), () {
          Get.offAndToNamed(RouteHelper.dashboardScreen);
        });
      }
      else {
        Future.delayed(const Duration(seconds: 2), () {
          Get.offAndToNamed(RouteHelper.loginScreen);
        });
      }
    }
  }

  Future<bool> initSharedData() {
    if (!splashRepo.apiClient.sharedPreferences
        .containsKey(SharedPreferenceHelper.countryCode)) {
      return splashRepo.apiClient.sharedPreferences.setString(
          SharedPreferenceHelper.countryCode,
          LocalStrings.appLanguages[0].countryCode);
    }
    if (!splashRepo.apiClient.sharedPreferences
        .containsKey(SharedPreferenceHelper.languageCode)) {
      return splashRepo.apiClient.sharedPreferences.setString(
          SharedPreferenceHelper.languageCode,
          LocalStrings.appLanguages[0].languageCode);
    }
    return Future.value(true);
  }

  Future<void> loadLanguage() async {
    localizationController.loadCurrentLanguage();
    String languageCode = localizationController.locale.languageCode;
    Map<String, Map<String, String>> language = {};
    final String response =
        await rootBundle.loadString('assets/lang/$languageCode.json');
    var resJson = jsonDecode(response);
    saveLanguageList(response);
    var value = resJson as Map<String, dynamic>;
    Map<String, String> json = {};
    value.forEach((key, value) {
      json[key] = value.toString();
    });
    language[
            '${localizationController.locale.languageCode}_${localizationController.locale.countryCode}'] =
        json;
    Get.addTranslations(Messages(languages: language).keys);
  }

  void saveLanguageList(String languageJson) async {
    await splashRepo.apiClient.sharedPreferences
        .setString(SharedPreferenceHelper.languageListKey, languageJson);
    return;
  }
}
