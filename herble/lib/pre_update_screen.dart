import 'dart:typed_data';
import 'package:herble/update_plant_technicalities.dart';

import 'globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:herble/plant_page.dart';
import 'add_plant.dart';
import 'package:http/http.dart' as http;

class PreUpdateScreen extends StatefulWidget {
  final globals.Plant plant;
  final Uint8List pic;

  const PreUpdateScreen({Key? key, required this.plant, required this.pic})
      : super(key: key);

  @override
  State<PreUpdateScreen> createState() => _PreUpdateScreenState();
}

class _PreUpdateScreenState extends State<PreUpdateScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update plant"),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PlantListScreen()),
            );
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: Column(
        children: [
          const Text("1. Turn on wifi on the herble pot "),
          const Text("2. Connect to the wifi from your device"),
          isLoading
              ? const CircularProgressIndicator()
              : TextButton(
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    if (await checkIfUrlIsAccessible()) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UpdatePlantTechnicalities(
                                plant: widget.plant, pic: widget.pic)),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: const Text(
                                'The device must be connected to plant pot'),
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
                    setState(() {
                      isLoading = false;
                    });
                  },
                  child: const Text("Continue")),
        ],
      ),
    );
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
