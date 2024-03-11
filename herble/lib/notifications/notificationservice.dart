import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:herble/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class NotificationService {
  final _firebaseMessaging = FirebaseMessaging.instance;

  NotificationService();

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

  Future<void> scheduleNotification(
    int plantId,
  ) async {
    await cancelNotificationByPlantID(plantId);
    globals.Plant plant = await getPlantsById(plantId);

    DateTime notificationTime = globals.wateringTime;
    Duration repeatInterval = Duration(
        days: getRefilDayCount(
            plant.dayCount.toDouble(), plant.waterVolume.toDouble()));
    DateTime combinedDateTime = notificationTime.add(repeatInterval);
    String formattedDateTime =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(combinedDateTime);
    print(formattedDateTime);

    String url = 'http://localhost:8060/api/notifications';
    await http.post(Uri.parse(url), body: {
      "title": "Refill water",
      "message": "Plant: ${plant.plantName}",
      "scheduleTime": formattedDateTime,
      "plantID": plantId.toString(),
      "plantName": plant.plantName,
      "token": globals.fcmToken
    });
  }

  Future<void> scheduleReminder(int plantId, Duration delay) async {
    await cancelNotificationByPlantID(plantId);
    globals.Plant plant = await getPlantsById(plantId);

    // Calculate the notification time by adding the delay to the current time
    DateTime notificationTime = DateTime.now().add(delay);
    String formattedDateTime =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(notificationTime);
    print(formattedDateTime);

    String url = 'http://localhost:8060/api/notifications';
    await http.post(Uri.parse(url), body: {
      "title": "Refill water",
      "message": "Plant: ${plant.plantName}",
      "scheduleTime": formattedDateTime,
      "plantID": plantId.toString(),
      "plantName": plant.plantName,
      "token": globals.fcmToken
    });
  }

  Future<void> cancelNotificationByPlantID(
    int plantId,
  ) async {
    String url = 'http://localhost:8060/api/notifications/cancel';
    await http.post(Uri.parse(url), body: {"plantID": plantId.toString()});
  }

  int getRefilDayCount(double days, double volume) {
    const double waterCapacity = 1.1;
    int refilDays;
    if (waterCapacity % volume == 0) {
      refilDays = ((waterCapacity / volume * 1000).floor() * days - 1).floor();
    } else {
      refilDays = ((waterCapacity / volume * 1000).floor() * days).floor();
    }
    return refilDays;
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
}
