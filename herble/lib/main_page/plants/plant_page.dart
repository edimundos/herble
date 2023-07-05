import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:herble/main_page/plants/individual_plant/individual_plant.dart';
import 'package:herble/main_page/plants/add_plant/pre_add_screen.dart';
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
          // sis app bar container
          SizedBox(
              height: 100,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Text(
                      "My plants",
                      textAlign: TextAlign.left,
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
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
                          padding: const EdgeInsets.all(20.0),
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
                                height: 350,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: const LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: <Color>[
                                      Color.fromARGB(255, 204, 217, 191),
                                      Color.fromARGB(255, 200, 223, 215),
                                    ],
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(30.0),
                                            child: Container(
                                              height: 150,
                                              width: 150,
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
                                                    width: 150,
                                                    child: Text(
                                                      plants[index].plantName,
                                                      textAlign:
                                                          TextAlign.center,
                                                      overflow:
                                                          TextOverflow.clip,
                                                      style: GoogleFonts
                                                          .cormorantGaramond(
                                                        fontSize: 35,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        height: 1,
                                                        color: const Color
                                                                .fromARGB(
                                                            255, 32, 54, 50),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 8,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 0.0),
                                                  child: SizedBox(
                                                    width: 150,
                                                    child: Text(
                                                      plants[index]
                                                          .plantDescription,
                                                      textAlign: TextAlign.left,
                                                      overflow:
                                                          TextOverflow.clip,
                                                      style: GoogleFonts
                                                          .cormorantGaramond(
                                                        fontSize: 23,
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
                                          const EdgeInsets.only(left: 30.0),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  "Watering frequency: ",
                                                  style: GoogleFonts
                                                      .cormorantGaramond(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    height: 1,
                                                    color: const Color.fromARGB(
                                                        255, 32, 54, 50),
                                                  ),
                                                ),
                                                Text(
                                                  "${" every " + plants[index].dayCount.toString()} days",
                                                  overflow: TextOverflow.clip,
                                                  style: GoogleFonts
                                                      .cormorantGaramond(
                                                    fontSize: 20,
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
                                                Text(
                                                  "Watering volume: ",
                                                  overflow: TextOverflow.clip,
                                                  style: GoogleFonts
                                                      .cormorantGaramond(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    height: 1,
                                                    color: const Color.fromARGB(
                                                        255, 32, 54, 50),
                                                  ),
                                                ),
                                                Text(
                                                  "${plants[index].waterVolume.toString()} ml",
                                                  style: GoogleFonts
                                                      .cormorantGaramond(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    height: 1,
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
                    return Center(child: Text("No herble plant pots yet :("));
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
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 5,
        ),
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
            height: 75,
            // width: MediaQuery.of(context).size.width - 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Color.fromARGB(255, 182, 172, 152),
            ),
            child: Center(
              child: Text(
                '+',
                style: GoogleFonts.lilitaOne(
                  fontSize: 80,
                  fontWeight: FontWeight.bold,
                  height: 1,
                  color: Color(0xffffffff),
                ),
              ),
            ),
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
