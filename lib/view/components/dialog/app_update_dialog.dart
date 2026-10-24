import 'dart:io';

import 'package:ipc_delegates/core/utils/images.dart';
import 'package:ipc_delegates/core/utils/local_strings.dart';
import 'package:flutter/material.dart';
import 'package:ipc_delegates/core/utils/dimensions.dart';
import 'package:ipc_delegates/core/utils/color_resources.dart';
import 'package:ipc_delegates/core/utils/style.dart';
import 'package:ipc_delegates/view/components/buttons/rounded_button.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

showAppUpdateDialog(BuildContext context, String titleUpdate)
{
  showDialog(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: ColorResources.getCardBgColor(),
      insetPadding: const EdgeInsets.symmetric(horizontal: Dimensions.space40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.only(
                  top: Dimensions.space50,
                  bottom: Dimensions.space15,
                  left: Dimensions.space15,
                  right: Dimensions.space15),
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: ColorResources.getCardBgColor(),
                  borderRadius: BorderRadius.circular(Dimensions.defaultRadius)),
              child: Column(
                children: [
                  const SizedBox(height: Dimensions.space10),
                  Text(
                    titleUpdate,
                    style: regularDefault,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 4,
                  ),
                  const SizedBox(height: Dimensions.space20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: RoundedButton(
                          text: LocalStrings.cancel.tr,
                          press: () {
                            Navigator.pop(context);
                          },
                          horizontalPadding: 3,
                          verticalPadding: 3,
                          color: ColorResources.colorLightGrey,
                          textColor: ColorResources.colorWhite,
                        ),
                      ),
                      const SizedBox(width: Dimensions.space10),
                      Expanded(
                        child: RoundedButton(
                            text: LocalStrings.update.tr,
                            press: ()
                            async {
                              String playStoreUrl = "https://play.google.com/store/apps/details?id=com.ipc.delegates";
                              String appStoreUrl = "https://apps.apple.com/app/com.ipc.delegates";
                              Uri playUrl = Uri.parse(playStoreUrl);
                              Uri appUrl = Uri.parse(appStoreUrl);

                              if (Platform.isAndroid)
                              {
                                try {
                                  if (await canLaunchUrl(playUrl)) {
                                    await launchUrl(playUrl, mode: LaunchMode.externalApplication);
                                    }
                              } catch (error) {
                              throw("Cannot launch Google map");
                              }
                              }
                              if (Platform.isIOS)
                              {
                                try {
                                if (await canLaunchUrl(appUrl)) {
                                  await launchUrl(playUrl, mode: LaunchMode.externalApplication);
                                  }
                                  } catch (error) {
                                  throw("Cannot launch Apple map");
                              }
                              }
                            },
                            horizontalPadding: 3,
                            verticalPadding: 3,
                            color: ColorResources.getPrimaryColor(),
                            textColor: ColorResources.colorWhite),
                      )
                    ],
                  )
                ],
              ),
            ),
            Positioned(
              top: -50,
              left: MediaQuery.of(context).padding.left,
              right: MediaQuery.of(context).padding.right,
              child: Container(
                height: 100,
                width: 100,
                padding: EdgeInsets.zero,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(
                    width: .3,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                child: Image.asset(
                    MyImages.mobileApp,
                    height: 80,
                    width: 80
                ),
              ),
            )
          ],
        ),
      ),
    ),
  );
}
