class SessionQuizModel
{
  SessionQuizModel({
    List<SessionQuizData>? sessionQuizData,
  }) {
    _sessionQuizData = sessionQuizData;
  }

  SessionQuizModel.fromJson(dynamic json)
  {

    if (json['data'] != null) {
      _sessionQuizData = [];
      json['data'].forEach((v) {
        _sessionQuizData?.add(SessionQuizData.fromJson(v));
      });
    }

  }

  List<SessionQuizData>? _sessionQuizData;

  List<SessionQuizData>? get sessionQuizData => _sessionQuizData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    if (_sessionQuizData != null) {
      map['data'] = _sessionQuizData?.map((v) => v.toJson()).toList();
    }

    return map;
  }
}

class SessionQuizData
{
  SessionQuizData({
    String? quizId,
    String? question,
    String? teamReplay,
    String? addedDate,
  }) {
    _quizId = quizId;
    _question = question;
    _teamReplay = teamReplay;
    _addedDate = addedDate;
  }

  SessionQuizData.fromJson(dynamic json) {
    _quizId = json['quiz_id'];
    _question = json['question'];
    _teamReplay = json['team_replay'];
    _addedDate = json['added_date'];
  }

  String? _quizId;
  String? _question;
  String? _teamReplay;
  String? _addedDate;

  String? get quizId => _quizId;
  String? get question => _question;
  String? get teamReplay => _teamReplay;
  String? get addedDate => _addedDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['quiz_id'] = _quizId;
    map['question'] = _question;
    map['team_replay'] = _teamReplay;
    map['added_date'] = _addedDate;

    return map;
  }

}