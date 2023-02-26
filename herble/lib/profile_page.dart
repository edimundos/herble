import 'package:flutter/material.dart';
import 'package:herble/change_email.dart';
import 'package:herble/change_pw.dart';
import 'package:herble/change_username.dart';
import 'package:herble/main.dart';
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
        Text("Hello, ${globals.username}!"),
        const Text("Email"),
        InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return const ChangeEmail();
                },
              ),
            );
          },
          child: Container(
            width: 400,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const Text("Username"),
        InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return const ChangeUsername();
                },
              ),
            );
          },
          child: Container(
            width: 400,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const Text("Password"),
        InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return const ChangePassword();
                },
              ),
            );
          },
          child: Container(
            width: 400,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        TextButton(
          onPressed: () async {
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
}
