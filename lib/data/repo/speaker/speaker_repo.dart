import 'package:ipc_delegates/core/utils/method.dart';
import 'package:ipc_delegates/core/utils/url_container.dart';
import 'package:ipc_delegates/data/model/global/response_model/response_model.dart';
import 'package:ipc_delegates/data/services/api_service.dart';

class SpeakerRepo
{
  ApiClient apiClient;
  SpeakerRepo({required this.apiClient});

  Future<ResponseModel> getAllSpeaker(String eventId) async {
    Map<String, String> map = {'action': 'SpeakerList', 'event_id': eventId};
    String url = "${UrlContainer.baseUrl}${UrlContainer.speakerUrl}";

    ResponseModel responseModel = await apiClient.request(url, Method.postMethod, map, passHeader: false);
    return responseModel;
  }

  Future<ResponseModel> getSpeakerDetails(String speakerId, String eventId) async {
    Map<String, String> map = {'action': 'GetSpeakerDetail', 'speaker_id': speakerId, 'event_id': eventId};
    String url = "${UrlContainer.baseUrl}${UrlContainer.speakerUrl}";

    ResponseModel responseModel =
    await apiClient.request(url, Method.postMethod, map, passHeader: false);
    return responseModel;
  }



}
