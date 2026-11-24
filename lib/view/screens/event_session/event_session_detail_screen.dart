import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:ipc_delegates/core/helper/shared_preference_helper.dart';
import 'package:ipc_delegates/core/utils/color_resources.dart';
import 'package:ipc_delegates/core/utils/images.dart';
import 'package:ipc_delegates/core/utils/local_strings.dart';
import 'package:ipc_delegates/core/utils/style.dart';
import 'package:ipc_delegates/data/controller/event_session/event_session_controller.dart';
import 'package:ipc_delegates/data/repo/event_session/event_session_repo.dart';
import 'package:ipc_delegates/data/services/api_service.dart';
import 'package:ipc_delegates/view/components/app-bar/custom_appbar.dart';
import 'package:ipc_delegates/view/components/custom_loader/custom_loader.dart';
import 'package:ipc_delegates/view/components/no_data.dart';
import 'package:ipc_delegates/view/screens/speaker/widget/session_speaker_card.dart';

class EventSessionDetailScreen extends StatefulWidget {
  const EventSessionDetailScreen({super.key, required this.id});

  final String id;

  @override
  State<EventSessionDetailScreen> createState() =>
      _EventSessionDetailScreenState();
}

class _EventSessionDetailScreenState extends State<EventSessionDetailScreen> {
  String sessionId = "";
  String eventId = "";
  late final EventSessionController controller;
  late EventSessionRepo eventSessionRepo;

  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(EventSessionRepo(apiClient: Get.find()));
    controller = Get.put(EventSessionController(eventSessionRepo: Get.find()));
    eventSessionRepo = Get.put(EventSessionRepo(apiClient: Get.find()));
    controller.isLoading = true;
    super.initState();

    sessionId = widget.id;
    eventId = eventSessionRepo.apiClient.sharedPreferences
        .getString(SharedPreferenceHelper.eventId) ??
        '';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadSessionDetails(sessionId, eventId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EventSessionController>(
      builder: (controller) {
        final data = controller.eventSessionDetailModel.data;
        final appBarColor = Theme.of(context).appBarTheme.backgroundColor ??
            ColorResources.primaryColor;

        return SafeArea(
          child: Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: CustomAppBar(
              title: LocalStrings.str_session_detail_title.tr,
              bgColor: appBarColor,
            ),
            body: controller.isLoading
                ? const CustomLoader()
                : SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(appBarColor, data),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _infoCard(
                          context,
                          icon: Icons.schedule_rounded,
                          color: ColorResources.blueColor,
                          title: LocalStrings
                              .str_session_detail_lbl_start_time.tr,
                          value: data?.startTime,
                        ),
                        const SizedBox(height: 12),
                        _infoCard(
                          context,
                          icon: Icons.timelapse_rounded,
                          color: ColorResources.yellowColor,
                          title: LocalStrings
                              .str_session_detail_lbl_session_duration.tr,
                          value: data?.duration,
                        ),
                        const SizedBox(height: 12),
                        _infoCard(
                          context,
                          icon: Icons.meeting_room_rounded,
                          color: ColorResources.redColor,
                          title: LocalStrings
                              .str_session_detail_lbl_session_hall.tr,
                          value: data?.hall,
                        ),
                        const SizedBox(height: 20),
                        _buildDescription(
                            context, data?.sessionDescription),
                        const SizedBox(height: 24),
                        _buildSpeakers(controller),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------- Header
  Widget _buildHeader(Color appBarColor, dynamic data) {
    final name = ((data?.sessionName ?? '') as String).trim();
    final type = ((data?.sessionType ?? '') as String).trim();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [appBarColor, appBarColor.withValues(alpha: 0.85)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (type.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.layers_rounded,
                      size: 14, color: Colors.white),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      type,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (type.isNotEmpty) const SizedBox(height: 12),
          Text(
            name.capitalize ?? name,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------ Info card
  Widget _infoCard(
      BuildContext context, {
        required IconData icon,
        required Color color,
        required String title,
        required String? value,
      }) {
    final text = (value ?? '').trim();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 3),
                Text(
                  text.isEmpty ? '-' : text,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------- Description
  Widget _buildDescription(BuildContext context, String? description) {
    final html = (description ?? '').trim();
    if (html.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(LocalStrings.str_session_detail_lbl_session_description.tr),
          const SizedBox(height: 12),
          HtmlWidget(html, textStyle: regularDefault),
        ],
      ),
    );
  }

  // -------------------------------------------------------------- Speakers
  Widget _buildSpeakers(EventSessionController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(LocalStrings.eventSpeaker.tr),
        const SizedBox(height: 12),
        controller.speakerList.isNotEmpty
            ? ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: controller.speakerList.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) => SessionSpeakerCard(
            speakerModel: controller.speakerList[index],
            sessionId: sessionId,
          ),
        )
            : const NoDataWidget(
          text: LocalStrings.str_speaker_no_speaker,
          image: MyImages.noSpeaker,
        ),
      ],
    );
  }

  // --------------------------------------------------------------- Helpers
  Widget _sectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: ColorResources.secondaryColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
        ),
      ],
    );
  }

  BoxDecoration _cardDecoration(BuildContext context) {
    return BoxDecoration(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.06),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}