import 'package:ipc_delegates/core/utils/images.dart';
import 'package:ipc_delegates/core/utils/local_strings.dart';
import 'package:ipc_delegates/core/utils/style.dart';
import 'package:ipc_delegates/core/utils/url_container.dart';
import 'package:ipc_delegates/data/controller/event/event_controller.dart';
import 'package:ipc_delegates/data/repo/event/event_repo.dart';
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
import 'package:ipc_delegates/core/utils/util.dart';
import 'package:ipc_delegates/view/components/buttons/card_button.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class EventDetailScreen extends StatefulWidget
{
  const EventDetailScreen({super.key});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen>
{
  String eventId = "";
  late final controller;
  late EventRepo eventRepo;

  @override
  void initState()
  {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(EventRepo(apiClient: Get.find()));
    controller = Get.put(EventController(eventRepo: Get.find()));
    eventRepo = Get.put(EventRepo(apiClient: Get.find()));
    controller.isLoading = true;
    super.initState();

    eventId = eventRepo.apiClient.sharedPreferences.getString(SharedPreferenceHelper.eventId)!;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.loadEventDetails(eventId);
    });

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context)
  {
    return GetBuilder<EventController>(
      builder: (controller) => SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: CustomAppBar(
            title: LocalStrings.str_event_detail_lbl_title.tr,
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
                      left: Dimensions.space15,
                      right: Dimensions.space15,
                      top: Dimensions.space20,
                      bottom: Dimensions.space20),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(
                        vertical: Dimensions.space15,
                        horizontal: Dimensions.space20),
                    decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${controller.eventDetailModel.eventData?.eventName!.capitalize ?? ''} ',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: regularExtraLarge,
                                    ),
                                    const SizedBox(height: Dimensions.space10),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: Dimensions.space20),
                        Row(
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
                                    header: LocalStrings.eventFromDate.tr,
                                    body: '${controller.eventDetailModel.eventData!.eventFromDate ?? ''} ${controller.eventDetailModel.eventData!.eventFromTime ?? ''}',),
                              ),
                            ),
                          ],
                        ),
                        const CustomDivider(space: Dimensions.space15),
                        Row(
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
                                    body: '${controller.eventDetailModel.eventData!.eventToDate ?? ''} ${controller.eventDetailModel.eventData!.eventToTime ?? ''}'),
                              ),
                            ),
                          ],
                        ),
                        const CustomDivider(space: Dimensions.space15),
                        Row(
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
                                    body: '${controller.eventDetailModel.eventData!.eventLocation ?? ''}'),
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
                                color: Theme
                                    .of(context)
                                    .cardColor,
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
                                              color: ColorResources.primaryColor,
                                              borderRadius: BorderRadius.only(
                                                  bottomRight: Radius.circular(16.0),
                                                  topRight: Radius.circular(16.0)),
                                            ),
                                            padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
                                            child: Text(LocalStrings
                                                .eventDescription
                                                .tr, style: primaryTextStyle(
                                                color: white, size: 12)),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                          height: Dimensions.space5),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: HtmlWidget(
                                              controller.eventDetailModel.eventData?.eventDescription ?? "",
                                              textStyle: regularDefault,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  )),
                            ),
                          ),
                        ),
                        const CustomDivider(space: Dimensions.space15),

                        Card(
                          margin: EdgeInsets.zero,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme
                                    .of(context)
                                    .cardColor,
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
                                              color: ColorResources.primaryColor,
                                              borderRadius: BorderRadius.only(
                                                  bottomRight: Radius.circular(16.0),
                                                  topRight: Radius.circular(16.0)),
                                            ),
                                            padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
                                            child: Text(LocalStrings
                                                .organizationName
                                                .tr, style: primaryTextStyle(
                                                color: white, size: 12)),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                          height: Dimensions.space5),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            controller.eventDetailModel.settingData?.organizationName ?? "",
                                            style: regularLarge,
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                            ),
                          ),
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
                                              color: ColorResources.primaryColor,
                                              borderRadius: BorderRadius.only(bottomRight: Radius.circular(16.0), topRight: Radius.circular(16.0)),
                                            ),
                                            padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
                                            child: Text(LocalStrings.organizationEmail.tr, style: primaryTextStyle(color: white, size: 12)),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: Dimensions.space5),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            controller.eventDetailModel.settingData?.organizationEmail ?? "",
                                            style: regularDefault,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: Dimensions.space5),
                                    ],
                                  )
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
