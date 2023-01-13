import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:herble/update_plant.dart';
import 'globals.dart' as globals;

class IndividualPlant extends StatefulWidget {
  final globals.Plant plant;
  final Uint8List pic;

  const IndividualPlant({Key? key, required this.plant, required this.pic})
      : super(key: key);

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
      body: bodyForm(plant: widget.plant, pic: widget.pic),
    );
  }
}

class bodyForm extends StatefulWidget {
  final globals.Plant plant;
  final Uint8List pic;

  const bodyForm({Key? key, required this.plant, required this.pic})
      : super(key: key);

  @override
  State<bodyForm> createState() => _bodyFormState();
}

class _bodyFormState extends State<bodyForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.memory(
          widget.pic,
          width: 200.0,
          height: 200.0,
          fit: BoxFit.cover,
        ),
        Text("plant name:${widget.plant.plantName}"),
        Text("plant description:${widget.plant.plantDescription}"),
        Text("day count:${widget.plant.dayCount}"),
        Text("water volume:${widget.plant.waterVolume}"),
        TextButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return const UpdatePage();
                },
              ),
            );
          },
          child: const Text('Update plant'),
        ),
      ],
    );
  }
}
