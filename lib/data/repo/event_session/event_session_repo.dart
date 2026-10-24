import 'package:ipc_delegates/core/utils/method.dart';
import 'package:ipc_delegates/core/utils/url_container.dart';
import 'package:ipc_delegates/data/model/global/response_model/response_model.dart';
import 'package:ipc_delegates/data/services/api_service.dart';

class EventSessionRepo
{
  ApiClient apiClient;
  EventSessionRepo({required this.apiClient});

  Future<ResponseModel> getAllSessions(String dayId, String areaId, String eventId) async {
    Map<String, String> map = {'action': 'SessionList', 'day_id': dayId, 'area_id': areaId, 'event_id': eventId};
    String url = "${UrlContainer.baseUrl}${UrlContainer.eventSessionUrl}";

    ResponseModel responseModel = await apiClient.request(url, Method.postMethod, map, passHeader: false);
    return responseModel;
  }

  Future<ResponseModel> getSessionDetails(String sessionId, String eventId) async {
    Map<String, String> map = {'action': 'GetSessionDetail', 'session_id': sessionId, 'event_id': eventId};
    String url = "${UrlContainer.baseUrl}${UrlContainer.eventSessionUrl}";

    ResponseModel responseModel =
    await apiClient.request(url, Method.postMethod, map, passHeader: false);
    return responseModel;
  }


}
