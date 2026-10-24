import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:ipc_delegates/core/utils/color_resources.dart';
import 'package:ipc_delegates/core/utils/dimensions.dart';
import 'package:ipc_delegates/core/utils/local_strings.dart';
import 'package:ipc_delegates/data/controller/event_session/event_session_controller.dart';
import 'package:ipc_delegates/data/repo/event_session/event_session_repo.dart';
import 'package:ipc_delegates/data/services/api_service.dart';
import 'package:ipc_delegates/core/utils/style.dart';
import 'package:ipc_delegates/view/components/app-bar/custom_appbar.dart';
import 'package:ipc_delegates/view/components/custom_loader/custom_loader.dart';
import 'package:ipc_delegates/view/components/no_data.dart';
import 'package:ipc_delegates/view/screens/event_session/widget/session_card.dart';
import 'package:ipc_delegates/core/helper/shared_preference_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/rendering.dart';
import 'package:ipc_delegates/core/utils/util.dart';
import 'package:ipc_delegates/data/model/event_session/event_session_model.dart';
import 'package:ipc_delegates/data/model/global/response_model/response_model.dart';
import 'package:ipc_delegates/view/components/snack_bar/show_custom_snackbar.dart';
import 'package:nb_utils/nb_utils.dart' hide NoDataWidget;
import 'package:ipc_delegates/view/components/text-form-field/custom_drop_down_text_field.dart';
import 'package:ipc_delegates/core/utils/images.dart';

import 'package:universal_html/html.dart' as html;
import 'package:ipc_delegates/core/route/route.dart';

class EventSessionScreen extends StatefulWidget {
  const EventSessionScreen({super.key, required this.arguments});

  final Map<String, dynamic> arguments;

  @override
  State<EventSessionScreen> createState() => _EventSessionScreenState();
}

class _EventSessionScreenState extends State<EventSessionScreen> {
  String from = '';
  String fromId = '';
  String selectedDayId = "1";
  String selectedAreaId = "";
  String eventId = "";
  bool _successLoad = false;
  bool isLoading = false;
  bool isSubmitLoading = false;
  late EventSessionRepo eventSessionRepo;
  late EventSessionModel eventSessionModel;
  List<SessionData> sessionList = [];
  List<EventAreaData> areaList = [];
  late final controller;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(EventSessionRepo(apiClient: Get.find()));
    controller = Get.put(EventSessionController(eventSessionRepo: Get.find()));
    eventSessionRepo = Get.put(EventSessionRepo(apiClient: Get.find()));

    _scrollController = ScrollController();

    // Get the arguments
    final args = widget.arguments;
    from = args['from'];//CheckInSession, EventArea, EventSession
    fromId = args['from_id'];

    if(from == 'EventArea')
    {
        selectedAreaId = fromId;
    }

    eventId = eventSessionRepo.apiClient.sharedPreferences.getString(SharedPreferenceHelper.eventId)!;

    _loadSessions(needLoading: true);

    backForWeb();

  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadSessions({bool needLoading = true}) async {
    if (needLoading) {
      setState(() {
        isLoading = true;
      });
    }

    try {
      ResponseModel responseModel = await eventSessionRepo.getAllSessions(selectedDayId, selectedAreaId, eventId);
      dynamic json = jsonDecode(responseModel.responseJson);
      _successLoad = json['success'];
      String _message = json['message'];
      if (_successLoad) {
        setState(() {
          eventSessionModel = EventSessionModel.fromJson(jsonDecode(responseModel.responseJson));
          isLoading = false;

          sessionList.addAll(eventSessionModel.data.validate());
          areaList.addAll(eventSessionModel.eventAreaData.validate());

          selectedAreaId = json['selected_area_id'] ?? '';

        });
      }
      else {
        isLoading = false;
        if (needLoading) {
          CustomSnackBar.error(errorList: [_message]);
        }
      }
    } catch (e) {
      setState(() {
        var data_error = 'Error...: ${e.toString() ?? ' '} ';
        CustomSnackBar.error(errorList: [data_error]);
      });
    }
  }

  Future<void> refreshList() async {
    setState(() {
      isLoading = true;
      sessionList.clear();
      areaList.clear();
    });
    _loadSessions(needLoading: true);
  }

  void backForWeb()
  {
    html.window.onPopState.listen((event)
    {
      if (kIsWeb)
      {
        String previousRoute = Get.previousRoute;
        if (previousRoute == '/splash-screen')
        {
          Get.offAndToNamed(RouteHelper.dashboardScreen);
        }
        else {
          Get.back();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: CustomAppBar(
        title: LocalStrings.str_event_session_in_title.tr,
      ),
      body: isLoading
          ? const CustomLoader()
          : RefreshIndicator(
        color: ColorResources.primaryColor,
        onRefresh: () async {
          await refreshList();
        },
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.all(Dimensions.space5),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [

              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomDropDownTextField(
                              onChanged: (value) {
                                selectedDayId = value;
                                refreshList();
                              },
                              dropDownColor: Theme.of(context).cardColor,
                              selectedValue: selectedDayId,
                              hintText: LocalStrings.str_event_session_select_event_day.tr,
                              items: eventSessionModel.eventDayData!.map((EventDayData value) {
                                return DropdownMenuItem(
                                  value: value.dayId,
                                  child: Text('${value.dayName?.tr ?? ''} : ${MyUtils.dateFormateToStr(value.dayDate?.tr ?? '') }',
                                    style: regularDefault.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomDropDownTextField(
                              onChanged: (value) {
                                selectedAreaId = value;
                                refreshList();
                              },
                              dropDownColor: Theme.of(context).cardColor,
                              selectedValue: selectedAreaId.isEmpty ? null : selectedAreaId,
                              hintText: LocalStrings.str_event_session_select_event_area.tr,
                              items: areaList.map((EventAreaData value) {
                                return DropdownMenuItem(
                                  value: value.areaId,
                                  child: Text(value.areaName?.tr ?? '',
                                    style: regularDefault.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: Dimensions.space1),
              const Divider(color: Color.fromARGB(255, 214, 213, 213), thickness: 1),
              const SizedBox(height: Dimensions.space5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: sessionList.isNotEmpty
                    ? ListView.separated(
                    shrinkWrap: true,
                    controller: ScrollController(),
                    //just add this line,
                    itemBuilder: (context, index) {
                      final item = sessionList[index];
                      return SessionCard(
                        eventSessionModel: item, from: from
                      );
                    },
                    separatorBuilder: (context, index) =>
                    const SizedBox(height: Dimensions.space10),
                    itemCount: sessionList.length)
                    : const NoDataWidget(
                  text: LocalStrings.str_event_session_not_found,
                  image: MyImages.noSession),
              ),
              const SizedBox(height: Dimensions.space10),
            ],
          ),

        ),
      ),

    );
  }
}
