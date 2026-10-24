class EventSessionModel
{
  EventSessionModel({
    List<SessionData>? data,
    List<EventDayData>? eventDayData,
    List<EventAreaData>? eventAreaData,
  }) {
    _data = data;
    _eventDayData = eventDayData;
    _eventAreaData = eventAreaData;
  }

  EventSessionModel.fromJson(dynamic json)
  {
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(SessionData.fromJson(v));
      });
    }

    if (json['event_day_data'] != null) {
      _eventDayData = [];
      json['event_day_data'].forEach((v) {
        _eventDayData?.add(EventDayData.fromJson(v));
      });
    }

    if (json['event_area_data'] != null) {
      _eventAreaData = [];
      json['event_area_data'].forEach((v) {
        _eventAreaData?.add(EventAreaData.fromJson(v));
      });
    }

  }

  List<SessionData>? _data;
  List<EventDayData>? _eventDayData;
  List<EventAreaData>? _eventAreaData;

  List<SessionData>? get data => _data;
  List<EventDayData>? get eventDayData => _eventDayData;
  List<EventAreaData>? get eventAreaData => _eventAreaData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }

    if (_eventDayData != null) {
      map['event_day_data'] = _eventDayData?.map((v) => v.toJson()).toList();
    }

    if (_eventAreaData != null) {
      map['event_area_data'] = _eventAreaData?.map((v) => v.toJson()).toList();
    }

    return map;
  }
}

class SessionData
{
  SessionData({
    String? sessionId,
    String? sessionName,
    String? sessionType,
    String? eventDay,
    String? startTime,
    String? duration,
    String? hall,
    String? sessionDescription,
    String? areaId,
    String? dayId,
    String? eventId,
    String? addedDate,
    String? updateDate,
  }) {
    _sessionId = sessionId;
    _sessionName = sessionName;
    _sessionType = sessionType;
    _eventDay = eventDay;
    _startTime = startTime;
    _duration = duration;
    _hall = hall;
    _sessionDescription = sessionDescription;
    _areaId = areaId;
    _dayId = dayId;
    _eventId = eventId;
    _addedDate = addedDate;
    _updateDate = updateDate;
  }

  SessionData.fromJson(dynamic json) {
    _sessionId = json['session_id'];
    _sessionName = json['session_name'];
    _sessionType = json['session_type'];
    _eventDay = json['event_day'];
    _startTime = json['start_time'];
    _duration = json['duration'];
    _hall = json['hall'];
    _sessionDescription = json['session_description'];
    _areaId = json['area_id'];
    _dayId = json['day_id'];
    _eventId = json['event_id'];
    _addedDate = json['added_date'];
    _updateDate = json['update_date'];
  }

  String? _sessionId;
  String? _sessionName;
  String? _sessionType;
  String? _eventDay;
  String? _startTime;
  String? _duration;
  String? _hall;
  String? _sessionDescription;
  String? _areaId;
  String? _dayId;
  String? _eventId;
  String? _addedDate;
  String? _updateDate;

  String? get sessionId => _sessionId;
  String? get sessionName => _sessionName;
  String? get sessionType => _sessionType;
  String? get eventDay => _eventDay;
  String? get startTime => _startTime;
  String? get duration => _duration;
  String? get hall => _hall;
  String? get sessionDescription => _sessionDescription;
  String? get areaId => _areaId;
  String? get dayId => _dayId;
  String? get eventId => _eventId;
  String? get addedDate => _addedDate;
  String? get updateDate => _updateDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['session_id'] = _sessionId;
    map['session_name'] = _sessionName;
    map['session_type'] = _sessionType;
    map['event_day'] = _eventDay;
    map['start_time'] = _startTime;
    map['duration'] = _duration;
    map['hall'] = _hall;
    map['session_description'] = _sessionDescription;
    map['area_id'] = _areaId;
    map['day_id'] = _dayId;
    map['event_id'] = _eventId;
    map['added_date'] = _addedDate;
    map['update_date'] = _updateDate;

    return map;
  }

}

class EventDayData
{
  EventDayData({
    String? dayIds,
    String? dayId,
    String? dayName,
    String? dayDate,
  }) {
    _dayIds = dayIds;
    _dayId = dayId;
    _dayName = dayName;
    _dayDate = dayDate;
  }

  EventDayData.fromJson(dynamic json) {
    _dayIds = json['day_ids'];
    _dayId = json['day_id'];
    _dayName = json['day_name'];
    _dayDate = json['day_date'];
  }

  String? _dayIds;
  String? _dayId;
  String? _dayName;
  String? _dayDate;

  String? get dayIds => _dayIds;
  String? get dayId => _dayId;
  String? get dayName => _dayName;
  String? get dayDate => _dayDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['day_ids'] = _dayIds;
    map['day_id'] = _dayId;
    map['day_name'] = _dayName;
    map['day_date'] = _dayDate;

    return map;
  }

}

class EventAreaData
{
  EventAreaData({
    String? areaId,
    String? areaName,
    String? areaAddress,
    String? pincode,
  }) {
    _areaId = areaId;
    _areaName = areaName;
    _areaAddress = areaAddress;
    _pincode = pincode;
  }

  EventAreaData.fromJson(dynamic json) {
    _areaId = json['area_id'];
    _areaName = json['area_name'];
    _areaAddress = json['area_address'];
    _pincode = json['pincode'];
  }

  String? _areaId;
  String? _areaName;
  String? _areaAddress;
  String? _pincode;

  String? get areaId => _areaId;
  String? get areaName => _areaName;
  String? get areaAddress => _areaAddress;
  String? get pincode => _pincode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['area_id'] = _areaId;
    map['area_name'] = _areaName;
    map['area_address'] = _areaAddress;
    map['pincode'] = _pincode;

    return map;
  }

}