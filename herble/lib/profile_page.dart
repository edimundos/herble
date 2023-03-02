import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    // ignore: prefer_const_constructors
    return Scaffold(
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
        SizedBox(
            height: 100,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text(
                    "Profile Page",
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
                      image: AssetImage("herble_logo.png"),
                    ),
                  ),
                )
              ],
            )),
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
