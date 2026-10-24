class LoginModel {
  LoginModel({
    bool? success,
    String? message,
    Data? data,
  }) {
    _success = success;
    _message = message;
    _data = data;
  }

  LoginModel.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'].toString();
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
    String? mobile,
    String? mobileOtp
  }) {
    _mobile = mobile;
    _mobileOtp = mobileOtp;
  }

  Data.fromJson(dynamic json) {
    _mobile = json['mobile'];
    _mobileOtp = json['mobileOtp'];
  }

  String? _mobile;
  String? _mobileOtp;

  String? get mobile => _mobile;
  String? get mobileOtp => _mobileOtp;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['mobile'] = _mobile;
    map['mobileOtp'] = _mobileOtp;

    return map;
  }
}
