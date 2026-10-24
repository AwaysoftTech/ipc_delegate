class OverviewModel {
  OverviewModel({
    bool? success,
    String? message,
    Data? data,
  }) {
    _success = success;
    _message = message;
    _data = data;
  }

  OverviewModel.fromJson(dynamic json)
  {
    _success = json['success'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? _success;
  String? _message;
  Data? _data;

  bool? get success => _success;
  String? get message => _message;
  Data? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }
}

class Data {
  Data({
    String? appName,
    String? appLogo,
    String? language,
    String? disableLogin,
    String? appDescription,
    String? appPrivacyPolicy,
    String? appTermCondition,
  }) {
    _appName = appName;
    _appLogo = appLogo;
    _language = language;
    _disableLogin = disableLogin;
    _appDescription = appDescription;
    _appPrivacyPolicy = appPrivacyPolicy;
    _appTermCondition = appTermCondition;
  }

  Data.fromJson(dynamic json) {
    _appName = json['app_name'];
    _appLogo = json['app_logo'];
    _language = json['language'];
    _disableLogin = json['disable_login'];
    _appDescription = json['app_description'];
    _appPrivacyPolicy = json['app_privacy_policy'];
    _appTermCondition = json['app_term_condition'];
  }

  String? _appName;
  String? _appLogo;
  String? _language;
  String? _disableLogin;
  String? _appDescription;
  String? _appPrivacyPolicy;
  String? _appTermCondition;

  String? get appName => _appName;
  String? get appLogo => _appLogo;
  String? get language => _language;
  String? get disableLogin => _disableLogin;
  String? get appDescription => _appDescription;
  String? get appPrivacyPolicy => _appPrivacyPolicy;
  String? get appTermCondition => _appTermCondition;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['app_name'] = _appName;
    map['app_logo'] = _appLogo;
    map['language'] = _language;
    map['disable_login'] = _disableLogin;
    map['app_description'] = _appDescription;
    map['app_privacy_policy'] = _appPrivacyPolicy;
    map['app_term_condition'] = _appTermCondition;

    return map;
  }
}
