import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:herble/colors.dart';
import 'package:herble/firebase_messaging.dart';
import 'package:herble/globals.dart';
import 'package:herble/start_page/home_page.dart';
import 'package:http/http.dart' as http;
import 'globals.dart' as globals;

final navigatorKey = GlobalKey<NavigatorState>();

//@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  //await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Firebase.initializeApp();
  FirebaseMessaging.instance.getToken().then((value) {
    globals.fcmToken = value!;
    print('Token: ${globals.fcmToken}');
  });
  NotificationServices notificationServices = NotificationServices();
  notificationServices.RequestNotificationPermission();
  runApp(const MyApp());

  globals.allInstructions = await getAllInstructions();
  globals.allTips = await getAllTips();

  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user == null) {
      print('User is currently signed out!');
    } else {
      print('User is signed in!');
    }
  });

  FirebaseAuth.instance.idTokenChanges().listen((User? user) {
    if (user == null) {
      print('User is currently signed out! token');
    } else {
      print('User is signed in! token');
    }
  });

  FirebaseAuth.instance.userChanges().listen((User? user) {
    if (user == null) {
      print('User is currently signed out! uc');
    } else {
      print('User is signed in! uc');
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Flutter Server',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        canvasColor: Colors.transparent,
        primaryColor: Color.fromARGB(255, 34, 65, 54),
        primarySwatch: mainpallete,
      ),
      home: const Scaffold(
        body: AppStartPage(),
      ),
    );
  }
}

Future<List<Tip>> getAllTips() async {
  String url = 'https://herbledb.000webhostapp.com/get_all_tips.php';
  try {
    var response = await http.post(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      List<Tip> tips = jsonList.map((data) => Tip.fromJson(data)).toList();
      return tips;
    } else {
      throw Exception('Request failed with status: ${response.statusCode}');
    }
  } catch (e) {
    // Handle exceptions here
    throw e;
  }
}

Future<List<Instruction>> getAllInstructions() async {
  String url = 'https://herbledb.000webhostapp.com/get_all_instructions.php';
  try {
    var response = await http.post(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      List<Instruction> instructions =
          jsonList.map((data) => Instruction.fromJson(data)).toList();
      return instructions;
    } else {
      throw Exception('Request failed with status: ${response.statusCode}');
    }
  } catch (e) {
    // Handle exceptions here
    throw e;
  }
}
