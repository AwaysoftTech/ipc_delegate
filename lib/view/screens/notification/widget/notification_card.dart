
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:ipc_delegates/core/helper/date_converter.dart';
import 'package:ipc_delegates/core/utils/color_resources.dart';
import 'package:ipc_delegates/core/utils/images.dart';
import 'package:ipc_delegates/core/utils/util.dart';
import 'package:ipc_delegates/data/model/notification/notification_model.dart';
import 'package:ipc_delegates/view/components/snack_bar/show_custom_snackbar.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
    required this.notificationModel,
  });

  final NotificationData notificationModel;

  Future<void> _openLink(String url) async {
    try {
      final uri = Uri.parse(url);

      if (!await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      )) {
        CustomSnackBar.error(
          errorList: ['Could not launch $url'],
        );
      }
    } catch (e) {
      CustomSnackBar.error(
        errorList: ['Unable to open this link'],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final title = notificationModel.title?.toString() ?? '';
    final message = notificationModel.message?.toString() ?? '';
    final addedDate = notificationModel.addedDate?.toString() ?? '';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: 0.30),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isDark ? 0.06 : 0.035,
            ),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Notification Header
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        colors.primary,
                        colors.primary.withValues(alpha: 0.75),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: colors.primary.withValues(alpha: 0.18),
                        blurRadius: 9,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Image.asset(
                      MyImages.notification,
                      height: 23,
                      width: 23,
                      color: Colors.white,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.notifications_active_rounded,
                          color: Colors.white,
                          size: 25,
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(width: 13),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          height: 1.35,
                          color: theme.textTheme.titleMedium?.color,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: colors.primary.withValues(alpha: 0.09),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Notification',
                          style: TextStyle(
                            color: colors.primary,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Icon(
                  Icons.notifications_none_rounded,
                  size: 21,
                  color: colors.primary.withValues(alpha: 0.75),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Notification Message
            if (message.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 2),
                child: Linkify(
                  text: message,
                  onOpen: (link) => _openLink(link.url),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 13,
                    height: 1.65,
                    color: theme.textTheme.bodyMedium?.color
                        ?.withValues(alpha: 0.78),
                  ),
                  linkStyle: TextStyle(
                    color: colors.primary,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),

            const SizedBox(height: 16),

            // Divider
            Divider(
              height: 1,
              thickness: 1,
              color: theme.dividerColor.withValues(alpha: 0.35),
            ),

            const SizedBox(height: 13),

            // Date Footer
            Row(
              children: [
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: colors.primary.withValues(alpha: 0.09),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Icon(
                    Icons.calendar_month_rounded,
                    color: colors.primary,
                    size: 17,
                  ),
                ),

                const SizedBox(width: 9),

                Expanded(
                  child: Text(
                    addedDate.isNotEmpty
                        ? MyUtils.dateTimeFormateToStr(addedDate)
                        : '--',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: theme.hintColor,
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 13,
                  color: theme.hintColor.withValues(alpha: 0.6),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
