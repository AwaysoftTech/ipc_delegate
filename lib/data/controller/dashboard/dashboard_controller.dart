import 'dart:async';
import 'dart:convert';
import 'package:ipc_delegates/core/helper/shared_preference_helper.dart';
import 'package:ipc_delegates/core/route/route.dart';
import 'package:ipc_delegates/core/utils/local_strings.dart';
import 'package:get/get.dart';
import 'package:ipc_delegates/data/model/global/response_model/response_model.dart';
import 'package:ipc_delegates/data/model/dashboard/dashboard_model.dart';
import 'package:ipc_delegates/data/repo/dashboard/dashboard_repo.dart';
import 'package:ipc_delegates/view/components/snack_bar/show_custom_snackbar.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:ipc_delegates/data/model/speaker/speaker_model.dart';
import 'package:nb_utils/nb_utils.dart' hide NoDataWidget;


class DashboardController extends GetxController
{
  DashboardRepo dashboardRepo;
  DashboardController({required this.dashboardRepo});

  bool isLoading = true;
  bool logoutLoading = false;
  String? eventId;
  String? appLogo;
  String appVersion = "";

  DashboardModel dashboardModel = DashboardModel();

  SpeakerModel speakerModel = SpeakerModel();
  List<SpeakerData> speakerList = [];

  Future<void> initialData({bool shouldLoad = true}) async {
    isLoading = shouldLoad ? true : false;
    update();

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    //String appName = packageInfo.appName;
    //String packageName = packageInfo.packageName;
    appVersion = packageInfo.version;
    //String buildNumber = packageInfo.buildNumber;

    eventId = dashboardRepo.apiClient.sharedPreferences.getString(SharedPreferenceHelper.eventId);
    appLogo = dashboardRepo.apiClient.sharedPreferences.getString(SharedPreferenceHelper.appLogo);
    await loadData();

    var eventIds = 'eventId...: ${eventId ?? ' '} ';
    print(eventIds);

    isLoading = false;
    update();
  }

  Future<void> loadData() async
  {
    ResponseModel responseModel = await dashboardRepo.getDashboardData(appVersion, eventId!);
    if (responseModel.statusCode == 200)
    {
      dynamic json = jsonDecode(responseModel.responseJson);
      dashboardModel = DashboardModel.fromJson(json);
      speakerModel = SpeakerModel.fromJson(json);
      if (dashboardModel.success!)
      {
        speakerList = speakerModel.speakerData.validate();
        //speakerList.addAll(speakerModel.speakerData.validate());

        String needUpdate = dashboardModel.eventSettingData?.needUpdate ?? "";
        var needUpdates = 'needUpdate...: ${needUpdate} ';
        print(needUpdates);
      }
      else {
        CustomSnackBar.error(errorList: [dashboardModel.message!]);
      }
    } else {
      CustomSnackBar.error(errorList: [responseModel.message]);
    }

    isLoading = false;
    update();
  }

  Future<void> logout() async {
    logoutLoading = true;
    update();
    await dashboardRepo.clearSharedPrefData();
    CustomSnackBar.success(successList: [LocalStrings.logoutSuccessMsg.tr]);
    logoutLoading = false;
    update();
    Get.offAllNamed(RouteHelper.loginScreen);
  }
}
