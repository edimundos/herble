import 'package:flutter/material.dart';

class TestNotifs extends StatefulWidget {
  const TestNotifs({super.key});

  @override
  State<TestNotifs> createState() => _TestNotifsState();
}

class _TestNotifsState extends State<TestNotifs> {
  String message = "";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = ModalRoute.of(context)!.settings.arguments;

    if (arguments != null) {
      Map? pushArguments = arguments as Map;
      setState(() {
        message = pushArguments["message"];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Container(
            child: Text("Push message: $message"),
          ),
        ),
      ),
    );
  }
}
