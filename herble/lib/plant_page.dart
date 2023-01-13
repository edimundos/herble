import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:herble/individual_plant.dart';
import 'package:herble/profile_page.dart';
import 'globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:herble/add_plant.dart';

class PlantListScreen extends StatefulWidget {
  const PlantListScreen({super.key});

  @override
  State<PlantListScreen> createState() => _PlantListScreenState();
}

class _PlantListScreenState extends State<PlantListScreen> {
  @override
  Scaffold build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Plant list"),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
            icon: const Icon(Icons.person),
          ),
        ],
      ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getPlantsByUser(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<dynamic> plants = json
                .decode(snapshot.data ?? "[{}]")
                .map((data) =>
                    globals.Plant.fromJson(data as Map<String, dynamic>))
                .toList();
            return ListView.builder(
                itemCount: plants.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(plants[index].plantName),
                    subtitle: Text(plants[index].plantDescription),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => IndividualPlant(
                            plant: plants[index],
                            pic: plantPics[index],
                          ),
                        ),
                      );
                    },
                    leading: FutureBuilder(
                      future: getImage(plants[index].picture),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          plantPics.add(snapshot.data!);
                          return Image.memory(snapshot.data!);
                        } else {
                          return const Placeholder(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  );
                });
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddPlantPage()),
            );
          }),
    );
  }

  Future<Uint8List> getImage(String blob) async {
    int? picID = int.tryParse(String.fromCharCodes(base64Decode(blob)));
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
