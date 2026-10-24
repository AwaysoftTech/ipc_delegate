import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:ipc_delegates/core/utils/images.dart';

class BasicAlertDialog {
  const BasicAlertDialog();

  void basicAlertDialog(BuildContext context, VoidCallback press,
      {String title = "Success", String image = MyImages.success})
  {

    showDialog(
      context: context,
      builder: (BuildContext context)
      {
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.of(context).pop();
        });
        return AlertDialog(
          backgroundColor: Theme.of(context).cardColor, // Set the desired background color here
          contentPadding: const EdgeInsets.all(20.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //TODO: lottie var
              Lottie.asset(
                image,
                height: 200,
                reverse: true,
                repeat: true,
              ),
              const SizedBox(height: 10),
              Text(title, style: const TextStyle(fontSize: 17)),
              const SizedBox(height: 13),
            ],
          ),
        );
      },
    );

  }
}

