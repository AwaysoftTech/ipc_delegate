import 'package:ipc_delegates/core/utils/method.dart';
import 'package:ipc_delegates/core/utils/url_container.dart';
import 'package:ipc_delegates/data/services/api_service.dart';
import 'package:ipc_delegates/data/model/global/response_model/response_model.dart';

class PrivacyRepo {
  ApiClient apiClient;
  PrivacyRepo({required this.apiClient});

  Future<ResponseModel> getPrivacyData() async {
    Map<String, String> map = {'action': 'GetSetting', 'app_version': '', 'attendee_id': ''};
    String url = '${UrlContainer.baseUrl}${UrlContainer.overviewUrl}';

    ResponseModel responseModel = await apiClient.request(url, Method.postMethod, map, passHeader: true);
    return responseModel;
  }
}


