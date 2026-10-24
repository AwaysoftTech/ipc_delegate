import 'dart:convert';

import 'package:get/get.dart';
import 'package:ipc_delegates/data/model/global/overview_model.dart';
import 'package:ipc_delegates/data/model/global/response_model/response_model.dart';
import 'package:ipc_delegates/data/repo/privacy/privacy_repo.dart';

import 'package:ipc_delegates/view/components/snack_bar/show_custom_snackbar.dart';

class PrivacyController extends GetxController {
  PrivacyRepo privacyRepo;
  bool isLoading = true;
  OverviewModel overviewModel = OverviewModel();
  //KnowledgeBaseDetailsModel privacyModel = KnowledgeBaseDetailsModel();
  PrivacyController({required this.privacyRepo});

  Future<void> initialData({bool shouldLoad = true}) async {
    isLoading = shouldLoad ? true : false;
    update();

    await loadData();
    isLoading = false;
    update();
  }

  Future<void> loadData() async {
    ResponseModel response = await privacyRepo.getPrivacyData();
    if (response.statusCode == 200)
    {
      overviewModel = OverviewModel.fromJson(jsonDecode(response.responseJson));
      //privacyModel = KnowledgeBaseDetailsModel.fromJson(
      //    jsonDecode(responseModel.responseJson));
    } else {
      CustomSnackBar.error(errorList: [response.message]);
    }

    isLoading = false;
    update();
  }
}
