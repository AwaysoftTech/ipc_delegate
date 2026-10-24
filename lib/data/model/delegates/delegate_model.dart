class AttendeesModel
{
  AttendeesModel({
    List<AttendeeData>? data,
  }) {
    _data = data;
  }

  AttendeesModel.fromJson(dynamic json)
  {
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(AttendeeData.fromJson(v));
      });
    }
  }

  List<AttendeeData>? _data;

  List<AttendeeData>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
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
    String? mobile,
    String? attendeePhoto,
    String? idCard,
  }) {
    _attendeeId = attendeeId;
    _guid = guid;
    _registrationNumber = registrationNumber;
    _attendeeName = attendeeName;
    _emailId = emailId;
    _categories = categories;
    _mobile = mobile;
    _attendeePhoto = attendeePhoto;
    _idCard = idCard;
  }

  AttendeeData.fromJson(dynamic json) {
    _attendeeId = json['attendee_id'];
    _guid = json['guid'];
    _registrationNumber = json['registration_number'];
    _attendeeName = json['attendee_name'];
    _emailId = json['email_id'];
    _categories = json['categories'];
    _mobile = json['mobile'];
    _attendeePhoto = json['attendee_photo'];
    _idCard = json['id_card'];
  }

  String? _attendeeId;
  String? _guid;
  String? _registrationNumber;
  String? _attendeeName;
  String? _emailId;
  String? _categories;
  String? _mobile;
  String? _attendeePhoto;
  String? _idCard;

  String? get attendeeId => _attendeeId;
  String? get guid => _guid;
  String? get registrationNumber => _registrationNumber;
  String? get attendeeName => _attendeeName;
  String? get emailId => _emailId;
  String? get categories => _categories;
  String? get mobile => _mobile;
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
    map['mobile'] = _mobile;
    map['attendee_photo'] = _attendeePhoto;
    map['id_card'] = _idCard;

    return map;
  }

}
