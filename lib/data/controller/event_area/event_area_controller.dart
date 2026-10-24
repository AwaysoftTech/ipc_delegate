import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:ipc_delegates/data/model/event_area/event_area_model.dart';
import 'package:ipc_delegates/data/repo/event_area/event_area_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:universal_html/html.dart' as html;

class EventAreaController extends GetxController
{
  bool isLoading = true;
  bool isSubmitLoading = false;
  String? eventId;
  EventAreaRepo eventAreaRepo;
  EventAreaController({required this.eventAreaRepo});

  TextEditingController searchController = TextEditingController(text: '');

  EventAreaModel eventAreaModel = EventAreaModel();

  Future<void> launchMapUrl(String address) async
  {
    String encodedAddress = Uri.encodeComponent(address);
    String googleMapUrl = "https://www.google.com/maps/search/?api=1&query=$encodedAddress";
    String appleMapUrl = "http://maps.apple.com/?q=$encodedAddress";
    Uri googleUrl = Uri.parse(googleMapUrl);
    Uri appleUrl = Uri.parse(appleMapUrl);

    if (kIsWeb)
    {
      try
      {
        final anchor = html.AnchorElement(href: googleMapUrl)
          ..target = '_blank'
          ..rel = 'noopener noreferrer'
          ..click();
      }
      catch (error) {
        throw("Cannot launch Apple map");
      }
    }
    else if (Platform.isAndroid)
    {
      try {
        if (await canLaunchUrl(googleUrl)) {
          await launchUrl(googleUrl);
        }
      } catch (error) {
        throw("Cannot launch Google map");
      }
    }
    else if (Platform.isIOS)
    {
      try {
        if (await canLaunchUrl(appleUrl)) {
          await launchUrl(appleUrl);
        }
      } catch (error) {
        throw("Cannot launch Apple map");
      }
    }


  }

  void clearData() {
    isLoading = false;
    isSubmitLoading = false;
  }
}
