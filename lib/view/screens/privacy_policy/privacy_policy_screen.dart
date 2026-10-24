import 'package:ipc_delegates/core/utils/local_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:ipc_delegates/core/utils/style.dart';
import 'package:ipc_delegates/data/controller/privacy/privacy_controller.dart';
import 'package:ipc_delegates/data/repo/privacy/privacy_repo.dart';
import 'package:ipc_delegates/data/services/api_service.dart';
import 'package:ipc_delegates/view/components/app-bar/custom_appbar.dart';
import 'package:ipc_delegates/view/components/custom_loader/custom_loader.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key, required this.id});

  final String id;

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  String from = "";
  String s_title = "";
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(PrivacyRepo(apiClient: Get.find()));
    final controller = Get.put(PrivacyController(privacyRepo: Get.find()));

    super.initState();

    from = widget.id;

    if(from == 'term_condition')
    {
      s_title = LocalStrings.termCondition.tr;
    }
    else
    {
      s_title = LocalStrings.privacyPolicy.tr;
    }

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.loadData();
    });
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
        appBar: CustomAppBar(
          title: s_title,
          bgColor: Theme.of(context).appBarTheme.backgroundColor!,
        ),
        body: GetBuilder<PrivacyController>(
          builder: (controller) => SizedBox(
            width: MediaQuery.of(context).size.width,
            child: controller.isLoading
                ? const CustomLoader()
                : SingleChildScrollView(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: HtmlWidget(
                            from == 'term_condition'
                                ? controller.overviewModel.data!.appTermCondition ?? ''
                                : controller.overviewModel.data!.appPrivacyPolicy ?? '',
                            textStyle: regularDefault,
                            onLoadingBuilder: (context, element, loadingProgress) =>
                                    const Center(child: CustomLoader())
                        )
                    )),
          ),
        ));
  }
}
