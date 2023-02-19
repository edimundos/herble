import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() {
  tz.initializeTimeZones();
}

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService._internal();

  Future<void> initNotification() async {
    // Android initialization
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_notification');

    // ios initialization
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);
    // the initialization settings are initialized after they are setted
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  tz.TZDateTime _nextInstanceOfTime(Time notificationTime) {
    tz.initializeTimeZones();
    final timeZone = tz.getLocation('Europe/Riga');
    final now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
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

  Future<void> scheduleNotification(int notificationId, String title,
      String body, Time notificationTime, Duration repeatInterval) async {
    await initNotification();
    requestIOSPermissions;
    tz.initializeTimeZones();
    print(_nextInstanceOfTime(notificationTime).add(repeatInterval));
    await flutterLocalNotificationsPlugin.zonedSchedule(
      notificationId,
      title,
      body,
      //tz.TZDateTime.now(tz.local).add(Duration(seconds: 3)),
      _nextInstanceOfTime(notificationTime).add(repeatInterval),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'repeating notification channel id',
          'repeating notification',
          channelDescription: 'notifications for water fill-up',
          importance: Importance.max,
          priority: Priority.max,
        ),
        iOS: DarwinNotificationDetails(
          sound: 'default.wav',
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> logActiveNotifications() async {
    initNotification();
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
    initNotification();
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    initNotification();
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
