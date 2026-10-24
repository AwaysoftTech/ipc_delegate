import 'package:ipc_delegates/core/helper/date_converter.dart';
import 'package:ipc_delegates/core/route/route.dart';
import 'package:ipc_delegates/core/utils/color_resources.dart';
import 'package:ipc_delegates/core/utils/dimensions.dart';
import 'package:ipc_delegates/core/utils/local_strings.dart';
import 'package:ipc_delegates/core/utils/style.dart';
import 'package:ipc_delegates/data/model/notification/notification_model.dart';
import 'package:ipc_delegates/view/components/divider/custom_divider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:ipc_delegates/core/utils/util.dart';
import 'package:ipc_delegates/core/utils/images.dart';
import 'package:ipc_delegates/view/components/buttons/card_button.dart';
import 'package:ipc_delegates/view/components/image/circle_shape_image.dart';

import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:ipc_delegates/view/components/snack_bar/show_custom_snackbar.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
    required this.notificationModel,
  });
  final NotificationData notificationModel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()
      {
        String notifyId = notificationModel.notifyId!;
      },
      child: Container(
        decoration: BoxDecoration(
          color: context.cardColor,
        ),
        padding: EdgeInsets.symmetric(horizontal: 1.0, vertical: 1.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.grey[300],
                      child: CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.white30,
                        child: Image.asset(
                          MyImages.notification,
                          height: 20,
                          width: 20,
                          color: ColorResources.primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${notificationModel.title.toString()} ',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 5,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 1.0),
                            child: Linkify(
                              text: '${notificationModel.message.toString()} ',
                              onOpen: (link) async {
                                final uri = Uri.parse(link.url);
                                if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
                                  //throw 'Could not launch $uri';
                                  CustomSnackBar.error(errorList: ['Could not launch $uri']);
                                }
                              },
                              style: TextStyle(fontSize: 14, color: Colors.grey),
                              linkStyle: TextStyle(color: Colors.blue),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 15,
                                backgroundColor: Colors.grey[300],
                                child: CircleAvatar(
                                  radius: 15,
                                  backgroundColor: Colors.white30,
                                  child: Image.asset(
                                    MyImages.calendar,
                                    height: 15,
                                    width: 15,
                                    color: ColorResources.colorGrey,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: Text(MyUtils.dateTimeFormateToStr('${notificationModel.addedDate.toString()} '),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle(fontSize: 12, color: Theme.of(context).primaryColor),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: Dimensions.space20),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
