import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ipc_delegates/core/utils/dimensions.dart';
import 'package:ipc_delegates/core/utils/style.dart';
import 'package:ipc_delegates/core/utils/color_resources.dart';

class CardColumn extends StatelessWidget {
  final String header;
  final String body;
  final bool alignmentEnd;

  const CardColumn(
      {super.key,
      this.alignmentEnd = false,
      required this.header,
      required this.body});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignmentEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          header.tr,
          style: const TextStyle(
            fontSize: 14,
            color: ColorResources.primaryColor,
            fontWeight: FontWeight.bold,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: Dimensions.space5),
        Text(body.tr,
            style: regularDefault.copyWith(
                color: Theme.of(context).textTheme.bodyMedium!.color,
                fontWeight: FontWeight.w500),
            overflow: TextOverflow.ellipsis,
            maxLines: 20,
        ),

      ],
    );
  }
}
