import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:herble/main_page.dart';
import 'package:herble/plant_page.dart';
import 'package:herble/pre_update_screen.dart';
import 'package:herble/update_plant_basics.dart';
import 'package:herble/update_plant_technicalities.dart';
import 'globals.dart' as globals;
import 'package:http/http.dart' as http;

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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MainPage(index: 1)),
            );
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
  bool isLoading = false;
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
        TextButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return UpdatePlantBasics(
                      plant: widget.plant, pic: widget.pic);
                },
              ),
            );
          },
          child: const Text('Edit plant basics'),
        ),
        Text("day count:${widget.plant.dayCount}"),
        Text("water volume:${widget.plant.waterVolume}"),
        TextButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return PreUpdateScreen(plant: widget.plant, pic: widget.pic);
                },
              ),
            );
          },
          child: const Text('Edit plant technicalities'),
        ),
        TextButton(
          onPressed: () async {
            bool? confirmed = await showConfirmationDialog(context);
            if (confirmed != null && confirmed) {
              await deletePlant(widget.plant.plantId);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MainPage(index: 1)),
              );
            }
          },
          child: const Text('Delete plant'),
        ),
        !isLoading
            ? Center(
                child: ElevatedButton(
                  child: const Text("Water now"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[300],
                    elevation: 0,
                  ),
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    if (await checkIfUrlIsAccessible()) {
                      waterNow();
                      setState(() {
                        isLoading = false;
                      });
                    } else {
                      setState(() {
                        isLoading = false;
                      });
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: const Text(
                                  'Connect to the plant pot wifi to water it'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, 'sorry'),
                                  child: const Text('sorry'),
                                ),
                              ],
                            );
                          });
                    }
                  },
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ],
    );
  }

  Future<void> waterNow() async {
    String url = 'http://192.168.4.1/?var1=-1&var2=-1';
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

  Future<bool?> showConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete'),
          content: const Text('Are you sure you want to delete this plant?'),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Yes',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> deletePlant(int id) async {
    await http.post(
      Uri.parse('https://herbledb.000webhostapp.com/delete_plant.php'),
      body: {'plant_id': id.toString()},
    );
  }
}
