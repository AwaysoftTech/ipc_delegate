class VerifyLoginModel
{
  VerifyLoginModel({
    bool? success,
    String? message,
    LoginData? data,
  }) {
    _success = success;
    _message = message;
    _data = data;
  }

  VerifyLoginModel.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'].toString();
    _data = json['data'] != null ? LoginData.fromJson(json['data']) : null;
  }
  bool? _success;
  String? _message;
  LoginData? _data;

  bool? get success => _success;
  String? get message => _message;
  LoginData? get data => _data;

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

class LoginData
{
  LoginData({
    String? attendeeId,
    String? registrationNumber,
    String? attendeeName,
    String? attendeeMobile,
    String? emailId,
    String? attendeePhoto,
    String? eventId
  }) {
    _attendeeId = attendeeId;
    _registrationNumber = registrationNumber;
    _attendeeName = attendeeName;
    _attendeeMobile = attendeeMobile;
    _emailId = emailId;
    _attendeePhoto = attendeePhoto;
    _eventId = eventId;
  }

  LoginData.fromJson(dynamic json)
  {
    _attendeeId = json['attendee_id'];
    _registrationNumber = json['registration_number'];
    _attendeeName = json['attendee_name'];
    _attendeeMobile = json['attendee_mobile'];
    _emailId = json['email_id'];
    _attendeePhoto = json['attendee_photo'];
    _eventId = json['event_id'];
  }
  String? _attendeeId;
  String? _registrationNumber;
  String? _attendeeName;
  String? _attendeeMobile;
  String? _emailId;
  String? _attendeePhoto;
  String? _eventId;

  String? get attendeeId => _attendeeId;
  String? get registrationNumber => _registrationNumber;
  String? get attendeeName => _attendeeName;
  String? get attendeeMobile => _attendeeMobile;
  String? get emailId => _emailId;
  String? get attendeePhoto => _attendeePhoto;
  String? get eventId => _eventId;

  Map<String, dynamic> toJson()
  {
    final map = <String, dynamic>{};
    map['attendee_id'] = _attendeeId;
    map['registration_number'] = _registrationNumber;
    map['attendee_name'] = _attendeeName;
    map['attendee_mobile'] = _attendeeMobile;
    map['email_id'] = _emailId;
    map['attendee_photo'] = _attendeePhoto;
    map['event_id'] = _eventId;

    return map;
  }

}
