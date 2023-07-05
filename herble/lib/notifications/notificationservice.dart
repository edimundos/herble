// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

// final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  final int? payload = notificationResponse.id;
  if (payload != null) {
    NotificationService().onNotificationClick.add(payload.toString());
  }
}

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final BehaviorSubject<String?> onNotificationClick = BehaviorSubject();

  Future<void> initNotification() async {
    tz.initializeTimeZones();
    // Android initialization
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_notification');

    // ios initialization
    DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true, // Request permission on iOS
      requestBadgePermission: true, // Request permission on iOS
      requestSoundPermission: true, // Request permission on iOS
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {
        final int? payload = notificationResponse.id;
        if (payload != null) {
          onNotificationClick.add(payload.toString());
        }
      },
    );

    //FIREBASE
    // await firebaseMessaging.requestPermission(
    //   alert: true,
    //   announcement: false,
    //   badge: true,
    //   carPlay: false,
    //   criticalAlert: false,
    //   provisional: false,
    //   sound: true,
    // );
    // firebaseMessaging.getToken().then((value) => print(value));
    // firebaseMessaging.configure(
    //   onBackgroundMessage: Platform.isIOS ? null : myBackgroundMessageHandler,
    //   onMessage: (message) async {
    //     print("onMessage: $message");
    //   },
    //   onLaunch: (message) async {
    //     print("onLaunch: $message");
    //   },
    //   onResume: (message) async {
    //     print("onResume: $message");
    //   },
    // );
  }

  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {
    print("");
  }

  tz.TZDateTime _nextInstanceOfTime(Time notificationTime) {
    final timeZone = tz.getLocation('Europe/Riga');
    final now = tz.TZDateTime.now(timeZone);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      timeZone,
      now.year,
      now.month,
      // now.day + 1,
      now.day,
      notificationTime.hour,
      notificationTime.minute,
      3,
    );
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  Future<void> scheduleReminder(int notificationId, String title, String body,
      Duration repeatInterval) async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
    requestIOSPermissions;
    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        notificationId,
        title,
        body,
        tz.TZDateTime.now(tz.local).add(repeatInterval),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'reminder notification channel id',
            'reminder notification',
            channelDescription: 'reminder for water fill-up',
            importance: Importance.max,
            priority: Priority.max,
            playSound: true,
          ),
          iOS: DarwinNotificationDetails(
            sound: 'default.wav',
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: notificationId.toString(),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    } catch (e) {
      print('Error scheduling notification: $e');
    }
  }

  Future<void> scheduleNotification(int notificationId, String title,
      String body, Time notificationTime, Duration repeatInterval) async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
    requestIOSPermissions;
    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        notificationId,
        title,
        body,
        _nextInstanceOfTime(notificationTime).add(repeatInterval),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'scheduled notification channel id',
            'scheduled notification',
            channelDescription: 'notifications for water fill-up',
            importance: Importance.max,
            priority: Priority.max,
            playSound: true,
          ),
          iOS: DarwinNotificationDetails(
            sound: 'default.wav',
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: notificationId.toString(),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    } catch (e) {
      print('Error scheduling notification: $e');
    }
  }

  Future<void> logActiveNotifications() async {
    final List<PendingNotificationRequest> pendingNotificationRequests =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    print(
        'Number of active notifications: ${pendingNotificationRequests.length}');
    for (PendingNotificationRequest request in pendingNotificationRequests) {
      print(
          'Notification id: ${request.id}, title: ${request.title}, body: ${request.body}');
    }
  }

  Future<void> cancelNotificationById(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  void requestIOSPermissions(FlutterLocalNotificationsPlugin notifsPlugin) {
    notifsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }
}
