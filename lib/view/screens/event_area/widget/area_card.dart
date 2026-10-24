import 'package:ipc_delegates/core/helper/date_converter.dart';
import 'package:ipc_delegates/core/route/route.dart';
import 'package:ipc_delegates/core/utils/color_resources.dart';
import 'package:ipc_delegates/core/utils/dimensions.dart';
import 'package:ipc_delegates/core/utils/local_strings.dart';
import 'package:ipc_delegates/core/utils/style.dart';
import 'package:ipc_delegates/data/model/event_area/event_area_model.dart';
import 'package:ipc_delegates/view/components/divider/custom_divider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:ipc_delegates/core/utils/util.dart';
import 'package:ipc_delegates/core/utils/images.dart';
import 'package:ipc_delegates/view/components/buttons/card_button.dart';
import 'package:ipc_delegates/view/screens/event_session/event_session_screen.dart';
import 'package:ipc_delegates/data/controller/event_area/event_area_controller.dart';

class AreaCard extends StatelessWidget {
  const AreaCard({super.key, required this.eventAreaModel, required this.controller});

  final EventAreaData eventAreaModel;
  final EventAreaController controller;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        String areaId = eventAreaModel.areaId ?? "";
        Get.to(() => EventSessionScreen(arguments: {'from': 'EventArea', 'from_id': areaId},));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 1.0, vertical: 1.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:[
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.grey[300],
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.white30,
                            child: Image.asset(
                              MyImages.address,
                              height: 40,
                              width: 40,
                              color: ColorResources.colorRed,
                            ),
                          ),
                        ),
                        const SizedBox(width: Dimensions.space12),
                        Expanded(
                          child: Padding(
                              padding: const EdgeInsets.all(1),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  child: Text('${eventAreaModel.areaName.toString()} ',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      size: 16,
                                      color: ColorResources.colorRed,
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 10.0),
                                        child: Text('${eventAreaModel.areaAddress.toString()} ',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 5,
                                          style: TextStyle(fontSize: 14, color: Colors.grey),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
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
                              String address = eventAreaModel.areaAddress.toString() ?? "";
                              controller.launchMapUrl(address);
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text('Open in Map'),
                          ),
                        ),
                        12.width,
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              String areaId = eventAreaModel.areaId ?? "";
                              Get.to(() => EventSessionScreen(arguments: {'from': 'EventArea', 'from_id': areaId},));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorResources.colorRed,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(LocalStrings.str_event_area_view_session),
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
