import 'package:flutter/material.dart';
import 'globals.dart' as globals;

class IndividualTip extends StatefulWidget {
  globals.Tip tip;
  IndividualTip({super.key, required this.tip});

  @override
  State<IndividualTip> createState() => _IndividualTipState();
}

class _IndividualTipState extends State<IndividualTip> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: Column(
        children: [
          Text(
            widget.tip.title,
            style: TextStyle(fontSize: 23),
          ),
          Text(
            widget.tip.description,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
