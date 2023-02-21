import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:herble/globals.dart';
import 'package:herble/main.dart';
import 'package:herble/notificationservice.dart';
import 'globals.dart' as globals;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Scaffold build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile page"),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: const ProfileBody(
        title: 'profile ',
      ),
    );
  }
}

class ProfileBody extends StatefulWidget {
  const ProfileBody({super.key, required this.title});
  final String title;

  @override
  State<ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        TextButton(
          onPressed: () async {
            //scheduleNotification();
            globals.isLoggedIn = false;
            globals.userID = 0;
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return const MyApp();
                },
              ),
            );
          },
          child: const Text('Sign out'),
        ),
      ],
    ));
  }

  // Future<void> scheduleNotification() async {
  //   String plant = 'monkey';
  //   await NotificationService().scheduleNotification(
  //     3, //id
  //     'Fill up the water for $plant', //title
  //     'Click the notification to confirm that you filled it', //text
  //     Time(18, 35),
  //     Duration(seconds: 30),
  //   );
  // }
}
