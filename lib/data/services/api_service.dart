import 'dart:convert';
import 'dart:io';

import 'package:ipc_delegates/core/utils/local_strings.dart';
import 'package:ipc_delegates/data/model/global/response_model/response_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ipc_delegates/core/helper/shared_preference_helper.dart';
import 'package:ipc_delegates/core/route/route.dart';
import 'package:ipc_delegates/core/utils/method.dart';
import 'package:ipc_delegates/data/model/authorization/authorization_response_model.dart';

class ApiClient extends GetxService {
  SharedPreferences sharedPreferences;
  ApiClient({required this.sharedPreferences});

  Future<ResponseModel> request(
    String uri,
    String method,
    Map<String, dynamic>? params, {
    bool passHeader = false,
    bool isOnlyAcceptType = false,
  }) async {
    Uri url = Uri.parse(uri);
    http.Response response;

    print('url--------------${uri.toString()}');
    print('params-----------${params.toString()}');

    try
    {
      if (method == Method.postMethod)
      {
        response = await http.post(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(params),
        );
      }
      else if (method == Method.deleteMethod)
      {
        response = await http.delete(url);
      }
      else if (method == Method.updateMethod)
      {
        response = await http.patch(url);
      }
      else {
          //initToken();
          print('Req-4------------${Method.postMethod}');
          response = await http.get(url,
              headers: {"Accept": "application/json"});
      }

      print('status-----------${response.statusCode}');
      print('body-------------${response.body.toString()}');

      if (response.statusCode == 200)
      {
        return ResponseModel(true, 'Success', 200, response.body);
      }
      else if (response.statusCode == 401)
      {
        AuthorizationResponseModel model = AuthorizationResponseModel.fromJson(jsonDecode(response.body));
        sharedPreferences.setBool(SharedPreferenceHelper.rememberMeKey, false);
        Get.offAllNamed(RouteHelper.loginScreen);
        return ResponseModel(false, model.message!, 401, response.body);
      } else if (response.statusCode == 500) {
        return ResponseModel(
            false, LocalStrings.serverError.tr, 500, response.body);
      } else {
        return ResponseModel(
            false, LocalStrings.somethingWentWrong.tr, 499, response.body);
      }
    }
    on SocketException {
      return ResponseModel(false, LocalStrings.noInternet.tr, 503, '');
    }
    on FormatException {
      return ResponseModel(false, LocalStrings.badResponseMsg.tr, 400, '');
    }
    catch (e) {
      var errorInfoString = 'Error: ${LocalStrings.somethingWentWrong.tr} ';
      print('Error:-----${e.toString()}');

      return ResponseModel(false, errorInfoString, 499, '');
    }
  }

}
