import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:herble/main_page.dart';
import 'package:herble/notificationservice.dart';
import 'package:herble/plant_page.dart';
import 'globals.dart' as globals;

class WaterConfirm extends StatefulWidget {
  final globals.Plant plant;

  const WaterConfirm({Key? key, required this.plant}) : super(key: key);

  @override
  State<WaterConfirm> createState() => _WaterConfirmState();
}

class _WaterConfirmState extends State<WaterConfirm> {
  Duration selectedDuration = Duration(hours: 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Confirm water fill-up"),
        automaticallyImplyLeading: true,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MainPage()),
            );
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: Column(
        children: [
          Text(
              "did you fill up the water for your plant: ${widget.plant.plantName}?"),
          Row(
            children: [
              TextButton(
                  onPressed: () async {
                    await scheduleNotification(
                      widget.plant.dayCount,
                      widget.plant.waterVolume,
                      widget.plant.plantId,
                      widget.plant.plantName,
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MainPage()),
                    );
                  },
                  child: const Text("yes")),
              TextButton(
                onPressed: () {},
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<Duration>(
                    value: selectedDuration,
                    onChanged: (Duration? duration) async {
                      setState(() {
                        selectedDuration = duration!;
                      });
                      await scheduleReminder(
                        widget.plant.plantId,
                        widget.plant.plantName,
                        Duration(hours: 1),
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MainPage()),
                      );
                    },
                    items: const [
                      DropdownMenuItem(
                        value: Duration(minutes: 30),
                        child: Text('30 minutes'),
                      ),
                      DropdownMenuItem(
                        value: Duration(hours: 1),
                        child: Text('1 hour'),
                      ),
                      DropdownMenuItem(
                        value: Duration(hours: 2),
                        child: Text('2 hours'),
                      ),
                      DropdownMenuItem(
                        value: Duration(hours: 2),
                        child: Text('3 hours'),
                      ),
                      DropdownMenuItem(
                        value: Duration(hours: 5),
                        child: Text('5 hours'),
                      ),
                      DropdownMenuItem(
                        value: Duration(hours: 10),
                        child: Text('10 hours'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
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

  Future<void> scheduleReminder(
      int plantId, String plant, Duration repeatInterval) async {
    NotificationService().cancelNotificationById(plantId);
    await NotificationService().scheduleReminder(
      plantId, //id
      'Fill up the water for $plant', //title
      'Click the notification to confirm that you filled it', //text
      repeatInterval,
    );
  }
}
