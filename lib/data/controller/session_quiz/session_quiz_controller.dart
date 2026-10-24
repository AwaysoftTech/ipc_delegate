import 'dart:async';
import 'dart:convert';
import 'package:ipc_delegates/core/utils/local_strings.dart';
import 'package:ipc_delegates/data/model/authorization/authorization_response_model.dart';
import 'package:ipc_delegates/data/model/session_quiz/session_quiz_create_model.dart';
import 'package:ipc_delegates/data/repo/session_quiz/session_quiz_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ipc_delegates/data/model/global/response_model/response_model.dart';
import 'package:ipc_delegates/view/components/snack_bar/show_custom_snackbar.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:ipc_delegates/core/helper/shared_preference_helper.dart';
import 'package:ipc_delegates/core/utils/color_resources.dart';
import 'package:ipc_delegates/view/components/dialog/basic_dialog.dart';
import 'package:ipc_delegates/core/utils/images.dart';
import 'package:ipc_delegates/view/components/dialog/progress_dialog.dart';

class SessionQuizController extends GetxController
{
  bool isLoading = true;
  bool isSubmitLoading = false;
  String? eventId;
  SessionQuizRepo sessionQuizRepo;
  SessionQuizController({required this.sessionQuizRepo});

  TextEditingController messageController = TextEditingController();

  FocusNode messageFocusNode = FocusNode();

  Future<void> addQuestionUs(BuildContext context, String attendeeId, String speakerId, String sessionId, String eventId) async {
    String question = messageController.text.toString();

    if (question.isEmpty)
    {
      CustomSnackBar.error(errorList: [LocalStrings.str_enquiry_us_lbl_enter_message]);
      return;
    }

    isSubmitLoading = true;
    const ProgressDialog().showProgressDialog(context);
    update();

    SessionQuizCreateModel sessionQuizCreateModel = SessionQuizCreateModel(
        question: question, speaker_id: speakerId, attendee_id: attendeeId, session_id: sessionId, event_id: eventId);

    ResponseModel responseModel = await sessionQuizRepo.createQuestionUs(sessionQuizCreateModel);
    if (responseModel.statusCode == 200)
    {
      const ProgressDialog().hideProgressDialog(context);

      dynamic json = jsonDecode(responseModel.responseJson);
      bool isSuccess = json['success'];
      String _message = json['message'];
      if (isSuccess)
      {
        const BasicAlertDialog().basicAlertDialog(context, ()
        {Get.back();},
            title: _message.tr,
            image: MyImages.success);

        //if (context.mounted) Navigator.pop(context);
        clearData();
      }
      else
      {
        const BasicAlertDialog().basicAlertDialog(context, () {Get.back();},
            title: _message.tr,
            image: MyImages.error);
      }
    }
    else {
      const ProgressDialog().hideProgressDialog(context);
      CustomSnackBar.error(errorList: [responseModel.message]);
      return;
    }

    isSubmitLoading = false;
    update();
  }

  void clearData()
  {
    isLoading = false;
    isSubmitLoading = false;
    messageController.text = '';
  }

}
