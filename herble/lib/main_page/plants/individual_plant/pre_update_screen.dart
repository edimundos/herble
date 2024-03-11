import 'dart:typed_data';
import 'package:google_fonts/google_fonts.dart';
import 'package:herble/colors.dart';
import 'package:herble/main_page/plants/individual_plant/update_plant_technicalities.dart';
import 'package:herble/globals.dart' as globals;
import 'package:flutter/material.dart';
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
              height: 88,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Material(
                      shape: const CircleBorder(),
                      clipBehavior: Clip.hardEdge,
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(Icons.arrow_back_sharp,
                            size: globals.width * 0.03, color: Colors.black26),
                      ),
                    ),
                  ),
                  SizedBox(
                    child: Center(
                      child: Text(
                        "Connect to WiFi",
                        textAlign: TextAlign.left,
                        style: GoogleFonts.inter(
                          fontSize: 25,
                          height: 1,
                          color: const Color.fromARGB(255, 32, 54, 50),
                        ),
                      ),
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
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 20, 30, 0),
            child: Text(
              "Follow these steps to update your plant's watering information. ",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 17,
                height: 1,
                color: const Color.fromARGB(255, 32, 54, 50),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 40, 20, 0),
            child: Row(
              children: [
                Text(
                  "Step 1 - ",
                  textAlign: TextAlign.left,
                  style: GoogleFonts.inter(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    height: 1,
                    color: const Color.fromARGB(255, 32, 54, 50),
                  ),
                ),
                Expanded(
                  child: Text(
                    "Turn on wifi on your herble pot. ",
                    textAlign: TextAlign.left,
                    style: GoogleFonts.inter(
                      fontSize: 22,
                      height: 1,
                      color: const Color.fromARGB(255, 32, 54, 50),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 17, 20, 0),
            child: Row(
              children: [
                Text(
                  "Step 2 - ",
                  textAlign: TextAlign.left,
                  style: GoogleFonts.inter(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    height: 1,
                    color: const Color.fromARGB(255, 32, 54, 50),
                  ),
                ),
                Expanded(
                  child: Text(
                    "Connect to the wifi from your device. ",
                    textAlign: TextAlign.left,
                    style: GoogleFonts.inter(
                      fontSize: 22,
                      height: 1,
                      color: const Color.fromARGB(255, 32, 54, 50),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 70,
          ),
          isLoading
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  // ignore: sort_child_properties_last
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Continue",
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          height: 1,
                          color: Color.fromARGB(255, 255, 255, 255),
                        )),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainpallete,
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
