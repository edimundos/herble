import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:herble/plant_page.dart';
import 'globals.dart' as globals;

class AddPlantPage extends StatefulWidget {
  const AddPlantPage({super.key});

  @override
  State<AddPlantPage> createState() => _AddPlantPageState();
}

class _AddPlantPageState extends State<AddPlantPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add a plant"),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: const PlantForm(),
    );
  }
}

class PlantForm extends StatefulWidget {
  const PlantForm({super.key});

  @override
  State<PlantForm> createState() => _PlantFormState();
}

class _PlantFormState extends State<PlantForm> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final dayController = TextEditingController();
  final volumeController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    dayController.dispose();
    volumeController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Plant name',
              hintText: 'enter your plants name',
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            controller: descriptionController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Description',
              hintText: 'enter your plants description',
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            controller: dayController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Days',
              hintText: 'enter how often you want your plant to be watered',
            ),
          ),
        ),
        Padding(
          //te ganjau vajadzes kaut kādu check box ar dazadiem variantiem or smth un tad pedejais variants "Custom:"
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            controller: volumeController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Volume',
              hintText: 'enter how much water you want on your plant',
            ),
          ),
        ),
        TextButton(
          onPressed: () async {
            int validator = dataIsValid(
              nameController.text,
              descriptionController.text,
              dayController.text,
              volumeController.text,
            );
            if (validator == 100 && globals.isLoggedIn) {
              await postPlant(
                nameController.text,
                descriptionController.text,
                int.parse(dayController.text),
                "0",
                int.parse(volumeController.text),
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const PlantListScreen()),
              );
            } else if (validator == 101) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: const Text('Plant name length must be < 250'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'sorry'),
                        child: const Text('sorry'),
                      ),
                    ],
                  );
                },
              );
            } else if (validator == 102) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content:
                        const Text('Plant description length must be < 2000'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'sorry'),
                        child: const Text('sorry'),
                      ),
                    ],
                  );
                },
              );
            } else if (validator == 103) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: const Text('day count must be an int'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'sorry'),
                        child: const Text('sorry'),
                      ),
                    ],
                  );
                },
              );
            } else if (validator == 104) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: const Text('Water volume must be an int'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'sorry'),
                        child: const Text('sorry'),
                      ),
                    ],
                  );
                },
              );
            } else if (validator == 105) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: const Text('Plant name cant be empty'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'sorry'),
                        child: const Text('sorry'),
                      ),
                    ],
                  );
                },
              );
            } else if (validator == 106) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: const Text('Day count cant be empty'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'sorry'),
                        child: const Text('sorry'),
                      ),
                    ],
                  );
                },
              );
            } else if (validator == 107) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: const Text('Water volume cant be empty'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'sorry'),
                        child: const Text('sorry'),
                      ),
                    ],
                  );
                },
              );
            }
          },
          child: const Text('Confirm'),
        ),
      ],
    );
  }

  Future<void> postPlant(
      String plant, String desc, int days, String pic, int volume) async {
    String url = 'https://herbledb.000webhostapp.com/post_plant.php';
    await http.post(Uri.parse(url), body: {
      'user_id': globals.userID.toString(),
      'plant_name': plant,
      'plant_description': desc,
      'day_count': days.toString(),
      'picture': pic,
      'water_volume': volume.toString(),
    });
  }

  int dataIsValid(String species, String desc, String days, String volume) {
    if (species.isEmpty) return 105;
    if (days.isEmpty) return 106;
    if (volume.isEmpty) return 107;
    if (species.length > 250) return 101;
    if (desc.length > 2000) return 102;
    if (int.tryParse(days) == null) return 103;
    if (int.tryParse(volume) == null) return 104;
    return 100;
  }
}
