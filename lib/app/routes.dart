import 'package:aurora_teacher/fileViews/imageFileScreen.dart';
import 'package:aurora_teacher/fileViews/pdfFileScreen.dart';
import 'package:aurora_teacher/ui/screens/aboutUsScreen.dart';
import 'package:aurora_teacher/ui/screens/add&editAssignmentScreen.dart';
import 'package:aurora_teacher/ui/screens/addOrEditAnnouncementScreen.dart';
import 'package:aurora_teacher/ui/screens/addOrEditLessonScreen.dart';
import 'package:aurora_teacher/ui/screens/addOrEditTopicScreen.dart';
import 'package:aurora_teacher/ui/screens/notificationsScreen.dart';
import 'package:aurora_teacher/ui/screens/result/addResultOfStudentScreen.dart';
import 'package:aurora_teacher/ui/screens/announcementsScreen.dart';

import 'package:aurora_teacher/ui/screens/assignment/assignmentScreen.dart';
import 'package:aurora_teacher/ui/screens/assignments/assignmentsScreen.dart';
import 'package:aurora_teacher/ui/screens/attendanceScreen.dart';
import 'package:aurora_teacher/ui/screens/class/classScreen.dart';
import 'package:aurora_teacher/ui/screens/contactUsScreen.dart';
import 'package:aurora_teacher/ui/screens/exam/examScreen.dart';
import 'package:aurora_teacher/ui/screens/exam/examTimeTableScreen.dart';
import 'package:aurora_teacher/ui/screens/holidays/holidaysScreen.dart';
import 'package:aurora_teacher/ui/screens/home/homeScreen.dart';
import 'package:aurora_teacher/ui/screens/lessonsScreen.dart';
import 'package:aurora_teacher/ui/screens/privacyPolicyScreen.dart';
import 'package:aurora_teacher/ui/screens/result/addResultForAllStudentsScreen.dart';

import 'package:aurora_teacher/ui/screens/searchStudentScreen.dart';
import 'package:aurora_teacher/ui/screens/splashScreen.dart';
import 'package:aurora_teacher/ui/screens/studentDetails/studentDetailsScreen.dart';
import 'package:aurora_teacher/ui/screens/subjectScreen.dart';
import 'package:aurora_teacher/ui/screens/termsAndConditionScreen.dart';
import 'package:aurora_teacher/ui/screens/topcisByLessonScreen.dart';
import 'package:aurora_teacher/ui/screens/topicsScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../ui/screens/auth/authScreen.dart';
import '../ui/screens/auth/loginScreen.dart';
import '../ui/screens/result/resultScreen.dart';

// ignore: avoid_classes_with_only_static_members
class Routes {
  static const String splash = "splash";
  static const String home = "/";
  static const String login = "auth";
  static const String teacherLogin = "teacherLogin";
  static const String classScreen = "/class";
  static const String subject = "/subject";

  static const String assignments = "/assignments";

  static const String announcements = "/announcements";

  static const String topics = "/topics";

  static const String assignment = "/assignment";

  static const String addAssignment = "/addAssignment";

  static const String attendance = "/attendance";

  static const String searchStudent = "/searchStudent";

  static const String studentDetails = "/studentDetails";

  static const String resultList = "/resultList";

  static const String addResult = "/addResult";
  static const String addResultForAllStudents = "/addResultForAllStudents";

  static const String lessons = "/lessons";

  static const String addOrEditLesson = "/addOrEditLesson";

  static const String addOrEditTopic = "/addOrEditTopic";

  static const String addOrEditAnnouncement = "/addOrEditAnnouncement";

  static const String monthWiseAttendance = "/monthWiseAttendance";

  static const String termsAndCondition = "/termsAndCondition";

  static const String aboutUs = "/aboutUs";
  static const String privacyPolicy = "/privacyPolicy";

  static const String contactUs = "/contactUs";

  static const String topicsByLesson = "/topicsByLesson";

  static const String holidays = "/holidays";

  static const String exams = "/exam";
  static const String examTimeTable = "/examTimeTable";

  static const String notifications = "/notifications";

  static const String pdfFileView = "/pdfFileView";
  static const String imageFileView = "/imageFileView";

  static String currentRoute = splash;

  static Route<dynamic> onGenerateRouted(RouteSettings routeSettings) {
    currentRoute = routeSettings.name ?? "";
    if (kDebugMode) {
      print("Route: $currentRoute");
    }
    switch (routeSettings.name) {
      case splash:
        {
          return SplashScreen.route(routeSettings);
        }
      case login:
        {
          return CupertinoPageRoute(builder: (_) => const AuthScreen());
        }

      case teacherLogin:
        {
          return LoginScreen.route(routeSettings);

        }


      case home:
        {
          return HomeScreen.route(routeSettings);
        }
      case classScreen:
        {
          return ClassScreen.route(routeSettings);
        }
      case subject:
        {
          return SubjectScreen.route(routeSettings);
        }
      case assignments:
        {
          return AssignmentsScreen.route(routeSettings);
        }
      case assignment:
        {
          return AssignmentScreen.route(routeSettings);
        }
      case addAssignment:
        {
          return AddAssignmentScreen.Routes(routeSettings);
        }

      case attendance:
        {
          return AttendanceScreen.route(routeSettings);
        }
      case searchStudent:
        {
          return SearchStudentScreen.route(routeSettings);
        }
      case studentDetails:
        {
          return StudentDetailsScreen.route(routeSettings);
        }
      case resultList:
        {
          return ResultListScreen.route(routeSettings);
        }
      case addResult:
        {
          return AddResultScreen.route(routeSettings);
        }
      case addResultForAllStudents:
        {
          return AddResultForAllStudents.route(routeSettings);
        }

      case announcements:
        {
          return AnnouncementsScreen.route(routeSettings);
        }
      case lessons:
        {
          return LessonsScreen.route(routeSettings);
        }
      case topics:
        {
          return TopicsScreen.route(routeSettings);
        }
      case addOrEditLesson:
        {
          return AddOrEditLessonScreen.route(routeSettings);
        }
      case addOrEditTopic:
        {
          return AddOrEditTopicScreen.route(routeSettings);
        }
      case aboutUs:
        {
          return AboutUsScreen.route(routeSettings);
        }
      case privacyPolicy:
        {
          return PrivacyPolicyScreen.route(routeSettings);
        }

      case contactUs:
        {
          return ContactUsScreen.route(routeSettings);
        }
      case termsAndCondition:
        {
          return TermsAndConditionScreen.route(routeSettings);
        }
      case addOrEditAnnouncement:
        {
          return AddOrEditAnnouncementScreen.route(routeSettings);
        }
      case topicsByLesson:
        {
          return TopcisByLessonScreen.route(routeSettings);
        }
      case holidays:
        {
          return HolidaysScreen.route(routeSettings);
        }
      case exams:
        {
          return ExamScreen.route(routeSettings);
        }

      case examTimeTable:
        {
          return ExamTimeTableScreen.route(routeSettings);
        }
      case notifications:
        return NotificationScreen.route(routeSettings);
      case pdfFileView:
        return PdfFileScreen.route(routeSettings);
      case imageFileView:
        return ImageFileScreen.route(routeSettings);
      default:
        {
          return CupertinoPageRoute(builder: (context) => const Scaffold());
        }
    }
  }
}
