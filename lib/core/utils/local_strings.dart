import 'package:ipc_delegates/data/model/language/language_model.dart';

class LocalStrings {
  static const String appName = "IPC Delegate";

  static List<LanguageModel> appLanguages = [
    LanguageModel(
        languageName: 'English', countryCode: 'US', languageCode: 'en'),
  ];

  // Navigation Drawer
  static const String nav_event_areas = "Conference Areas";
  static const String nav_event_day = "Conference Day";
  static const String nav_speaker = "Speaker";
  static const String nav_notification = "Notification";
  static const String nav_contact_us = "Ask Question";
  static const String nav_about_us = "About IPC";
  static const String nav_terms = "Terms & Condition";
  static const String nav_privacy = "Privacy Policy";
  static const String nav_settings = "Settings";

  // Onboarding Screens
  static const String onboardTitle1 = "Welcome to 75th IPC";
  static const String onboardSubTitle1 = "Find out Conference and Session details, schedules, get directions, and more.";
  static const String onboardTitle2 = "Stay Informed";
  static const String onboardSubTitle2 = "Stay informed of all Conference updates, and announcements.";
  static const String onboardTitle3 = "Ask Questions";
  static const String onboardSubTitle3 = "Ask relevant questions regard to the Conference.";
  static const String skip = "Skip";
  static const String next = "Next";
  static const String getStarted = "Get Started";

  // Login Screen
  static const String mobile = "WhatsApp Number";
  static const String enterMobile = "Enter WhatsApp Number";
  static const String iAgreeWith = "I agree with the";
  static const String policies = 'Term & Policies';

  static const String signIn = "Sign In with Mobile";
  static const String login = 'Login for Delegate';
  static const String loginDesc = 'Login to your account';
  static const String loginFailedTryAgain = 'Login failed, please try again';
  static const String mobile_verify = "Verify your Mobile";
  static const String mobile_verify_des =
      'We have send OTP to your Registered WhatsApp Number ';
  static const String enterOtp = "Enter OTP Value";
  static const String verifyNow = "Verify Now";
  static const String scanQr = "Scan QR Code";
  static const String or = "OR";

  // Attendee Detail
  static const String viewAttendeeProfile = "Attendee Profile";
  static const String str_attendee_not_found = "Attendee Not Found";
  static const String attendee_name = "Attendee Name";
  static const String registration_number = "Registration Number";
  static const String attendee_mobile = "Attendee Phone";
  static const String attendee_email = "Email Id";
  static const String categories = "Categories";
  static const String organization = "Organization";
  static const String state = "State";
  static const String attendee_address = "Address";
  static const String id_card = "Id Card";
  static const String registration_date = "Registration On";
  static const String search_attendee = "Search Attendee";
  static const String str_check_in = "Check In Conference";
  static const String str_attendee_welcome_kit = "Welcome Kit Provided";
  static const String str_attendee_check_in_date = "Conference Checked In";
  static const String str_attendee_check_out_date = "Conference Checked Out";
  static const String str_attendee_no_attendee_id = "No Attendee Id Found";
  static const String str_attendee_no_event_id = "No Conference Id Found";

  // Home
  static const String dashboard = "Dashboard";
  static const String totalAreas = "Areas";
  static const String totalSpeaker = "Speaker";
  static const String home_event_day = "Conference Day";
  static const String home_event_day_view = "View All Session";
  static const String eventDetail = "About Conference";
  static const String home_view_more = "View More";
  static const String welcome = 'Welcome';
  static const String eventSpeaker = "Our All Speakers";
  static const String home_notification = "Notify";
  static const String home_enquiry = "Ask";

  //Event Detail
  static const String str_event_detail_lbl_title = "Conference Detail";
  static const String eventFromDate = "Conference From";
  static const String eventToDate = "Conference To";
  static const String eventLocation = "Conference Location";
  static const String eventDescription = "Conference Description";
  static const String organizationName = "Organized By";
  static const String organizationEmail = "Organized Email";

  // Profile
  static const String viewProfile = "View Profile";
  static const String email_id = "Email Id";
  static const String name = "Name";
  static const String phone = "Phone Number";
  static const String designation = "Designation";

  // Event Session
  static const String str_event_session_in_title = "Conference Session";
  static const String str_event_session_check_in_title = "Session Check In";
  static const String str_event_session_select_event_day = "Select Conference Day";
  static const String str_event_session_select_event_area = "Select Area";
  static const String str_event_session_not_found = "Session Not Found";
  static const String str_event_session_lbl_view_speaker = "View Speaker";
  static const String str_event_session_lbl_view_session = "View Detail";

