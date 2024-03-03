import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:herble/notifications/notificationservice.dart';
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
                    NotificationService notificationService =
                        NotificationService();
                    await notificationService
                        .scheduleNotification(currentPlant.plantId);

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
                              NotificationService notificationService =
                                  NotificationService();
                              await notificationService.scheduleReminder(
                                  currentPlant.plantId, selectedDuration);

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
}
