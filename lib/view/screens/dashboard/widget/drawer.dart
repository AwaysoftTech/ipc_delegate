import 'package:ipc_delegates/core/route/route.dart';
import 'package:ipc_delegates/core/utils/local_strings.dart';
import 'package:ipc_delegates/core/utils/url_container.dart';
import 'package:ipc_delegates/data/controller/dashboard/dashboard_controller.dart';
import 'package:ipc_delegates/data/model/dashboard/dashboard_model.dart';
import 'package:ipc_delegates/view/components/circle_image_button.dart';
import 'package:ipc_delegates/view/components/dialog/warning_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ipc_delegates/core/utils/color_resources.dart';
import 'package:ipc_delegates/core/utils/dimensions.dart';
import 'package:ipc_delegates/core/utils/style.dart';

import 'package:ipc_delegates/data/services/api_service.dart';
import 'package:ipc_delegates/core/helper/shared_preference_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ipc_delegates/view/screens/event_session/event_session_screen.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key, required this.dashboardModel});

  final DashboardModel dashboardModel;

  @override
  Widget build(BuildContext context)
  {
    final apiClient = Get.put(ApiClient(sharedPreferences: Get.find()));
    SharedPreferences pref = apiClient.sharedPreferences;
    String attendeePhoto = pref.getString(SharedPreferenceHelper.attendeeName) ?? '';
    String attendeeName = pref.getString(SharedPreferenceHelper.attendeeName) ?? '';

    return SafeArea(
      child: Drawer(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {}, // consume tap
          child: Column(
            children: [
              DrawerHeader(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: ColorResources.blueGreyColor,
                      radius: 42,
                      child: CircleImageWidget(
                        imagePath:
                        '${UrlContainer.profileImgUrl}${attendeePhoto ?? ''}',
                        isAsset: false,
                        isProfile: true,
                        width: 80,
                        height: 80,
                      ),
                    ),
                    const SizedBox(width: Dimensions.space15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: Dimensions.space15),
                          Text(
                            '${attendeeName ?? ''} ',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Get.toNamed(RouteHelper.profileScreen);
                            },
                            child: Text(
                              LocalStrings.viewProfile.tr,
                              style: mediumDefault.copyWith(
                                color: Theme.of(context).secondaryHeaderColor,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              GetBuilder<DashboardController>(
                builder: (controller) {
                  return Column(
                    children: [
                      ListTile(
                        leading: const Icon(
                          Icons.location_city,
                          color: ColorResources.primaryColor,
                        ),
                        title: Text(
                          LocalStrings.nav_event_areas.tr,
                          style: regularDefault.copyWith(
                            color: Theme.of(context).textTheme.bodyMedium!.color,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: Dimensions.space12,
                          color: ColorResources.contentTextColor,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Get.toNamed(RouteHelper.eventAreaScreen);
                        },
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.list_alt,
                          color: ColorResources.primaryColor,
                        ),
                        title: Text(
                          LocalStrings.nav_event_day.tr,
                          style: regularDefault.copyWith(
                            color: Theme.of(context).textTheme.bodyMedium!.color,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: Dimensions.space12,
                          color: ColorResources.contentTextColor,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Get.to(
                                () => EventSessionScreen(
                              arguments: {'from': 'EventSession', 'from_id': ''},
                            ),
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.person,
                          color: ColorResources.primaryColor,
                        ),
                        title: Text(
                          LocalStrings.nav_speaker.tr,
                          style: regularDefault.copyWith(
                            color: Theme.of(context).textTheme.bodyMedium!.color,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: Dimensions.space12,
                          color: ColorResources.contentTextColor,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Get.toNamed(RouteHelper.speakerScreen);
                        },
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.notifications,
                          color: ColorResources.primaryColor,
                        ),
                        title: Text(
                          LocalStrings.nav_notification.tr,
                          style: regularDefault.copyWith(
                            color: Theme.of(context).textTheme.bodyMedium!.color,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: Dimensions.space12,
                          color: ColorResources.contentTextColor,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Get.toNamed(RouteHelper.notificationScreen);
                        },
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.message,
                          color: ColorResources.primaryColor,
                        ),
                        title: Text(
                          LocalStrings.nav_contact_us.tr,
                          style: regularDefault.copyWith(
                            color: Theme.of(context).textTheme.bodyMedium!.color,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: Dimensions.space12,
                          color: ColorResources.contentTextColor,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Get.toNamed(RouteHelper.enquiryUsAddScreen);
                        },
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.assignment_outlined,
                          color: ColorResources.primaryColor,
                        ),
                        title: Text(
                          LocalStrings.nav_about_us.tr,
                          style: regularDefault.copyWith(
                            color: Theme.of(context).textTheme.bodyMedium!.color,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: Dimensions.space12,
                          color: ColorResources.contentTextColor,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Get.toNamed(RouteHelper.eventDetailScreen);
                        },
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.policy,
                          color: ColorResources.primaryColor,
                        ),
                        title: Text(
                          LocalStrings.nav_terms.tr,
                          style: regularDefault.copyWith(
                            color: Theme.of(context).textTheme.bodyMedium!.color,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: Dimensions.space12,
                          color: ColorResources.contentTextColor,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          String from = 'term_condition';
                          Get.toNamed(RouteHelper.privacyScreen, arguments: from);
                        },
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.privacy_tip,
                          color: ColorResources.primaryColor,
                        ),
                        title: Text(
                          LocalStrings.nav_privacy.tr,
                          style: regularDefault.copyWith(
                            color: Theme.of(context).textTheme.bodyMedium!.color,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: Dimensions.space12,
                          color: ColorResources.contentTextColor,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          String from = 'privacy_policy';
                          Get.toNamed(RouteHelper.privacyScreen, arguments: from);
                        },
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.settings,
                          color: ColorResources.primaryColor,
                        ),
                        title: Text(
                          LocalStrings.settings.tr,
                          style: regularDefault.copyWith(
                            color: Theme.of(context).textTheme.bodyMedium!.color,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: Dimensions.space12,
                          color: ColorResources.contentTextColor,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Get.toNamed(RouteHelper.settingsScreen);
                        },
                      ),
                    ],
                  );
                },
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ListTile(
                    leading: const Icon(
                      Icons.logout,
                      size: Dimensions.space20,
                      color: Colors.red,
                    ),
                    title: Text(
                      LocalStrings.logout.tr,
                      style: regularDefault.copyWith(
                        color: Theme.of(context).textTheme.bodyMedium!.color,
                      ),
                    ),
                    onTap: () {
                      const WarningAlertDialog().warningAlertDialog(
                        context,
                            () {
                          Get.back();
                          Get.find<DashboardController>().logout();
                        },
                        title: LocalStrings.logoutTitle.tr,
                        subTitle: LocalStrings.logoutSureWarningMSg.tr,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
