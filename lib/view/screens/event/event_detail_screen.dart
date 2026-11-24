
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';

import 'package:ipc_delegates/core/helper/shared_preference_helper.dart';
import 'package:ipc_delegates/core/utils/color_resources.dart';
import 'package:ipc_delegates/core/utils/images.dart';
import 'package:ipc_delegates/core/utils/local_strings.dart';
import 'package:ipc_delegates/core/utils/style.dart';
import 'package:ipc_delegates/data/controller/event/event_controller.dart';
import 'package:ipc_delegates/data/repo/event/event_repo.dart';
import 'package:ipc_delegates/data/services/api_service.dart';
import 'package:ipc_delegates/view/components/app-bar/custom_appbar.dart';
import 'package:ipc_delegates/view/components/custom_loader/custom_loader.dart';

class EventDetailScreen extends StatefulWidget {
  const EventDetailScreen({super.key});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  String eventId = '';

  late final EventController controller;

  @override
  void initState() {
    super.initState();

    final apiClient = Get.isRegistered<ApiClient>()
        ? Get.find<ApiClient>()
        : Get.put(ApiClient(sharedPreferences: Get.find()));

    final eventRepo = Get.isRegistered<EventRepo>()
        ? Get.find<EventRepo>()
        : Get.put(EventRepo(apiClient: apiClient));

    controller = Get.isRegistered<EventController>()
        ? Get.find<EventController>()
        : Get.put(EventController(eventRepo: eventRepo));

    controller.isLoading = true;

    eventId = apiClient.sharedPreferences
        .getString(SharedPreferenceHelper.eventId) ??
        '';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        controller.loadEventDetails(eventId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary =
        theme.appBarTheme.backgroundColor ?? ColorResources.primaryColor;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: LocalStrings.str_event_detail_lbl_title.tr,
        bgColor: primary,
      ),
      body: GetBuilder<EventController>(
        builder: (controller) {
          if (controller.isLoading) {
            return const CustomLoader();
          }

          final event = controller.eventDetailModel.eventData;
          final settings = controller.eventDetailModel.settingData;

          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildEventHeader(
                  context,
                  event?.eventName ?? '',
                  primary,
                ),

                const SizedBox(height: 22),

                _sectionTitle(
                  context,
                  'Event Schedule',
                  'Date and time of the event',
                ),

                const SizedBox(height: 14),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _scheduleCard(
                        context,
                        icon: Icons.calendar_month_rounded,
                        title: LocalStrings.eventFromDate.tr,
                        date: event?.eventFromDate ?? '--',
                        time: event?.eventFromTime ?? '--',
                        color: const Color(0xFF5286D8),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _scheduleCard(
                        context,
                        icon: Icons.event_available_rounded,
                        title: LocalStrings.eventToDate.tr,
                        date: event?.eventToDate ?? '--',
                        time: event?.eventToTime ?? '--',
                        color: const Color(0xFF25A582),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 22),

                _sectionTitle(
                  context,
                  'Event Venue',
                  'Location and venue information',
                ),

                const SizedBox(height: 14),

                _buildLocationCard(
                  context,
                  event?.eventLocation ?? '',
                ),

                const SizedBox(height: 22),

                _sectionTitle(
                  context,
                  'About The Event',
                  'Event information and description',
                ),

                const SizedBox(height: 14),

                _buildDescriptionCard(
                  context,
                  event?.eventDescription ?? '',
                ),

                const SizedBox(height: 22),

                _sectionTitle(
                  context,
                  'Organizer Information',
                  'Contact details of the organizing institution',
                ),

                const SizedBox(height: 14),

                _buildOrganizationCard(
                  context,
                  settings?.organizationName ?? '',
                  settings?.organizationEmail ?? '',
                  primary,
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  // ---------------------------------------------------------
  // EVENT HEADER
  // ---------------------------------------------------------

  Widget _buildEventHeader(
      BuildContext context,
      String eventName,
      Color primary,
      ) {
    final theme = Theme.of(context);

    final name = eventName.trim().isEmpty
        ? 'Event Details'
        : (eventName.trim().capitalize ?? eventName.trim());

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primary,
            primary.withValues(alpha: 0.78),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.22),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.25),
              ),
            ),
            child: const Icon(
              Icons.event_rounded,
              color: Colors.white,
              size: 27,
            ),
          ),

          const SizedBox(height: 20),

          Text(
            'WELCOME TO',
            style: TextStyle(
              fontSize: 10,
              letterSpacing: 2,
              fontWeight: FontWeight.w700,
              color: Colors.white.withValues(alpha: 0.75),
            ),
          ),

          const SizedBox(height: 8),

          Text(
            name,
            style: const TextStyle(
              fontSize: 23,
              height: 1.3,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.17),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.verified_rounded,
                  color: Colors.white,
                  size: 15,
                ),
                const SizedBox(width: 7),
                Text(
                  'Official Event Information',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.95),
                    fontSize: 11,
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

  // ---------------------------------------------------------
  // SECTION TITLE
  // ---------------------------------------------------------

  Widget _sectionTitle(
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
            fontSize: 18,
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
  // SCHEDULE CARD
  // ---------------------------------------------------------

  Widget _scheduleCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String date,
        required String time,
        required Color color,
      }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: _cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              icon,
              color: color,
              size: 22,
            ),
          ),

          const SizedBox(height: 14),

          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              color: theme.hintColor,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            date,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: theme.textTheme.bodyLarge?.color,
            ),
          ),

          const SizedBox(height: 9),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 9,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.09),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.access_time_rounded,
                  size: 13,
                  color: color,
                ),
                const SizedBox(width: 5),
                Flexible(
                  child: Text(
                    time,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // LOCATION CARD
  // ---------------------------------------------------------

  Widget _buildLocationCard(
      BuildContext context,
      String location,
      ) {
    final theme = Theme.of(context);
    const color = Color(0xFFE36C78);

    return Container(
      padding: const EdgeInsets.all(17),
      decoration: _cardDecoration(context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.location_on_rounded,
              color: color,
              size: 25,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocalStrings.eventLocation.tr,
                  style: TextStyle(
                    fontSize: 11,
                    color: theme.hintColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  location.trim().isEmpty ? '--' : location,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    fontWeight: FontWeight.w700,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // DESCRIPTION CARD
  // ---------------------------------------------------------

  Widget _buildDescriptionCard(
      BuildContext context,
      String description,
      ) {
    final theme = Theme.of(context);
    final primary = ColorResources.primaryColor;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: _cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                  Icons.description_rounded,
                  color: primary,
                  size: 22,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  LocalStrings.eventDescription.tr,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Divider(
            color: theme.dividerColor.withValues(alpha: 0.6),
            height: 1,
          ),

          const SizedBox(height: 14),

          if (description.trim().isEmpty)
            Text(
              'No description available.',
              style: TextStyle(
                fontSize: 13,
                color: theme.hintColor,
              ),
            )
          else
            HtmlWidget(
              description,
              textStyle: TextStyle(
                fontSize: 13,
                height: 1.6,
                color: theme.textTheme.bodyMedium?.color,
              ),
            ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // ORGANIZATION CARD
  // ---------------------------------------------------------

  Widget _buildOrganizationCard(
      BuildContext context,
      String organizationName,
      String organizationEmail,
      Color primary,
      ) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(context),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.apartment_rounded,
                  color: primary,
                  size: 24,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocalStrings.organizationName.tr,
                      style: TextStyle(
                        fontSize: 11,
                        color: theme.hintColor,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      organizationName.trim().isEmpty
                          ? '--'
                          : organizationName,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Divider(
              height: 1,
              color: theme.dividerColor,
            ),
          ),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFF32A58B)
                      .withValues(alpha: 0.11),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.email_rounded,
                  color: Color(0xFF32A58B),
                  size: 21,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocalStrings.organizationEmail.tr,
                      style: TextStyle(
                        fontSize: 11,
                        color: theme.hintColor,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      organizationEmail.trim().isEmpty
                          ? '--'
                          : organizationEmail,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
          blurRadius: 15,
          offset: const Offset(0, 5),
        ),
      ],
    );
  }
}
