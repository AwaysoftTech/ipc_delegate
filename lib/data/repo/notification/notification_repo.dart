import 'package:ipc_delegates/core/utils/method.dart';
import 'package:ipc_delegates/core/utils/url_container.dart';
import 'package:ipc_delegates/data/model/global/response_model/response_model.dart';
import 'package:ipc_delegates/data/services/api_service.dart';

class NotificationRepo
{
  ApiClient apiClient;
  NotificationRepo({required this.apiClient});

  Future<ResponseModel> getAllNotification(int page, int pageLimit, String attendeeId, String eventId) async {
    Map<String, String> map = {'action': 'NotificationList', 'page': page.toString(), 'page_limit': pageLimit.toString(), 'attendee_id': attendeeId, 'event_id': eventId};
    String url = "${UrlContainer.baseUrl}${UrlContainer.notificationUrl}";

    ResponseModel responseModel = await apiClient.request(url, Method.postMethod, map, passHeader: false);
    return responseModel;
  }

  Future<ResponseModel> getNotificationDetails(String notificationId, String eventId) async {
    Map<String, String> map = {'action': 'GetNotificationDetail', 'notification_id': notificationId, 'event_id': eventId};
    String url = "${UrlContainer.baseUrl}${UrlContainer.notificationUrl}";

    ResponseModel responseModel = await apiClient.request(url, Method.postMethod, map, passHeader: false);
    return responseModel;
  }

}
