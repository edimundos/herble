import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:herble/change_picture.dart';
import 'package:herble/connect_to_internet_page.dart';
import 'package:herble/main_page.dart';
import 'package:http/http.dart' as http;
import 'package:herble/plant_page.dart';
import 'globals.dart' as globals;
import 'package:google_fonts/google_fonts.dart';

class AddPlantPage extends StatefulWidget {
  Uint8List pic;
  int? picId;

  AddPlantPage({Key? key, required this.pic, this.picId}) : super(key: key);

  @override
  State<AddPlantPage> createState() => _AddPlantPageState();
}

class _AddPlantPageState extends State<AddPlantPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PlantForm(pic: widget.pic, picId: widget.picId),
    );
  }
}

class PlantForm extends StatefulWidget {
  Uint8List pic;
  int? picId;

  PlantForm({super.key, required this.pic, this.picId});

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
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
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
                                    builder: (context) => MainPage(
                                          index: 1,
                                        )),
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
                        "Add Plant",
                        textAlign: TextAlign.left,
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 42,
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
              SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  reverse: true,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    PicturePage(pic: widget.pic, cum: 1)),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(35),
                            border: Border.all(
                              color: Colors.black45,
                              width: 2,
                            ),
                          ),
                          child: ClipRRect(
                            clipBehavior: Clip.hardEdge,
                            borderRadius: BorderRadius.circular(35),
                            child: Image.memory(
                              widget.pic,
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 16),
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 16),
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          controller: dayController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Days',
                            hintText:
                                'enter how often you want your plant to be watered',
                          ),
                        ),
                      ),
                      Padding(
                        //te ganjau vajadzes kaut kādu check box ar dazadiem variantiem or smth un tad pedejais variants "Custom:"
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          controller: volumeController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Volume',
                            hintText:
                                'enter how much water you want on your plant',
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          int validator = await dataIsValid(
                            nameController.text,
                            descriptionController.text,
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
                                  builder: (context) => ConnectInternet(
                                        plant: nameController.text,
                                        desc: descriptionController.text,
                                        days: int.parse(dayController.text),
                                        pic: base64Encode(widget.pic),
                                        picId: widget.picId,
                                        volume:
                                            int.parse(volumeController.text),
                                      )),
                            );
                          } else if (validator == 101) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: const Text(
                                      'Plant name length must be < 250'),
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
                          } else if (validator == 102) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: const Text(
                                      'Plant description length must be < 2000'),
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
                          } else if (validator == 103) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content:
                                      const Text('day count must be an int'),
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
                          } else if (validator == 105) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content:
                                      const Text('Plant name cant be empty'),
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
                                  content:
                                      const Text('Day count cant be empty'),
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
                                  content:
                                      const Text('Water volume cant be empty'),
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
                                      'Must be connected to plant pot'),
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
                          } else if (validator == 109) {
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
                        },
                        child: const Text('Confirm'),
                      ),
                    ],
                  )),
            ],
          ),
        ));
  }

  Future<int> dataIsValid(
      String species, String desc, String days, String volume) async {
    if (species.isEmpty) return 105;
    if (days.isEmpty) return 106;
    if (volume.isEmpty) return 107;
    if (species.length > 250) return 101;
    if (desc.length > 2000) return 102;
    if (int.tryParse(days) == null) return 103;
    if (int.tryParse(volume) == null) return 104;
    if (!await checkIfUrlIsAccessible()) return 108;
    if (int.parse(volume) > 1050) return 109;
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
