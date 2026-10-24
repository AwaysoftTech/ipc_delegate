import 'package:ipc_delegates/core/helper/shared_preference_helper.dart';
import 'package:ipc_delegates/core/utils/method.dart';
import 'package:ipc_delegates/core/utils/url_container.dart';
import 'package:ipc_delegates/data/model/global/response_model/response_model.dart';
import 'package:ipc_delegates/data/services/api_service.dart';

class DashboardRepo {
  ApiClient apiClient;
  DashboardRepo({required this.apiClient});

  Future<ResponseModel> getDashboardData(String appVersion, String eventId) async {
    Map<String, String> map = {'action': 'GetEventDetail', 'app_version': appVersion, 'event_id': eventId};
    String url = "${UrlContainer.baseUrl}${UrlContainer.dashboardUrl}";

    ResponseModel responseModel = await apiClient.request(url, Method.postMethod, map, passHeader: true);
    return responseModel;
  }

  Future<void> clearSharedPrefData() async {
    await apiClient.sharedPreferences
        .setBool(SharedPreferenceHelper.isLogin, false);

    await apiClient.sharedPreferences
        .setString(SharedPreferenceHelper.userNameKey, '');
    await apiClient.sharedPreferences
        .setString(SharedPreferenceHelper.userEmailKey, '');
    await apiClient.sharedPreferences
        .setString(SharedPreferenceHelper.accessTokenType, '');
    await apiClient.sharedPreferences
        .setString(SharedPreferenceHelper.accessTokenKey, '');

    return Future.value();
  }
}
