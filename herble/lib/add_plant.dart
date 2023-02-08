import 'package:flutter/material.dart';
import 'package:herble/change_picture.dart';
import 'package:herble/connect_to_internet_page.dart';
import 'package:http/http.dart' as http;
import 'package:herble/plant_page.dart';
import 'globals.dart' as globals;

class AddPlantPage extends StatefulWidget {
  const AddPlantPage({super.key});

  @override
  State<AddPlantPage> createState() => _AddPlantPageState();
}

class _AddPlantPageState extends State<AddPlantPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add a plant"),
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
      body: const PlantForm(),
    );
  }
}

class PlantForm extends StatefulWidget {
  const PlantForm({super.key});

  @override
  State<PlantForm> createState() => _PlantFormState();
}

class _PlantFormState extends State<PlantForm> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final dayController = TextEditingController();
  final volumeController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    dayController.dispose();
    volumeController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const PicturePage(pic: null)),
            );
          },
          child: Image.asset(
            'assets/default_plant-1.jpg',
            width: 120,
            height: 120,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Plant name',
              hintText: 'enter your plants name',
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            controller: descriptionController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Description',
              hintText: 'enter your plants description',
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            controller: dayController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Days',
              hintText: 'enter how often you want your plant to be watered',
            ),
          ),
        ),
        Padding(
          //te ganjau vajadzes kaut kādu check box ar dazadiem variantiem or smth un tad pedejais variants "Custom:"
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            controller: volumeController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Volume',
              hintText: 'enter how much water you want on your plant',
            ),
          ),
        ),
        TextButton(
          onPressed: (() async {
            if (await checkIfUrlIsAccessible()) {
              print("Yes access ########################################");
            } else {
              print("NO access##################");
            }
          }),
          child: Text("test connect"),
        ),
        TextButton(
          onPressed: () async {
            int validator = await dataIsValid(
              nameController.text,
              descriptionController.text,
              dayController.text,
              volumeController.text,
            );
            if (validator == 100 && globals.isLoggedIn) {
              sendToChip(
                int.parse(dayController.text),
                int.parse(volumeController.text),
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ConnectInternet(
                          plant: nameController.text,
                          desc: descriptionController.text,
                          days: int.parse(dayController.text),
                          pic: "0",
                          volume: int.parse(volumeController.text),
                        )),
              );
              // await postPlant(
              //   nameController.text,
              //   descriptionController.text,
              //   int.parse(dayController.text),
              //   "0",
              //   int.parse(volumeController.text),
              // );
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => const PlantListScreen()),
              // );
            } else if (validator == 101) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: const Text('Plant name length must be < 250'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'sorry'),
                        child: const Text('sorry'),
                      ),
                    ],
                  );
                },
              );
            } else if (validator == 102) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content:
                        const Text('Plant description length must be < 2000'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'sorry'),
                        child: const Text('sorry'),
                      ),
                    ],
                  );
                },
              );
            } else if (validator == 103) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: const Text('day count must be an int'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'sorry'),
                        child: const Text('sorry'),
                      ),
                    ],
                  );
                },
              );
            } else if (validator == 104) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: const Text('Water volume must be an int'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'sorry'),
                        child: const Text('sorry'),
                      ),
                    ],
                  );
                },
              );
            } else if (validator == 105) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: const Text('Plant name cant be empty'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'sorry'),
                        child: const Text('sorry'),
                      ),
                    ],
                  );
                },
              );
            } else if (validator == 106) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: const Text('Day count cant be empty'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'sorry'),
                        child: const Text('sorry'),
                      ),
                    ],
                  );
                },
              );
            } else if (validator == 107) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: const Text('Water volume cant be empty'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'sorry'),
                        child: const Text('sorry'),
                      ),
                    ],
                  );
                },
              );
            } else if (validator == 108) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: const Text('Must be connected to plant pot'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'sorry'),
                        child: const Text('sorry'),
                      ),
                    ],
                  );
                },
              );
            }
          },
          child: const Text('Confirm'),
        ),
      ],
    );
  }

  Future<int> dataIsValid(
      String species, String desc, String days, String volume) async {
    if (species.isEmpty) return 105;
    if (days.isEmpty) return 106;
    if (volume.isEmpty) return 107;
    if (species.length > 250) return 101;
    if (desc.length > 2000) return 102;
    if (int.tryParse(days) == null) return 103;
    if (int.tryParse(volume) == null) return 104;
    if (!await checkIfUrlIsAccessible()) return 108;
    return 100;
  }

  Future<void> sendToChip(int days, int volume) async {
    String url = 'http://192.168.4.1/?var1=$days&var2=$volume';
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
}
