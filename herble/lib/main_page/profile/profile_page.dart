import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:herble/colors.dart';
import 'package:herble/main_page/profile/edit_profile.dart';
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
              height: globals.height * 0.04,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Text(
                      "Profile page",
                      textAlign: TextAlign.left,
                      style: GoogleFonts.caudex(
                        fontSize: globals.width * 0.03,
                        height: 1,
                        color: const Color.fromARGB(255, 32, 54, 50),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Material(
                    shape: const CircleBorder(),
                    clipBehavior: Clip.hardEdge,
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return const ChangeUsername(); // Replace ChangeSettings with the actual widget for the settings page
                            },
                          ),
                        );
                      },
                      icon: Icon(Icons.settings_outlined,
                          size: globals.width * 0.03, color: Colors.black26),
                    ),
                  ),
                  // const Align(
                  //   alignment: Alignment.centerRight,
                  //   child: Padding(
                  //     padding: EdgeInsets.all(25.0),
                  //     child: Image(
                  //       image: AssetImage("assets/herble_logo.png"),
                  //     ),
                  //   ),
                  // )
                ],
              )),
          SizedBox(
            height: globals.height * 0.01,
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              "Hello, ${globals.username}!",
              style: GoogleFonts.inter(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                height: 1,
                color: const Color.fromARGB(255, 0, 0, 0),
              ),
            ),
          ),
          SizedBox(
            height: globals.height * 0.03,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    side: const BorderSide(
                      color: Colors.black26, // Set the color of the border
                      width: 1.0, // Set the width of the border
                    ),
                  ),
                  onPressed: () async {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return const ChangeUsername();
                        },
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Icon(Icons.edit,
                          size: globals.width * 0.02, color: Colors.black),
                      Container(
                        width: globals.width * 0.08,
                        height: globals.height * 0.014,
                        child: Center(
                          child: Text(
                            'Edit Profile',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: globals.width * 0.014,
                              fontWeight: FontWeight.w600,
                              height: 1,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: globals.height * 0.002,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                " User Information ",
                textAlign: TextAlign.left,
                style: GoogleFonts.inter(
                  fontSize: globals.width * 0.017,
                  fontWeight: FontWeight.normal,
                  height: 1,
                  color: const Color.fromARGB(255, 32, 54, 50),
                ),
              ),
            ),
          ),
          SizedBox(
            height: globals.height * 0.01,
          ),
          Column(
            children: [
              // GestureDetector(
              //   onTap: () {
              //     Navigator.of(context).push(
              //       MaterialPageRoute(
              //         builder: (BuildContext context) {
              //           return const ChangeEmail();
              //         },
              //       ),
              //     );
              //   },
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Row(
                      children: [
                        Icon(Icons.email,
                            size: globals.width * 0.02, color: Colors.black),
                        Text(
                          " ${globals.email}",
                          textAlign: TextAlign.left,
                          style: GoogleFonts.inter(
                            fontSize: globals.width * 0.02,
                            fontWeight: FontWeight.normal,
                            height: 1,
                            color: const Color.fromARGB(255, 32, 54, 50),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: globals.height * 0.002,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Divider(
                      color: Colors.black26,
                      thickness: 0.5,
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: globals.height * 0.015,
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Row(
                      children: [
                        Icon(Icons.person,
                            size: globals.width * 0.02, color: Colors.black),
                        Text(
                          " @${globals.username} ",
                          textAlign: TextAlign.left,
                          style: GoogleFonts.inter(
                            fontSize: globals.width * 0.02,
                            fontWeight: FontWeight.normal,
                            height: 1,
                            color: const Color.fromARGB(255, 32, 54, 50),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: globals.height * 0.002,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Divider(
                      color: Colors.black26,
                      thickness: 0.5,
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: globals.height * 0.07,
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          TextButton(
            onPressed: () async {
              FirebaseAuth.instance.signOut();
              globals.isLoggedIn = false;
              globals.userID = 0;
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove("userID");
              await prefs.remove("password");
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (BuildContext context) =>
                      const AppStartPage(), // Replace with your initial screen
                ),
                (Route<dynamic> route) =>
                    false, // Remove all previous routes from the stack
              );
            },
            child: Container(
              width: globals.width * 0.24,
              height: globals.height * 0.024,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: mainpallete,
              ),
              child: Center(
                child: Text(
                  'Sign out',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: globals.width * 0.02,
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
