import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ipc_delegates/core/route/route.dart';
import 'package:ipc_delegates/core/utils/color_resources.dart';
import 'package:ipc_delegates/core/utils/local_strings.dart';
import 'package:ipc_delegates/core/utils/url_container.dart';
import 'package:ipc_delegates/data/model/speaker/speaker_model.dart';
import 'package:ipc_delegates/view/components/circle_image_button.dart';
import 'package:ipc_delegates/view/screens/session_quiz/session_quiz_add_screen.dart';

class SessionSpeakerCard extends StatelessWidget {
  const SessionSpeakerCard({
    super.key,
    required this.speakerModel,
    required this.sessionId,
  });

  final SpeakerData speakerModel;
  final String sessionId;

  void _openSpeakerDetail() {
    final speakerId = speakerModel.speakerId ?? "";
    Get.toNamed(RouteHelper.speakerDetailScreen, arguments: speakerId);
  }

  void _openQuiz() {
    final speakerId = speakerModel.speakerId ?? "";
    Get.to(() => SessionQuizAddScreen(
        arguments: {'speaker_id': speakerId, 'session_id': sessionId}));
  }

  @override
  Widget build(BuildContext context) {
    final primary = ColorResources.primaryColor;
    final name = (speakerModel.speakerName ?? '').trim();

    return Container(
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
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tapping the top part opens speaker detail
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: _openSpeakerDetail,
              child: Row(
                children: [
                  Container(
                    height: 66,
                    width: 66,
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
                      '${UrlContainer.profileImgUrl}${speakerModel.speakerImage ?? ""}',
                      height: 56,
                      width: 56,
                      isAsset: false,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: primary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.record_voice_over_rounded,
                                  size: 13, color: primary),
                              const SizedBox(width: 5),
                              Flexible(
                                child: Text(
                                  LocalStrings.str_session_detail_lbl_speaker,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded, color: Colors.grey),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _openSpeakerDetail,
                    icon: const Icon(Icons.person_outline_rounded, size: 17),
                    label: Text(
                      LocalStrings.str_session_detail_lbl_more_about,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: primary,
                      side: BorderSide(color: primary.withValues(alpha: 0.5)),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _openQuiz,
                    icon: const Icon(Icons.question_answer_rounded, size: 17),
                    label: Text(
                      LocalStrings.str_session_detail_lbl_ask_quiz_now,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
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