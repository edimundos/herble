import 'package:flutter/material.dart';
import 'globals.dart' as globals;

class IndividualPlant extends StatefulWidget {
  final globals.Plant plant;

  const IndividualPlant({Key? key, required this.plant}) : super(key: key);

  @override
  _IndividualPlantState createState() => _IndividualPlantState();
}

class _IndividualPlantState extends State<IndividualPlant> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: Text(widget.plant.plantName),
      ),
      body: Center(
        child: Text("plant id:${widget.plant.plantDescription}"),
      ),
    );
  }
}
