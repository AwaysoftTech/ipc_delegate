import 'package:ipc_delegates/core/utils/images.dart';
import 'package:ipc_delegates/core/utils/local_strings.dart';
import 'package:ipc_delegates/core/utils/style.dart';
import 'package:ipc_delegates/core/utils/url_container.dart';
import 'package:ipc_delegates/data/controller/profile/profile_controller.dart';
import 'package:ipc_delegates/data/repo/profile/profile_repo.dart';
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
import 'package:ipc_delegates/core/helper/shared_preference_helper.dart';
import 'package:ipc_delegates/core/utils/color_resources.dart';
import 'package:ipc_delegates/core/utils/style.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ipc_delegates/view/components/buttons/card_button.dart';

class ProfileScreen extends StatefulWidget
{
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
{
  bool showFab = true;
  String attendeeId = "";
  String eventId = "";
  late final controller;
  late ProfileRepo profileRepo;

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
    Get.put(ProfileRepo(apiClient: Get.find()));
    controller = Get.put(ProfileController(profileRepo: Get.find()));
    profileRepo = Get.put(ProfileRepo(apiClient: Get.find()));
    controller.isLoading = true;
    super.initState();

    attendeeId = profileRepo.apiClient.sharedPreferences.getString(SharedPreferenceHelper.attendeeId)!;
    eventId = profileRepo.apiClient.sharedPreferences.getString(SharedPreferenceHelper.eventId)!;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.loadAttendeeDetails(attendeeId, eventId);
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
    return GetBuilder<ProfileController>(
      builder: (controller) => SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: CustomAppBar(
            title: LocalStrings.profile.tr,
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
                                '${UrlContainer.profileImgUrl}${controller.profileModel.data!.attendeePhoto ?? ''}',
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
                                      '${controller.profileModel.data?.attendeeName!.capitalize ?? ''} ',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: regularExtraLarge,
                                    ),
                                    const SizedBox(
                                      height: Dimensions.space10,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: Dimensions.space20),

                        //Event Check-In Label
                        Container(
                          decoration: BoxDecoration(
                            color: ColorResources.colorLightGrey,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleShapeImage(
                                image: MyImages.repeat,
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
                                        LocalStrings.str_profile_lbl_event_check_in_status,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: regularLarge.copyWith(
                                          color: ColorResources.cardColorDark,
                                        ),
                                      ),
                                      const SizedBox(height: Dimensions.space10),
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
                                      const SizedBox(height: Dimensions.space10),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),

                        ),

                        const SizedBox(height: Dimensions.space10),

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
                                          color: ColorResources.colorWhite,
                                        ),
                                      ),
                                      const SizedBox(height: Dimensions.space10),
                                      Row(
                                        children: [
                                          Flexible(
                                            child: Text(
                                              'Status: ${controller.profileModel.checkInData?.welcomeKitProvide ?? "No Yet"} ',
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
                                            '${controller.profileModel.checkInData?.welcomeKitDate ?? "--"} ',
                                            style: TextStyle(fontSize: 12, color: Colors.white),
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

  Widget _attendeeDetail(ProfileController controller)
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
                        .profileModel
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
                        .profileModel
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
                        .profileModel
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
                        .profileModel
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
                        .profileModel
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
                        .profileModel
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
                    body: controller.profileModel.data?.address1 ?? "--",
                  ),
                ),
              ),
            ],
          ),
          const CustomDivider(space: Dimensions.space15),
          Card(
            margin: EdgeInsets.zero,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  border: Border(
                    left: BorderSide(
                      width: 5.0,
                      color: ColorResources.colorGrey,
                    ),
                  ),
                ),
                child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                color: ColorResources.blueGreyColor,
                                borderRadius: BorderRadius.only(bottomRight: Radius.circular(16.0), topRight: Radius.circular(16.0)),
                              ),
                              padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
                              child: Text(LocalStrings.str_profile_lbl_qr_code.tr, style: primaryTextStyle(color: white, size: 12)),
                            ),
                          ],
                        ),
                        const SizedBox(height: Dimensions.space5),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [

                                CachedNetworkImage(
                                imageUrl: '${UrlContainer.profileImgUrl}${controller.profileModel.data!.qrCode ?? ''}',
                                height: 200,
                                fit: BoxFit.cover,
                                errorWidget: (ctx, object, trx) {
                                  return Image.asset(
                                      MyImages.appLogos,
                                      height: 200);
                                },
                                placeholder: (ctx, trx) {
                                  return CircularProgressIndicator();
                                }),
                          ],
                        ),
                        const SizedBox(height: Dimensions.space5),
                      ],
                    )),
              ),
            ),
          ),

        ],
      ),
    );
  }

  Widget _checkInActivity(ProfileController controller)
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
                    body: '${controller.profileModel.checkInData?.eventInDate.toString()} - ${controller.profileModel.checkInData?.eventInTime.toString()}',
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
                    body: '${controller.profileModel.checkInData?.eventOutDate.toString()} - ${controller.profileModel.checkInData?.eventOutTime.toString()}',
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
