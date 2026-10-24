class SessionQuizCreateModel {
  final String question;
  final String speaker_id;
  final String attendee_id;
  final String session_id;
  final String event_id;

  SessionQuizCreateModel(
      { required this.question,
        required this.speaker_id,
        required this.attendee_id,
        required this.session_id,
        required this.event_id,
      });
}
