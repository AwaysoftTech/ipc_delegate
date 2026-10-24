import 'package:ipc_delegates/data/model/profile/profile_model.dart';

class DashboardModel
{
  DashboardModel({
    bool? success,
    String? message,
    EventData? eventData,
    WidgetsData? widgetsData,
    EventSettingData? eventSettingData,
  }) {
    _success = success;
    _message = message;
    _eventData = eventData;
    _widgetsData = widgetsData;
    _eventSettingData = eventSettingData;
  }

  DashboardModel.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    _eventData = json['event_data'] != null ? EventData.fromJson(json['event_data']) : null;
    _widgetsData = json['widgets_data'] != null ? WidgetsData.fromJson(json['widgets_data']) : null;
    _eventSettingData = json['event_setting_data'] != null ? EventSettingData.fromJson(json['event_setting_data']) : null;
  }
  bool? _success;
  String? _message;
  EventData? _eventData;
  WidgetsData? _widgetsData;
  EventSettingData? _eventSettingData;

  bool? get success => _success;
  String? get message => _message;
  EventData? get eventData => _eventData;
  WidgetsData? get widgetsData => _widgetsData;
  EventSettingData? get eventSettingData => _eventSettingData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['message'] = _message;

    if (_eventData != null) {
      map['event_data'] = _eventData?.toJson();
    }

    if (_widgetsData != null) {
      map['widgets_data'] = _widgetsData?.toJson();
    }

    if (_eventSettingData != null) {
      map['event_setting_data'] = _eventSettingData?.toJson();
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
    String? organizationName,
    String? organizationLogo
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
    _organizationName = organizationName;
    _organizationLogo = organizationLogo;
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
    _organizationName = json['organization_name'];
    _organizationLogo = json['organization_logo'];
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
  String? _organizationName;
  String? _organizationLogo;

  String? get eventId => _eventId;
  String? get eventName => _eventName;
  String? get eventThumbs => _eventThumbs;
  String? get eventLocation => _eventLocation;
  String? get eventDescription => _eventDescription;
  String? get eventFromDate => _eventFromDate;
  String? get eventFromTime => _eventFromTime;
  String? get eventToDate => _eventToDate;
  String? get eventToTime => _eventToTime;
  String? get organizationName => _organizationName;
  String? get organizationLogo => _organizationLogo;

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
    map['organization_name'] = _organizationName;
    map['organization_logo'] = _organizationLogo;

    return map;
  }

}

class WidgetsData
{
  WidgetsData({
    int? totalAreas,
    int? totalSpeaker,
  }) {
    _totalAreas = totalAreas;
    _totalSpeaker = totalSpeaker;
  }

  WidgetsData.fromJson(dynamic json) {
    _totalAreas = json['total_areas'];
    _totalSpeaker = json['total_speaker'];
  }

  int? _totalAreas;
  int? _totalSpeaker;

  int? get totalAreas => _totalAreas;
  int? get totalSpeaker => _totalSpeaker;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['total_areas'] = _totalAreas;
    map['total_speaker'] = _totalSpeaker;

    return map;
  }
}

class EventSettingData
{
  EventSettingData({
    String? organizationName,
    String? organizationLogo,
    String? needUpdate,
    String? titleUpdate,
  }) {
    _organizationName = organizationName;
    _organizationLogo = organizationLogo;
    _needUpdate = needUpdate;
    _titleUpdate = titleUpdate;
  }

  EventSettingData.fromJson(dynamic json)
  {
    _organizationName = json['organization_name'];
    _organizationLogo = json['organization_logo'];
    _needUpdate = json['need_update'];
    _titleUpdate = json['title_update'];
  }
  String? _organizationName;
  String? _organizationLogo;
  String? _needUpdate;
  String? _titleUpdate;

  String? get organizationName => _organizationName;
  String? get organizationLogo => _organizationLogo;
  String? get needUpdate => _needUpdate;
  String? get titleUpdate => _titleUpdate;

  Map<String, dynamic> toJson()
  {
    final map = <String, dynamic>{};
    map['organization_name'] = _organizationName;
    map['organization_logo'] = _organizationLogo;
    map['need_update'] = _needUpdate;
    map['title_update'] = _titleUpdate;

    return map;
  }

}
