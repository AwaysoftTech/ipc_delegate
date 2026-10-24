import 'dart:async';
import 'dart:convert';
import 'package:ipc_delegates/data/model/notification/notification_model.dart';
import 'package:ipc_delegates/data/repo/notification/notification_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController
{
  bool isLoading = true;
  bool isSubmitLoading = false;
  String? eventId;
  NotificationRepo notificationRepo;
  NotificationController({required this.notificationRepo});

  TextEditingController searchController = TextEditingController(text: '');

  NotificationModel notificationModel = NotificationModel();

  void clearData() {
    isLoading = false;
    isSubmitLoading = false;
  }
}
