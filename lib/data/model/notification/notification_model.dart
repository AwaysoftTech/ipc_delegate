class NotificationModel
{
  NotificationModel({
    List<NotificationData>? notificationData,
  }) {
    _notificationData = notificationData;
  }

  NotificationModel.fromJson(dynamic json)
  {

    if (json['notification_data'] != null) {
      _notificationData = [];
      json['notification_data'].forEach((v) {
        _notificationData?.add(NotificationData.fromJson(v));
      });
    }

  }

  List<NotificationData>? _notificationData;

  List<NotificationData>? get notificationData => _notificationData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    if (_notificationData != null) {
      map['notification_data'] = _notificationData?.map((v) => v.toJson()).toList();
    }

    return map;
  }
}

class NotificationData
{
  NotificationData({
    String? notifyId,
    String? title,
    String? message,
    String? addedDate,
  }) {
    _notifyId = notifyId;
    _title = title;
    _message = message;
    _addedDate = addedDate;
  }

  NotificationData.fromJson(dynamic json) {
    _notifyId = json['notify_id'];
    _title = json['title'];
    _message = json['message'];
    _addedDate = json['added_date'];
  }

  String? _notifyId;
  String? _title;
  String? _message;
  String? _addedDate;

  String? get notifyId => _notifyId;
  String? get title => _title;
  String? get message => _message;
  String? get addedDate => _addedDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['notify_id'] = _notifyId;
    map['title'] = _title;
    map['message'] = _message;
    map['added_date'] = _addedDate;

    return map;
  }

}