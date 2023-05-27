import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:herble/change_email.dart';
import 'package:herble/change_pw.dart';
import 'package:herble/change_username.dart';
import 'package:herble/main.dart';
import 'globals.dart' as globals;
import 'home_page.dart';

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
      backgroundColor: Colors.white,
      body: Column(children: [
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
        Column(
          children: [
            Container(
              height: 15,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Email",
                    textAlign: TextAlign.left,
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                      height: 1,
                      color: const Color.fromARGB(255, 32, 54, 50),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
              child: Column(
                children: [
                  Container(
                    // height: 20,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Text(
                            " ${globals.email}",
                            textAlign: TextAlign.left,
                            style: GoogleFonts.cormorantGaramond(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              height: 1,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                          // const Spacer(),
                          // Align(
                          //   alignment: Alignment.centerRight,
                          Container(
                              height: 20,
                              decoration: const BoxDecoration(
                                // borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                    image: AssetImage('pencil.png')),
                              )),
                          // ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  const Divider(
                    color: Colors.grey,
                    thickness: 3.0,
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              height: 30,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Username",
                    textAlign: TextAlign.left,
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                      height: 1,
                      color: const Color.fromARGB(255, 32, 54, 50),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
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
              child: Padding(
                padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                child: Column(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    // alignment: Alignment.centerRight,
                    // Row(
                    //   children: [
                    //     const Spacer(),
                    //     Align(
                    //       alignment: Alignment.centerRight,
                    //       child: Container(
                    //           height: 40,
                    //           decoration: const BoxDecoration(
                    //             // borderRadius: BorderRadius.circular(20),
                    //             image: DecorationImage(
                    //                 image: AssetImage('pencil.png')),
                    //           )),
                    //     ),
                    //   ],
                    // ),

                    const SizedBox(
                      height: 5,
                    ),
                    const Divider(
                      color: Colors.grey,
                      thickness: 3.0,
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              height: 30,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Password",
                    textAlign: TextAlign.left,
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                      height: 1,
                      color: const Color.fromARGB(255, 32, 54, 50),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
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
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      const Divider(
                        color: Colors.grey,
                        thickness: 3.0,
                      )
                    ],
                  ),
                )),
            const SizedBox(
              height: 15,
            ),
            TextButton(
              onPressed: () async {
                FirebaseAuth.instance.signOut();
                globals.isLoggedIn = false;
                globals.userID = 0;
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (BuildContext context) {
                //       return const MyApp();
                //     },
                //   ),
                // );
                Navigator.of(context).pop();
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
      ]),
    );
  }
}
