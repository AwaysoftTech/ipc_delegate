import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:ipc_delegates/core/helper/shared_preference_helper.dart';
import 'package:ipc_delegates/core/utils/color_resources.dart';
import 'package:ipc_delegates/core/utils/local_strings.dart';
import 'package:ipc_delegates/core/utils/style.dart';
import 'package:ipc_delegates/core/utils/url_container.dart';
import 'package:ipc_delegates/data/controller/speaker/speaker_controller.dart';
import 'package:ipc_delegates/data/repo/speaker/speaker_repo.dart';
import 'package:ipc_delegates/data/services/api_service.dart';
import 'package:ipc_delegates/view/components/app-bar/custom_appbar.dart';
import 'package:ipc_delegates/view/components/circle_image_button.dart';
import 'package:ipc_delegates/view/components/custom_loader/custom_loader.dart';

class SpeakerDetailScreen extends StatefulWidget {
  const SpeakerDetailScreen({super.key, required this.id});

  final String id;

  @override
  State<SpeakerDetailScreen> createState() => _SpeakerDetailScreenState();
}

class _SpeakerDetailScreenState extends State<SpeakerDetailScreen> {
  String speakerId = "";
  String eventId = "";
  late final SpeakerController controller;
  late SpeakerRepo speakerRepo;

  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(SpeakerRepo(apiClient: Get.find()));
    controller = Get.put(SpeakerController(speakerRepo: Get.find()));
    speakerRepo = Get.put(SpeakerRepo(apiClient: Get.find()));
    controller.isLoading = true;
    super.initState();

    speakerId = widget.id;
    eventId = speakerRepo.apiClient.sharedPreferences
        .getString(SharedPreferenceHelper.eventId) ??
        '';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadSpeakerDetails(speakerId, eventId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SpeakerController>(
      builder: (controller) {
        final data = controller.speakerDetailModel.speakerData;
        final appBarColor = Theme.of(context).appBarTheme.backgroundColor ??
            ColorResources.primaryColor;

        return SafeArea(
          child: Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: CustomAppBar(
              title: LocalStrings.str_speaker_detail_title.tr,
              bgColor: appBarColor,
            ),
            body: controller.isLoading
                ? const CustomLoader()
                : SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(context, appBarColor, data),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _infoCard(
                          context,
                          icon: Icons.email_rounded,
                          color: ColorResources.redColor,
                          title: LocalStrings
                              .str_speaker_detail_speaker_email.tr,
                          value: data?.speakerEmail,
                        ),
                        const SizedBox(height: 12),
                        _infoCard(
                          context,
                          icon: Icons.work_rounded,
                          color: ColorResources.blueColor,
                          title: LocalStrings
                              .str_speaker_detail_designation.tr,
                          value: data?.designation,
                        ),
                        const SizedBox(height: 12),
                        _infoCard(
                          context,
                          icon: Icons.business_rounded,
                          color: ColorResources.yellowColor,
                          title: LocalStrings
                              .str_speaker_detail_company_name.tr,
                          value: data?.companyName,
                        ),
                        const SizedBox(height: 12),
                        _infoCard(
                          context,
                          icon: Icons.public_rounded,
                          color: ColorResources.colorGreen,
                          title:
                          LocalStrings.str_speaker_detail_country.tr,
                          value: data?.country,
                        ),
                        const SizedBox(height: 20),
                        _buildAbout(context, data?.description),
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
  Widget _buildHeader(BuildContext context, Color appBarColor, dynamic data) {
    final name = ((data?.speakerName ?? '') as String).trim();
    final designation = ((data?.designation ?? '') as String).trim();
    final company = ((data?.companyName ?? '') as String).trim();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
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
        children: [
          Container(
            height: 116,
            width: 116,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.18),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: CircleImageWidget(
              isProfile: true,
              imagePath:
              '${UrlContainer.profileImgUrl}${data?.speakerImage ?? ''}',
              height: 104,
              width: 104,
              isAsset: false,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            name.capitalize ?? name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          if (designation.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              designation,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 14,
              ),
            ),
          ],
          if (company.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.business_rounded,
                      size: 14, color: Colors.white),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      company,
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
          ],
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
                Text(
                  title,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 3),
                Text(
                  text.isEmpty ? '-' : text,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------------- About
  Widget _buildAbout(BuildContext context, String? description) {
    final html = (description ?? '').trim();
    if (html.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                  LocalStrings.str_speaker_detail_speaker_description.tr,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          HtmlWidget(html, textStyle: regularDefault),
        ],
      ),
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