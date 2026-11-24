
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:ipc_delegates/core/helper/shared_preference_helper.dart';
import 'package:ipc_delegates/core/utils/images.dart';
import 'package:ipc_delegates/core/utils/local_strings.dart';
import 'package:ipc_delegates/data/controller/enquiry_us/enquiry_us_controller.dart';
import 'package:ipc_delegates/data/repo/enquiry_us/enquiry_us_repo.dart';
import 'package:ipc_delegates/data/services/api_service.dart';
import 'package:ipc_delegates/view/components/app-bar/custom_appbar.dart';
import 'package:ipc_delegates/view/components/custom_loader/custom_loader.dart';
import 'package:ipc_delegates/view/components/buttons/rounded_button.dart';
import 'package:ipc_delegates/view/components/dialog/warning_dialog.dart';
import 'package:ipc_delegates/view/components/text-form-field/custom_text_field.dart';

class EnquiryUsAddScreen extends StatefulWidget {
  const EnquiryUsAddScreen({super.key});

  @override
  State<EnquiryUsAddScreen> createState() => _EnquiryUsAddScreenState();
}

class _EnquiryUsAddScreenState extends State<EnquiryUsAddScreen> {
  final formKey = GlobalKey<FormState>();

  late EnquiryUsController controller;
  late EnquiryUsRepo enquiryUsRepo;

  String attendeeId = '';
  String eventId = '';

  final int maxMessageLength = 1000;

  @override
  void initState() {
    super.initState();

    if (!Get.isRegistered<ApiClient>()) {
      Get.put(ApiClient(sharedPreferences: Get.find()));
    }

    if (!Get.isRegistered<EnquiryUsRepo>()) {
      Get.put(EnquiryUsRepo(apiClient: Get.find()));
    }

    if (!Get.isRegistered<EnquiryUsController>()) {
      Get.put(EnquiryUsController(enquiryUsRepo: Get.find()));
    }

    controller = Get.find<EnquiryUsController>();
    enquiryUsRepo = Get.find<EnquiryUsRepo>();

    controller.isLoading = false;

    attendeeId = enquiryUsRepo.apiClient.sharedPreferences
        .getString(SharedPreferenceHelper.attendeeId) ??
        '';

    eventId = enquiryUsRepo.apiClient.sharedPreferences
        .getString(SharedPreferenceHelper.eventId) ??
        '';
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GetBuilder<EnquiryUsController>(
      builder: (controller) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            appBar: CustomAppBar(
              title: LocalStrings.str_enquiry_us_title.tr,
              bgColor: theme.appBarTheme.backgroundColor ??
                  theme.colorScheme.surface,
            ),
            body: controller.isLoading
                ? const CustomLoader()
                : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(18, 20, 18, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 26),
                  _buildSectionTitle(context),
                  const SizedBox(height: 14),
                  _buildEnquiryForm(context, controller),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colors.primary,
            colors.primary.withValues(alpha: 0.78),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: colors.primary.withValues(alpha: 0.20),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 58,
                width: 58,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.25),
                  ),
                ),
                child: Center(
                  child: Image.asset(
                    MyImages.enquiry,
                    height: 34,
                    width: 34,
                    color: Colors.white,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.support_agent_rounded,
                      color: Colors.white,
                      size: 34,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.17),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.chat_bubble_outline_rounded,
                      color: Colors.white,
                      size: 15,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Support',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Text(
            LocalStrings.str_enquiry_us_title.tr,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 9),
          Text(
            LocalStrings.str_enquiry_us_title_des.tr,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.88),
              fontSize: 14,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 18),
          const Row(
            children: [
              Icon(
                Icons.verified_user_outlined,
                color: Colors.white,
                size: 17,
              ),
              SizedBox(width: 7),
              Text(
                'We are here to help you',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.edit_note_rounded,
            color: theme.colorScheme.primary,
            size: 25,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Write Your Message',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                'Describe your query or concern below',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.textTheme.bodySmall?.color
                      ?.withValues(alpha: 0.65),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEnquiryForm(
      BuildContext context,
      EnquiryUsController controller,
      ) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: 0.35),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: theme.brightness == Brightness.dark ? 0.08 : 0.035,
            ),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  LocalStrings.str_enquiry_us_lbl_enter_message.tr,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 4),
                const Text(
                  '*',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            CustomTextField(
              animatedLabel: true,
              needOutlineBorder: true,
              labelText:
              LocalStrings.str_enquiry_us_lbl_enter_message.tr,
              textInputType: TextInputType.multiline,
              maxLines: 8,
              focusNode: controller.messageFocusNode,
              controller: controller.messageController,
              inputAction: TextInputAction.newline,
              onChanged: (value) {
                setState(() {});
              },
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please Enter Message'.tr;
                }

                if (value.trim().length < 10) {
                  return 'Please enter at least 10 characters'.tr;
                }

                if (value.length > maxMessageLength) {
                  return 'Message cannot exceed 1000 characters'.tr;
                }

                return null;
              },
            ),

            const SizedBox(height: 8),

            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${controller.messageController.text.length}/$maxMessageLength',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: controller.messageController.text.length >
                      maxMessageLength
                      ? Colors.red
                      : theme.hintColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(height: 22),

            SizedBox(
              width: double.infinity,
              height: 54,
              child: RoundedButton(
                text: LocalStrings.str_enquiry_us_b_send_now.tr,
                press: () {
                  FocusScope.of(context).unfocus();

                  if (formKey.currentState!.validate()) {
                    const WarningAlertDialog().warningAlertDialog(
                      context,
                          () {
                        Get.back();
                        controller.addEnquiryUs(
                          context,
                          attendeeId,
                          eventId,
                        );
                      },
                      title: 'Confirm to',
                      image: MyImages.enquiry,
                      subTitle: 'Send Enquiry',
                    );
                  }
                },
              ),
            ),

            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 19,
                    color: colors.primary,
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Text(
                      'Please provide complete details so our support team can assist you better.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        height: 1.5,
                        color: theme.textTheme.bodyMedium?.color,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
