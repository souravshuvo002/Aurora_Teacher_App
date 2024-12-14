import 'dart:io';
import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:aurora_teacher/app/routes.dart';
import 'package:aurora_teacher/data/repositories/settingsRepository.dart';
import 'package:aurora_teacher/ui/screens/home/homeScreen.dart';
import 'package:aurora_teacher/utils/constants.dart';
import 'package:aurora_teacher/utils/uiUtils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';

// ignore: avoid_classes_with_only_static_members
class NotificationUtility {
  static String customNotificationType = "custom";
  static String noticeboardNotificationType = "noticeboard";
  static String classNoticeboardNotificationType = "class";
  static String classSectionNoticeboardNotificationType = "class_section";
  static String assignmentlNotificationType = "assignment";
  static String assignmentSubmissionNotificationType = "assignment_submission";
  static String onlineFeePaymentNotificationType = "Online";
  static String attendenceNotificationType = "attendance";
  static List<String> notificaitonTypesToNotIncrementCount = [
    noticeboardNotificationType,
    classNoticeboardNotificationType,
    classSectionNoticeboardNotificationType,
  ];

  static StreamSubscription<RemoteMessage>? openAppStreamSubscription;
  static StreamSubscription<RemoteMessage>? onMessageOpenAppStreamSubscription;

  static Future<void> setUpNotificationService(
    BuildContext buildContext,
  ) async {
    NotificationSettings notificationSettings =
        await FirebaseMessaging.instance.getNotificationSettings();

    //ask for permission
    if (notificationSettings.authorizationStatus ==
            AuthorizationStatus.notDetermined ||
        notificationSettings.authorizationStatus ==
            AuthorizationStatus.denied) {
      notificationSettings =
          await FirebaseMessaging.instance.requestPermission();
    }
    if (buildContext.mounted) {
      initNotificationListener(buildContext);
    }
  }

  static void initNotificationListener(BuildContext buildContext) {
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationUtility.onActionReceivedMethod,
      onNotificationCreatedMethod:
          NotificationUtility.onNotificationCreatedMethod,
      onNotificationDisplayedMethod:
          NotificationUtility.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod:
          NotificationUtility.onDismissActionReceivedMethod,
    );
    openAppStreamSubscription =
        FirebaseMessaging.onMessage.listen(foregroundMessageListener);
    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
    onMessageOpenAppStreamSubscription =
        FirebaseMessaging.onMessageOpenedApp.listen((remoteMessage) {
      onMessageOpenedAppListener(remoteMessage, buildContext);
    });
  }

  @pragma('vm:entry-point')
  static Future<void> onBackgroundMessage(RemoteMessage remoteMessage) async {
    if (!notificaitonTypesToNotIncrementCount
        .contains(remoteMessage.data["type"])) {
      await Firebase.initializeApp();
      int oldCount = await SettingsRepository().getNotificationCount();
      await SettingsRepository().setNotificationCount(oldCount + 1);
    }
    if (Platform.isAndroid) {
      createLocalNotification(dimissable: true, message: remoteMessage);
    }
  }

  static Future<void> foregroundMessageListener(
    RemoteMessage remoteMessage,
  ) async {
    await FirebaseMessaging.instance.getToken();
    if (!notificaitonTypesToNotIncrementCount
        .contains(remoteMessage.data["type"])) {
      int oldCount = await SettingsRepository().getNotificationCount();
      notificationCountValueNotifier.value = oldCount + 1;
      await SettingsRepository().setNotificationCount(oldCount + 1);
    }
    if (Platform.isAndroid) {
      createLocalNotification(dimissable: true, message: remoteMessage);
    }
  }

  static void onMessageOpenedAppListener(
    RemoteMessage remoteMessage,
    BuildContext buildContext,
  ) {
    _onTapNotificationScreenNavigateCallback(
      remoteMessage.data['type'] ?? "",
      remoteMessage.data,
    );
  }

  static void _onTapNotificationScreenNavigateCallback(
    String notificationType,
    Map<String, dynamic> data,
  ) {
    if (notificationType == customNotificationType) {
      UiUtils.rootNavigatorKey.currentState?.pushNamed(Routes.notifications);
    } else if (notificationType == assignmentSubmissionNotificationType) {
      UiUtils.rootNavigatorKey.currentState?.pushNamed(Routes.assignments);
    }
  }

  static Future<void> initializeAwesomeNotification() async {
    await AwesomeNotifications().initialize(null, [
      NotificationChannel(
        channelKey: notificationChannelKey,
        channelName: 'Basic notifications',
        channelDescription:
            'Notification channel for announcements and other notifications.',
        vibrationPattern: highVibrationPattern,
        importance: NotificationImportance.High,
      ),
    ]);
  }

  static Future<bool> isLocalNotificationAllowed() async {
    const notificationPermission = Permission.notification;
    final status = await notificationPermission.status;
    return status.isGranted;
  }

  /// Use this method to detect when a new notification or a schedule is created
  static Future<void> onNotificationCreatedMethod(
    ReceivedNotification receivedNotification,
  ) async {
    // Your code goes here
  }

  /// Use this method to detect every time that a new notification is displayed
  static Future<void> onNotificationDisplayedMethod(
    ReceivedNotification receivedNotification,
  ) async {
    // Your code goes here
  }

  /// Use this method to detect if the user dismissed a notification
  static Future<void> onDismissActionReceivedMethod(
    ReceivedAction receivedAction,
  ) async {
    // Your code goes here
  }

  /// Use this method to detect when the user taps on a notification or action button
  static Future<void> onActionReceivedMethod(
    ReceivedAction receivedAction,
  ) async {
    if (Platform.isAndroid) {
      _onTapNotificationScreenNavigateCallback(
        (receivedAction.payload ?? {})['type'] ?? "",
        Map.from(receivedAction.payload ?? {}),
      );
    }
  }

  static Future<void> createLocalNotification({
    required bool dimissable,
    required RemoteMessage message,
  }) async {
    String title = "";
    String body = "";
    String type = "";
    String? image;

    if (message.notification != null) {
      title = message.notification?.title ?? "";
      body = message.notification?.body ?? "";
    } else {
      title = message.data["title"] ?? "";
      body = message.data["body"] ?? "";
    }
    type = message.data['type'] ?? "";
    image = message.data['image'];

    if (image == null) {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: Random().nextInt(5000),
          autoDismissible: dimissable,
          title: title,
          body: body,
          locked: !dimissable,
          wakeUpScreen: true,
          payload: {"type": type},
          channelKey: notificationChannelKey,
          notificationLayout: NotificationLayout.BigText,
        ),
      );
    } else {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: Random().nextInt(5000),
          autoDismissible: dimissable,
          title: title,
          body: body,
          locked: !dimissable,
          wakeUpScreen: true,
          bigPicture: image,
          payload: {"type": type},
          channelKey: notificationChannelKey,
          notificationLayout: NotificationLayout.BigPicture,
        ),
      );
    }
  }

  //remove when logging out to prevent multi-listeners
  static removeListener() {
    try {
      openAppStreamSubscription?.cancel();
      onMessageOpenAppStreamSubscription?.cancel();
      SettingsRepository().setNotificationCount(0);
    } catch (_) {}
  }
}
