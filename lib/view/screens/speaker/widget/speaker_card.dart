import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ipc_delegates/core/route/route.dart';
import 'package:ipc_delegates/core/utils/color_resources.dart';
import 'package:ipc_delegates/core/utils/local_strings.dart';
import 'package:ipc_delegates/core/utils/url_container.dart';
import 'package:ipc_delegates/data/model/speaker/speaker_model.dart';
import 'package:ipc_delegates/view/components/circle_image_button.dart';

class SpeakerCard extends StatelessWidget {
  const SpeakerCard({
    super.key,
    required this.speakerModel,
  });

  final SpeakerData speakerModel;

  @override
  Widget build(BuildContext context) {
    final primary = ColorResources.primaryColor;

    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            final speakerId = speakerModel.speakerId;
            if (speakerId == null) return;
            Get.toNamed(RouteHelper.speakerDetailScreen, arguments: speakerId);
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Avatar with soft ring
                Container(
                  height: 84,
                  width: 84,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: primary.withValues(alpha: 0.08),
                    border: Border.all(
                      width: 2,
                      color: primary.withValues(alpha: 0.35),
                    ),
                  ),
                  child: CircleImageWidget(
                    isProfile: true,
                    imagePath:
                    '${UrlContainer.profileImgUrl}${speakerModel.speakerImage ?? ''}',
                    height: 72,
                    width: 72,
                    isAsset: false,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  (speakerModel.speakerName ?? '').toString().trim(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  (speakerModel.designation ?? '').toString().trim(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 10),
                // View profile pill
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: ColorResources.blueGreyColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          LocalStrings.str_speaker_view_profile.tr,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 2),
                      const Icon(Icons.chevron_right_rounded,
                          size: 14, color: Colors.white),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}