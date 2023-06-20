import 'dart:convert';
import 'dart:typed_data';
import 'package:google_fonts/google_fonts.dart';
import 'package:herble/main_page/plants/change_picture.dart';
import 'package:herble/main_page/plants/individual_plant/individual_plant.dart';
import 'package:herble/main_page/main_page.dart';
import 'package:herble/main_page/plants/plant_page.dart';
import 'package:http/http.dart' as http;
import 'package:herble/globals.dart' as globals;
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        reverse: true,
        child: Column(
          children: [
            SizedBox(
                height: 100,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => IndividualPlant(
                                  plant: globals.currentPlant,
                                  pic: widget.pic,
                                ),
                              ),
                            );
                          },
                          child: const Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.all(15.0),
                              child: Image(
                                image: AssetImage("assets/backButton.png"),
                              ),
                            ),
                          )),
                    ),
                    Text(
                      "Update",
                      textAlign: TextAlign.left,
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        height: 1,
                        color: const Color.fromARGB(255, 32, 54, 50),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Spacer(),
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.all(25.0),
                        child: Image(
                          image: AssetImage("assets/herble_logo.png"),
                        ),
                      ),
                    )
                  ],
                )),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          PicturePage(pic: widget.pic, cum: 2)),
                );
              },
              child: ClipRRect(
                clipBehavior: Clip.hardEdge,
                borderRadius: BorderRadius.circular(35),
                child: Stack(
                  children: [
                    Image.memory(
                      widget.pic,
                      width: 200.0,
                      height: 200.0,
                      fit: BoxFit.cover,
                    ),
                    const Positioned(
                      bottom: 10,
                      right: 10,
                      child: Icon(
                        Icons.edit,
                        color: Colors.black45,
                        size: 50.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Plant name',
                  hintText: 'enter your plants name',
                ),
                validator: validateName,
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
            ElevatedButton(
              // ignore: sort_child_properties_last
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Confirm",
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      height: 1,
                      color: Color.fromARGB(255, 255, 255, 255),
                    )),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 177, 177, 177),
                elevation: 0,
              ),
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
                    MaterialPageRoute(builder: (context) => MainPage(index: 1)),
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
                        content: const Text(
                            'Plant description length must be < 2000'),
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
            ),
          ],
        ),
      ),
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
  }

  String? validateName(String? value) {
    if (value!.length < 3) {
      return 'Name must be more than 2 charaters';
    }
    if (value.length > 250) {
      return 'Name cant be more than 250 characters';
    } else {
      return null;
    }
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
