import 'package:ipc_delegates/core/helper/date_converter.dart';
import 'package:ipc_delegates/core/route/route.dart';
import 'package:ipc_delegates/core/utils/color_resources.dart';
import 'package:ipc_delegates/core/utils/dimensions.dart';
import 'package:ipc_delegates/core/utils/local_strings.dart';
import 'package:ipc_delegates/core/utils/style.dart';
import 'package:ipc_delegates/data/model/speaker/speaker_model.dart';
import 'package:ipc_delegates/view/components/divider/custom_divider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:ipc_delegates/core/utils/util.dart';
import 'package:ipc_delegates/core/utils/images.dart';
import 'package:ipc_delegates/view/components/buttons/card_button.dart';
import 'package:ipc_delegates/view/components/image/circle_shape_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ipc_delegates/core/utils/url_container.dart';
import 'package:ipc_delegates/view/components/divider/custom_divider.dart';

import 'package:ipc_delegates/view/components/circle_image_button.dart';

class SpeakerCard extends StatelessWidget {
  const SpeakerCard({
    super.key,
    required this.speakerModel,
  });
  final SpeakerData speakerModel;

  @override
  Widget build(BuildContext context)
  {
    return Container(
      width: ContextExtensions(context).width() * 0.46 - 16,
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: context.cardColor,
        boxShadow: [BoxShadow(color: ColorResources.primaryColor.withValues(alpha: 0.3), offset: Offset(0.0, 1.0), blurRadius: 2.0)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: Dimensions.space5),
          Container(
            height: 100,
            width: 100,
            padding: EdgeInsets.zero,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
              border: Border.all(
                width: .3,
                color: Theme.of(context).primaryColor,
              ),
            ),
            child: CircleImageWidget(
              isProfile: true,
              imagePath:
              '${UrlContainer.profileImgUrl}${speakerModel.speakerImage ?? ''}',
              height: 80,
              width: 80,
              isAsset: false,
            ),
          ),
          Text('${speakerModel.speakerName.toString()} ',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ).paddingAll(8),
          Text('${speakerModel.designation.toString()} ',
            style: TextStyle(fontSize: 12, color: Colors.grey),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ).paddingOnly(left: 8, right: 8, bottom: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: ColorResources.blueGreyColor,
                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(16.0), topRight: Radius.circular(16.0)),
                ),
                padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
                child: Text(LocalStrings.str_speaker_view_profile.tr, style: primaryTextStyle(color: white, size: 12)),
              ),
            ],
          ),
        ],
      ),
    ).onTap(
          () {
            String speakerId = speakerModel.speakerId!;
            Get.toNamed(RouteHelper.speakerDetailScreen, arguments: speakerId);
        //BHDetailScreen().launch(context);
      },
    );
  }
}
