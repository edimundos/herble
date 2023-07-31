import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:herble/main_page/profile/change_email.dart';
import 'package:herble/main_page/profile/change_pw.dart';
import 'package:herble/main_page/profile/change_username.dart';
import 'package:herble/start_page/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../globals.dart' as globals;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Scaffold build(BuildContext context) {
    return const Scaffold(
      body: ProfileBody(
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
      backgroundColor: Colors.white,
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
                        image: AssetImage("assets/herble_logo.png"),
                      ),
                    ),
                  )
                ],
              )),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              "Hello, ${globals.username}!",
              style: GoogleFonts.cormorantGaramond(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                height: 1,
                color: const Color.fromARGB(255, 0, 0, 0),
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return const ChangeEmail();
                        },
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Text(
                        "Change Email",
                        textAlign: TextAlign.left,
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                          height: 1,
                          color: const Color.fromARGB(255, 32, 54, 50),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Divider(
                        color: Colors.grey,
                        thickness: 1.0,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return const ChangeUsername();
                        },
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Text(
                        "Change Username",
                        textAlign: TextAlign.left,
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                          height: 1,
                          color: const Color.fromARGB(255, 32, 54, 50),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Divider(
                        color: Colors.grey,
                        thickness: 1.0,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return const ChangePassword();
                        },
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Text(
                        "Change Password",
                        textAlign: TextAlign.left,
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                          height: 1,
                          color: const Color.fromARGB(255, 32, 54, 50),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Divider(
                        color: Colors.grey,
                        thickness: 1.0,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          TextButton(
            onPressed: () async {
              FirebaseAuth.instance.signOut();
              // globals.isLoggedIn = false;
              // globals.userID = 0;
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove("userID");
              await prefs.remove("password");
              SchedulerBinding.instance.addPostFrameCallback((_) {
                if (!mounted) return;
                Navigator.popUntil(context, (route) => route.isFirst);
              });
            },
            child: Container(
              width: 200,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                gradient: const LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: <Color>[
                    Color.fromARGB(255, 39, 39, 39),
                    Color.fromARGB(255, 202, 207, 197),
                  ],
                ),
              ),
              child: Center(
                child: Text(
                  'Sign out',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    height: 1,
                    color: Color.fromARGB(255, 226, 233, 218),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
