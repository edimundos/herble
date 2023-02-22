import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:herble/water_confirmation.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'globals.dart' as globals;
import 'package:http/http.dart' as http;

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
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );
  }

  void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      globals.Plant plant =
          await getPlantsById(int.parse(notificationResponse.payload!));
      (BuildContext context) => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WaterConfirm(plant: plant)),
          );
    }
  }

  Future<globals.Plant> getPlantsById(int id) async {
    String url = 'https://herbledb.000webhostapp.com/get_plant_by_id.php';
    try {
      var response =
          await http.post(Uri.parse(url), body: {'id': id.toString()});

      if (response.statusCode == 200) {
        List<dynamic> plants = json
            .decode(response.body)
            .map((data) => globals.Plant.fromJson(data as Map<String, dynamic>))
            .toList();
        return plants[0];
      } else {
        throw Exception('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions here
      throw e;
    }
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

  Future<void> scheduleReminder(int notificationId, String title, String body,
      Duration repeatInterval) async {
    await initNotification();
    requestIOSPermissions;
    tz.initializeTimeZones();
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
        ),
        iOS: DarwinNotificationDetails(
          sound: 'default.wav',
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: notificationId.toString(),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> scheduleNotification(int notificationId, String title,
      String body, Time notificationTime, Duration repeatInterval) async {
    await initNotification();
    requestIOSPermissions;
    tz.initializeTimeZones();
    print(tz.TZDateTime.now(tz.local));
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
      payload: notificationId.toString(),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> logActiveNotifications() async {
    initNotification();
    print(tz.TZDateTime.now(tz.local));
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
