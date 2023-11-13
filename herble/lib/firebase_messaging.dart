import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:herble/notifications/water_confirmation.dart';
import '../globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart'
    show FirebaseMessaging, RemoteMessage;

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  void RequestNotificationPermission() async {
    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void initLocalNotifications(
      BuildContext context, RemoteMessage message) async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_notification');
    DarwinInitializationSettings IOSInitializationSettings =
        const DarwinInitializationSettings();
    InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: IOSInitializationSettings);
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (payload) async {
      globals.Plant plant =
          await getPlantsById(int.parse(message.data['plantID']));
      handleMessage(context, message, plant);
    });
  }

  Future<void> FirebaseInit(BuildContext context) async {
    FirebaseMessaging.onMessage.listen((message) {
      initLocalNotifications(context, message);
      showNotification(message);
    });
  }

  Future<void> showNotification(RemoteMessage message) async {
    print("show message");
    globals.currentPlant =
        await getPlantsById(int.parse(message.data['plantID']));
    AndroidNotificationChannel channel = AndroidNotificationChannel(
        Random.secure().nextInt(100000).toString(),
        'High importance notification');

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            channel.id.toString(), channel.name.toString(),
            channelDescription: 'Water reminder',
            importance: Importance.max,
            priority: Priority.max,
            ticker: 'ticker');

    DarwinNotificationDetails darwinNotificationDetails =
        const DarwinNotificationDetails(
      sound: 'default.wav',
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);

    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
          0,
          message.notification!.title.toString(),
          message.notification!.body.toString(),
          notificationDetails);
    });
  }

  Future<void> setupInteractMessage(BuildContext context) async {
    //terminated app
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      globals.Plant plant =
          await getPlantsById(int.parse(initialMessage.data['plantID']));
      handleMessage(context, initialMessage, plant);
    }

    //app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((event) async {
      print("backgroubd " + event.data['plantID']);
      globals.Plant plant =
          await getPlantsById(int.parse(event.data['plantID']));
      handleMessage(context, event, plant);
    });
  }

  void handleMessage(
      BuildContext context, RemoteMessage message, globals.Plant plant) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: ((context) =>
                //(WaterConfirm(plantID: int.parse(message.data['plantID']))))));
                (WaterConfirm(currentPlant: plant)))));
  }
}

Future<globals.Plant> getPlantsById(int id) async {
  print("AAAAAAAAAAAAA " + id.toString());
  String url = 'https://herbledb.000webhostapp.com/get_plant_by_id.php';
  try {
    var response = await http.post(Uri.parse(url), body: {'id': id.toString()});
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
