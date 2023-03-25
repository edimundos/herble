import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:herble/main_page.dart';
import 'package:herble/notificationservice.dart';
import 'package:http/http.dart' as http;
import 'package:herble/plant_page.dart';
import 'globals.dart' as globals;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class ConnectInternet extends StatefulWidget {
  String plant;
  String desc;
  int days;
  String pic;
  int volume;
  int? picId;
  ConnectInternet({
    super.key,
    required this.plant,
    required this.desc,
    required this.days,
    required this.pic,
    required this.volume,
    this.picId,
  });

  @override
  State<ConnectInternet> createState() => _ConnectInternetState();
}

class _ConnectInternetState extends State<ConnectInternet> {
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
                      await postPlant(
                        widget.plant,
                        widget.desc,
                        widget.days,
                        widget.pic,
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

  Future<void> postPlant(
      String plant, String desc, int days, String pic, int volume) async {
    String url = 'https://herbledb.000webhostapp.com/post_plant.php';
    if (widget.picId != null) {
      pic = widget.picId.toString();
    }
    await http.post(Uri.parse(url), body: {
      'user_id': globals.userID.toString(),
      'plant_name': plant,
      'plant_description': desc,
      'day_count': days.toString(),
      'picture': pic,
      'water_volume': volume.toString(),
    });

    int plantId = await getPlantID(plant, days, volume);

    NotificationService().cancelNotificationById(plantId);
    //create notification
    Time notificationTime = globals.wateringTime;
    Duration repeatInterval =
        Duration(days: getRefilDayCount(days.toDouble(), volume.toDouble()));
    await NotificationService().scheduleNotification(
      plantId, //id
      'Fill up the water for $plant', //title
      'Click the notification to confirm that you filled it', //text
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
    return refilDays;
  }

  Future<bool> hasInternet() async {
    try {
      final response = await Future.any([
        http.get(
            Uri.parse("https://herbledb.000webhostapp.com/get_all_users.php")),
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

  Future<int> getPlantID(String plant, int days, int volume) async {
    String url = 'https://herbledb.000webhostapp.com/get_plant_id.php';
    var response = await http.post(Uri.parse(url), body: {
      'user_id': globals.userID.toString(),
      'plant_name': plant,
      'day_count': days.toString(),
      'water_volume': volume.toString(),
    });

    if (response.statusCode == 200 && response.body.length > 6) {
      List<dynamic> user = jsonDecode(response.body);
      Map<String, dynamic> userMap = user[0];
      int X = int.parse(userMap["plant_id"]);
      return X;
    } else {
      // The request failed
      debugPrint('Request failed with status: ${response.statusCode}');
      return 0;
    }
  }
}
