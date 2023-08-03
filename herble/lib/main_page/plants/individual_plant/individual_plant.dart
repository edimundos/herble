import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:herble/main_page/main_page.dart';
import 'package:herble/main_page/plants/individual_plant/pre_update_screen.dart';
import 'package:herble/main_page/plants/individual_plant/update_plant_basics.dart';
import 'package:herble/main_page/plants/plant_page.dart';
import '../../../globals.dart' as globals;
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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(children: [
          SizedBox(
              height: 100,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Material(
                      shape: const CircleBorder(),
                      clipBehavior: Clip.hardEdge,
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const PlantListScreen(),
                            ),
                          );
                        },
                        icon: Icon(Icons.arrow_back_sharp,
                            size: globals.width * 0.03, color: Colors.black38),
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
          bodyForm(plant: widget.plant, pic: widget.pic),
        ]),
      ),
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
  double textSize = 25;
  double paddingSize = 70;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 20),
          child: Container(
              width: 200.0,
              height: 200.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(35),
              ),
              child: ClipRRect(
                clipBehavior: Clip.hardEdge,
                borderRadius: BorderRadius.circular(35),
                child: Image.memory(
                  widget.pic,
                  width: 200.0,
                  height: 200.0,
                  fit: BoxFit.cover,
                ),
              )),
        ),

        Container(
          color: Colors.white, // Set the color of the rectangle here
          padding: const EdgeInsets.fromLTRB(
              10, 4, 10, 0), // Add padding to the content inside the rectangle
          child: Column(
            children: [
              Row(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: Text(
                        "Plant basic information ",
                        textAlign: TextAlign.left,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          height: 1,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Plant name ",
                            textAlign: TextAlign.left,
                            style: GoogleFonts.inter(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              height: 1,
                              color: const Color.fromARGB(255, 32, 54, 50),
                            ),
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: SizedBox(
                                width: globals.width * 0.12,
                                height: globals.height * 0.015,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    side: const BorderSide(
                                      color: Colors
                                          .black26, // Set the color of the border
                                      width: 1.0, // Set the width of the border
                                    ),
                                  ),
                                  onPressed: () async {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (BuildContext context) {
                                          return UpdatePlantBasics(
                                              plant: widget.plant,
                                              pic: widget.pic);
                                        },
                                      ),
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      Icon(Icons.edit,
                                          size: globals.width * 0.018,
                                          color: Colors.black),
                                      SizedBox(
                                        width: globals.width * 0.07,
                                        height: globals.height * 0.014,
                                        child: Center(
                                          child: Text(
                                            'Edit basics',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.inter(
                                              fontSize: globals.width * 0.012,
                                              fontWeight: FontWeight.w600,
                                              height: 1,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        widget.plant.plantName,
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          height: 1,
                          color: const Color.fromARGB(255, 32, 54, 50),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 5, 10, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Plant description ",
                        textAlign: TextAlign.left,
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          height: 1,
                          color: const Color.fromARGB(255, 32, 54, 50),
                        ),
                      ),
                      Text(
                        widget.plant.plantDescription,
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          height: 1,
                          color: const Color.fromARGB(255, 32, 54, 50),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        const Divider(
          height: 1,
          color: Colors.black,
        ),
        const SizedBox(height: 5),
        Container(
          color: Colors.white, // Set the color of the box here
          padding: const EdgeInsets.fromLTRB(
              10, 4, 10, 0), // Add padding to the content inside the box
          child: Column(
            children: [
              Row(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 8, 0),
                      child: Text(
                        "Plant watering information ",
                        textAlign: TextAlign.left,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          height: 1,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 10, 10, 10),
                  child: Row(
                    children: [
                      Text(
                        "Day count: ",
                        textAlign: TextAlign.left,
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          height: 1,
                          color: const Color.fromARGB(255, 32, 54, 50),
                        ),
                      ),
                      Text(
                        "${widget.plant.dayCount}",
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          height: 1,
                          color: const Color.fromARGB(255, 32, 54, 50),
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: SizedBox(
                            width: globals.width * 0.13,
                            height: globals.height * 0.015,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50)),
                                side: const BorderSide(
                                  color: Colors
                                      .black26, // Set the color of the border
                                  width: 1.0, // Set the width of the border
                                ),
                              ),
                              onPressed: () async {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (BuildContext context) {
                                    return PreUpdateScreen(
                                        plant: widget.plant, pic: widget.pic);
                                  }),
                                );
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.edit,
                                      size: globals.width * 0.018,
                                      color: Colors.black),
                                  SizedBox(
                                    width: globals.width * 0.08,
                                    height: globals.height * 0.01,
                                    child: Center(
                                      child: Text(
                                        'Edit watering',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.inter(
                                          fontSize: globals.width * 0.012,
                                          fontWeight: FontWeight.w600,
                                          height: 1,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 5, 10, 10),
                  child: Row(
                    children: [
                      Text(
                        "Water volume: ",
                        textAlign: TextAlign.left,
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          height: 1,
                          color: const Color.fromARGB(255, 32, 54, 50),
                        ),
                      ),
                      Text(
                        "${widget.plant.waterVolume} ml",
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          height: 1,
                          color: const Color.fromARGB(255, 32, 54, 50),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 55),

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
          child: Text(
            'Delete plant',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 16,
              // fontWeight: FontWeight.bold,
              height: 1,
              color: const Color.fromARGB(255, 168, 37, 37),
            ),
          ),
        ),

        // SizedBox(
        //   height: 10,
        // ),
        // !isLoading
        //     ? Center(
        //         child: ElevatedButton(
        //           // ignore: sort_child_properties_last
        //           child: Padding(
        //             padding: const EdgeInsets.all(8.0),
        //             child: Text("Water now",
        //                 style: GoogleFonts.cormorantGaramond(
        //                   fontSize: 20,
        //                   fontWeight: FontWeight.normal,
        //                   height: 1,
        //                   color: Color.fromARGB(255, 255, 255, 255),
        //                 )),
        //           ),
        //           style: ElevatedButton.styleFrom(
        //             backgroundColor: Color.fromARGB(255, 64, 67, 107),
        //             elevation: 0,
        //           ),
        //           onPressed: () async {
        //             setState(() {
        //               isLoading = true;
        //             });
        //             if (await checkIfUrlIsAccessible()) {
        //               waterNow();
        //               setState(() {
        //                 isLoading = false;
        //               });
        //             } else {
        //               setState(() {
        //                 isLoading = false;
        //               });
        //               showDialog(
        //                   context: context,
        //                   builder: (BuildContext context) {
        //                     return AlertDialog(
        //                       content: const Text(
        //                           'Connect to the plant pot wifi to water it'),
        //                       actions: <Widget>[
        //                         TextButton(
        //                           onPressed: () =>
        //                               Navigator.pop(context, 'sorry'),
        //                           child: const Text('sorry'),
        //                         ),
        //                       ],
        //                     );
        //                   });
        //             }
        //           },
        //         ),
        //       )
        //     : const Center(
        //         child: CircularProgressIndicator(),
        //       ),
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
