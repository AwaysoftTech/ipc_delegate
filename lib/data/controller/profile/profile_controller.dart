import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:ipc_delegates/data/model/global/response_model/response_model.dart';
import 'package:ipc_delegates/data/model/profile/profile_model.dart';
import 'package:ipc_delegates/data/repo/profile/profile_repo.dart';
import 'package:ipc_delegates/view/components/snack_bar/show_custom_snackbar.dart';
import 'package:ipc_delegates/core/helper/shared_preference_helper.dart';
import 'package:ipc_delegates/core/utils/color_resources.dart';
import 'package:flutter/material.dart';

class ProfileController extends GetxController {
  ProfileRepo profileRepo;
  ProfileController({required this.profileRepo});

  String? attendeeId;
  String? eventId;
  String status = "";
  Color statusColor = ColorResources.blueColor;
  bool isLoading = true;
  ProfileModel profileModel = ProfileModel();

  Future<void> loadAttendeeDetails(String attendeeId, String eventId) async {
    ResponseModel responseModel = await profileRepo.getProfileData(attendeeId, eventId);
    if (responseModel.statusCode == 200)
    {
      dynamic json = jsonDecode(responseModel.responseJson);
      bool isSuccess = json['success'];
      String message = json['message'];
      if (isSuccess)
      {
        profileModel = ProfileModel.fromJson(jsonDecode(responseModel.responseJson));

        switch (profileModel.checkInData?.status)
        {
          case 'In':
            statusColor = ColorResources.greenColor.withAlpha(200);
            status = "Checked In";
            break;
          case 'Out':
            statusColor = ColorResources.redColor.withAlpha(200);
            status = "Checked Out";
            break;
          default:
            statusColor = ColorResources.colorOrange.withAlpha(200);
            status = "Yet to Check";
            break;
        }
      }
      else
      {
        CustomSnackBar.error(errorList: [message]);
      }
    }
    else {
      CustomSnackBar.error(errorList: [responseModel.message]);
    }

    isLoading = false;
    update();
  }

}
