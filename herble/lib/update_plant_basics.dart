import 'dart:convert';
import 'dart:typed_data';
import 'package:herble/change_picture.dart';
import 'package:herble/individual_plant.dart';
import 'package:herble/plant_page.dart';
import 'package:http/http.dart' as http;
import 'globals.dart' as globals;
import 'package:flutter/material.dart';

class UpdatePlantBasics extends StatefulWidget {
  final globals.Plant plant;
  final Uint8List pic;
  int? picId;

  UpdatePlantBasics(
      {Key? key, required this.plant, required this.pic, this.picId})
      : super(key: key);

  @override
  State<UpdatePlantBasics> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePlantBasics> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Update"),
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios_new),
          ),
        ),
        body: PlantUpdateForm(
          plant: widget.plant,
          pic: widget.pic,
          picId: widget.picId,
        ));
  }
}

class PlantUpdateForm extends StatefulWidget {
  final globals.Plant plant;
  final Uint8List pic;
  int? picId;

  PlantUpdateForm(
      {Key? key, required this.plant, required this.pic, required this.picId})
      : super(key: key);

  @override
  State<PlantUpdateForm> createState() => _PlantUpdateFormState();
}

class _PlantUpdateFormState extends State<PlantUpdateForm> {
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

  @override
  void initState() {
    nameController.text = widget.plant.plantName;
    descriptionController.text = widget.plant.plantDescription;
    dayController.text = widget.plant.dayCount.toString();
    volumeController.text = widget.plant.waterVolume.toString();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PicturePage(pic: widget.pic, cum: 2)),
              );
            },
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 3,
                ),
                shape: BoxShape.circle,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.memory(
                  widget.pic,
                  width: 120,
                  height: 120,
                ),
              ),
            )),
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
        TextButton(
          onPressed: () async {
            int validator = dataIsValid(
              nameController.text,
              descriptionController.text,
              dayController.text,
              volumeController.text,
            );
            if (validator == 100 && globals.isLoggedIn) {
              await updatePlant(
                nameController.text,
                descriptionController.text,
                int.parse(dayController.text),
                widget.pic,
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

  Future<void> updatePlant(
      String name, String desc, int days, Uint8List pic, int volume) async {
    String url = 'https://herbledb.000webhostapp.com/update_plant.php';
    String picture;
    if (widget.picId != null) {
      picture = widget.picId.toString();
    } else {
      picture = base64Encode(pic).toString();
    }
    await http.post(Uri.parse(url), body: {
      'id': widget.plant.plantId.toString(),
      'plant_name': name,
      'plant_description': desc,
      'day_count': days.toString(),
      'picture': picture,
      'water_volume': volume.toString(),
    });
    print(base64Encode(pic));
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
