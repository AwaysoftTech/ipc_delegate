import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:ipc_delegates/core/utils/color_resources.dart';
import 'package:ipc_delegates/core/utils/dimensions.dart';
import 'package:ipc_delegates/core/utils/local_strings.dart';
import 'package:ipc_delegates/data/controller/event_area/event_area_controller.dart';
import 'package:ipc_delegates/data/repo/event_area/event_area_repo.dart';
import 'package:ipc_delegates/data/services/api_service.dart';
import 'package:ipc_delegates/core/utils/style.dart';
import 'package:ipc_delegates/view/components/app-bar/custom_appbar.dart';
import 'package:ipc_delegates/view/components/custom_loader/custom_loader.dart';
import 'package:ipc_delegates/view/components/no_data.dart';
import 'package:ipc_delegates/view/screens/event_area/widget/area_card.dart';
import 'package:ipc_delegates/core/helper/shared_preference_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/rendering.dart';
import 'package:ipc_delegates/core/utils/util.dart';
import 'package:ipc_delegates/data/model/event_area/event_area_model.dart';
import 'package:ipc_delegates/data/model/global/response_model/response_model.dart';
import 'package:ipc_delegates/view/components/snack_bar/show_custom_snackbar.dart';
import 'package:nb_utils/nb_utils.dart' hide NoDataWidget;
import 'package:ipc_delegates/view/components/text-form-field/custom_drop_down_text_field.dart';
import 'package:ipc_delegates/core/utils/images.dart';

import 'package:universal_html/html.dart' as html;
import 'package:ipc_delegates/core/route/route.dart';

class EventAreaScreen extends StatefulWidget {
  const EventAreaScreen({super.key});

  @override
  State<EventAreaScreen> createState() => _EventAreaScreenState();
}

class _EventAreaScreenState extends State<EventAreaScreen>
{
  String eventId = "";
  bool _successLoad = false;
  bool isLoading = false;
  bool isSubmitLoading = false;
  late EventAreaRepo eventAreaRepo;
  late EventAreaModel eventAreaModel;
  List<EventAreaData> areaList = [];
  late final controller;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(EventAreaRepo(apiClient: Get.find()));
    controller = Get.put(EventAreaController(eventAreaRepo: Get.find()));
    eventAreaRepo = Get.put(EventAreaRepo(apiClient: Get.find()));

    _scrollController = ScrollController();

    eventId = eventAreaRepo.apiClient.sharedPreferences.getString(SharedPreferenceHelper.eventId)!;

    _loadArea(needLoading: true);

    backForWeb();

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
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadArea({bool needLoading = true}) async {
    if (needLoading) {
      setState(() {
        isLoading = true;
      });
    }

    try {
      ResponseModel responseModel = await eventAreaRepo.getAllArea(eventId);
      dynamic json = jsonDecode(responseModel.responseJson);
      _successLoad = json['success'];
      String _message = json['message'];
      if (_successLoad)
      {
        setState(() {
          eventAreaModel = EventAreaModel.fromJson(jsonDecode(responseModel.responseJson));
          isLoading = false;

          areaList.addAll(eventAreaModel.eventAreaData.validate());
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

    if (needLoading) {
      setState(() {
        isLoading = false;
      });
    }

  }

  Future<void> refreshList() async {
    setState(() {
      isLoading = true;
      areaList.clear();
    });
    _loadArea(needLoading: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        title: LocalStrings.str_event_area_in_title.tr,
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
              const SizedBox(height: Dimensions.space1),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: areaList.isNotEmpty
                    ? ListView.separated(
                    shrinkWrap: true,
                    controller: ScrollController(),
                    //just add this line,
                    itemBuilder: (context, index) {
                      final item = areaList[index];
                      return AreaCard(
                        eventAreaModel: item,
                        controller: controller,
                      );
                    },
                    separatorBuilder: (context, index) =>
                    const SizedBox(height: Dimensions.space10),
                    itemCount: areaList.length)
                    : const NoDataWidget(
                  text: LocalStrings.str_event_area_not_found,
                  image: MyImages.noSession,),
              ),
              const SizedBox(height: Dimensions.space10),

            ],
          ),

        ),
      ),

    );
  }
}