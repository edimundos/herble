import 'package:flutter/material.dart';
import 'package:herble/home_page.dart';
import 'package:herble/log_in.dart';
import 'package:herble/notificationservice.dart';
import 'package:herble/sign_up.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

Future<void> main() async {
  runApp(const MyApp());
  await NotificationService().initNotification();
  tz.initializeTimeZones();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Server',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(
        title: 'herble',
      ),
    );
  }
}
