import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../globals.dart' as globals;

Duration other = Duration(seconds: 1);
Duration selectedDuration = Duration(hours: 1);

class WaterConfirm extends StatefulWidget {
  final globals.Plant currentPlant;

  const WaterConfirm({Key? key, required this.currentPlant}) : super(key: key);

  @override
  State<WaterConfirm> createState() => _WaterConfirmState();
}

class _WaterConfirmState extends State<WaterConfirm> {
  late globals.Plant currentPlant = widget.currentPlant;

  @override
  void initState() {
    super.initState();
  }

  double opacity = 1.0; // Initial opacity value

  void fadeScreenToBlack() {
    setState(() {
      opacity = 0.0; // Update opacity to trigger fade
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: Duration(seconds: 2), // Fade duration
      opacity: opacity,
      child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            reverse: true,
            child: Column(
              children: [
                SizedBox(
                    height: 100,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 25.0),
                          child: Text(
                            "Water confirmation",
                            textAlign: TextAlign.left,
                            style: GoogleFonts.cormorantGaramond(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              height: 1,
                              color: const Color.fromARGB(255, 32, 54, 50),
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
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(30, 10, 10, 10),
                    child: Text(
                      "Did you fill up the water for your plant: ${currentPlant.plantName}?",
                      textAlign: TextAlign.left,
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        height: 1,
                        color: const Color.fromARGB(255, 32, 54, 50),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  // ignore: sort_child_properties_last
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Yes",
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 21,
                          fontWeight: FontWeight.normal,
                          height: 1,
                          color: Color.fromARGB(255, 255, 255, 255),
                        )),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 214, 180, 180),
                    elevation: 0,
                  ),
                  onPressed: () async {
                    // await scheduleNotification(
                    //   currentPlant.dayCount,
                    //   currentPlant.waterVolume,
                    //   currentPlant.plantId,
                    //   currentPlant.plantName,
                    // );
                    Navigator.pop(context);
                    fadeScreenToBlack();
                    Future.delayed(Duration(seconds: 2));
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 145, 198, 136),
                    elevation: 0,
                  ),
                  onPressed: () async {
                    _showDialog(
                      Column(
                        children: [
                          CupertinoTimerPicker(
                            mode: CupertinoTimerPickerMode.hm,
                            initialTimerDuration: selectedDuration,
                            onTimerDurationChanged: (Duration newDuration) {
                              setState(() => selectedDuration = newDuration);
                            },
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Color.fromARGB(255, 100, 100, 100),
                              elevation: 0,
                            ),
                            onPressed: () async {
                              // await scheduleReminder(
                              //   currentPlant.plantId,
                              //   currentPlant.plantName,
                              //   selectedDuration,
                              // );
                              Navigator.pop(context);
                              fadeScreenToBlack();
                              SystemChannels.platform
                                  .invokeMethod('SystemNavigator.pop');
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Set",
                                  style: GoogleFonts.cormorantGaramond(
                                    fontSize: 21,
                                    fontWeight: FontWeight.normal,
                                    height: 1,
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                  )),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Remind me later",
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 21,
                          fontWeight: FontWeight.normal,
                          height: 1,
                          color: Color.fromARGB(255, 255, 255, 255),
                        )),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 300,
        padding: const EdgeInsets.only(top: 6.0),
        // The bottom margin is provided to align the popup above the system
        // navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom +
              MediaQuery.of(context).size.height / 2,
        ),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
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

  Future<void> scheduleNotification(
      int days, int volume, int plantId, String plant) async {
    NotificationService().cancelNotificationById(plantId);
    DateTime notificationTime = globals.wateringTime;
    Duration repeatInterval =
        Duration(days: getRefilDayCount(days.toDouble(), volume.toDouble()));
    await NotificationService().scheduleNotification(
      plantId, //id
      'Fill up the water for $plant', //title
      'Click to confirm that you filled it', //text
      notificationTime,
      repeatInterval,
    );
  }

  Future<void> scheduleReminder(
      int plantId, String plant, Duration repeatInterval) async {
    NotificationService().cancelNotificationById(plantId);
    await NotificationService().scheduleReminder(
      plantId, //id
      'Fill up the water for $plant', //title
      'Click to confirm that you filled it', //text
      repeatInterval,
    );
  }
}

Future<void> scheduleNotifification() async {
  String url = 'https://herbledb.000webhostapp.com/get_user_credentials.php';
  var response = await http
      .post(Uri.parse(url), body: {'user_id': globals.userID.toString()});

  if (response.statusCode == 200 && response.body.length > 6) {
    List<dynamic> user = jsonDecode(response.body);
    Map<String, dynamic> userMap = user[0];
    correctEmail = (userMap["email"]).toString().trim();
    print(correctEmail);
    globals.username = (userMap["username"]).toString();
    globals.email = (userMap["email"]).toString();
  } else {
    // The request failed
    debugPrint('Request failed with status: ${response.statusCode}');
  }
}
