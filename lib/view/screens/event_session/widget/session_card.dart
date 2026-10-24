import 'package:ipc_delegates/core/helper/date_converter.dart';
import 'package:ipc_delegates/core/route/route.dart';
import 'package:ipc_delegates/core/utils/color_resources.dart';
import 'package:ipc_delegates/core/utils/dimensions.dart';
import 'package:ipc_delegates/core/utils/style.dart';
import 'package:ipc_delegates/data/model/event_session/event_session_model.dart';
import 'package:ipc_delegates/view/components/divider/custom_divider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:ipc_delegates/core/utils/util.dart';
import 'package:ipc_delegates/core/utils/images.dart';
import 'package:ipc_delegates/core/utils/local_strings.dart';

class SessionCard extends StatelessWidget {
  const SessionCard({
    super.key,
    required this.eventSessionModel,
    required this.from,
  });
  final SessionData eventSessionModel;
  final String from;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()
      {
        String dayId = eventSessionModel.dayId!;
        String areaId = eventSessionModel.areaId!;
        String sessionId = eventSessionModel.sessionId!;

        Get.toNamed(RouteHelper.eventSessionDetailScreen, arguments: sessionId);
        //Get.to(() => SessionAttendeeScreen(arguments: {'from': 'EventSession', 'from_id': sessionId}));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 1.0, vertical: 1.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 1, horizontal: 0),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.grey[300],
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.white30,
                            child: Image.asset(
                              MyImages.session,
                              height: 40,
                              width: 40,
                            ),
                          ),
                        ),
                        12.width,
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(eventSessionModel.sessionName ?? '',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: ColorResources.primaryColor
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                      color: ColorResources.colorGrey,
                                      borderRadius: BorderRadius.only(bottomRight: Radius.circular(16.0), topRight: Radius.circular(16.0)),
                                    ),
                                    padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
                                    child: Text(eventSessionModel.sessionType ?? '', style: primaryTextStyle(color: white, size: 12)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.punch_clock_sharp,
                                    size: 16,
                                    color: Colors.indigoAccent,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(MyUtils.timeFormateToStr(eventSessionModel.startTime ?? '00:00:00'),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle(fontSize: 14, color: Colors.indigoAccent),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.timer,
                                    size: 16,
                                    color: Colors.orange,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(MyUtils.addTimeToStr(eventSessionModel.duration ?? '00:00'),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle(fontSize: 14, color: Colors.orange),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    12.height,
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              String sessionId = eventSessionModel.sessionId!;
                              Get.toNamed(RouteHelper.eventSessionDetailScreen, arguments: sessionId);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorResources.primaryColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(LocalStrings.str_event_session_lbl_view_session),
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
      ),
    );
  }
}
