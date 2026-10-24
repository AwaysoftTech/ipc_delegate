class SpeakerModel
{
  SpeakerModel({
    List<SpeakerData>? speakerData,
  }) {
    _speakerData = speakerData;
  }

  SpeakerModel.fromJson(dynamic json)
  {

    if (json['speaker_data'] != null)
    {
      _speakerData = [];
      json['speaker_data'].forEach((v) {
        _speakerData?.add(SpeakerData.fromJson(v));
      });
    }

  }

  List<SpeakerData>? _speakerData;

  List<SpeakerData>? get speakerData => _speakerData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    if (_speakerData != null) {
      map['speaker_data'] = _speakerData?.map((v) => v.toJson()).toList();
    }

    return map;
  }
}

class SpeakerData
{
  SpeakerData({
    String? speakerId,
    String? speakerName,
    String? speakerEmail,
    String? country,
    String? speakerImage,
    String? designation,
    String? companyName,
    String? address,
    String? mobile,
    String? description,
  }) {
    _speakerId = speakerId;
    _speakerName = speakerName;
    _speakerEmail = speakerEmail;
    _country = country;
    _speakerImage = speakerImage;
    _designation = designation;
    _companyName = companyName;
    _address = address;
    _mobile = mobile;
    _description = description;
  }

  SpeakerData.fromJson(dynamic json) {
    _speakerId = json['speaker_id'];
    _speakerName = json['speaker_name'];
    _speakerEmail = json['speaker_email'];
    _country = json['country'];
    _speakerImage = json['speaker_image'];
    _designation = json['designation'];
    _companyName = json['company_name'];
    _address = json['address'];
    _mobile = json['mobile'];
    _description = json['description'];
  }

  String? _speakerId;
  String? _speakerName;
  String? _speakerEmail;
  String? _country;
  String? _speakerImage;
  String? _designation;
  String? _companyName;
  String? _address;
  String? _mobile;
  String? _description;

  String? get speakerId => _speakerId;
  String? get speakerName => _speakerName;
  String? get speakerEmail => _speakerEmail;
  String? get country => _country;
  String? get speakerImage => _speakerImage;
  String? get designation => _designation;
  String? get companyName => _companyName;
  String? get address => _address;
  String? get mobile => _mobile;
  String? get description => _description;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['speaker_id'] = _speakerId;
    map['speaker_name'] = _speakerName;
    map['speaker_email'] = _speakerEmail;
    map['country'] = _country;
    map['speaker_image'] = _speakerImage;
    map['designation'] = _designation;
    map['company_name'] = _companyName;
    map['address'] = _address;
    map['mobile'] = _mobile;
    map['description'] = _description;

    return map;
  }

}