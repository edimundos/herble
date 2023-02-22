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
      body: FutureBuilder(
        future: getAllInstructions(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<dynamic> instructions = json
                .decode(snapshot.data ?? "[{}]")
                .map((data) =>
                    globals.Instruction.fromJson(data as Map<String, dynamic>))
                .toList();
            return ListView.builder(
                itemCount: instructions.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(instructions[index].question),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => IndividualInstruction(
                            instruction: instructions[index],
                          ),
                        ),
                      );
                    },
                  );
                });
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Future<String> getAllInstructions() async {
    String url = 'https://herbledb.000webhostapp.com/get_all_instructions.php';
    try {
      var response = await http.post(Uri.parse(url));

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions here
      throw e;
    }
  }
}
