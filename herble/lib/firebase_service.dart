// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// final flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
// final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

// void setupFirebaseAndLocalNotification() async {
//   var initializationSettingsAndroid =
//       new AndroidInitializationSettings('notification_icon_push');

//   var initializationSettingsIOS = DarwinInitializationSettings();

//   var initializationSettings = InitializationSettings(
//       android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

//   flutterLocalNotificationsPlugin.initialize(initializationSettings,
//       onDidReceiveNotificationResponse: onSelect);

//   final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

//   firebaseMessaging.getToken().then((value) => print(value));
//   _firebaseMessaging.configure(
//     onBackgroundMessage: Platform.isIOS ? null : myBackgroundMessageHandler,
//     onMessage: (message) async {
//       print("onMessage: $message");
//     },
//     onLaunch: (message) async {
//       print("onLaunch: $message");
//     },
//     onResume: (message) async {
//       print("onResume: $message");
//     },
//   );
// }