import 'package:flutter/material.dart';
import 'package:herble/home_page.dart';
import 'package:herble/log_in.dart';
import 'package:herble/sign_up.dart';

void main() {
  runApp(const MyApp());
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
