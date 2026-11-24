import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ipc_delegates/core/helper/shared_preference_helper.dart';
import 'package:ipc_delegates/core/route/route.dart';
import 'package:ipc_delegates/core/utils/color_resources.dart';
import 'package:ipc_delegates/core/utils/dimensions.dart';
import 'package:ipc_delegates/core/utils/images.dart';
import 'package:ipc_delegates/core/utils/local_strings.dart';
import 'package:ipc_delegates/core/utils/notification/notification_service.dart';
import 'package:ipc_delegates/core/utils/url_container.dart';
import 'package:ipc_delegates/data/controller/dashboard/dashboard_controller.dart';
import 'package:ipc_delegates/data/repo/dashboard/dashboard_repo.dart';
import 'package:ipc_delegates/data/repo/profile/profile_repo.dart';
import 'package:ipc_delegates/data/services/api_service.dart';
import 'package:ipc_delegates/view/components/app-bar/action_button_icon_widget.dart';
import 'package:ipc_delegates/view/components/custom_loader/custom_loader.dart';
import 'package:ipc_delegates/view/components/dialog/app_update_dialog.dart';
import 'package:ipc_delegates/view/components/no_data.dart';
import 'package:ipc_delegates/view/components/will_pop_widget.dart';
import 'package:ipc_delegates/view/screens/dashboard/widget/drawer.dart';
import 'package:ipc_delegates/view/screens/event_session/event_session_screen.dart';
import 'package:ipc_delegates/view/screens/speaker/widget/speaker_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String attendeeName = "";
  String attendeePhoto = "";
  String attendeeEmailId = "";
  late final DashboardController controller;
  late ProfileRepo profileRepo;

  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(DashboardRepo(apiClient: Get.find()));
    controller = Get.put(DashboardController(dashboardRepo: Get.find()));
    profileRepo = Get.put(ProfileRepo(apiClient: Get.find()));
    controller.isLoading = true;

    super.initState();

    final prefs = profileRepo.apiClient.sharedPreferences;
    attendeeName = prefs.getString(SharedPreferenceHelper.attendeeName) ?? "";
    attendeePhoto = prefs.getString(SharedPreferenceHelper.attendeePhoto) ?? "";
    attendeeEmailId = prefs.getString(SharedPreferenceHelper.emailId) ?? "";

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initialData();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      NotificationService.init(context);
    }

    Future.delayed(const Duration(seconds: 3), () {
      if (!controller.isLoading && controller.dashboardModel.eventSettingData?.needUpdate == 'Yes' &&
          mounted) {
        showAppUpdateDialog(context,
            controller.dashboardModel.eventSettingData?.titleUpdate ?? "");
      }
    });

    return WillPopWidget(
      nextRoute: "",
      child: GetBuilder<DashboardController>(
        builder: (controller) => Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: _buildAppBar(context, controller),
          drawer: HomeDrawer(dashboardModel: controller.dashboardModel),
          body: controller.isLoading
              ? const CustomLoader()
              : RefreshIndicator(
            color: Theme.of(context).primaryColor,
            onRefresh: () async {
              await controller.initialData(shouldLoad: false);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  _buildHeader(context, controller),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildQuickStats(context, controller),
                        const SizedBox(height: 12),
                        _buildEventDayTile(context),
                        const SizedBox(height: 24),
                        _sectionHeader(
                          title: LocalStrings.eventSpeaker.tr,
                          onTap: () =>
                              Get.toNamed(RouteHelper.speakerScreen),
                        ),
                        const SizedBox(height: 12),
                        _buildSpeakers(controller),
                        const SizedBox(height: 24),
                        _sectionHeader(
                          title: LocalStrings.eventDetail.tr,
                          onTap: () =>
                              Get.toNamed(RouteHelper.eventDetailScreen),
                        ),
                        const SizedBox(height: 12),
                        _buildEventDetails(context, controller),
                        const SizedBox(height: 24),
                        _buildBottomActions(context),
                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------- AppBar
  PreferredSizeWidget _buildAppBar(
      BuildContext context, DashboardController controller) {
    return AppBar(
      toolbarHeight: 56,
      elevation: 0,
      centerTitle: true,
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu_rounded, size: 28, color: Colors.white),
          onPressed: () => WidgetsBinding.instance.addPostFrameCallback((_) {
            Scaffold.of(context).openDrawer();
          }),
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        ),
      ),
      title: CachedNetworkImage(
        imageUrl: '${UrlContainer.profileImgUrl}${controller.appLogo ?? ''}',
        height: 30,
        color: Colors.white,
        errorWidget: (_, __, ___) =>
            Image.asset(MyImages.appLogoFlat, height: 30),
        placeholder: (_, __) => Image.asset(MyImages.appLogo, height: 30),
      ),
      actions: [
        ActionButtonIconWidget(
          pressed: () => Get.toNamed(RouteHelper.notificationScreen),
          icon: Icons.notifications_none_rounded,
          size: 30,
          iconColor: Colors.white,
        ),
      ],
    );
  }

  // ---------------------------------------------------------------- Header
  /// Curved header: greeting + profile on top, event banner below.
  Widget _buildHeader(BuildContext context, DashboardController controller) {
    final appBarColor =
        Theme.of(context).appBarTheme.backgroundColor ?? ColorResources.primaryColor;
    final eventData = controller.dashboardModel.eventData;

    return Stack(
      children: [
        // Curved coloured background
        Container(
          height: 150,
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
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Column(
            children: [
              // Welcome row
              InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => Get.toNamed(RouteHelper.profileScreen),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          radius: 26,
                          backgroundColor: ColorResources.blueGreyColor,
                          child: ClipOval(
                            child: CachedNetworkImage(
                              imageUrl:
                              '${UrlContainer.profileImgUrl}$attendeePhoto',
                              width: 52,
                              height: 52,
                              fit: BoxFit.cover,
                              errorWidget: (_, __, ___) => Image.asset(
                                  MyImages.person,
                                  width: 52,
                                  height: 52),
                              placeholder: (_, __) => Image.asset(
                                  MyImages.person,
                                  width: 52,
                                  height: 52),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome back,',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withValues(alpha: 0.8),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              attendeeName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              attendeeEmailId,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Profile',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600)),
                            SizedBox(width: 2),
                            Icon(Icons.chevron_right_rounded,
                                size: 16, color: Colors.white),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Event banner
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl:
                      '${UrlContainer.profileImgUrl}${eventData?.eventThumbs ?? ''}',
                      height: 190,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => Image.asset(
                        MyImages.appLogos,
                        height: 190,
                        width: double.infinity,
                        fit: BoxFit.contain,
                      ),
                      placeholder: (_, __) => const SizedBox(
                        height: 190,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    ),
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.65),
                            ],
                            stops: const [0.45, 1],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 14,
                      right: 14,
                      bottom: 12,
                      child: Text(
                        eventData?.eventName ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ----------------------------------------------------------- Quick stats
  Widget _buildQuickStats(BuildContext context, DashboardController controller) {
    final widgets = controller.dashboardModel.widgetsData;
    return Row(
      children: [
        Expanded(
          child: _statTile(
            context,
            icon: Icons.location_city_rounded,
            color: ColorResources.redColor,
            value: '${widgets?.totalAreas ?? 0}',
            label: LocalStrings.totalAreas.tr,
            onTap: () => Get.toNamed(RouteHelper.eventAreaScreen),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _statTile(
            context,
            icon: Icons.record_voice_over_rounded,
            color: ColorResources.yellowColor,
            value: '${widgets?.totalSpeaker ?? 0}',
            label: LocalStrings.totalSpeaker.tr,
            onTap: () => Get.toNamed(RouteHelper.speakerScreen),
          ),
        ),
      ],
    );
  }

  Widget _statTile(
      BuildContext context, {
        required IconData icon,
        required Color color,
        required String value,
        required String label,
        required VoidCallback onTap,
      }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: _cardDecoration(context),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w800),
                  ),
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------------- Event day tile
  Widget _buildEventDayTile(BuildContext context) {
    final primary = ColorResources.primaryColor;
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => Get.to(() => EventSessionScreen(
          arguments: {'from': 'EventSession', 'from_id': ''})),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [primary, primary.withValues(alpha: 0.75)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.event_note_rounded,
                  color: Colors.white, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocalStrings.home_event_day.tr,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    LocalStrings.home_event_day_view,
                    style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_rounded, color: Colors.white),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------- Speakers
  Widget _buildSpeakers(DashboardController controller) {
    if (controller.speakerList.isEmpty) {
      return const NoDataWidget(
        text: LocalStrings.str_speaker_no_speaker,
        image: MyImages.noSpeaker,
      );
    }
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 210,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: controller.speakerList.length,
      itemBuilder: (context, index) =>
          SpeakerCard(speakerModel: controller.speakerList[index]),
    );
  }

  // -------------------------------------------------------- Event details
  Widget _buildEventDetails(
      BuildContext context, DashboardController controller) {
    final e = controller.dashboardModel.eventData;
    final accent =
        Theme.of(context).appBarTheme.backgroundColor ?? ColorResources.primaryColor;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(context),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: ColorResources.blueGreyColor,
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl:
                    '${UrlContainer.profileImgUrl}${e?.organizationLogo ?? ''}',
                    width: 52,
                    height: 52,
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) =>
                        Image.asset(MyImages.appLogos, width: 52, height: 52),
                    placeholder: (_, __) =>
                        Image.asset(MyImages.appLogos, width: 52, height: 52),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  e?.eventName ?? '',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: ColorResources.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Divider(height: 1),
          ),
          _infoRow(
            icon: Icons.calendar_month_rounded,
            color: accent,
            title: LocalStrings.eventFromDate.tr,
            value: '${e?.eventFromDate ?? ''} ${e?.eventFromTime ?? ''}',
          ),
          const SizedBox(height: 14),
          _infoRow(
            icon: Icons.event_available_rounded,
            color: accent,
            title: LocalStrings.eventToDate.tr,
            value: '${e?.eventToDate ?? ''} ${e?.eventToTime ?? ''}',
          ),
          const SizedBox(height: 14),
          _infoRow(
            icon: Icons.location_on_rounded,
            color: accent,
            title: LocalStrings.eventLocation.tr,
            value: '${e?.eventLocation ?? ''}',
          ),
        ],
      ),
    );
  }

  Widget _infoRow({
    required IconData icon,
    required Color color,
    required String title,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 20, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 2),
              Text(value,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }

  // --------------------------------------------------------- Bottom actions
  Widget _buildBottomActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _actionTile(
            context,
            icon: Icons.notifications_active_rounded,
            color: ColorResources.blueColor,
            title: LocalStrings.home_notification.tr,
            subtitle: 'View',
            onTap: () => Get.toNamed(RouteHelper.notificationScreen),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _actionTile(
            context,
            icon: Icons.chat_bubble_rounded,
            color: ColorResources.colorGreen,
            title: LocalStrings.home_enquiry,
            subtitle: 'Question',
            onTap: () => Get.toNamed(RouteHelper.enquiryUsAddScreen),
          ),
        ),
      ],
    );
  }

  Widget _actionTile(
      BuildContext context, {
        required IconData icon,
        required Color color,
        required String title,
        required String subtitle,
        required VoidCallback onTap,
      }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: _cardDecoration(context),
        child: Column(
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
            const SizedBox(height: 12),
            Text(title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w700)),
            const SizedBox(height: 2),
            Text(subtitle,
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------- Helpers
  Widget _sectionHeader({required String title, required VoidCallback onTap}) {
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
        const SizedBox(width: Dimensions.space5 + 3),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
          ),
        ),
        TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            minimumSize: const Size(0, 30),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                LocalStrings.home_view_more.tr,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: ColorResources.blueColor,
                ),
              ),
              Icon(Icons.chevron_right_rounded,
                  size: 18, color: ColorResources.blueColor),
            ],
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