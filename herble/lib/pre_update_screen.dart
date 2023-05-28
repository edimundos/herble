import 'dart:typed_data';
import 'package:google_fonts/google_fonts.dart';
import 'package:herble/main_page.dart';
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
      backgroundColor: Colors.white,
      body: Column(
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
                    "Update",
                    textAlign: TextAlign.left,
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 25,
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
          Text(
            "1. Turn on wifi on your herble pot ",
            textAlign: TextAlign.left,
            style: GoogleFonts.cormorantGaramond(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              height: 1,
              color: const Color.fromARGB(255, 32, 54, 50),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "2. Connect to the wifi from your device",
            textAlign: TextAlign.left,
            style: GoogleFonts.cormorantGaramond(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              height: 1,
              color: const Color.fromARGB(255, 32, 54, 50),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          isLoading
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  // ignore: sort_child_properties_last
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Continue",
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
                ),
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
