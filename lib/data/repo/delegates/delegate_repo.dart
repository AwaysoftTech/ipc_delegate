import 'package:ipc_delegates/core/utils/method.dart';
import 'package:ipc_delegates/core/utils/url_container.dart';
import 'package:ipc_delegates/data/model/global/response_model/response_model.dart';
import 'package:ipc_delegates/data/services/api_service.dart';

class AttendeeRepo
{
  ApiClient apiClient;
  AttendeeRepo({required this.apiClient});

  Future<ResponseModel> getAllAttendees(int page, int page_limit, String from, String eventId) async {
    Map<String, String> map = {'action': 'AttendeesList', 'page': page.toString(), 'page_limit': page_limit.toString(), 'from': from, 'event_id': eventId};
    String url = "${UrlContainer.baseUrl}${UrlContainer.delegatesUrl}";

    ResponseModel responseModel = await apiClient.request(url, Method.postMethod, map, passHeader: false);
    return responseModel;
  }

  Future<ResponseModel> searchAttendees(String searchText, String eventId) async {
    Map<String, String> map = {'action': 'SearchAttendees', 'search': searchText, 'event_id': eventId};
    String url = "${UrlContainer.baseUrl}${UrlContainer.delegatesUrl}";

    ResponseModel responseModel = await apiClient.request(url, Method.postMethod, map, passHeader: false);
    return responseModel;
  }

  Future<ResponseModel> getAllAttendeesBySession(int page, int page_limit, String searchText, String sessionId, String eventId) async
  {
    Map<String, String> map = {'action': 'AttendeesBySessionList', 'page': page.toString()
      , 'page_limit': page_limit.toString(), 'search': searchText, 'session_id': sessionId, 'event_id': eventId};
    String url = "${UrlContainer.baseUrl}${UrlContainer.delegatesUrl}";

    ResponseModel responseModel = await apiClient.request(url, Method.postMethod, map, passHeader: false);
    return responseModel;
  }

  Future<ResponseModel> getAttendeeDetails(String attendeeId, String eventId) async {
    Map<String, String> map = {'action': 'GetAttendeeDetail', 'attendee_id': attendeeId, 'event_id': eventId};
    String url = "${UrlContainer.baseUrl}${UrlContainer.delegatesUrl}";

    ResponseModel responseModel =
    await apiClient.request(url, Method.postMethod, map, passHeader: false);
    return responseModel;
  }

}
