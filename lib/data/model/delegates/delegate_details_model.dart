class AttendeeDetailsModel {
  AttendeeDetailsModel({
    bool? success,
    String? message,
    Attendee? data,
    CheckInData? checkInData,
  }) {
    _success = success;
    _message = message;
    _data = data;
    _checkInData = checkInData;
  }

  AttendeeDetailsModel.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    _data = json['data'] != null ? Attendee.fromJson(json['data']) : null;
    _checkInData = json['check_in_data'] != null ? CheckInData.fromJson(json['check_in_data']) : null;
  }
  bool? _success;
  String? _message;
  Attendee? _data;
  CheckInData? _checkInData;

  bool? get success => _success;
  String? get message => _message;
  Attendee? get data => _data;
  CheckInData? get checkInData => _checkInData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['message'] = _message;

    if (_data != null) {
      map['data'] = _data?.toJson();
    }

    if (_checkInData != null) {
      map['check_in_data'] = _checkInData?.toJson();
    }

    return map;
  }
}

class Attendee {
  Attendee({
    String? attendeeId,
    String? guid,
    String? registrationNumber,
    String? attendeeName,
    String? emailId,
    String? categories,
    String? affiliation,
    String? state,
    String? mobile,
    String? address1,
    String? attendeePhoto,
    String? idCard,
  }) {
    _attendeeId = attendeeId;
    _guid = guid;
    _registrationNumber = registrationNumber;
    _attendeeName = attendeeName;
    _emailId = emailId;
    _categories = categories;
    _affiliation = affiliation;
    _state = state;
    _mobile = mobile;
    _address1 = address1;
    _attendeePhoto = attendeePhoto;
    _idCard = idCard;
  }

  Attendee.fromJson(dynamic json) {
    _attendeeId = json['attendee_id'];
    _guid = json['guid'];
    _registrationNumber = json['registration_number'];
    _attendeeName = json['attendee_name'];
    _emailId = json['email_id'];
    _categories = json['categories'];
    _affiliation = json['affiliation'];
    _state = json['state'];
    _mobile = json['mobile'];
    _address1 = json['address_1'];
    _attendeePhoto = json['attendee_photo'];
    _idCard = json['id_card'];
  }

  String? _attendeeId;
  String? _guid;
  String? _registrationNumber;
  String? _attendeeName;
  String? _emailId;
  String? _categories;
  String? _affiliation;
  String? _state;
  String? _mobile;
  String? _address1;
  String? _attendeePhoto;
  String? _idCard;

  String? get attendeeId => _attendeeId;
  String? get guid => _guid;
  String? get registrationNumber => _registrationNumber;
  String? get attendeeName => _attendeeName;
  String? get emailId => _emailId;
  String? get categories => _categories;
  String? get affiliation => _affiliation;
  String? get state => _state;
  String? get mobile => _mobile;
  String? get address1 => _address1;
  String? get attendeePhoto => _attendeePhoto;
  String? get idCard => _idCard;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['attendee_id'] = _attendeeId;
    map['guid'] = _guid;
    map['registration_number'] = _registrationNumber;
    map['attendee_name'] = _attendeeName;
    map['email_id'] = _emailId;
    map['categories'] = _categories;
    map['affiliation'] = _affiliation;
    map['state'] = _state;
    map['mobile'] = _mobile;
    map['address_1'] = _address1;
    map['attendee_photo'] = _attendeePhoto;
    map['id_card'] = _idCard;

    return map;
  }
}

class CheckInData
{
  CheckInData({
    String? checkInId,
    String? eventInDate,
    String? eventInTime,
    String? eventOutDate,
    String? eventOutTime,
    String? status,
    String? welcomeKitProvide,
    String? welcomeKitDate,
  }) {
    _checkInId = checkInId;
    _eventInDate = eventInDate;
    _eventInTime = eventInTime;
    _eventOutDate = eventOutDate;
    _eventOutTime = eventOutTime;
    _status = status;
    _welcomeKitProvide = welcomeKitProvide;
    _welcomeKitDate = welcomeKitDate;
  }

  CheckInData.fromJson(dynamic json) {
    _checkInId = json['checkin_id'];
    _eventInDate = json['event_in_date'];
    _eventInTime = json['event_in_time'];
    _eventOutDate = json['event_out_date'];
    _eventOutTime = json['event_out_time'];
    _status = json['status'];
    _welcomeKitProvide = json['welcome_kit_provide'];
    _welcomeKitDate = json['welcome_kit_date'];
  }

  String? _checkInId;
  String? _eventInDate;
  String? _eventInTime;
  String? _eventOutDate;
  String? _eventOutTime;
  String? _status;
  String? _welcomeKitProvide;
  String? _welcomeKitDate;

  String? get checkInId => _checkInId;
  String? get eventInDate => _eventInDate;
  String? get eventInTime => _eventInTime;
  String? get eventOutDate => _eventOutDate;
  String? get eventOutTime => _eventOutTime;
  String? get status => _status;
  String? get welcomeKitProvide => _welcomeKitProvide;
  String? get welcomeKitDate => _welcomeKitDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['checkin_id'] = _checkInId;
    map['event_in_date'] = _eventInDate;
    map['event_in_time'] = _eventInTime;
    map['event_out_date'] = _eventOutDate;
    map['event_out_time'] = _eventOutTime;
    map['status'] = _status;
    map['welcome_kit_provide'] = _welcomeKitProvide;
    map['welcome_kit_date'] = _welcomeKitDate;

    return map;
  }
}

