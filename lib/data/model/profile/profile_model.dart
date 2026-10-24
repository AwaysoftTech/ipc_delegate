class ProfileModel {
  ProfileModel({
    AttendeeData? data,
    CheckInData? checkInData,
  }) {
    _data = data;
    _checkInData = checkInData;
  }

  ProfileModel.fromJson(dynamic json) {
    _data = json['data'] != null ? AttendeeData.fromJson(json['data']) : null;
    _checkInData = json['check_in_data'] != null ? CheckInData.fromJson(json['check_in_data']) : null;
  }
  bool? _success;
  String? _message;
  AttendeeData? _data;
  CheckInData? _checkInData;

  bool? get success => _success;
  String? get message => _message;
  AttendeeData? get data => _data;
  CheckInData? get checkInData => _checkInData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    if (_data != null) {
      map['data'] = _data?.toJson();
    }

    if (_checkInData != null) {
      map['check_in_data'] = _checkInData?.toJson();
    }

    return map;
  }
}

class AttendeeData
{
  AttendeeData({
    String? attendeeId,
    String? guid,
    String? registrationNumber,
    String? attendeeName,
    String? emailId,
    String? categories,
    String? affiliation,
    String? state,
    String? mobile,
    String? attendeePhoto,
    String? qrCode,
    String? idCard,
    String? address1,
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
    _attendeePhoto = attendeePhoto;
    _qrCode = qrCode;
    _idCard = idCard;
    _address1 = address1;
  }

  AttendeeData.fromJson(dynamic json)
  {
    _attendeeId = json['attendee_id'];
    _guid = json['guid'];
    _registrationNumber = json['registration_number'];
    _attendeeName = json['attendee_name'];
    _emailId = json['email_id'];
    _categories = json['categories'];
    _affiliation = json['affiliation'];
    _state = json['state'];
    _mobile = json['mobile'];
    _attendeePhoto = json['attendee_photo'];
    _qrCode = json['qr_code'];
    _idCard = json['id_card'];
    _address1 = json['address_1'];
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
  String? _attendeePhoto;
  String? _qrCode;
  String? _idCard;
  String? _address1;

  String? get attendeeId => _attendeeId;
  String? get guid => _guid;
  String? get registrationNumber => _registrationNumber;
  String? get attendeeName => _attendeeName;
  String? get emailId => _emailId;
  String? get categories => _categories;
  String? get affiliation => _affiliation;
  String? get state => _state;
  String? get mobile => _mobile;
  String? get attendeePhoto => _attendeePhoto;
  String? get qrCode => _qrCode;
  String? get idCard => _idCard;
  String? get address1 => _address1;

  Map<String, dynamic> toJson()
  {
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
    map['attendee_photo'] = _attendeePhoto;
    map['qr_code'] = _qrCode;
    map['id_card'] = _idCard;
    map['address_1'] = _address1;

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
