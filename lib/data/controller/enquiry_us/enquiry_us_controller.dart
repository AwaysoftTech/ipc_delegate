import 'dart:async';
import 'dart:convert';
import 'package:ipc_delegates/core/utils/local_strings.dart';
import 'package:ipc_delegates/data/model/authorization/authorization_response_model.dart';
import 'package:ipc_delegates/data/model/enquiry_us/enquiry_us_create_model.dart';
import 'package:ipc_delegates/data/repo/enquiry_us/enquiry_us_repo.dart';
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

class EnquiryUsController extends GetxController
{
  bool isLoading = true;
  bool isSubmitLoading = false;
  String? eventId;
  EnquiryUsRepo enquiryUsRepo;
  EnquiryUsController({required this.enquiryUsRepo});

  TextEditingController titleController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  FocusNode titleFocusNode = FocusNode();
  FocusNode messageFocusNode = FocusNode();

  Future<void> addEnquiryUs(BuildContext context, String attendeeId, String eventId) async {
    String message = messageController.text.toString();

    if (message.isEmpty) {
      CustomSnackBar.error(errorList: [LocalStrings.str_enquiry_us_lbl_enter_message]);
      return;
    }

    isSubmitLoading = true;
    const ProgressDialog().showProgressDialog(context);
    update();

    EnquiryUsCreateModel attendeeModel = EnquiryUsCreateModel(
        message: message, attendee_id: attendeeId, event_id: eventId);

    ResponseModel responseModel = await enquiryUsRepo.createEnquiryUs(attendeeModel);
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

  void clearData() {
    isLoading = false;
    isSubmitLoading = false;
    titleController.text = '';
    messageController.text = '';
  }
}
