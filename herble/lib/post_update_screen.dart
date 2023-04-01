import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:herble/main_page.dart';
import 'package:herble/notificationservice.dart';
import 'package:http/http.dart' as http;
import 'package:herble/plant_page.dart';
import 'globals.dart' as globals;
import 'package:connectivity/connectivity.dart';

class PostUpdate extends StatefulWidget {
  final globals.Plant plant;
  final int days;
  final int volume;
  final Uint8List picture;
  PostUpdate({
    super.key,
    required this.plant,
    required this.days,
    required this.volume,
    required this.picture,
  });

  @override
  State<PostUpdate> createState() => _ConnectInternetState();
}

class _ConnectInternetState extends State<PostUpdate> {
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
              children: const [
                SizedBox(
                  width: 10,
                ),
                Spacer(),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.all(25.0),
                    child: Image(
                      image: AssetImage("assets/herble_logo.png"),
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            "Reconect to the internet to finish",
            textAlign: TextAlign.left,
            style: GoogleFonts.cormorantGaramond(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              height: 1,
              color: const Color.fromARGB(255, 32, 54, 50),
            ),
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
                    if (await hasInternet()) {
                      await updatePlant(
                        widget.plant.plantName,
                        widget.plant.plantDescription,
                        widget.days,
                        base64Encode(widget.picture),
                        widget.volume,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MainPage(index: 1)),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: const Text(
                                'The device must be connected to the internet'),
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

  Future<void> updatePlant(
      String name, String desc, int days, String pic, int volume) async {
    String url = 'https://herbledb.000webhostapp.com/update_plant.php';
    await http.post(Uri.parse(url), body: {
      'id': widget.plant.plantId.toString(),
      'plant_name': name,
      'plant_description': desc,
      'day_count': days.toString(),
      'picture': pic,
      'water_volume': volume.toString(),
    });

    await NotificationService().cancelNotificationById(widget.plant.plantId);

    //create notification
    Time notificationTime = globals.wateringTime;
    Duration repeatInterval =
        Duration(days: getRefilDayCount(days.toDouble(), volume.toDouble()));
    await NotificationService().scheduleNotification(
      widget.plant.plantId, //id
      'Fill up water', //title
      'Fill up the water for $name', //text
      notificationTime,
      repeatInterval,
    );
  }

  int getRefilDayCount(double days, double volume) {
    const double waterCapacity = 1.1;
    int refilDays;
    if (waterCapacity % volume == 0) {
      refilDays = ((waterCapacity / volume * 1000).floor() * days - 1).floor();
    } else {
      refilDays = ((waterCapacity / volume * 1000).floor() * days).floor();
    }
    print(refilDays);
    return refilDays;
  }

  Future<bool> hasInternet() async {
    try {
      final response = await Future.any([
        http.get(
            Uri.parse("https://herbledb.000webhostapp.com/post_plant.php")),
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
