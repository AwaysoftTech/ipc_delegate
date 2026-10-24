import 'package:ipc_delegates/core/utils/method.dart';
import 'package:ipc_delegates/core/utils/url_container.dart';
import 'package:ipc_delegates/data/model/global/response_model/response_model.dart';
import 'package:ipc_delegates/data/services/api_service.dart';

class LoginRepo {
  ApiClient apiClient;

  LoginRepo({required this.apiClient});

  Future<ResponseModel> loginUser(String mobile) async {
    Map<String, String> map = {'action': 'CheckMobile', 'mobile': mobile};
    String url = '${UrlContainer.baseUrl}${UrlContainer.profileUrl}';

    ResponseModel model = await apiClient.request(url, Method.postMethod, map, passHeader: false);
    return model;
  }

  Future<ResponseModel> loginUsingQr(String registration_number, String device_token) async {
    Map<String, String> map = {'action': 'VerifyLogin', 'from': 'QRLogin', 'from_id': registration_number, 'device_id': '', 'device_token': device_token};
    String url = '${UrlContainer.baseUrl}${UrlContainer.profileUrl}';

    ResponseModel model = await apiClient.request(url, Method.postMethod, map, passHeader: false);
    return model;
  }

}
