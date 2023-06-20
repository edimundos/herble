import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:herble/start_page/firebase_options.dart';
import 'package:herble/globals.dart';
import 'package:herble/start_page/home_page.dart';
import 'package:herble/notifications/notificationservice.dart';
import 'package:herble/notifications/water_confirmation.dart';
import 'package:http/http.dart' as http;
import 'package:timezone/data/latest.dart' as tz;

import 'globals.dart' as globals;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
  await NotificationService().initNotification();
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

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const backgroundImage = DecorationImage(
      image: AssetImage('assets/StartUpPage.png'),
      fit: BoxFit.cover,
    );

    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Flutter Server',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.green, canvasColor: Colors.transparent),
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: backgroundImage,
          ),
          child: MyHomePage(),
        ),
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
