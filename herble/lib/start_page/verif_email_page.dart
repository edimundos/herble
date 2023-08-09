import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:herble/colors.dart';
import 'package:herble/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:herble/main_page/main_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerifyEmail extends StatefulWidget {
  final String? email;
  final String? password;
  final String? username;
  final TimeOfDay? timeOfDay;

  const VerifyEmail({
    super.key,
    this.email,
    this.username,
    this.password,
    this.timeOfDay,
  });

  @override
  State<VerifyEmail> createState() => _verifyEmailState();
}

class _verifyEmailState extends State<VerifyEmail> with WidgetsBindingObserver {
  late String email2;
  bool isEmailVerified = false;
  Timer? timer;
  late TimeOfDay selectedTime24Hour;
  late String pw2;
  late String username2;

  @override
  void initState() {
    super.initState();
    email2 = widget.email!;
    selectedTime24Hour = widget.timeOfDay!;
    pw2 = widget.password!;
    username2 = widget.username!;
    WidgetsBinding.instance.addObserver(this);
    FirebaseAuth.instance.currentUser?.sendEmailVerification();
    Timer(const Duration(seconds: 3), () {});

    // FirebaseAuth.instance.currentUser?.sendEmailVerification();

    // DeleteFirebaseAccount();
    if (!mounted) return;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      timer = Timer.periodic(
          const Duration(seconds: 3),
          (_) =>
              checkEmailVerified(username2, email2, pw2, selectedTime24Hour));
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print("App lifecycle state changed: $state");

    final background = state == AppLifecycleState.detached;
    if (background && !isEmailVerified) {
      // FirebaseAuth.instance.currentUser?.delete();

      // print("App is in background and email is not verified. Deleting user.");
    }
  }

  checkEmailVerified(String username, String email, String password,
      TimeOfDay selectedTime24Hour) async {
    await FirebaseAuth.instance.currentUser?.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) {
      // TODO: implement your code after email verification
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Email Successfully Verified")));
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
      globals.password = password;
      globals.isLoggedIn = true;
      globals.email = email;
      globals.wateringTime =
          Time(selectedTime24Hour.hour, selectedTime24Hour.minute);
      final prefs = await SharedPreferences.getInstance(); //remember me
      await prefs.setInt('userID', globals.userID);
      await prefs.setString('password', globals.password);
      timer?.cancel();
      Future.delayed(Duration.zero, () => _navigateToPlantList(context));
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

  // Future<void> DeleteFirebaseAccount() async {
  //   String url = 'https://herbledb.000webhostapp.com/get_user_by_username.php';
  //   var response =
  //       await http.post(Uri.parse(url), body: {'username_flutter': email2});

  //   if (response.statusCode != 200) {
  //     FirebaseAuth.instance.currentUser?.delete();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // FirebaseAuth.instance.currentUser?.sendEmailVerification();
    Timer(const Duration(seconds: 2), () {});
    FirebaseAuth.instance.currentUser?.sendEmailVerification();
    // DeleteFirebaseAccount();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(
              height: 85,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Text(
                      "Verify email",
                      textAlign: TextAlign.left,
                      style: GoogleFonts.inter(
                        fontSize: 30,
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
          Icon(
            Icons.email, // Email icon
            size: 60,
            color: const Color.fromARGB(255, 32, 54, 50),
          ),
          Center(
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Check your email! ",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 28,
                            height: 1,
                            color: const Color.fromARGB(255, 32, 54, 50),
                          )),
                      SizedBox(height: 35),
                      Text(
                        " To verify your account, click on the verification link sent to your email on ",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 17,
                          height: 1,
                          color: const Color.fromARGB(255, 32, 54, 50),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Text(
                          email2,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            height: 1,
                            color: const Color.fromARGB(255, 32, 54, 50),
                          ),
                        ),
                      ),
                      Text(
                        "(it might be in spam)",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 17,
                          height: 1,
                          color: const Color.fromARGB(255, 32, 54, 50),
                        ),
                      ),
                    ],
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
                    print("g spot");
                    print('$e');
                  }
                },
                child: Container(
                  width: 200,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: mainpallete,
                  ),
                  child: Center(
                    child: Text(
                      'Resend link',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        height: 1,
                        color: Color.fromARGB(255, 226, 233, 218),
                      ),
                    ),
                  ),
                ),
              ),

              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    child: Text(
                      "Cancel",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        height: 1,
                        color: Color.fromARGB(255, 184, 27, 27),
                      ),
                    ),
                    onTap: () {
                      try {
                        // FirebaseAuth.instance.currentUser?.delete();
                        Navigator.pop(context);
                      } catch (e) {
                        debugPrint('$e');
                      }
                    },
                  ),
                ),
              ),

              // TextButton(
              //   onPressed: () {
              //     try {
              //       // FirebaseAuth.instance.currentUser?.delete();
              //       Navigator.pop(context);
              //     } catch (e) {
              //       debugPrint('$e');
              //     }
              //   },
              //   child: Container(
              //     width: 200,
              //     height: 50,
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(50),
              //       gradient: const LinearGradient(
              //         begin: Alignment.topRight,
              //         end: Alignment.bottomLeft,
              //         colors: <Color>[
              //           Color.fromARGB(255, 39, 39, 39),
              //           Color.fromARGB(255, 202, 207, 197),
              //         ],
              //       ),
              //     ),
              //     child: Center(
              //       child: Text(
              //         'Cancel',
              //         textAlign: TextAlign.center,
              //         style: GoogleFonts.cormorantGaramond(
              //           fontSize: 30,
              //           fontWeight: FontWeight.bold,
              //           height: 1,
              //           color: Color.fromARGB(255, 226, 233, 218),
              //         ),
              //       ),
              //     ),
              //   ),
              // )
            ]),
          )
        ],
      ),
    );
  }
}
