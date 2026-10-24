import 'dart:convert';

import 'package:ipc_delegates/core/utils/images.dart';
import 'package:ipc_delegates/core/utils/local_strings.dart';
import 'package:ipc_delegates/core/utils/style.dart';
import 'package:ipc_delegates/core/utils/url_container.dart';
import 'package:ipc_delegates/data/controller/enquiry_us/enquiry_us_controller.dart';
import 'package:ipc_delegates/data/repo/enquiry_us/enquiry_us_repo.dart';
import 'package:ipc_delegates/view/components/circle_image_button.dart';
import 'package:ipc_delegates/view/components/column_widget/card_column.dart';
import 'package:ipc_delegates/view/components/divider/custom_divider.dart';
import 'package:ipc_delegates/view/components/image/circle_shape_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ipc_delegates/core/utils/dimensions.dart';
import 'package:ipc_delegates/data/services/api_service.dart';
import 'package:ipc_delegates/view/components/app-bar/custom_appbar.dart';
import 'package:ipc_delegates/view/components/custom_loader/custom_loader.dart';
import 'package:ipc_delegates/core/utils/color_resources.dart';
import 'package:ipc_delegates/view/components/custom_fab.dart';
import 'package:ipc_delegates/core/helper/shared_preference_helper.dart';

import 'package:ipc_delegates/view/components/buttons/rounded_button.dart';
import 'package:ipc_delegates/view/components/buttons/rounded_loading_button.dart';
import 'package:ipc_delegates/view/components/dialog/basic_dialog.dart';
import 'package:ipc_delegates/view/components/buttons/card_button.dart';
import 'package:ipc_delegates/view/components/text-form-field/custom_text_field.dart';
import 'package:ipc_delegates/view/components/dialog/warning_dialog.dart';
import 'package:ipc_delegates/view/components/text-form-field/custom_drop_down_text_field.dart';
import 'package:ipc_delegates/view/components/dialog/progress_dialog.dart';

class EnquiryUsAddScreen extends StatefulWidget {
  const EnquiryUsAddScreen({super.key});

  @override
  State<EnquiryUsAddScreen> createState() => _EnquiryUsAddScreenState();
}

class _EnquiryUsAddScreenState extends State<EnquiryUsAddScreen>
{
  final formKey = GlobalKey<FormState>();

  bool showFab = true;
  String attendeeId = "";
  String eventId = "";
  late final controller;
  late EnquiryUsRepo enquiryUsRepo;

  @override
  void initState()
  {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(EnquiryUsRepo(apiClient: Get.find()));
    controller = Get.put(EnquiryUsController(enquiryUsRepo: Get.find()));
    enquiryUsRepo = Get.put(EnquiryUsRepo(apiClient: Get.find()));

    super.initState();

    controller.isLoading = false;

    attendeeId = enquiryUsRepo.apiClient.sharedPreferences.getString(SharedPreferenceHelper.attendeeId) ?? "";
    eventId = enquiryUsRepo.apiClient.sharedPreferences.getString(SharedPreferenceHelper.eventId)!;
  }

  ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    controller.isLoading = false;
    controller.isSubmitLoading = false;
    scrollController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context)
  {
    return GetBuilder<EnquiryUsController>(
      builder: (controller) => SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: CustomAppBar(
            title: LocalStrings.str_enquiry_us_title.tr,
            bgColor: Theme.of(context).appBarTheme.backgroundColor!,
          ),
          body: controller.isLoading
              ? const CustomLoader()
              : Stack(
            children: [
              Positioned(
                top: -10,
                child: Container(
                  height: 100,
                  width: MediaQuery.of(context).size.width,
                  color: Theme.of(context).appBarTheme.backgroundColor!,
                ),
              ),
              Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                left: Dimensions.space5,
                right: Dimensions.space5,
                top: Dimensions.space20,
                bottom: Dimensions.space20,
              ),
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(
                  vertical: Dimensions.space10,
                  horizontal: Dimensions.space10,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.blueAccent[300],
                              child: CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.white30,
                                child: Image.asset(
                                  MyImages.enquiry,
                                  height: 40,
                                  width: 40,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(LocalStrings.str_enquiry_us_title,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 1.0),
                                    child: Text(LocalStrings.str_enquiry_us_title_des,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 5,
                                      style: TextStyle(fontSize: 14, color: Colors.grey),
                                    ),
                                  ),
                                  const SizedBox(height: 4),

                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: Dimensions.space20),
                    _attendeeDetail(controller),

                    const SizedBox(height: Dimensions.space40),
                    const SizedBox(height: Dimensions.space40),
                  ],
                ),
              ),
            ),
          ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _attendeeDetail(EnquiryUsController controller)
  {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          )),
      padding: const EdgeInsets.symmetric(
          horizontal: 8.0, vertical: Dimensions.space20),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomTextField(
              animatedLabel: true,
              needOutlineBorder: true,
              labelText: LocalStrings.str_enquiry_us_lbl_enter_message.tr,
              textInputType: TextInputType.multiline,
              maxLines: 10,
              focusNode: controller.messageFocusNode,
              controller: controller.messageController,
              inputAction: TextInputAction.done,
              onChanged: (value) {
                return;
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please Enter Message'.tr;
                } else {
                  return null;
                }
              },
            ),
            const SizedBox(height: Dimensions.space20),
            RoundedButton(
                text: LocalStrings.str_enquiry_us_b_send_now.tr,
                press: ()
                {
                  if (formKey.currentState!.validate())
                  {
                    const WarningAlertDialog().warningAlertDialog(context, () {
                      Get.back();
                      controller.addEnquiryUs(context, attendeeId, eventId);
                    },
                        title: 'Confirm to',
                        image: MyImages.enquiry,
                        subTitle: 'Send Enquiry');
                  }
                }),
            const SizedBox(height: Dimensions.space20),
          ],
        ),
      ),
    );
  }

}