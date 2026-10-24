import 'package:ipc_delegates/core/utils/method.dart';
import 'package:ipc_delegates/core/utils/url_container.dart';
import 'package:ipc_delegates/data/model/global/response_model/response_model.dart';
import 'package:ipc_delegates/data/model/enquiry_us/enquiry_us_create_model.dart';
import 'package:ipc_delegates/data/services/api_service.dart';

class EnquiryUsRepo
{
  ApiClient apiClient;
  EnquiryUsRepo({required this.apiClient});

  Future<ResponseModel> createEnquiryUs(EnquiryUsCreateModel enquiryUsCreateModel) async {

    String url = "${UrlContainer.baseUrl}${UrlContainer.enquiryUrl}";

    Map<String, String> params = {
      "action": 'PostEnquiry',
      "message": enquiryUsCreateModel.message,
      "attendee_id": enquiryUsCreateModel.attendee_id,
      "event_id": enquiryUsCreateModel.event_id,
    };

    ResponseModel responseModel = await apiClient.request(url, Method.postMethod, params, passHeader: true);

    return responseModel;
  }

}
