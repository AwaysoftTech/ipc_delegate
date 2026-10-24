
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:ipc_delegates/core/route/route.dart';
import 'package:ipc_delegates/core/utils/color_resources.dart';
import 'package:ipc_delegates/core/utils/dimensions.dart';
import 'package:ipc_delegates/core/utils/images.dart';
import 'package:ipc_delegates/core/utils/local_strings.dart';
import 'package:ipc_delegates/core/utils/style.dart';
import 'package:ipc_delegates/core/utils/url_container.dart';

import 'package:ipc_delegates/view/components/app-bar/action_button_icon_widget.dart';
import 'package:ipc_delegates/view/components/circle_image_button.dart';
import 'package:ipc_delegates/view/components/custom_loader/custom_loader.dart';
import 'package:ipc_delegates/view/components/no_data.dart';
import 'package:ipc_delegates/view/components/card/custom_card.dart';
import 'package:ipc_delegates/view/screens/dashboard/widget/overview_card.dart';
import 'package:ipc_delegates/view/screens/dashboard/widget/drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ipc_delegates/data/controller/dashboard/dashboard_controller.dart';
import 'package:ipc_delegates/data/repo/dashboard/dashboard_repo.dart';
import 'package:ipc_delegates/data/services/api_service.dart';
import 'package:ipc_delegates/view/components/will_pop_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:ipc_delegates/view/components/bottom-sheet/custom_bottom_sheet.dart';
import 'package:ipc_delegates/view/components/image/circle_shape_image.dart';
import 'package:ipc_delegates/view/components/column_widget/card_column.dart';
import 'package:ipc_delegates/view/components/divider/custom_divider.dart';
import 'package:ipc_delegates/core/helper/shared_preference_helper.dart';
import 'package:ipc_delegates/data/repo/profile/profile_repo.dart';
import 'package:ipc_delegates/view/components/dialog/warning_dialog.dart';
import 'package:ipc_delegates/view/components/dialog/app_update_dialog.dart';
import 'package:ipc_delegates/view/screens/speaker/widget/speaker_card.dart';
import 'package:ipc_delegates/view/components/no_data.dart';
import 'package:nb_utils/nb_utils.dart' hide NoDataWidget;

import 'package:ipc_delegates/view/screens/event_session/event_session_screen.dart';

import 'package:ipc_delegates/core/utils/notification/notification_service.dart';


