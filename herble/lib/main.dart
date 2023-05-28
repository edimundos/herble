import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:herble/globals.dart';
import 'package:herble/home_page.dart';
import 'package:herble/notificationservice.dart';
import 'package:herble/water_confirmation.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'globals.dart' as globals;
import 'package:http/http.dart' as http;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().initNotification();
  globals.allInstructions = await getAllInstructions();
  globals.allTips = await getAllTips();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const backgroundImage = DecorationImage(
      image: AssetImage('assets/StartUpPage.png'),
      fit: BoxFit.cover,
    );

    return MaterialApp(
      title: 'Flutter Server',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.green, canvasColor: Colors.transparent),
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: backgroundImage,
          ),
          child: MyHomePage(title: 'herble'),
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
