import 'package:flutter/material.dart';
import 'package:ipc_delegates/core/utils/color_resources.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ipc_delegates/core/utils/images.dart';

class ProgressDialog
{
  const ProgressDialog();

  void showProgressDialog(BuildContext context)
  {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 100),
          elevation: 5.0,
          backgroundColor: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 30),
            Center(
                child: SpinKitRotatingPlain(
                  color: ColorResources.primaryColor,
                  size: 30.0,
                )),
              SizedBox(height: 10),
              Text("Please wait...", style: TextStyle(fontSize: 17,color: Colors.black87)),
              SizedBox(height: 10),
            ],
          ),
        );
      },
    );

  }

  void hideProgressDialog(BuildContext context) {
    // Dismisses the most recent dialog
    Navigator.of(context, rootNavigator: true).pop();
  }

}