class HomeScreen extends StatefulWidget
{
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String attendeeName = "";
  String attendeePhoto = "";
  String attendeeEmailId = "";
  late final controller;
  late ProfileRepo profileRepo;
  @override
  void initState()
  {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(DashboardRepo(apiClient: Get.find()));
    controller = Get.put(DashboardController(dashboardRepo: Get.find()));
    profileRepo = Get.put(ProfileRepo(apiClient: Get.find()));
    controller.isLoading = true;

    super.initState();

    attendeeName = profileRepo.apiClient.sharedPreferences.getString(SharedPreferenceHelper.attendeeName) ?? "";
    attendeePhoto = profileRepo.apiClient.sharedPreferences.getString(SharedPreferenceHelper.attendeePhoto) ?? "";
    attendeeEmailId = profileRepo.apiClient.sharedPreferences.getString(SharedPreferenceHelper.emailId) ?? "";

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.initialData();
    });

  }

  @override
  Widget build(BuildContext context)
  {
    if (!kIsWeb)
    {
      ///////////////////////////////////////
      NotificationService.init(context);
      ///////////////////////////////////////
    }

    Future.delayed(const Duration(seconds: 3), () {
      if(!controller.isLoading)
      {
        if(controller.dashboardModel.eventSettingData?.needUpdate == 'Yes')
        {
          Future.delayed(Duration.zero, () => showAppUpdateDialog(context, controller.dashboardModel.eventSettingData?.titleUpdate ?? ""));
        }
      }
    });

    return WillPopWidget(
      nextRoute: "",
      child: GetBuilder<DashboardController>(
        builder: (controller) => Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            toolbarHeight: 50,
            leading: Builder(builder: (context) {
              return IconButton(
                icon: const Icon(
                  Icons.menu_rounded,
                  size: 30,
                  color: Colors.white,
                ),
                onPressed: ()
                {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Scaffold.of(context).openDrawer();
                  });

                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            }),
            centerTitle: true,
            title: CachedNetworkImage(
                imageUrl: '${UrlContainer.profileImgUrl}${controller.appLogo ?? ''}',
                height: 30,
                color: Colors.white,
                errorWidget: (ctx, object, trx) {
                  return Image.asset(
                    MyImages.appLogoFlat,
                    height: 30,
                  );
                },
                placeholder: (ctx, trx) {
                  return Image.asset(
                    MyImages.appLogo,
                    height: 30,
                  );
                }),
            actions: [
              ActionButtonIconWidget(
                pressed: () => Get.toNamed(RouteHelper.notificationScreen),
                icon: Icons.notifications,
                size: 35,
                iconColor: Colors.white,
              ),
            ],
          ),
          drawer: HomeDrawer(dashboardModel: controller.dashboardModel),
          body: controller.isLoading
              ? const CustomLoader()
              : RefreshIndicator(
            onRefresh: () async
            {
              await controller.initialData(shouldLoad: false);
            },
            color: Theme.of(context).primaryColor,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(Dimensions.space10),
              child: Column(
                children: [

                  Column(
                    children: [
                      CachedNetworkImage(
                          imageUrl: '${UrlContainer.profileImgUrl}${controller.dashboardModel.eventData!.eventThumbs ?? ''}',
                          height: 200,
                          width: MediaQuery.of(context).size.width, // Set to screen width
                          fit: BoxFit.fitWidth,
                          errorWidget: (ctx, object, trx)
                          {
                            return Image.asset(
                                MyImages.appLogos,
                                height: 200
                            );
                          },
                          placeholder: (ctx, trx) {
                            return CircularProgressIndicator();
                          }),
                    ],
                  ),
                  const SizedBox(height: Dimensions.space15),
                  //User Profile Label
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.2), // Shadow color and opacity
                          spreadRadius: 2, // Extends the shadow outwards
                          blurRadius: 2, // Blurs the edges of the shadow
                          offset: Offset(0, 2), // Shifts the shadow horizontally and vertically
                        ),
                      ],
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: ColorResources.blueGreyColor,
                          radius: 31,
                          child: CachedNetworkImage(
                              imageUrl: '${UrlContainer.profileImgUrl}${attendeePhoto ?? ''}',
                              height: 200,
                              fit: BoxFit.fitHeight,
                              errorWidget: (ctx, object, trx) {
                                return Image.asset(
                                    MyImages.person,
                                    height: 200
                                );
                              },
                              placeholder: (ctx, trx) {
                                return Image.asset(
                                  MyImages.person,
                                  height: 200,
                                );
                              }),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: Dimensions.space10),
                                Text(attendeeName ?? '',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: regularLarge.copyWith(
                                    color: ColorResources.primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: Dimensions.space5),
                                Text(
                                  attendeeEmailId ?? '',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(fontSize: 14, color: Colors.grey),
                                ),
                                const SizedBox(height: Dimensions.space10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                        color: ColorResources.blueGreyColor,
                                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(16.0), topRight: Radius.circular(16.0)),
                                      ),
                                      padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
                                      child: Text('View Profile', style: primaryTextStyle(color: white, size: 12)),
                                    ),
                                  ],
                                ).onTap(
                                      () {
                                    Get.toNamed(RouteHelper.profileScreen);
                                  },
                                ),
                                const SizedBox(height: Dimensions.space10),
                              ],
                            ),
                          ),
                        ),

                      ],
                    ),

                  ),
                  const SizedBox(height: Dimensions.space15),
                  //Counting Card
                  Row(
                    children: [
                      OverviewCard(
                          icon: Icons.location_city,
                          iconColor: ColorResources.redColor,
                          name: LocalStrings.totalAreas.tr,
                          onPress: () => Get.toNamed(RouteHelper.eventAreaScreen),
                          number: '${controller.dashboardModel.widgetsData?.totalAreas.toString()}',
                          color: ColorResources.blueColor,
                          bgColor: Theme.of(context).cardColor),
                      OverviewCard(
                          icon: Icons.person,
                          iconColor: ColorResources.yellowColor,
                          name: LocalStrings.totalSpeaker.tr,
                          onPress: () => Get.toNamed(RouteHelper.speakerScreen),
                          number: '${controller.dashboardModel.widgetsData?.totalSpeaker.toString()}',
                          color: ColorResources.redColor,
                          bgColor: Theme.of(context).cardColor),
                    ],
                  ),
                  const SizedBox(height: Dimensions.space20),
                  //View Event Day Card
                  Row(
                    children: [
                      OverviewCard(
                          icon: Icons.list_alt,
                          iconColor: ColorResources.colorlighterGrey,
                          name: LocalStrings.home_event_day_view,
                          onPress: () => Get.to(() => EventSessionScreen(arguments: {'from': 'EventSession', 'from_id': ''})),
                          number: LocalStrings.home_event_day.tr,
                          color: ColorResources.lightGray,
                          bgColor: ColorResources.colorRed),
                    ],
                  ),
                  const SizedBox(height: Dimensions.space20),
                  //Speaker Listing
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Container(
                          width: 3,
                          height: 15,
                          color: ColorResources.secondaryColor,
                        ),
                        const SizedBox(width: Dimensions.space5),
                        Text(
                          LocalStrings.eventSpeaker.tr,
                          style: regularLarge,
                        ),
                        const Spacer(),
                        Container(
                          height: 30.0,
                          decoration: BoxDecoration(
                            border: Border.all(color: ColorResources.blueColor),
                            borderRadius: const BorderRadius.all(Radius.circular(5)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 1),
                            child: TextButton(
                              onPressed: () {
                                Get.toNamed(RouteHelper.speakerScreen);
                              },
                              child: Text(
                                LocalStrings.home_view_more.tr,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: ColorResources.blueColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Dimensions.space10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: controller.speakerList.isNotEmpty
                        ? GridView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        controller: ScrollController(),
                        padding: EdgeInsets.only(top: 10),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisExtent: 210, // <-- this works!
                        ),
                        //just add this line,
                        itemBuilder: (context, index) {
                          final item = controller.speakerList[index];
                          return SpeakerCard(
                            speakerModel: item,
                          );
                        },
                        itemCount: controller.speakerList.length)
                        : const NoDataWidget(
                      text: LocalStrings.str_speaker_no_speaker,
                      image: MyImages.noSpeaker,),
                  ),
                  const SizedBox(height: Dimensions.space10),
                  //Event Detail
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Container(
                          width: 3,
                          height: 15,
                          color: ColorResources.secondaryColor,
                        ),
                        const SizedBox(width: Dimensions.space5),
                        Text(
                          LocalStrings.eventDetail.tr,
                          style: regularLarge,
                        ),
                        const Spacer(),
                        Container(
                          height: 30.0,
                          decoration: BoxDecoration(
                            border: Border.all(color: ColorResources.blueColor),
                            borderRadius: const BorderRadius.all(Radius.circular(5)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 1),
                            child: TextButton(
                              onPressed: () {
                                Get.toNamed(RouteHelper.eventDetailScreen);
                              },
                              child: Text(
                                LocalStrings.home_view_more.tr,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: ColorResources.blueColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Dimensions.space15),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: ColorResources.blueGreyColor,
                          radius: 31,
                          child: CachedNetworkImage(
                              imageUrl: '${UrlContainer.profileImgUrl}${controller.dashboardModel.eventData!.organizationLogo ?? ''}',
                              height: 200,
                              fit: BoxFit.fitHeight,
                              errorWidget: (ctx, object, trx) {
                                return Image.asset(
                                    MyImages.appLogos,
                                    height: 200
                                );
                              },
                              placeholder: (ctx, trx) {
                                return Image.asset(
                                  MyImages.appLogos,
                                  height: 200,
                                );
                              }),
                        ),
                        const SizedBox(width: Dimensions.space10),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${controller.dashboardModel.eventData!.eventName ?? ''} ',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: ColorResources.primaryColor),
                                ),
                                const SizedBox(height: Dimensions.space10),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                  ),
                  const Divider(color: Color.fromARGB(255, 214, 213, 213), thickness: 1),
                  const SizedBox(height: Dimensions.space10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleShapeImage(imageColor: Theme.of(context).appBarTheme.backgroundColor,
                            image: MyImages.calendar),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 15.0),
                            child: CardColumn(
                              header: LocalStrings.eventFromDate.tr,
                              body: '${controller.dashboardModel.eventData?.eventFromDate.toString() ?? ''} ${controller.dashboardModel.eventData?.eventFromTime.toString() ?? ''}',),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const CustomDivider(space: Dimensions.space15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleShapeImage(imageColor: Theme.of(context)
                            .appBarTheme
                            .backgroundColor,
                            image: MyImages.calendar),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 15.0),
                            child: CardColumn(
                                header: LocalStrings.eventToDate.tr,
                                body: '${controller.dashboardModel.eventData?.eventToDate.toString() ?? ''} ${controller.dashboardModel.eventData?.eventToTime.toString() ?? ''}'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const CustomDivider(space: Dimensions.space15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleShapeImage(imageColor: Theme.of(context)
                            .appBarTheme
                            .backgroundColor,
                            image: MyImages.map),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 15.0),
                            child: CardColumn(
                                header: LocalStrings.eventLocation.tr,
                                body: '${controller.dashboardModel.eventData?.eventLocation.toString() ?? ''}'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const CustomDivider(space: Dimensions.space15),
                  //Other Card
                  Row(
                    children: [
                      OverviewCard(
                          icon: Icons.notifications,
                          iconColor: ColorResources.colorlighterGrey,
                          name: 'View',
                          onPress: () => Get.toNamed(RouteHelper.notificationScreen),
                          number: LocalStrings.home_notification.tr,
                          color: ColorResources.lightGray,
                          bgColor: ColorResources.colorGrey),
                      OverviewCard(
                          icon: Icons.message,
                          iconColor: ColorResources.colorGreen,
                          name: 'Question',
                          onPress: () {
                            Get.toNamed(RouteHelper.enquiryUsAddScreen);
                          },
                          number: LocalStrings.home_enquiry,
                          color: ColorResources.lightGray,
                          bgColor: ColorResources.blueColor),
                    ],
                  ),
                  const SizedBox(height: Dimensions.space25),
                  const SizedBox(height: Dimensions.space25),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}
