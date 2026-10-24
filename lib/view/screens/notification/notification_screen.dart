import 'dart:async';
import 'dart:convert';
import 'package:ipc_delegates/core/utils/color_resources.dart';
import 'package:ipc_delegates/core/utils/dimensions.dart';
import 'package:ipc_delegates/core/utils/local_strings.dart';
import 'package:ipc_delegates/data/controller/notification/notification_controller.dart';
import 'package:ipc_delegates/data/repo/notification/notification_repo.dart';
import 'package:ipc_delegates/data/services/api_service.dart';
import 'package:ipc_delegates/core/utils/style.dart';
import 'package:ipc_delegates/view/components/app-bar/custom_appbar.dart';
import 'package:ipc_delegates/view/components/custom_loader/custom_loader.dart';
import 'package:ipc_delegates/view/components/no_data.dart';
import 'package:ipc_delegates/view/screens/notification/widget/notification_card.dart';
import 'package:ipc_delegates/core/helper/shared_preference_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/rendering.dart';
import 'package:ipc_delegates/core/utils/util.dart';
import 'package:ipc_delegates/data/model/notification/notification_model.dart';
import 'package:ipc_delegates/data/model/global/response_model/response_model.dart';
import 'package:ipc_delegates/view/components/snack_bar/show_custom_snackbar.dart';
import 'package:nb_utils/nb_utils.dart' hide NoDataWidget;
import 'package:ipc_delegates/view/components/text-form-field/custom_drop_down_text_field.dart';
import 'package:ipc_delegates/core/utils/images.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
{
  String attendeeId = "";
  String eventId = "";
  bool _successLoad = false;
  bool isLoading = false;
  int _currentPage = 0;
  int page_limit = 25;
  bool hasMoreLoad = true;
  bool isSubmitLoading = false;
  late NotificationRepo notificationRepo;
  late NotificationModel notificationModel;
  List<NotificationData> notificationList = [];
  late final controller;
  late ScrollController _scrollController;

  @override
  void initState()
  {
    super.initState();

    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(NotificationRepo(apiClient: Get.find()));
    controller = Get.put(NotificationController(notificationRepo: Get.find()));
    notificationRepo = Get.put(NotificationRepo(apiClient: Get.find()));

    attendeeId = notificationRepo.apiClient.sharedPreferences.getString(SharedPreferenceHelper.attendeeId) ?? "";
    eventId = notificationRepo.apiClient.sharedPreferences.getString(SharedPreferenceHelper.eventId) ?? "";

    _scrollController = ScrollController();
    _scrollController.addListener(_loadMore);

    _loadNotification(_currentPage, needLoading: true);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadNotification(int pageKey, {bool needLoading = true}) async {
    if (needLoading) {
      setState(() {
        isLoading = true;
      });
    }

    try {
      ResponseModel responseModel = await notificationRepo.getAllNotification(
        pageKey, page_limit, attendeeId, eventId
      );

      dynamic json = jsonDecode(responseModel.responseJson);
      _successLoad = json['success'];
      String _message = json['message'];
      if (_successLoad)
      {
        setState(()
        {
          NotificationModel notificationModel = NotificationModel.fromJson(
            jsonDecode(responseModel.responseJson),);
          final newAttendeesList = notificationModel.notificationData.validate();
          isLoading = false;

          if (newAttendeesList.length < page_limit) {
            hasMoreLoad = false;
          }

          notificationList.addAll(newAttendeesList);
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

  Future<void> _loadMore() async {
    if (_scrollController.position.maxScrollExtent ==
        _scrollController.offset) {
      if (notificationList.length > 0) {
        _currentPage = notificationList.length;
      }
      _loadNotification(_currentPage, needLoading: false);
    }
  }

  Future<void> refreshList() async {
    setState(() {
      isLoading = false;
      hasMoreLoad = true;
      _currentPage = 0;
      notificationList.clear();
    });
    _loadNotification(_currentPage, needLoading: true);
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: CustomAppBar(
        title: LocalStrings.str_notification_title.tr,
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
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: notificationList.isNotEmpty
                    ? ListView.separated(
                    shrinkWrap: true,
                    controller: ScrollController(),
                    //just add this line,
                    itemBuilder: (context, index)
                    {
                      if (index < notificationList.length)
                      {
                        final item = notificationList[index];
                        return NotificationCard(
                          notificationModel: item,
                        );
                      }
                      else {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: hasMoreLoad
                                ? CircularProgressIndicator(
                              backgroundColor: Color(0xffD6D6D6),
                              strokeWidth: 4,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.greenAccent),
                            ) : const Text(
                              'No more data to Load',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                fontSize: 16,
                                color: ColorResources.blueColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      }

                    },
                    separatorBuilder: (context, index) =>
                    const SizedBox(height: Dimensions.space10),
                    itemCount: notificationList.length + 1)
                    : const NoDataWidget(
                      text: LocalStrings.str_notification_no_notification,
                      image: MyImages.noNotification,),
              ),
              const SizedBox(height: Dimensions.space10),
              const Divider(color: Color.fromARGB(255, 214, 213, 213), thickness: 1),
              const SizedBox(height: Dimensions.space15),

            ],
          ),

        ),
      ),

    );
  }
}