  // Session Detail
  static const String str_session_detail_title = "About Session";
  static const String str_session_detail_lbl_session_name = "Session Name";
  static const String str_session_detail_lbl_session_type = "Session Type";
  static const String str_session_detail_lbl_start_time = "Session Start On";
  static const String str_session_detail_lbl_session_duration = "Session Duration";
  static const String str_session_detail_lbl_session_hall = "Session in Hall";
  static const String str_session_detail_lbl_session_speaker = "Session Speaker";
  static const String str_session_detail_lbl_session_description = "Session Description";
  static const String str_session_detail_lbl_speaker = "(Session Speaker)";
  static const String str_session_detail_lbl_more_about = "More about";
  static const String str_session_detail_lbl_ask_quiz_now = "Ask Question";

  // Event Area
  static const String str_event_area_in_title = "Conference Areas";
  static const String str_event_area_not_found = "Area Not Found";
  static const String str_event_area_view_session = "View Session";

  // Settings
  static const String profile = "My Profile";
  static const String theme = "Theme";
  static const String notification = 'Notifications';
  static const String settings = "Settings";
  static const String language = "Language";
  static const String selectLanguage = 'Select Language';
  static const String privacyPolicy = "Privacy & Policy";
  static const String termCondition = "Term & Condition";
  static const String darkmode = "Dark Mode";
  static const String exitTitle = "Are you sure you want to exit the app?";
  static const String logout = "Logout";
  static const String logoutTitle = "Log out";
  static const String logoutSureWarningMSg =
      "Are you sure you want to log out from your account?";
  static const String logoutSuccessMsg = 'Sign Out Successfully';

  // Operations
  static const String viewAll = "View All";
  static const String submit = "Submit";
  static const String status = "Status";
  static const String fieldErrorMsg = "Please fill out this field";
  static const String badResponseMsg = 'Bad Response Format!';
  static const String serverError = 'Server Error';
  static const String unAuthorized = 'Unauthorized';
  static const String somethingWentWrong = 'Something went wrong';
  static const String noInternet = 'No internet connection';
  static const String noDataFound = 'Sorry! there are no data to show';
  static const String yes = "Yes";
  static const String no = "No";
  static const String cancel = "Cancel";
  static const String update = "Update";

  // Attendee
  static const String all_attendees = "All Attendees";
  static const String attendee = 'Attendee';
  static const String attendeeDetails = 'Attendee Details';
  static const String title = 'Title';
  static const String openedBy = 'Opened By';
  static const String attendeeType = 'Attendee Type';
  static const String selectAttendeeType = 'Select Attendee Type';
  static const String str_profile_lbl_qr_code = "QR Code";
  static const String selectAttendeeAttachment = "No File Attached";
  static const String str_profile_lbl_event_check_in_status = "Conference Check-In Status";

  //Notification
  static const String str_notification_title = 'Notification';
  static const String str_notification_no_notification = 'No Notification Found';

  //Speaker Screen
  static const String str_speaker_title = 'Our Speaker';
  static const String str_speaker_no_speaker = 'No Speaker Found';
  static const String str_speaker_view_profile = 'View Profile';
  static const String str_speaker_detail_title = 'About Speaker';
  static const String str_speaker_detail_speaker_name = 'Speaker Name';
  static const String str_speaker_detail_speaker_email = 'Speaker Email';
  static const String str_speaker_detail_company_name = 'Affiliation';
  static const String str_speaker_detail_designation = 'Designation';
  static const String str_speaker_detail_address = 'Speaker Location';
  static const String str_speaker_detail_country = 'Speaker Country';
  static const String str_speaker_detail_speaker_description = 'Description';

  //Enquiry
  static const String str_enquiry_us_title = 'Ask Question';
  static const String str_enquiry_us_title_des = 'Related Conference';
  static const String str_enquiry_us_lbl_message = 'Message';
  static const String str_enquiry_us_lbl_enter_message = 'Enter Message';
  static const String str_enquiry_us_b_send_now = 'Send Now';

  //Session Quiz
  static const String str_session_quiz_title = 'Ask Question to Speaker';
  static const String str_session_quiz_title_des = 'Ask Your Question Related Session';
  static const String str_session_quiz_lbl_message = 'Enter Question here';
  static const String str_session_quiz_lbl_enter_message = 'Enter Question';
  static const String str_session_quiz_b_send_now = 'Submit Now';

}

