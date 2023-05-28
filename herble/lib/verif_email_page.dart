import 'dart:async';
import 'dart:convert';

import 'package:email_auth/email_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:herble/globals.dart';
import 'globals.dart' as globals;
import 'package:http/http.dart' as http;

import 'globals.dart';
import 'main_page.dart';

class VerifyEmail extends StatefulWidget {
  String? email;

  String? password;

  String? username;

  TimeOfDay? timeOfDay;

  VerifyEmail({
    super.key,
    this.email,
    this.username,
    this.password,
    this.timeOfDay,
  });

  @override
  State<VerifyEmail> createState() => _verifyEmailState();
}

class _verifyEmailState extends State<VerifyEmail> {
  late String email2;
  bool isEmailVerified = false;
  Timer? timer;
  late TimeOfDay selectedTime24Hour;
  late String pw2;
  late String username2;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    email2 = widget.email!;
    selectedTime24Hour = widget.timeOfDay!;
    pw2 = widget.password!;
    username2 = widget.username!;
    FirebaseAuth.instance.currentUser?.sendEmailVerification();
    timer = Timer.periodic(const Duration(seconds: 3),
        (_) => checkEmailVerified(username2, email2, pw2, selectedTime24Hour));
  }

  checkEmailVerified(String username, String email, String password,
      TimeOfDay selectedTime24Hour) async {
    await FirebaseAuth.instance.currentUser?.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) {
      // TODO: implement your code after email verification
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Email Successfully Verified")));
      Future.delayed(Duration.zero, () => _navigateToPlantList(context));
      await postUser(
        username,
        password,
        email,
        selectedTime24Hour,
      );
      globals.isLoggedIn = true;
      globals.username = username;
      globals.userID = await getUserID(
        username,
      );

      timer?.cancel();
    }
  }

  Future<void> postUser(String username, String pw, String email,
      TimeOfDay selectedTime24Hour) async {
    String url = 'https://herbledb.000webhostapp.com/post_user.php';

    globals.username = username;
    globals.password = pw;
    globals.email = email;
    globals.wateringTime =
        Time(selectedTime24Hour.hour, selectedTime24Hour.minute);
    await http.post(Uri.parse(url), body: {
      'username_flutter': username,
      'pw_flutter': pw,
      'email_flutter': email,
      'time':
          '${selectedTime24Hour.hour.toString().length == 1 ? '0${selectedTime24Hour.hour}' : selectedTime24Hour.hour}:${selectedTime24Hour.minute.toString().length == 1 ? '0${selectedTime24Hour.minute}' : selectedTime24Hour.minute}:00',
    });
  }

  Future<int> getUserID(String username) async {
    String url = 'https://herbledb.000webhostapp.com/get_user_id.php';
    var response =
        await http.post(Uri.parse(url), body: {'username_flutter': username});

    if (response.statusCode == 200 && response.body.length > 6) {
      List<dynamic> user = jsonDecode(response.body);
      Map<String, dynamic> userMap = user[0];
      int X = int.parse(userMap["id"]);
      return X;
    } else {
      // The request failed
      debugPrint('Request failed with status: ${response.statusCode}');
      return 0;
    }
  }

  void _navigateToPlantList(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MainPage(index: 1)),
    );
    // FirebaseAuth.instance.currentUser?.delete();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

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
                      "Verify email",
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
            height: 100,
          ),
          Center(
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: Text(
                  "Check your email ($email2) to find verification link. (might be in spam)",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    height: 1,
                    color: const Color.fromARGB(255, 32, 54, 50),
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              TextButton(
                onPressed: () {
                  try {
                    FirebaseAuth.instance.currentUser?.sendEmailVerification();
                  } catch (e) {
                    debugPrint('$e');
                  }
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
                      'Resend link',
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
              const SizedBox(
                height: 30,
              ),
              TextButton(
                onPressed: () {
                  try {
                    FirebaseAuth.instance.signOut();
                    Navigator.pop(context);
                  } catch (e) {
                    debugPrint('$e');
                  }
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
                      'Cancel',
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
              )
            ]),
          )
        ],
      ),
    );
  }
}
