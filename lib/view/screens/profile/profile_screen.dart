
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:ipc_delegates/core/helper/shared_preference_helper.dart';
import 'package:ipc_delegates/core/utils/color_resources.dart';
import 'package:ipc_delegates/core/utils/images.dart';
import 'package:ipc_delegates/core/utils/local_strings.dart';
import 'package:ipc_delegates/core/utils/url_container.dart';
import 'package:ipc_delegates/data/controller/profile/profile_controller.dart';
import 'package:ipc_delegates/data/repo/profile/profile_repo.dart';
import 'package:ipc_delegates/data/services/api_service.dart';
import 'package:ipc_delegates/view/components/app-bar/custom_appbar.dart';
import 'package:ipc_delegates/view/components/circle_image_button.dart';
import 'package:ipc_delegates/view/components/custom_loader/custom_loader.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String attendeeId = '';
  String eventId = '';

  late final ProfileController controller;

  int activeIndex = 0;

  @override
  void initState() {
    super.initState();

    final apiClient = Get.isRegistered<ApiClient>()
        ? Get.find<ApiClient>()
        : Get.put(ApiClient(sharedPreferences: Get.find()));

    final profileRepo = Get.isRegistered<ProfileRepo>()
        ? Get.find<ProfileRepo>()
        : Get.put(ProfileRepo(apiClient: apiClient));

    controller = Get.isRegistered<ProfileController>()
        ? Get.find<ProfileController>()
        : Get.put(ProfileController(profileRepo: profileRepo));

    controller.isLoading = true;

    final prefs = apiClient.sharedPreferences;

    attendeeId =
        prefs.getString(SharedPreferenceHelper.attendeeId) ?? '';

    eventId =
        prefs.getString(SharedPreferenceHelper.eventId) ?? '';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        controller.loadAttendeeDetails(attendeeId, eventId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.appBarTheme.backgroundColor ??
        ColorResources.primaryColor;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: LocalStrings.profile.tr,
        bgColor: primary,
      ),
      body: GetBuilder<ProfileController>(
        builder: (controller) {
          if (controller.isLoading) {
            return const CustomLoader();
          }

          return RefreshIndicator(
            color: primary,
            onRefresh: () async {
              await controller.loadAttendeeDetails(
                attendeeId,
                eventId,
              );
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  _buildProfileHeader(context, controller, primary),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 22, 16, 35),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildStatusCards(context, controller),

                        const SizedBox(height: 26),

                        _buildSectionHeading(
                          context,
                          'Profile Information',
                          'Your registered attendee details',
                        ),

                        const SizedBox(height: 14),

                        _buildTabs(context),

                        const SizedBox(height: 18),

                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          switchInCurve: Curves.easeOut,
                          switchOutCurve: Curves.easeIn,
                          child: activeIndex == 0
                              ? _buildAttendeeDetails(
                            context,
                            controller,
                            key: const ValueKey('details'),
                          )
                              : _buildCheckInActivity(
                            context,
                            controller,
                            key: const ValueKey('activity'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ---------------------------------------------------------
  // PROFILE HEADER
  // ---------------------------------------------------------

  Widget _buildProfileHeader(
      BuildContext context,
      ProfileController controller,
      Color primary,
      ) {
    final data = controller.profileModel.data;

    final name = (data?.attendeeName ?? '').toString().trim();
    final regNo =
    (data?.registrationNumber ?? '').toString().trim();

    final photoUrl =
        '${UrlContainer.profileImgUrl}${data?.attendeePhoto ?? ''}';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primary,
            primary.withValues(alpha: 0.82),
          ],
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
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.55),
                width: 2,
              ),
            ),
            child: Container(
              height: 112,
              width: 112,
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: CircleImageWidget(
                  isProfile: true,
                  imagePath: photoUrl,
                  height: 104,
                  width: 104,
                  isAsset: false,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          Text(
            name.isEmpty ? 'Attendee' : name.capitalize!,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: 0.2,
            ),
          ),

          if (regNo.isNotEmpty) ...[
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 9,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.17),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.confirmation_number_rounded,
                    color: Colors.white,
                    size: 17,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      regNo,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 14),

          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.verified_rounded,
                size: 15,
                color: Colors.white,
              ),
              const SizedBox(width: 6),
              Text(
                'Registered Attendee',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.9),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // STATUS CARDS
  // ---------------------------------------------------------

  Widget _buildStatusCards(
      BuildContext context,
      ProfileController controller,
      ) {
    final checkIn = controller.profileModel.checkInData;

    final statusColor = controller.statusColor as Color;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _statusCard(
            context,
            icon: Icons.how_to_reg_rounded,
            title: 'Check-In Status',
            value: controller.status.toString(),
            color: statusColor,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: _statusCard(
            context,
            icon: Icons.card_giftcard_rounded,
            title: 'Welcome Kit',
            value: '${checkIn?.welcomeKitProvide ?? 'Not Yet'}',
            subtitle: '${checkIn?.welcomeKitDate ?? '--'}',
            color: const Color(0xFF6676C8),
          ),
        ),
      ],
    );
  }

  Widget _statusCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String value,
        required Color color,
        String? subtitle,
      }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: 0.16),
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.07),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              icon,
              color: color,
              size: 21,
            ),
          ),

          const SizedBox(height: 13),

          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              color: theme.hintColor,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),

          if (subtitle != null) ...[
            const SizedBox(height: 7),
            Row(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  size: 11,
                  color: theme.hintColor,
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10,
                      color: theme.hintColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // SECTION HEADING
  // ---------------------------------------------------------

  Widget _buildSectionHeading(
      BuildContext context,
      String title,
      String subtitle,
      ) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w800,
            color: theme.textTheme.bodyLarge?.color,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: theme.hintColor,
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------
  // MODERN TABS
  // ---------------------------------------------------------

  Widget _buildTabs(BuildContext context) {
    final theme = Theme.of(context);
    final primary = ColorResources.primaryColor;

    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          _tabItem(
            context,
            index: 0,
            title: 'Personal Details',
            icon: Icons.person_outline_rounded,
            primary: primary,
          ),
          _tabItem(
            context,
            index: 1,
            title: 'Check-In Activity',
            icon: Icons.history_rounded,
            primary: primary,
          ),
        ],
      ),
    );
  }

  Widget _tabItem(
      BuildContext context, {
        required int index,
        required String title,
        required IconData icon,
        required Color primary,
      }) {
    final selected = activeIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            activeIndex = index;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(
            vertical: 13,
            horizontal: 5,
          ),
          decoration: BoxDecoration(
            color: selected
                ? primary
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 17,
                color: selected
                    ? Colors.white
                    : Theme.of(context).hintColor,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: selected
                        ? Colors.white
                        : Theme.of(context).hintColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // ATTENDEE DETAILS
  // ---------------------------------------------------------

  Widget _buildAttendeeDetails(
      BuildContext context,
      ProfileController controller, {
        Key? key,
      }) {
    final d = controller.profileModel.data;
    final accent = ColorResources.primaryColor;

    final rows = <_InfoItem>[
      _InfoItem(
        Icons.confirmation_number_rounded,
        const Color(0xFF6476D5),
        LocalStrings.registration_number.tr,
        d?.registrationNumber,
      ),
      _InfoItem(
        Icons.email_rounded,
        const Color(0xFFE46B78),
        LocalStrings.attendee_email.tr,
        d?.emailId,
      ),
      _InfoItem(
        Icons.phone_rounded,
        const Color(0xFF32A58B),
        LocalStrings.attendee_mobile.tr,
        d?.mobile,
      ),
      _InfoItem(
        Icons.category_rounded,
        const Color(0xFFE3A343),
        LocalStrings.categories.tr,
        d?.categories,
      ),
      _InfoItem(
        Icons.business_rounded,
        const Color(0xFF558ACB),
        LocalStrings.organization.tr,
        d?.affiliation,
      ),
      _InfoItem(
        Icons.map_rounded,
        const Color(0xFF9A72C5),
        LocalStrings.state.tr,
        d?.state,
      ),
      _InfoItem(
        Icons.location_on_rounded,
        accent,
        LocalStrings.attendee_address.tr,
        d?.address1,
      ),
    ];

    return Column(
      key: key,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: _cardDecoration(context),
          child: Column(
            children: [
              for (int i = 0; i < rows.length; i++) ...[
                _buildInfoRow(context, rows[i]),

                if (i != rows.length - 1)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Divider(
                      height: 1,
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
              ],
            ],
          ),
        ),

        const SizedBox(height: 18),

        _buildQrCard(context, d?.qrCode),
      ],
    );
  }

  // ---------------------------------------------------------
  // INFORMATION ROW
  // ---------------------------------------------------------

  Widget _buildInfoRow(
      BuildContext context,
      _InfoItem item,
      ) {
    final theme = Theme.of(context);
    final value = (item.value ?? '').toString().trim();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 43,
          width: 43,
          decoration: BoxDecoration(
            color: item.color.withValues(alpha: 0.11),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(
            item.icon,
            color: item.color,
            size: 21,
          ),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: TextStyle(
                  fontSize: 11,
                  color: theme.hintColor,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                value.isEmpty ? '-' : value,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.4,
                  fontWeight: FontWeight.w700,
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------
  // QR CODE CARD
  // ---------------------------------------------------------

  Widget _buildQrCard(
      BuildContext context,
      String? qrCode,
      ) {
    final theme = Theme.of(context);
    final primary = ColorResources.primaryColor;

    final qrUrl =
        '${UrlContainer.profileImgUrl}${qrCode ?? ''}';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(context),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  Icons.qr_code_2_rounded,
                  color: primary,
                  size: 25,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocalStrings.str_profile_lbl_qr_code.tr,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Your event identification QR code',
                      style: TextStyle(
                        fontSize: 11,
                        color: theme.hintColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.grey.withValues(alpha: 0.2),
              ),
            ),
            child: CachedNetworkImage(
              imageUrl: qrUrl,
              height: 190,
              width: 190,
              fit: BoxFit.contain,
              placeholder: (_, __) => const SizedBox(
                height: 190,
                width: 190,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              errorWidget: (_, __, ___) => Image.asset(
                MyImages.appLogos,
                height: 190,
                width: 190,
              ),
            ),
          ),

          const SizedBox(height: 14),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.verified_user_rounded,
                size: 15,
                color: Colors.green.shade600,
              ),
              const SizedBox(width: 6),
              Text(
                'Keep this QR code ready for scanning',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  color: theme.hintColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // CHECK-IN ACTIVITY
  // ---------------------------------------------------------

  Widget _buildCheckInActivity(
      BuildContext context,
      ProfileController controller, {
        Key? key,
      }) {
    final checkIn = controller.profileModel.checkInData;

    return Container(
      key: key,
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeading(
            context,
            'Event Timeline',
            'Your event entry and exit information',
          ),

          const SizedBox(height: 25),

          _activityItem(
            context,
            icon: Icons.login_rounded,
            color: const Color(0xFF27A77B),
            title: 'Event Check-In',
            date: '${checkIn?.eventInDate ?? '--'}',
            time: '${checkIn?.eventInTime ?? '--'}',
            isLast: false,
          ),

          _activityItem(
            context,
            icon: Icons.logout_rounded,
            color: const Color(0xFFE36B75),
            title: 'Event Check-Out',
            date: '${checkIn?.eventOutDate ?? '--'}',
            time: '${checkIn?.eventOutTime ?? '--'}',
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _activityItem(
      BuildContext context, {
        required IconData icon,
        required Color color,
        required String title,
        required String date,
        required String time,
        required bool isLast,
      }) {
    final theme = Theme.of(context);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 44,
            child: Column(
              children: [
                Container(
                  height: 42,
                  width: 42,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 21,
                  ),
                ),

                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      color: theme.dividerColor,
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 26),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                  ),

                  const SizedBox(height: 9),

                  Row(
                    children: [
                      Icon(
                        Icons.calendar_month_rounded,
                        size: 14,
                        color: theme.hintColor,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          date,
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.hintColor,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 14,
                        color: theme.hintColor,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        time,
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.hintColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // COMMON CARD DECORATION
  // ---------------------------------------------------------

  BoxDecoration _cardDecoration(BuildContext context) {
    final theme = Theme.of(context);

    return BoxDecoration(
      color: theme.cardColor,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: theme.dividerColor.withValues(alpha: 0.35),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(
            alpha: theme.brightness == Brightness.dark ? 0.10 : 0.035,
          ),
          blurRadius: 16,
          offset: const Offset(0, 5),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------
// INFORMATION MODEL
// ---------------------------------------------------------

class _InfoItem {
  final IconData icon;
  final Color color;
  final String title;
  final String? value;

  const _InfoItem(
      this.icon,
      this.color,
      this.title,
      this.value,
      );
}
