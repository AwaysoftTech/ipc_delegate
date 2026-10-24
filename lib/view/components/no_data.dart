import 'package:ipc_delegates/core/utils/images.dart';
import 'package:ipc_delegates/core/utils/local_strings.dart';
import 'package:flutter/material.dart';
import 'package:ipc_delegates/core/utils/dimensions.dart';
import 'package:ipc_delegates/core/utils/style.dart';
import 'package:get/get.dart';

class NoDataWidget extends StatelessWidget {
  final double margin;
  final Color color;
  final String text;
  final String image;
  const NoDataWidget({
    super.key,
    this.margin = 6,
    this.color = Colors.grey,
    this.text = LocalStrings.noDataFound,
    this.image = 'noDataFound',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height / margin),
      child: Column(
        children: [
          Image.asset(image, height: 120),
          const SizedBox(height: Dimensions.space20),
          Text(
            text.tr,
            style: regularMediumLarge.copyWith(color: color),
          )
        ],
      ),
    );
  }
}
