import 'package:ipc_delegates/core/utils/images.dart';
import 'package:ipc_delegates/core/utils/local_strings.dart';
import 'package:ipc_delegates/core/utils/style.dart';
import 'package:ipc_delegates/core/utils/url_container.dart';
import 'package:ipc_delegates/data/controller/event_session/event_session_controller.dart';
import 'package:ipc_delegates/data/repo/event_session/event_session_repo.dart';
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
import 'package:ipc_delegates/view/screens/session_quiz/session_quiz_add_screen.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:ipc_delegates/core/utils/util.dart';
import 'package:ipc_delegates/view/components/buttons/card_button.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:ipc_delegates/core/route/route.dart';
import 'package:ipc_delegates/view/screens/speaker/widget/speaker_card.dart';

import 'package:ipc_delegates/view/screens/speaker/widget/session_speaker_card.dart';

class EventSessionDetailScreen extends StatefulWidget {
  const EventSessionDetailScreen({super.key, required this.id});

  final String id;

  @override
  State<EventSessionDetailScreen> createState() => _EventSessionDetailScreenState();
}

class _EventSessionDetailScreenState extends State<EventSessionDetailScreen> {
  String sessionId = "";
  String eventId = "";
  late final controller;
  late EventSessionRepo eventSessionRepo;

  @override
  void initState()
  {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(EventSessionRepo(apiClient: Get.find()));
    controller = Get.put(EventSessionController(eventSessionRepo: Get.find()));
    eventSessionRepo = Get.put(EventSessionRepo(apiClient: Get.find()));
    controller.isLoading = true;
    super.initState();

    sessionId = widget.id;
    eventId = eventSessionRepo.apiClient.sharedPreferences.getString(SharedPreferenceHelper.eventId)!;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.loadSessionDetails(sessionId, eventId);
    });

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context)
  {
    return GetBuilder<EventSessionController>(
      builder: (controller) => SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: CustomAppBar(
            title: LocalStrings.str_session_detail_title.tr,
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
                                    Text('${controller.eventSessionDetailModel.data?.sessionName!.capitalize ?? ''} ',
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
                                image: MyImages.layers),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 15.0),
                                child: CardColumn(
                                    header: LocalStrings.str_session_detail_lbl_session_type.tr,
                                    body: controller.eventSessionDetailModel.data?.sessionType ?? ""),
                              ),
                            ),
                          ],
                        ),
                        const CustomDivider(space: Dimensions.space15),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleShapeImage(imageColor: Theme.of(context).appBarTheme.backgroundColor,
                                image: MyImages.clock),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 15.0),
                                child: CardColumn(
                                    header: LocalStrings.str_session_detail_lbl_start_time.tr,
                                    body: controller.eventSessionDetailModel.data?.startTime ?? ""),
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
                                image: MyImages.repeat),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 15.0),
                                child: CardColumn(
                                    header: LocalStrings.str_session_detail_lbl_session_duration.tr,
                                    body: controller.eventSessionDetailModel.data?.duration ?? ""),
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
                                image: MyImages.company),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 15.0),
                                child: CardColumn(
                                    header: LocalStrings.str_session_detail_lbl_session_hall.tr,
                                    body: controller.eventSessionDetailModel.data?.hall ?? ""),
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
                                            child: Text(LocalStrings.str_session_detail_lbl_session_description.tr, style: primaryTextStyle(color: white, size: 12)),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: Dimensions.space5),

                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                              child: HtmlWidget(
                                                controller.eventSessionDetailModel.data?.sessionDescription ?? "",
                                                textStyle: regularDefault,
                                              ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: Dimensions.space5),
                                    ],
                                  )),
                            ),
                          ),
                        ),
                        const CustomDivider(space: Dimensions.space15),
                        //Speaker Listing
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                          child: controller.speakerList.isNotEmpty
                              ? ListView.separated(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              controller: ScrollController(),
                              padding: EdgeInsets.only(top: 1),
                              //just add this line,
                              itemBuilder: (context, index) {
                                final item = controller.speakerList[index];
                                return SessionSpeakerCard(
                                  speakerModel: item,
                                  sessionId: sessionId,
                                );
                              },
                              separatorBuilder: (context, index) =>
                              const SizedBox(height: Dimensions.space10),
                              itemCount: controller.speakerList.length)
                              : const NoDataWidget(title: LocalStrings.str_speaker_no_speaker,
                            image: MyImages.noSpeaker),
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
