import 'dart:async';
import 'dart:convert';
import 'package:ipc_delegates/core/utils/local_strings.dart';
import 'package:ipc_delegates/core/utils/sounds.dart';
import 'package:ipc_delegates/data/model/authorization/authorization_response_model.dart';

import 'package:ipc_delegates/data/model/delegates/delegate_details_model.dart';
import 'package:ipc_delegates/data/model/delegates/delegate_model.dart';
import 'package:ipc_delegates/data/repo/delegates/delegate_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ipc_delegates/data/model/global/response_model/response_model.dart';
import 'package:ipc_delegates/view/components/snack_bar/show_custom_snackbar.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:ipc_delegates/core/helper/shared_preference_helper.dart';
import 'package:ipc_delegates/core/utils/color_resources.dart';
import 'package:ipc_delegates/view/components/dialog/basic_dialog.dart';
import 'package:ipc_delegates/core/utils/images.dart';

import 'package:ipc_delegates/core/utils/util.dart';

class AttendeeController extends GetxController
{
  bool isLoading = true;
  bool isSubmitLoading = false;
  String? eventId;
  String status = "";
  Color statusColor = ColorResources.blueColor;
  String statusButton = "";
  Color statusButtonColor = ColorResources.blueColor;
  AttendeeRepo attendeeRepo;
  AttendeeController({required this.attendeeRepo});

  TextEditingController searchController = TextEditingController(text: '');

  AttendeesModel attendeesModel = AttendeesModel();
  AttendeeDetailsModel attendeeDetailsModel = AttendeeDetailsModel();

  TextEditingController nameController = TextEditingController();
  TextEditingController regNumberController = TextEditingController();
  TextEditingController emailIdController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController categoriesController = TextEditingController();

  FocusNode nameFocusNode = FocusNode();
  FocusNode regNumberFocusNode = FocusNode();
  FocusNode emailIdFocusNode = FocusNode();
  FocusNode mobileFocusNode = FocusNode();
  FocusNode categoriesFocusNode = FocusNode();

  Future<void> loadAttendeeDetails(String attendeeId, String eventId) async {
    ResponseModel responseModel = await attendeeRepo.getAttendeeDetails(attendeeId, eventId);
    if (responseModel.statusCode == 200)
    {
      dynamic json = jsonDecode(responseModel.responseJson);
      bool isSuccess = json['success'];
      String message = json['message'];
      if (isSuccess)
      {
        attendeeDetailsModel = AttendeeDetailsModel.fromJson(jsonDecode(responseModel.responseJson));

        switch (attendeeDetailsModel.checkInData?.status)
        {
          case 'In':
            statusColor = ColorResources.greenColor.withAlpha(200);
            status = "Checked In";

            statusButtonColor = ColorResources.redColor.withAlpha(200);
            statusButton = "Check Out Event";
            break;
          case 'Out':
            statusColor = ColorResources.redColor.withAlpha(200);
            status = "Checked Out";

            statusButtonColor = ColorResources.greenColor.withAlpha(200);
            statusButton = "Check In Event";
            break;
          default:
            statusColor = ColorResources.colorOrange.withAlpha(200);
            status = "Yet to Check";

            statusButtonColor = ColorResources.greenColor.withAlpha(200);
            statusButton = "Check In Event";
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

  void clearData() {
    isLoading = false;
    isSubmitLoading = false;
    nameController.text = '';
    regNumberController.text = '';
    emailIdController.text = '';
  }
}
