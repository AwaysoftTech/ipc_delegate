import 'package:ipc_delegates/core/utils/method.dart';
import 'package:ipc_delegates/core/utils/url_container.dart';
import 'package:ipc_delegates/data/model/global/response_model/response_model.dart';
import 'package:ipc_delegates/data/model/session_quiz/session_quiz_create_model.dart';
import 'package:ipc_delegates/data/services/api_service.dart';

class SessionQuizRepo
{
  ApiClient apiClient;
  SessionQuizRepo({required this.apiClient});

  Future<ResponseModel> createQuestionUs(SessionQuizCreateModel sessionQuizCreateModel) async {

    String url = "${UrlContainer.baseUrl}${UrlContainer.sessionQuizUrl}";

    Map<String, String> params = {
      "action": 'SessionQuestion',
      "question": sessionQuizCreateModel.question,
      "speaker_id": sessionQuizCreateModel.speaker_id,
      "attendee_id": sessionQuizCreateModel.attendee_id,
      "session_id": sessionQuizCreateModel.session_id,
      "event_id": sessionQuizCreateModel.event_id,
    };

    ResponseModel responseModel = await apiClient.request(url, Method.postMethod, params, passHeader: true);

    return responseModel;
  }

}
