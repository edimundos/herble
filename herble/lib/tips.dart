import 'package:flutter/material.dart';
import 'package:herble/individual_tip.dart';
import 'dart:convert';
import 'globals.dart' as globals;
import 'package:http/http.dart' as http;

class Tips extends StatefulWidget {
  const Tips({super.key});

  @override
  State<Tips> createState() => _TipsState();
}

class _TipsState extends State<Tips> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Plant tips"),
        automaticallyImplyLeading: false,
      ),
      body: TipForm(),
    );
  }
}

class TipForm extends StatefulWidget {
  const TipForm({super.key});

  @override
  State<TipForm> createState() => _TipFormState();
}

class _TipFormState extends State<TipForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: globals.allTips!.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(globals.allTips![index].title),
            subtitle: Text(
                "${globals.allTips![index].description.substring(0, 50)}..."),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => IndividualTip(
                    tip: globals.allTips![index],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
