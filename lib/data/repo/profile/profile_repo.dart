import 'package:ipc_delegates/core/utils/method.dart';
import 'package:ipc_delegates/core/utils/url_container.dart';
import 'package:ipc_delegates/data/model/global/response_model/response_model.dart';
import 'package:ipc_delegates/data/services/api_service.dart';

class ProfileRepo {
  ApiClient apiClient;
  ProfileRepo({required this.apiClient});

  Future<ResponseModel> getProfileData(String attendeeId, String eventId) async {
    Map<String, String> map = {'action': 'GetAttendeeDetail', 'attendee_id': attendeeId, 'event_id': eventId};
    String url = "${UrlContainer.baseUrl}${UrlContainer.profileUrl}";

    ResponseModel responseModel = await apiClient.request(url, Method.postMethod, map, passHeader: false);
    return responseModel;
  }
}
