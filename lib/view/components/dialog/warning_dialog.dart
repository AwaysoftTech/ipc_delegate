import 'package:ipc_delegates/core/utils/local_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:ipc_delegates/core/utils/dimensions.dart';
import 'package:ipc_delegates/core/utils/color_resources.dart';
import 'package:ipc_delegates/core/utils/images.dart';
import 'package:ipc_delegates/core/utils/style.dart';
import 'package:ipc_delegates/view/components/buttons/rounded_button.dart';

class WarningAlertDialog {
  const WarningAlertDialog();

  warningAlertDialog(BuildContext context, VoidCallback press,
      {String title = LocalStrings.logoutSureWarningMSg,
      String subTitle = '',
      String image = MyImages.warningImage})
  {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: ColorResources.getCardBgColor(),
        insetPadding:
            const EdgeInsets.symmetric(horizontal: Dimensions.space40),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.only(
                    top: Dimensions.space60,
                    bottom: Dimensions.space15,
                    left: Dimensions.space15,
                    right: Dimensions.space15),
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.defaultRadius)),
                child: Column(
                  children: [
                    const SizedBox(height: Dimensions.space10),
                    Text(
                      title.tr,
                      style: boldExtraLarge,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 4,
                    ),
                    if (subTitle != '')
                      const SizedBox(height: Dimensions.space12),
                    if (subTitle != '')
                      Text(
                        subTitle.tr,
                        style: mediumLarge,
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
                            text: LocalStrings.no.tr,
                            press: () {
                              Navigator.pop(context);
                            },
                            horizontalPadding: 3,
                            verticalPadding: 3,
                            color: ColorResources.colorGrey,
                            textColor: ColorResources.colorWhite,
                          ),
                        ),
                        const SizedBox(width: Dimensions.space10),
                        Expanded(
                          child: RoundedButton(
                              text: LocalStrings.yes.tr,
                              press: press,
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
                top: -60,
                left: MediaQuery.of(context).padding.left,
                right: MediaQuery.of(context).padding.right,
                child: Container(
                  height: 120,
                  width: 120,
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
                      image,
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
}
