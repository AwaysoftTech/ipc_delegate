import 'dart:async';
import 'dart:convert';
import 'package:ipc_delegates/core/utils/local_strings.dart';
import 'package:ipc_delegates/data/model/authorization/authorization_response_model.dart';
import 'package:ipc_delegates/data/model/event/event_detail_model.dart';
import 'package:ipc_delegates/data/repo/event/event_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ipc_delegates/data/model/global/response_model/response_model.dart';
import 'package:ipc_delegates/view/components/snack_bar/show_custom_snackbar.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:ipc_delegates/core/helper/shared_preference_helper.dart';
import 'package:ipc_delegates/core/utils/color_resources.dart';
import 'package:ipc_delegates/view/components/dialog/basic_dialog.dart';
import 'package:ipc_delegates/core/utils/images.dart';

class EventController extends GetxController
{
  bool isLoading = true;
  bool isSubmitLoading = false;
  String? eventId;
  EventRepo eventRepo;
  EventController({required this.eventRepo});

  EventDetailModel eventDetailModel = EventDetailModel();
  TextEditingController titleController = TextEditingController();
  FocusNode titleFocusNode = FocusNode();

  Future<void> loadEventDetails(String eventId) async
  {
    ResponseModel responseModel = await eventRepo.getEventDetails(eventId);
    if (responseModel.statusCode == 200)
    {
      dynamic json = jsonDecode(responseModel.responseJson);
      bool isSuccess = json['success'];
      String message = json['message'];
      if (isSuccess)
      {
        eventDetailModel = EventDetailModel.fromJson(jsonDecode(responseModel.responseJson));
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
    titleController.text = '';
  }
}
