class EventAreaModel
{
  EventAreaModel({
    List<EventAreaData>? eventAreaData,
  }) {
    _eventAreaData = eventAreaData;
  }

  EventAreaModel.fromJson(dynamic json)
  {

    if (json['event_area_data'] != null) {
      _eventAreaData = [];
      json['event_area_data'].forEach((v) {
        _eventAreaData?.add(EventAreaData.fromJson(v));
      });
    }

  }

  List<EventAreaData>? _eventAreaData;

  List<EventAreaData>? get eventAreaData => _eventAreaData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    if (_eventAreaData != null) {
      map['event_area_data'] = _eventAreaData?.map((v) => v.toJson()).toList();
    }

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