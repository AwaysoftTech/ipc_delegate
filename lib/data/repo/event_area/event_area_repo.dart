import 'package:ipc_delegates/core/utils/method.dart';
import 'package:ipc_delegates/core/utils/url_container.dart';
import 'package:ipc_delegates/data/model/global/response_model/response_model.dart';
import 'package:ipc_delegates/data/services/api_service.dart';

class EventAreaRepo
{
  ApiClient apiClient;
  EventAreaRepo({required this.apiClient});

  Future<ResponseModel> getAllArea(String eventId) async {
    Map<String, String> map = {'action': 'AreaList', 'event_id': eventId};
    String url = "${UrlContainer.baseUrl}${UrlContainer.eventAreaUrl}";

    ResponseModel responseModel = await apiClient.request(url, Method.postMethod, map, passHeader: false);
    return responseModel;
  }

  Future<ResponseModel> getAreaDetails(String areaId, String eventId) async {
    Map<String, String> map = {'action': 'GetAreaDetail', 'area_id': areaId, 'event_id': eventId};
    String url = "${UrlContainer.baseUrl}${UrlContainer.eventAreaUrl}";

    ResponseModel responseModel =
    await apiClient.request(url, Method.postMethod, map, passHeader: false);
    return responseModel;
  }



}
