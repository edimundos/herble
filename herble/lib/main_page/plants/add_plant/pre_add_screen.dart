import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:herble/main_page/main_page.dart';
import 'add_plant.dart';
import 'package:herble/globals.dart' as globals;
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
                        "Add plant",
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
              "Follow these steps to add your first plant. ",
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
