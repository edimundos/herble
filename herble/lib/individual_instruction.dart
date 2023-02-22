import 'package:flutter/material.dart';
import 'globals.dart' as globals;

class IndividualInstruction extends StatefulWidget {
  globals.Instruction instruction;
  IndividualInstruction({super.key, required this.instruction});

  @override
  State<IndividualInstruction> createState() => _IndividualInstructionState();
}

class _IndividualInstructionState extends State<IndividualInstruction> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: Column(
        children: [
          Text(
            widget.instruction.question,
            style: TextStyle(fontSize: 23),
          ),
          Text(
            widget.instruction.answer,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
