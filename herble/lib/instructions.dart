import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:herble/individual_instruction.dart';
import 'globals.dart' as globals;
import 'package:http/http.dart' as http;

class Instructions extends StatefulWidget {
  const Instructions({super.key});

  @override
  State<Instructions> createState() => _InstructionsState();
}

class _InstructionsState extends State<Instructions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Instructions"),
        automaticallyImplyLeading: false,
      ),
      body: const InstructionsForm(),
    );
  }
}

class InstructionsForm extends StatefulWidget {
  const InstructionsForm({super.key});

  @override
  State<InstructionsForm> createState() => _InstructionsFormState();
}

class _InstructionsFormState extends State<InstructionsForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: globals.allInstructions!.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(globals.allInstructions![index].question),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => IndividualInstruction(
                    instruction: globals.allInstructions![index],
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
