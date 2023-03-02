import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:herble/main_page.dart';
import 'package:herble/plant_page.dart';
import 'add_plant.dart';
import 'package:http/http.dart' as http;

class PreAddScreen extends StatefulWidget {
  const PreAddScreen({super.key});

  @override
  State<PreAddScreen> createState() => _PreAddScreenState();
}

class _PreAddScreenState extends State<PreAddScreen> {
  bool isLoading = false;
  late Uint8List pic;

  @override
  void initState() {
    super.initState();
    loadImageFromAssets('assets/default_plant-1.jpg').then((value) {
      setState(() {
        pic = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
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
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Add Plant",
                    textAlign: TextAlign.left,
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 50,
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
                            builder: (context) => AddPlantPage(pic: pic)),
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

  Future<Uint8List> loadImageFromAssets(String url) async {
    final byteData = await rootBundle.load(url);
    return byteData.buffer.asUint8List();
  }
}
