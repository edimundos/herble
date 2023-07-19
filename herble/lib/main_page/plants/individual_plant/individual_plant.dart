import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:herble/main_page/main_page.dart';
import 'package:herble/main_page/plants/individual_plant/pre_update_screen.dart';
import 'package:herble/main_page/plants/individual_plant/update_plant_basics.dart';
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
        // Text("plant name:${widget.plant.plantName}"),
        // Text("plant description:${widget.plant.plantDescription}"),

        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30, 10, 10, 10),
            child: Text(
              "Plant name: ${widget.plant.plantName}",
              textAlign: TextAlign.left,
              style: GoogleFonts.cormorantGaramond(
                fontSize: textSize,
                fontWeight: FontWeight.bold,
                height: 1,
                color: const Color.fromARGB(255, 32, 54, 50),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 10, 10, 10),
            child: Text(
              "Plant description: ${widget.plant.plantDescription}",
              textAlign: TextAlign.left,
              style: GoogleFonts.cormorantGaramond(
                fontSize: textSize,
                fontWeight: FontWeight.bold,
                height: 1,
                color: const Color.fromARGB(255, 32, 54, 50),
              ),
            ),
          ),
        ),
        // const SizedBox(height: 5),
        ElevatedButton(
          // ignore: sort_child_properties_last
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Edit plant basics",
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
        ),
        // const SizedBox(height: 10),
        // Text("day count:${widget.plant.dayCount}"),
        // Text("water volume:${widget.plant.waterVolume}"),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 10, 10, 10),
            child: Text(
              "Day count: ${widget.plant.dayCount}",
              textAlign: TextAlign.left,
              style: GoogleFonts.cormorantGaramond(
                fontSize: textSize,
                fontWeight: FontWeight.bold,
                height: 1,
                color: const Color.fromARGB(255, 32, 54, 50),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 10, 10, 10),
            child: Text(
              "Water volume: ${widget.plant.waterVolume} ml",
              textAlign: TextAlign.left,
              style: GoogleFonts.cormorantGaramond(
                fontSize: textSize,
                fontWeight: FontWeight.bold,
                height: 1,
                color: const Color.fromARGB(255, 32, 54, 50),
              ),
            ),
          ),
        ),
        // const SizedBox(height: 10),
        ElevatedButton(
          // ignore: sort_child_properties_last
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Edit plant technicalities",
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
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return PreUpdateScreen(plant: widget.plant, pic: widget.pic);
                },
              ),
            );
          },
        ),
        // const SizedBox(height: 20),
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
          child: Center(
            child: Text(
              'Delete plant',
              textAlign: TextAlign.center,
              style: GoogleFonts.cormorantGaramond(
                fontSize: textSize - 5,
                fontWeight: FontWeight.bold,
                height: 1,
                color: Color.fromARGB(255, 168, 37, 37),
              ),
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
                // Navigator.of(context).pop(true);
              },
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () {
                // Navigator.of(context).pop(false);
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
