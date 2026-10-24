import 'package:ipc_delegates/core/utils/images.dart';
import 'package:ipc_delegates/core/utils/local_strings.dart';
import 'package:ipc_delegates/core/utils/style.dart';
import 'package:ipc_delegates/core/utils/url_container.dart';
import 'package:ipc_delegates/data/controller/speaker/speaker_controller.dart';
import 'package:ipc_delegates/data/repo/speaker/speaker_repo.dart';
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



class SpeakerDetailScreen extends StatefulWidget
{
  const SpeakerDetailScreen({super.key, required this.id});

  final String id;

  @override
  State<SpeakerDetailScreen> createState() => _SpeakerDetailScreenState();
}

class _SpeakerDetailScreenState extends State<SpeakerDetailScreen>
{
  String speakerId = "";
  String eventId = "";
  late final controller;
  late SpeakerRepo speakerRepo;

  @override
  void initState()
  {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(SpeakerRepo(apiClient: Get.find()));
    controller = Get.put(SpeakerController(speakerRepo: Get.find()));
    speakerRepo = Get.put(SpeakerRepo(apiClient: Get.find()));
    controller.isLoading = true;
    super.initState();

    speakerId = widget.id;
    eventId = speakerRepo.apiClient.sharedPreferences.getString(SharedPreferenceHelper.eventId)!;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.loadSpeakerDetails(speakerId, eventId);
    });

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context)
  {
    return GetBuilder<SpeakerController>(
      builder: (controller) => SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: CustomAppBar(
            title: LocalStrings.str_speaker_detail_title.tr,
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
                        horizontal: Dimensions.space15),
                    decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(15)),
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
                                '${UrlContainer.profileImgUrl}${controller.speakerDetailModel.speakerData!.speakerImage ?? ''}',
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
                                      '${controller.speakerDetailModel.speakerData?.speakerName!.capitalize ?? ''} ',
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

                        Card(
                          margin: EdgeInsets.zero,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                border: Border(
                                  left: BorderSide(
                                    width: 8.0,
                                    color: ColorResources.primaryColor,
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
                                            child: Text(LocalStrings.str_speaker_detail_speaker_email.tr, style: primaryTextStyle(color: white, size: 12)),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: Dimensions.space5),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              controller.speakerDetailModel.speakerData?.speakerEmail ?? "",
                                              style: regularDefault,
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
                                    width: 8.0,
                                    color: ColorResources.primaryColor,
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
                                              borderRadius: BorderRadius.only(
                                                  bottomRight: Radius.circular(16.0),
                                                  topRight: Radius.circular(16.0)),
                                            ),
                                            padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
                                            child: Text(LocalStrings
                                                .str_speaker_detail_designation
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
                                            child: Text(
                                              controller.speakerDetailModel.speakerData?.designation ?? "",
                                              style: regularDefault,
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
                                    width: 8.0,
                                    color: ColorResources.primaryColor,
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
                                              borderRadius: BorderRadius.only(
                                                  bottomRight: Radius.circular(16.0),
                                                  topRight: Radius.circular(16.0)),
                                            ),
                                            padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
                                            child: Text(LocalStrings
                                                .str_speaker_detail_company_name
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
                                            child: Text(
                                              controller.speakerDetailModel.speakerData?.companyName ?? "",
                                              style: regularDefault,
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
                                    width: 8.0,
                                    color: ColorResources.primaryColor,
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
                                              borderRadius: BorderRadius.only(
                                                  bottomRight: Radius.circular(16.0),
                                                  topRight: Radius.circular(16.0)),
                                            ),
                                            padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
                                            child: Text(LocalStrings
                                                .str_speaker_detail_country
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
                                            child: Text(
                                              controller.speakerDetailModel.speakerData?.country ?? "",
                                              style: regularDefault,
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
                                    width: 8.0,
                                    color: ColorResources.primaryColor,
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
                                              borderRadius: BorderRadius.only(
                                                  bottomRight: Radius.circular(16.0),
                                                  topRight: Radius.circular(16.0)),
                                            ),
                                            padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
                                            child: Text(LocalStrings
                                                .str_speaker_detail_speaker_description
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
                                              controller.speakerDetailModel.speakerData?.description ?? "",
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
