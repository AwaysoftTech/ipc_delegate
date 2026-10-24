import 'package:ipc_delegates/core/helper/date_converter.dart';
import 'package:ipc_delegates/core/route/route.dart';
import 'package:ipc_delegates/core/utils/color_resources.dart';
import 'package:ipc_delegates/core/utils/dimensions.dart';
import 'package:ipc_delegates/core/utils/local_strings.dart';
import 'package:ipc_delegates/core/utils/style.dart';
import 'package:ipc_delegates/data/model/speaker/speaker_model.dart';
import 'package:ipc_delegates/view/components/divider/custom_divider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:ipc_delegates/core/utils/util.dart';
import 'package:ipc_delegates/core/utils/images.dart';
import 'package:ipc_delegates/view/components/buttons/card_button.dart';
import 'package:ipc_delegates/view/components/image/circle_shape_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ipc_delegates/core/utils/url_container.dart';
import 'package:ipc_delegates/view/components/divider/custom_divider.dart';
import 'package:ipc_delegates/view/screens/session_quiz/session_quiz_add_screen.dart';
import 'package:ipc_delegates/view/components/circle_image_button.dart';


class SessionSpeakerCard extends StatelessWidget {
  const SessionSpeakerCard({
    super.key,
    required this.speakerModel,
    required this.sessionId,
  });
  final SpeakerData speakerModel;
  final String sessionId;

  @override
  Widget build(BuildContext context)
  {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: Container(
        margin: EdgeInsets.zero,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 70,
                  width: 70,
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
                    imagePath: '${UrlContainer.profileImgUrl}${speakerModel.speakerImage ?? ""}',
                    height: 60,
                    width: 60,
                    isAsset: false,
                  ),
                ),
                12.width,
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(speakerModel.speakerName ?? "",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: ColorResources.primaryColor
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              LocalStrings.str_session_detail_lbl_speaker,
                              style: TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
            12.height,
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: ()
                    {
                      String speakerId = speakerModel.speakerId ?? "";
                      Get.toNamed(RouteHelper.speakerDetailScreen, arguments: speakerId);
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(LocalStrings.str_session_detail_lbl_more_about, style: TextStyle(fontSize: 12, color: Colors.black)),
                  ),
                ),
                10.width,
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      String speakerId = speakerModel.speakerId ?? "";
                      Get.to(() => SessionQuizAddScreen(arguments: {'speaker_id': speakerId, 'session_id': sessionId}));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorResources.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(LocalStrings.str_session_detail_lbl_ask_quiz_now, style: TextStyle(fontSize: 12, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
