class EventSessionDetailModel {
  EventSessionDetailModel({
    SessionData? data,
  }) {
    _data = data;
  }

  EventSessionDetailModel.fromJson(dynamic json) {
    _data = json['data'] != null ? SessionData.fromJson(json['data']) : null;
  }

  SessionData? _data;

  SessionData? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    if (_data != null) {
      map['data'] = _data?.toJson();
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
    String? speakerId,
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
    _speakerId = speakerId;
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
    _speakerId = json['speaker_id'];
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
  String? _speakerId;

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
  String? get speakerId => _speakerId;

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
    map['speaker_id'] = _speakerId;

    return map;
  }

}


