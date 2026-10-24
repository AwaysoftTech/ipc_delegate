import 'package:ipc_delegates/data/controller/common/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ipc_delegates/core/utils/color_resources.dart';
import 'package:intl/intl.dart';
import 'package:audioplayers/audioplayers.dart';

class MyUtils {
  static splashScreenUtils(bool isDark) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: ColorResources.getScreenBgColor(),
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: ColorResources.getScreenBgColor(),
        systemNavigationBarIconBrightness: Brightness.light));
  }

  static void allScreensUtils(bool isDark) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: ColorResources.getPrimaryColor(),
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: ColorResources.getScreenBgColor(),
        systemNavigationBarIconBrightness: Brightness.light));
  }

  static dynamic getShadow() {
    return [
      BoxShadow(
          blurRadius: 15.0,
          offset: const Offset(0, 25),
          color: Colors.grey.shade500.withValues(alpha: 0.6),
          spreadRadius: -35.0),
    ];
  }

  static dynamic getBottomSheetShadow() {
    return [
      BoxShadow(
        color: Get.find<ThemeController>().darkTheme
            ? Colors.black87.withValues(alpha: 0.30)
            : Colors.grey.shade400.withValues(alpha: 0.30),
        spreadRadius: 1,
        blurRadius: 4,
        offset: const Offset(0, 3), // changes position of shadow
      ),
    ];
  }

  static dynamic getCardShadow(BuildContext context) {
    return [
      BoxShadow(
        color: Get.find<ThemeController>().darkTheme
            ? Theme.of(context).shadowColor.withValues(alpha: 0.10)
            : Colors.grey.shade400.withValues(alpha: 0.10),
        spreadRadius: 1,
        blurRadius: 4,
        offset: const Offset(0, 3),
      ),
    ];
  }

  static Color getCardBgColor() {
    return Get.find<ThemeController>().darkTheme
        ? ColorResources.cardColorDark
        : ColorResources.cardColor;
  }

  Color projectStatusColor(String state) {
    Color color = ColorResources.blueColor;
    switch (state) {
      case '1':
        color = ColorResources.darkColor;
        break;
      case '2':
        color = ColorResources.blueColor;
        break;
      case '3':
        color = ColorResources.yellowColor;
        break;
      case '4':
        color = ColorResources.greenColor;
        break;
      case '5':
        color = ColorResources.redColor;
        break;
    }
    return color;
  }

  Color invoiceStatusColor(String state) {
    Color color = ColorResources.blueColor;
    switch (state) {
      case '1':
        color = ColorResources.redColor;
        break;
      case '2':
        color = ColorResources.greenColor;
        break;
      case '3':
        color = ColorResources.yellowColor;
        break;
      case '4':
        color = ColorResources.yellowColor;
        break;
      case '5':
        color = ColorResources.redColor;
        break;
      case '6':
        color = ColorResources.darkColor;
        break;
    }
    return color;
  }

  Color estimateStatusColor(String state) {
    Color color = ColorResources.blueColor;
    switch (state) {
      case '1':
        color = ColorResources.darkColor;
        break;
      case '2':
        color = ColorResources.blueColor;
        break;
      case '3':
        color = ColorResources.redColor;
        break;
      case '4':
        color = ColorResources.greenColor;
        break;
      case '5':
        color = ColorResources.yellowColor;
        break;
    }
    return color;
  }

  Color contractStatusColor(String state) {
    Color color = ColorResources.blueColor;
    switch (state) {
      case '0':
        color = ColorResources.blueColor;
        break;
      case '1':
        color = ColorResources.greenColor;
        break;
      case '2':
        color = ColorResources.redColor;
        break;
      case '3':
        color = ColorResources.yellowColor;
        break;
      case '4':
        color = ColorResources.darkColor;
        break;
    }
    return color;
  }

  static void hideKeyboard(context)
  {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  static String addTimeToStr(String timeString)
  {
    String printTimeString = '';

    if(timeString.isNotEmpty)
    {
      List<String> parts = timeString.split(':');

      int hour = int.parse(parts[0]);
      int minute = int.parse(parts[1]);

      printTimeString = '$hour Hr: $minute Min';
    }

    return printTimeString;
  }

  static String timeFormateToStr(String timeString)
  {
    String printTimeString = '';

    if(timeString.isNotEmpty)
    {
      var inputDateFormat = DateFormat('HH:mm:ss');
      var inputDate = inputDateFormat.parse(timeString); // 24Hour format

      var outputDateFormat = DateFormat('hh:mm a');
      var outputDate = outputDateFormat.format(inputDate);

      printTimeString = outputDate;
    }

    return printTimeString;
  }

  static String dateFormateToStr(String dateString)
  {
    String printDateString = '';

    if(dateString.isNotEmpty)
    {
      var inputDateFormat = DateFormat('yyyy-MM-dd');
      var inputDate = inputDateFormat.parse(dateString); // 24Hour format

      var outputDateFormat = DateFormat('dd-MMM-yyyy');
      var outputDate = outputDateFormat.format(inputDate);

      printDateString = outputDate;
    }

    return printDateString;
  }

  static String dateTimeFormateToStr(String dateString)
  {
    String printDateTimeString = '';

    if(dateString.isNotEmpty)
    {
      var inputDateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
      var inputDate = inputDateFormat.parse(dateString); // 24Hour format

      var outputDateFormat = DateFormat('dd-MMM-yyyy hh:mm a');
      var outputDate = outputDateFormat.format(inputDate);

      printDateTimeString = outputDate;
    }

    return printDateTimeString;
  }

  static Future<void> playSound(String soundAssets)
  async {
    final player = AudioPlayer();
    await player.play(AssetSource(soundAssets)); // For assets
    Future.delayed(const Duration(seconds: 1), ()
    async {
      await player.stop();
    });
  }

}
