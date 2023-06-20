import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:herble/main_page/plants/individual_plant/individual_plant.dart';
import 'package:herble/main_page/plants/plant_page.dart';
import 'package:herble/main_page/plants/individual_plant/post_update_screen.dart';
import 'package:http/http.dart' as http;
import 'package:herble/globals.dart' as globals;
import 'package:flutter/material.dart';

class UpdatePlantTechnicalities extends StatefulWidget {
  final globals.Plant plant;
  final Uint8List pic;

  const UpdatePlantTechnicalities(
      {Key? key, required this.plant, required this.pic})
      : super(key: key);

  @override
  State<UpdatePlantTechnicalities> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePlantTechnicalities> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PlantUpdateForm(plant: widget.plant, pic: widget.pic));
  }
}

class PlantUpdateForm extends StatefulWidget {
  final globals.Plant plant;
  final Uint8List pic;

  const PlantUpdateForm({Key? key, required this.plant, required this.pic})
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
                                Navigator.of(context).pop();
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
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextField(
                    controller: dayController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Days',
                      hintText:
                          'enter how often you want your plant to be watered',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    controller: volumeController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Volume',
                      hintText: 'enter how much water you want on your plant',
                    ),
                  ),
                ),
                ElevatedButton(
                    // ignore: sort_child_properties_last
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Confirm",
                          style: GoogleFonts.cormorantGaramond(
                            fontSize: 20,
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
                        dayController.text,
                        volumeController.text,
                      );
                      if (validator == 100 && globals.isLoggedIn) {
                        sendToChip(
                          int.parse(dayController.text),
                          int.parse(volumeController.text),
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PostUpdate(
                                    plant: widget.plant,
                                    days: int.parse(dayController.text),
                                    volume: int.parse(volumeController.text),
                                    picture: widget.pic,
                                  )),
                        );
                      } else if (validator == 103) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: const Text('day count must be an int'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, 'sorry'),
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
                              content:
                                  const Text('Water volume must be an int'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, 'sorry'),
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
                                  onPressed: () =>
                                      Navigator.pop(context, 'sorry'),
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
                                  onPressed: () =>
                                      Navigator.pop(context, 'sorry'),
                                  child: const Text('sorry'),
                                ),
                              ],
                            );
                          },
                        );
                      } else if (validator == 108) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: const Text(
                                  'This pot cannot hold more than 1050ml'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, 'sorry'),
                                  child: const Text('sorry'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    }),
              ],
            )));
  }

  Future<void> updatePlant(
      String name, String desc, int days, String pic, int volume) async {
    String url = 'https://herbledb.000webhostapp.com/update_plant.php';
    await http.post(Uri.parse(url), body: {
      'id': widget.plant.plantId.toString(),
      'plant_name': name,
      'plant_description': desc,
      'day_count': days.toString(),
      'picture': pic,
      'water_volume': volume.toString(),
    });
  }

  int dataIsValid(String days, String volume) {
    if (days.isEmpty) return 106;
    if (volume.isEmpty) return 107;
    if (int.tryParse(days) == null) return 103;
    if (int.tryParse(volume) == null) return 104;
    if (int.parse(volume) > 1050) return 108;
    return 100;
  }

  Future<void> sendToChip(int days, int volume) async {
    String url = 'http://192.168.4.1/?var1=$days&var2=$volume';
    await http.post(Uri.parse(url));
  }

  Future<bool> checkIfUrlIsAccessible() async {
    try {
      final response = await Future.any([
        http.get(Uri.parse("http://192.168.4.1/")),
        Future.delayed(const Duration(seconds: 3), () => null),
      ]);
      if (response == null) {
        throw Exception("Request timed out");
      }
      if (response.statusCode == 200) {
        return true;
      }
    } catch (_) {
      return false;
    }
    return false;
  }
}
