import 'package:ipc_delegates/core/utils/method.dart';
import 'package:ipc_delegates/core/utils/url_container.dart';
import 'package:ipc_delegates/data/model/global/response_model/response_model.dart';
import 'package:ipc_delegates/data/services/api_service.dart';

class SplashRepo {
  ApiClient apiClient;
  SplashRepo({required this.apiClient});

  Future<ResponseModel> getOverviewData(String attendee_id) async
  {
    Map<String, String> map = {'action': 'GetSetting', 'attendee_id': attendee_id};
    String url = "${UrlContainer.baseUrl}${UrlContainer.overviewUrl}";

    ResponseModel responseModel = await apiClient.request(url, Method.postMethod, map, passHeader: true);
    return responseModel;
  }

}
