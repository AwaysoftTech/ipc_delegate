import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:ipc_delegates/core/utils/local_strings.dart';
import 'package:ipc_delegates/core/utils/messages.dart';
import 'package:ipc_delegates/core/utils/themes.dart';
import 'package:ipc_delegates/data/controller/common/theme_controller.dart';
import 'package:ipc_delegates/data/controller/localization/localization_controller.dart';
import 'package:ipc_delegates/core/route/route.dart';

import 'core/di_service/di_services.dart' as services;
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Text(
            'Flutter UI Working',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
            ),
          ),
        ),
      ),
    ),
  );

  debugPrint('STEP 3: runApp executed');
}

