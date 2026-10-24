import 'dart:async';
import 'dart:convert';
import 'package:ipc_delegates/data/model/speaker/speaker_model.dart';
import 'package:ipc_delegates/data/model/speaker/speaker_detail_model.dart';
import 'package:ipc_delegates/data/repo/speaker/speaker_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ipc_delegates/data/model/global/response_model/response_model.dart';
import 'package:ipc_delegates/view/components/snack_bar/show_custom_snackbar.dart';

class SpeakerController extends GetxController
{
  bool isLoading = true;
  bool isSubmitLoading = false;
  String? eventId;
  SpeakerRepo speakerRepo;
  SpeakerController({required this.speakerRepo});

  SpeakerModel speakerModel = SpeakerModel();
  SpeakerDetailModel speakerDetailModel = SpeakerDetailModel();
  TextEditingController titleController = TextEditingController();
  FocusNode titleFocusNode = FocusNode();

  Future<void> loadSpeakerDetails(String speakerId, String eventId) async
  {
    ResponseModel responseModel = await speakerRepo.getSpeakerDetails(speakerId, eventId);
    if (responseModel.statusCode == 200)
    {
      dynamic json = jsonDecode(responseModel.responseJson);
      bool isSuccess = json['success'];
      String message = json['message'];
      if (isSuccess)
      {
        speakerDetailModel = SpeakerDetailModel.fromJson(jsonDecode(responseModel.responseJson));

        var speakerName = 'speakerName...: ${speakerDetailModel.speakerData?.speakerName ?? ' '} ';
        print(speakerName);
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
