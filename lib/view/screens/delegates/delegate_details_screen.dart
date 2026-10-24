import 'dart:convert';

import 'package:ipc_delegates/core/utils/images.dart';
import 'package:ipc_delegates/core/utils/local_strings.dart';
import 'package:ipc_delegates/core/utils/style.dart';
import 'package:ipc_delegates/core/utils/url_container.dart';
import 'package:ipc_delegates/data/controller/delegates/delegate_controller.dart';
import 'package:ipc_delegates/data/repo/delegates/delegate_repo.dart';
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

import 'package:ipc_delegates/view/components/dialog/warning_dialog.dart';

class AttendeeDetailsScreen extends StatefulWidget {
  const AttendeeDetailsScreen({super.key, required this.id});

  final String id;

  @override
  State<AttendeeDetailsScreen> createState() => _AttendeeDetailsScreenState();
}

class _AttendeeDetailsScreenState extends State<AttendeeDetailsScreen>
{
  bool showFab = true;
  String attendee_id = "";
  String eventId = "";
  late final controller;
  late AttendeeRepo attendeeRepo;

  int activeIndex = 0;
  void _changeContent(int index)
  {
    setState(() {
      activeIndex = index;
    });
  }

  @override
  void initState()
  {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(AttendeeRepo(apiClient: Get.find()));
    controller = Get.put(AttendeeController(attendeeRepo: Get.find()));
    attendeeRepo = Get.put(AttendeeRepo(apiClient: Get.find()));
    controller.isLoading = true;
    super.initState();

    attendee_id = widget.id;
    eventId = attendeeRepo.apiClient.sharedPreferences.getString(SharedPreferenceHelper.eventId)!;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.loadAttendeeDetails(attendee_id, eventId);
    });

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
    return GetBuilder<AttendeeController>(
      builder: (controller) => SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: CustomAppBar(
            title: LocalStrings.viewAttendeeProfile.tr,
            bgColor: Theme.of(context).appBarTheme.backgroundColor!,
          ),
          floatingActionButton: AnimatedSlide(
            offset: showFab ? Offset.zero : const Offset(0, 2),
            duration: const Duration(milliseconds: 30),
            child: AnimatedOpacity(
              opacity: showFab ? 1 : 0,
              duration: const Duration(milliseconds: 30),
              child: controller.isSubmitLoading
                  ? const RoundedLoadingBtn()
                  : RoundedButton(
                  text: controller.statusButton,
                  color: controller.statusButtonColor,
                  press: () async
                  {
                  },
              ),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
                  vertical: Dimensions.space15,
                  horizontal: Dimensions.space30,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          padding: EdgeInsets.zero,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.transparent,
                            border: Border.all(
                              width: .3,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          child: CircleImageWidget(
                            isProfile: true,
                            imagePath:
                            '${UrlContainer.profileImgUrl}${controller.attendeeDetailsModel.data!.attendeePhoto ?? ''}',
                            height: 80,
                            width: 80,
                            isAsset: false,
                          ),
                        ),
                        const SizedBox(width: Dimensions.space15),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              right: 15.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${controller.attendeeDetailsModel.data?.attendeeName!.capitalize ?? ''} ',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: regularExtraLarge,
                                ),
                                const SizedBox(
                                  height: Dimensions.space10,
                                ),

                                Container(
                                  decoration: BoxDecoration(
                                    color: controller.statusColor,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.person,
                                        color: ColorResources.lightGray,
                                      ),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(right: 5.0,),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(
                                                height: Dimensions.space5,
                                              ),
                                              Text(
                                                controller.status,
                                                overflow: TextOverflow.visible,
                                                maxLines: 1,
                                                style: regularLarge.copyWith(
                                                    color: ColorResources.lightGray),
                                              ),

                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: Dimensions.space20),

                    //Welcome Kit Label
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleShapeImage(
                              image: MyImages.shoppingBag,
                              size: 40,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: Dimensions.space10),
                                    Text(
                                      LocalStrings.str_attendee_welcome_kit,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: regularLarge.copyWith(
                                        color: ColorResources.primaryColor,
                                      ),
                                    ),
                                    const SizedBox(height: Dimensions.space10),
                                    Row(
                                      children: [
                                        Flexible(
                                          child: Text(
                                            controller.attendeeDetailsModel.checkInData?.welcomeKitProvide ?? "No Yet Provide",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: boldLarge.copyWith(
                                              color: ColorResources.lightGray,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: Dimensions.space10),
                                    Row(
                                      children: [
                                        Icon(Icons.calendar_month, size: 16, color: Colors.white),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${controller.attendeeDetailsModel.checkInData?.welcomeKitDate ?? "--"} ',
                                          style: TextStyle(fontSize: 12, color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: Dimensions.space10),
                                    Row(
                                      children: [
                                        CardButton(
                                          text: 'Provide Kit Now',
                                          bgColor: ColorResources.colorOrange.withAlpha(200),
                                          icon: Icons.check_box_outlined,
                                          press: () async
                                          {

                                          },
                                        ),

                                      ],
                                    ),
                                    const SizedBox(height: Dimensions.space10),

                                  ],
                                ),
                              ),
                            ),

                          ],
                        ),

                    ),

                    const SizedBox(height: Dimensions.space10),

                    //Tab Bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // "Active" Button
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _changeContent(0),
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: activeIndex == 0 ? ColorResources.primaryColor : ColorResources.borderColor,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  bottomLeft: Radius.circular(8),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "Attendee Detail",
                                  style: TextStyle(
                                    color: activeIndex == 0 ? Colors.white : Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // "Completed" Button
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _changeContent(1),
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: activeIndex == 1 ? ColorResources.primaryColor : ColorResources.borderColor,
                              ),
                              child: Center(
                                child: Text(
                                  "Check-In Activity",
                                  style: TextStyle(
                                    color: activeIndex == 1 ? Colors.white : Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),

                    const SizedBox(height: Dimensions.space10),

                    activeIndex == 0
                        ? _attendeeDetail(controller)
                        : _checkInActivity(controller),

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

  Widget _attendeeDetail(AttendeeController controller)
  {
    return Container(
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: Colors.white30,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: Colors.white30,
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: Dimensions.space20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleShapeImage(
                imageColor: Theme.of(
                  context,
                ).appBarTheme.backgroundColor,
                image: MyImages.list,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 15.0,
                  ),
                  child: CardColumn(
                    header:
                    LocalStrings.registration_number.tr,
                    body:
                    controller
                        .attendeeDetailsModel
                        .data
                        ?.registrationNumber ??
                        "",
                  ),
                ),
              ),
            ],
          ),
          const CustomDivider(space: Dimensions.space15),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleShapeImage(
                imageColor: Theme.of(
                  context,
                ).appBarTheme.backgroundColor,
                image: MyImages.email,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 15.0,
                  ),
                  child: CardColumn(
                    header: LocalStrings.attendee_email.tr,
                    body:
                    controller
                        .attendeeDetailsModel
                        .data
                        ?.emailId ??
                        "",
                  ),
                ),
              ),
            ],
          ),
          const CustomDivider(space: Dimensions.space15),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleShapeImage(
                imageColor: Theme.of(
                  context,
                ).appBarTheme.backgroundColor,
                image: MyImages.phone,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 15.0,
                  ),
                  child: CardColumn(
                    header: LocalStrings.attendee_mobile.tr,
                    body:
                    controller
                        .attendeeDetailsModel
                        .data
                        ?.mobile ??
                        "",
                  ),
                ),
              ),
            ],
          ),
          const CustomDivider(space: Dimensions.space15),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleShapeImage(
                imageColor: Theme.of(
                  context,
                ).appBarTheme.backgroundColor,
                image: MyImages.grid,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 15.0,
                  ),
                  child: CardColumn(
                    header: LocalStrings.categories.tr,
                    body:
                    controller
                        .attendeeDetailsModel
                        .data
                        ?.categories ??
                        "",
                  ),
                ),
              ),
            ],
          ),
          const CustomDivider(space: Dimensions.space15),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleShapeImage(
                imageColor: Theme.of(
                  context,
                ).appBarTheme.backgroundColor,
                image: MyImages.company,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 15.0,
                  ),
                  child: CardColumn(
                    header: LocalStrings.organization.tr,
                    body:
                    controller
                        .attendeeDetailsModel
                        .data
                        ?.affiliation ??
                        "",
                  ),
                ),
              ),
            ],
          ),
          const CustomDivider(space: Dimensions.space15),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleShapeImage(
                imageColor: Theme.of(
                  context,
                ).appBarTheme.backgroundColor,
                image: MyImages.address,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 15.0,
                  ),
                  child: CardColumn(
                    header: LocalStrings.state.tr,
                    body:
                    controller
                        .attendeeDetailsModel
                        .data
                        ?.state ??
                        "",
                  ),
                ),
              ),
            ],
          ),
          const CustomDivider(space: Dimensions.space15),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleShapeImage(
                imageColor: Theme.of(
                  context,
                ).appBarTheme.backgroundColor,
                image: MyImages.phone,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 15.0,
                  ),
                  child: CardColumn(
                    header:
                    LocalStrings.attendee_address.tr,
                    body: controller.attendeeDetailsModel.data?.address1 ?? "--",
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _checkInActivity(AttendeeController controller)
  {
    return Container(
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: Colors.white30,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: Colors.white30,
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: Dimensions.space20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleShapeImage(
                imageColor: ColorResources.greenColor,
                image: MyImages.calendar,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 15.0,
                  ),
                  child: CardColumn(

                    header: LocalStrings.str_attendee_check_in_date.tr,
                    body: '${controller.attendeeDetailsModel.checkInData?.eventInDate.toString()} - ${controller.attendeeDetailsModel.checkInData?.eventInTime.toString()}',
                  ),
                ),
              ),
            ],
          ),
          const CustomDivider(space: Dimensions.space15),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleShapeImage(
                imageColor: ColorResources.redColor,
                image: MyImages.calendar,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 15.0,
                  ),
                  child: CardColumn(
                    header: LocalStrings.str_attendee_check_out_date.tr,
                    body: '${controller.attendeeDetailsModel.checkInData?.eventOutDate.toString()} - ${controller.attendeeDetailsModel.checkInData?.eventOutTime.toString()}',
                  ),
                ),
              ),
            ],
          ),
          const CustomDivider(space: Dimensions.space15),

        ],
      ),
    );
  }


}


