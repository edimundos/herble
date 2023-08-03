import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:herble/colors.dart';
import 'package:herble/main_page/plants/individual_plant/individual_plant.dart';
import 'package:herble/main_page/plants/add_plant/pre_add_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

class PlantListScreen extends StatefulWidget {
  const PlantListScreen({super.key});

  @override
  State<PlantListScreen> createState() => _PlantListScreenState();
}

class _PlantListScreenState extends State<PlantListScreen> {
  @override
  Scaffold build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Scaffold(
      body: const MyPlantsForm(),
    );
  }
}

class MyPlantsForm extends StatefulWidget {
  const MyPlantsForm({super.key});

  @override
  State<MyPlantsForm> createState() => _MyPlantsFormState();
}

class _MyPlantsFormState extends State<MyPlantsForm> {
  List<Uint8List> plantPics = [];
  Map<int, Uint8List> plantPicData = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: globals.height * 0.004),
          // sis app bar container
          SizedBox(
              height: globals.height * 0.04,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Text(
                      "My plants",
                      textAlign: TextAlign.left,
                      style: GoogleFonts.caudex(
                        fontSize: globals.width * 0.03,
                        height: 1,
                        color: const Color.fromARGB(255, 32, 54, 50),
                      ),
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

          Expanded(
            child: FutureBuilder(
              future: getPlantsByUser(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<dynamic> plants = json
                      .decode(snapshot.data ?? "[{}]")
                      .map((data) =>
                          globals.Plant.fromJson(data as Map<String, dynamic>))
                      .toList();
                  if (plants.isNotEmpty) {
                    return ListView.builder(
                      itemCount: plants.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 35),
                          child: GestureDetector(
                            onTap: () {
                              globals.currentPlant = plants[index];
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => IndividualPlant(
                                    plant: plants[index],
                                    pic: plantPicData[index]!,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                                height: globals.height * 0.11,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color.fromARGB(255, 214, 224, 221),
                                  border: Border.all(
                                    color: mainpallete
                                        .shade200, // Set the color of the outline
                                    width: 0.2, // Set the width of the outline
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                15, 15, 15, 30),
                                            // const EdgeInsets.all(15.0),
                                            child: Container(
                                              height: globals.height * 0.05,
                                              width: globals.width * 0.09,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: ClipRRect(
                                                clipBehavior: Clip.hardEdge,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child: FittedBox(
                                                  fit: BoxFit.cover,
                                                  child: FutureBuilder(
                                                    future: getImage(
                                                        plants[index].picture),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.hasData) {
                                                        Uint8List picData =
                                                            snapshot.data!;
                                                        plantPicData[index] =
                                                            picData;
                                                        return Image.memory(
                                                            picData);
                                                      } else {
                                                        return const Placeholder(
                                                          child:
                                                              CircularProgressIndicator(),
                                                        );
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.topCenter,
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 0.0),
                                                  child: SizedBox(
                                                    width: globals.width * 0.2,
                                                    child: Text(
                                                      plants[index].plantName,
                                                      textAlign: TextAlign.left,
                                                      overflow:
                                                          TextOverflow.clip,
                                                      style: GoogleFonts.inter(
                                                        fontSize:
                                                            globals.width *
                                                                0.02,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        height: 1,
                                                        color: const Color
                                                                .fromARGB(
                                                            255, 32, 54, 50),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height:
                                                      globals.height * 0.001,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 0.0),
                                                  child: SizedBox(
                                                    width: globals.width * 0.2,
                                                    child: Text(
                                                      plants[index]
                                                                  .plantDescription
                                                                  .length >=
                                                              60
                                                          ? plants[index]
                                                                  .plantDescription
                                                                  .substring(
                                                                      0, 60) +
                                                              "..."
                                                          : plants[index]
                                                              .plantDescription,
                                                      textAlign: TextAlign.left,
                                                      overflow:
                                                          TextOverflow.clip,
                                                      style: GoogleFonts.inter(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        height: 1,
                                                        color: const Color
                                                                .fromARGB(
                                                            255, 32, 54, 50),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 15.0),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons
                                                      .water_drop, // Use the water_drop icon from Material Icons
                                                  size: globals.width *
                                                      0.02, // Adjust the icon size as needed
                                                  color: const Color.fromARGB(
                                                      255, 32, 54, 50),
                                                ),
                                                Text(
                                                  " frequency: ",
                                                  style: GoogleFonts.inter(
                                                    fontSize:
                                                        globals.width * 0.018,
                                                    fontWeight: FontWeight.bold,
                                                    height: 1,
                                                    color: const Color.fromARGB(
                                                        255, 32, 54, 50),
                                                  ),
                                                ),
                                                Text(
                                                  plants[index].dayCount == 1
                                                      ? "every ${plants[index].dayCount} day"
                                                      : "every ${plants[index].dayCount} days",
                                                  overflow: TextOverflow.clip,
                                                  style: GoogleFonts.inter(
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    height: 1,
                                                    color: const Color.fromARGB(
                                                        255, 32, 54, 50),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 15),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons
                                                      .water_drop, // Use the water_drop icon from Material Icons
                                                  size: globals.width *
                                                      0.02, // Adjust the icon size as needed
                                                  color: const Color.fromARGB(
                                                      255, 32, 54, 50),
                                                ),
                                                Text(
                                                  " volume: ",
                                                  overflow: TextOverflow.clip,
                                                  style: GoogleFonts.inter(
                                                    fontSize:
                                                        globals.width * 0.018,
                                                    fontWeight: FontWeight.bold,
                                                    // height: 1,
                                                    color: const Color.fromARGB(
                                                        255, 32, 54, 50),
                                                  ),
                                                ),
                                                Text(
                                                  "${plants[index].waterVolume.toString()} ml",
                                                  style: GoogleFonts.inter(
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    // height: 1,
                                                    color: const Color.fromARGB(
                                                        255, 32, 54, 50),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                )
                                // title: Text(plants[index].plantName),
                                // subtitle: Text(plants[index].plantDescription),
                                // onTap: () {
                                //   globals.currentPlant = plants[index];
                                //   Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //       builder: (context) => IndividualPlant(
                                //         plant: plants[index],
                                //         pic: plantPicData[index]!,
                                //       ),
                                //     ),
                                //   );
                                // },
                                // leading: FutureBuilder(
                                //   future: getImage(plants[index].picture),
                                //   builder: (context, snapshot) {
                                //     if (snapshot.hasData) {
                                //       Uint8List picData = snapshot.data!;
                                //       plantPicData[index] = picData;
                                //       return Image.memory(picData);
                                //     } else {
                                //       return const Placeholder(
                                //         child: CircularProgressIndicator(),
                                //       );
                                //     }
                                //   },
                                // ),
                                ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(
                        child: Column(
                      children: [
                        const Flexible(
                          child: FractionallySizedBox(
                            heightFactor: 0.45,
                          ),
                        ),
                        Text(
                          "No herble plant pots yet",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: globals.width * 0.01,
                            height: 1,
                            color: const Color.fromARGB(255, 116, 129, 127),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            final Uri url = Uri.parse(
                                'https://www.herble.eu/products/self-watering-plant-pot');
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url);
                            } else {
                              print("shit dont work");
                            }
                            if (!await launchUrl(url)) {
                              throw Exception('Could not launch $url');
                            }
                          },
                          child: Text(
                            "Order now",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: globals.width * 0.01,
                              fontWeight: FontWeight.bold,
                              height: 1,
                              color: Color.fromARGB(255, 34, 65, 54),
                            ),
                          ),
                        ),
                      ],
                    ));
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ],
      ),
      // onPressed: () {
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(builder: (context) => const PreAddScreen()),
      //       );
      //     }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        // padding: const EdgeInsets.symmetric(
        //   vertical: 4,
        //   horizontal: 14,
        // ),
        padding: const EdgeInsets.only(bottom: 7),
        alignment: Alignment.bottomCenter,
        child: TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PreAddScreen()),
            );
          },
          child: Container(
            alignment: Alignment.bottomCenter,
            width: globals.width * 0.17,
            height: globals.height * 0.025,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: mainpallete.shade400,
              border: Border.all(
                color: mainpallete, // Set the color of the outline
                width: 1.0, // Set the width of the outline
              ),
            ),
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                Text(" Add plant",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: globals.width * 0.015,
                      color: Colors.white,
                    ))
              ],
            )),
          ),
        ),
      ),
    );
  }

  Future<Uint8List> getImage(String blob) async {
    int? picID = int.tryParse(blob);
    if (picID != null) {
      return (await rootBundle.load('assets/default_plant$picID.jpg'))
          .buffer
          .asUint8List();
    } else {
      Uint8List imageBytes = base64Decode(blob);
      return imageBytes;
    }
  }

  Future<String> getPlantsByUser() async {
    String url =
        'https://herbledb.000webhostapp.com/get_all_plants_by_user.php';
    try {
      var response = await http
          .post(Uri.parse(url), body: {'user_id': globals.userID.toString()});

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions here
      throw e;
    }
  }
}
