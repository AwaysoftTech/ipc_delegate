class UrlContainer
{
  //static const String domainUrl = 'http://192.168.0.105/IpcEventManager';
  static const String domainUrl = 'https://pharmair.org';

  // if your domain have index.php at the end please add it to the domain url too
  // Example: https://your-domain.com/index.php

  static const String baseUrl = '$domainUrl/admino/attendees-api/';
  static const String attachmentUrl = '$domainUrl/files/timeline_files/';
  static const String profileImgUrl = '$domainUrl/admino/';
  static const String systemImgUrl = '$domainUrl/files/system/';

  static RegExp emailValidatorRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  // Authentication
  static const String profileUrl = 'user_profile.php';

  // Dashboard
  static const String overviewUrl = 'action.php';
  static const String dashboardUrl = 'dashboard.php';

  // Pages
  static const String delegatesUrl = 'attendees.php';
  static const String eventUrl = 'event.php';
  static const String eventSessionUrl = 'event_session.php';
  static const String eventAreaUrl = 'event_area.php';
  static const String notificationUrl = 'notification.php';
  static const String speakerUrl = 'speaker.php';
  static const String enquiryUrl = 'enquiry_us.php';
  static const String sessionQuizUrl = 'session_quiz.php';

  static const String notificationChannel = "basic_channel";

}


