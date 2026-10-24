class EventDetailModel
{
  EventDetailModel({
    bool? success,
    String? message,
    EventData? eventData,
    SettingData? settingData,
  }) {
    _success = success;
    _message = message;
    _eventData = eventData;
    _settingData = settingData;
  }

  EventDetailModel.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    _eventData = json['event_data'] != null ? EventData.fromJson(json['event_data']) : null;
    _settingData = json['setting_data'] != null ? SettingData.fromJson(json['setting_data']) : null;
  }
  bool? _success;
  String? _message;
  EventData? _eventData;
  SettingData? _settingData;

  bool? get success => _success;
  String? get message => _message;
  EventData? get eventData => _eventData;
  SettingData? get settingData => _settingData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['message'] = _message;

    if (_eventData != null) {
      map['event_data'] = _eventData?.toJson();
    }

    if (_settingData != null) {
      map['setting_data'] = _settingData?.toJson();
    }

    return map;
  }
}

class EventData
{
  EventData({
    String? eventId,
    String? eventName,
    String? eventThumbs,
    String? eventLocation,
    String? eventDescription,
    String? eventFromDate,
    String? eventFromTime,
    String? eventToDate,
    String? eventToTime,
  }) {
    _eventId = eventId;
    _eventName = eventName;
    _eventThumbs = eventThumbs;
    _eventLocation = eventLocation;
    _eventDescription = eventDescription;
    _eventFromDate = eventFromDate;
    _eventFromTime = eventFromTime;
    _eventToDate = eventToDate;
    _eventToTime = eventToTime;
  }

  EventData.fromJson(dynamic json)
  {
    _eventId = json['event_id'];
    _eventName = json['event_name'];
    _eventThumbs = json['event_thumbs'];
    _eventLocation = json['event_location'];
    _eventDescription = json['event_description'];
    _eventFromDate = json['format_event_from_date'];
    _eventFromTime = json['format_event_from_time'];
    _eventToDate = json['format_event_to_date'];
    _eventToTime = json['format_event_to_time'];
  }
  String? _eventId;
  String? _eventName;
  String? _eventThumbs;
  String? _eventLocation;
  String? _eventDescription;
  String? _eventFromDate;
  String? _eventFromTime;
  String? _eventToDate;
  String? _eventToTime;

  String? get eventId => _eventId;
  String? get eventName => _eventName;
  String? get eventThumbs => _eventThumbs;
  String? get eventLocation => _eventLocation;
  String? get eventDescription => _eventDescription;
  String? get eventFromDate => _eventFromDate;
  String? get eventFromTime => _eventFromTime;
  String? get eventToDate => _eventToDate;
  String? get eventToTime => _eventToTime;

  Map<String, dynamic> toJson()
  {
    final map = <String, dynamic>{};
    map['event_id'] = _eventId;
    map['event_name'] = _eventName;
    map['event_thumbs'] = _eventThumbs;
    map['event_location'] = _eventLocation;
    map['event_description'] = _eventDescription;
    map['format_event_from_date'] = _eventFromDate;
    map['format_event_from_time'] = _eventFromTime;
    map['format_event_to_date'] = _eventToDate;
    map['format_event_to_time'] = _eventToTime;

    return map;
  }

}

class SettingData
{
  SettingData({
    String? organizationName,
    String? organizationMobile,
    String? organizationEmail,
    String? organizationDescription,
    String? organizationLogo
  }) {
    _organizationName = organizationName;
    _organizationMobile = organizationMobile;
    _organizationEmail = organizationEmail;
    _organizationDescription = organizationDescription;
    _organizationLogo = organizationLogo;
  }

  SettingData.fromJson(dynamic json) {
    _organizationName = json['organization_name'];
    _organizationMobile = json['organization_mobile'];
    _organizationEmail = json['organization_email'];
    _organizationDescription = json['organization_description'];
    _organizationLogo = json['organization_logo'];
  }

  String? _organizationName;
  String? _organizationMobile;
  String? _organizationEmail;
  String? _organizationDescription;
  String? _organizationLogo;

  String? get organizationName => _organizationName;
  String? get organizationMobile => _organizationMobile;
  String? get organizationEmail => _organizationEmail;
  String? get organizationDescription => _organizationDescription;
  String? get organizationLogo => _organizationLogo;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['organization_name'] = _organizationName;
    map['organization_mobile'] = _organizationMobile;
    map['organization_email'] = _organizationEmail;
    map['organization_description'] = _organizationDescription;
    map['organization_logo'] = _organizationLogo;

    return map;
  }
}
