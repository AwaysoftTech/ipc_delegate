import 'dart:async';
import 'dart:convert';
import 'package:ipc_delegates/core/utils/color_resources.dart';
import 'package:ipc_delegates/core/utils/dimensions.dart';
import 'package:ipc_delegates/core/utils/local_strings.dart';
import 'package:ipc_delegates/data/controller/speaker/speaker_controller.dart';
import 'package:ipc_delegates/data/repo/speaker/speaker_repo.dart';
import 'package:ipc_delegates/data/services/api_service.dart';
import 'package:ipc_delegates/core/utils/style.dart';
import 'package:ipc_delegates/view/components/app-bar/custom_appbar.dart';
import 'package:ipc_delegates/view/components/custom_loader/custom_loader.dart';
import 'package:ipc_delegates/view/components/no_data.dart';
import 'package:ipc_delegates/view/screens/speaker/widget/speaker_card.dart';
import 'package:ipc_delegates/core/helper/shared_preference_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/rendering.dart';
import 'package:ipc_delegates/core/utils/util.dart';
import 'package:ipc_delegates/data/model/speaker/speaker_model.dart';
import 'package:ipc_delegates/data/model/global/response_model/response_model.dart';
import 'package:ipc_delegates/view/components/snack_bar/show_custom_snackbar.dart';
import 'package:nb_utils/nb_utils.dart' hide NoDataWidget;
import 'package:ipc_delegates/view/components/text-form-field/custom_drop_down_text_field.dart';
import 'package:ipc_delegates/core/utils/images.dart';

class SpeakerScreen extends StatefulWidget {
  const SpeakerScreen({super.key});

  @override
  State<SpeakerScreen> createState() => _SpeakerScreenState();
}

class _SpeakerScreenState extends State<SpeakerScreen>
{
  String eventId = "";
  bool _successLoad = false;
  bool isLoading = false;
  bool isSubmitLoading = false;
  late SpeakerRepo speakerRepo;
  late SpeakerModel speakerModel;
  List<SpeakerData> speakerList = [];
  late final controller;
  late ScrollController _scrollController;

  @override
  void initState()
  {
    super.initState();

    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(SpeakerRepo(apiClient: Get.find()));
    controller = Get.put(SpeakerController(speakerRepo: Get.find()));
    speakerRepo = Get.put(SpeakerRepo(apiClient: Get.find()));

    _scrollController = ScrollController();

    eventId = speakerRepo.apiClient.sharedPreferences.getString(SharedPreferenceHelper.eventId)!;

    _loadSpeaker(needLoading: true);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadSpeaker({bool needLoading = true}) async {
    if (needLoading) {
      setState(() {
        isLoading = true;
      });
    }

    try {
      ResponseModel responseModel = await speakerRepo.getAllSpeaker(eventId);
      dynamic json = jsonDecode(responseModel.responseJson);
      _successLoad = json['success'];
      String _message = json['message'];
      if (_successLoad)
      {
        setState(() {
          speakerModel = SpeakerModel.fromJson(jsonDecode(responseModel.responseJson));
          isLoading = false;

          speakerList.addAll(speakerModel.speakerData.validate());
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
      speakerList.clear();
    });
    _loadSpeaker(needLoading: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // set it to false
      appBar: CustomAppBar(
        title: LocalStrings.str_speaker_title.tr,
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
                child: speakerList.isNotEmpty
                    ? GridView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    controller: ScrollController(),
                    padding: EdgeInsets.only(top: 10),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisExtent: 210, // <-- this works!
                    ),
                    //just add this line,
                    itemBuilder: (context, index) {
                      final item = speakerList[index];
                      return SpeakerCard(
                        speakerModel: item,
                      );
                    },
                    itemCount: speakerList.length)
                    : const NoDataWidget(
                  text: LocalStrings.str_speaker_no_speaker,
                  image: MyImages.noSpeaker,),
              ),
              const SizedBox(height: Dimensions.space20),

            ],
          ),

        ),
      ),

    );
  }
}