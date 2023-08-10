import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';
import 'package:herble/globals.dart' as globals;

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  FirebaseApi();

  Future<void> initNotifications() async {
    globals.fcmToken = (await _firebaseMessaging.getToken())!;
    print('Token: ${globals.fcmToken}');
    initPushNotifications();
    initLocalNotifications();
  }

  Future<void> sendPushNotification({
    required String plantName,
    required DateTime notificationDateTime,
  }) async {
    await _firebaseMessaging.requestPermission();

    final payload = {
      'plantName': plantName,
      'notificationDateTime': notificationDateTime.toString(),
    };

    await _firebaseMessaging.sendMessage(
      to: globals.fcmToken,
      data: payload,
    );
  }

  void initPushNotifications() {
    // Initialize push notifications
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification != null) {
        showLocalNotification(
          id: 1,
          title: notification.title ?? '',
          body: notification.body ?? '',
        );
      }
    });

    // FirebaseMessaging.onMessageOpenedApp.listen((message) {
    //   final payload = message.data;
    //   notificationService.onNotificationClick.add(
    //     jsonEncode(payload),
    //   );
    // });
  }

  void initLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await _localNotifications.initialize(
      initializationSettings,
    );
  }

  final _localNotifications = FlutterLocalNotificationsPlugin();

  Future<void> showLocalNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      channelDescription: 'channel_description',
      importance: Importance.high,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await _localNotifications.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: jsonEncode({'notification': body}),
    );
  }
}
