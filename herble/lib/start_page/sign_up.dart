import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/src/types.dart';
import 'package:herble/main_page/main_page.dart';
import 'package:herble/start_page/verif_email_page.dart';
import 'package:http/http.dart' as http;
import '../globals.dart' as globals;
import '../start_page/DatabaseUsers.dart' as FUser;
import 'package:email_auth/email_auth.dart';
import 'package:google_fonts/google_fonts.dart';

bool isLoading = false;

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign up"),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: LogInForm(),
    );
  }
}

class LogInForm extends StatefulWidget {
  const LogInForm({super.key});

  @override
  State<LogInForm> createState() => _LogInFormState();
}

class _LogInFormState extends State<LogInForm> {
  final emailController = TextEditingController();
  final pwController1 = TextEditingController();
  final pwController2 = TextEditingController();
  final usernameController = TextEditingController();
  bool passwordVisible1 = false;
  bool passwordVisible2 = false;
  late TimeOfDay selectedTime24Hour = const TimeOfDay(hour: 20, minute: 0);
  bool submitValid = false;

  void dispose() {
    emailController.dispose();
    pwController1.dispose();
    pwController2.dispose();
    usernameController.dispose();
    super.dispose();
  }

  late EmailAuth emailAuth;

  @override
  void initState() {
    super.initState();
    // Initialize the package
    emailAuth = EmailAuth(
      sessionName: "Sample session",
    );

    /// Configuring the remote server
    emailAuth.config({"server": "https://www.herble.eu/"});
  }

  /// a void funtion to send the OTP to the user
  /// Can also be converted into a Boolean function and render accordingly for providers
  void sendOtp(String email) async {
    bool result = await emailAuth.sendOtp(recipientMail: email, otpLength: 5);
    if (result) {
      print("Email Verified!");
      setState(() {
        submitValid = true;
      });
    } else {
      print("Invalid Verification Code");
    }
  }

  Widget build(BuildContext context) {
    return Column(
      children: [
        isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Container(),
        !isLoading
            ? Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: globals.height * 0.02,
                        width: globals.width * 0.27,
                        child: TextField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Email',
                            labelStyle: TextStyle(
                              fontFamily: 'GoogleFonts.inter',
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: globals.height * 0.005),
                    ]),
              )
            : Container(),
        !isLoading
            ? Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: globals.height * 0.02,
                        width: globals.width * 0.27,
                        child: TextField(
                          controller: usernameController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Username',
                            labelStyle: TextStyle(
                              fontFamily: 'GoogleFonts.inter',
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: globals.height * 0.005),
                    ]),
              )
            : Container(),
        !isLoading
            ? Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: globals.height * 0.02,
                        width: globals.width * 0.27,
                        child: TextField(
                          obscureText: !passwordVisible1,
                          controller: pwController1,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Password',
                            labelStyle: TextStyle(
                              fontFamily: 'GoogleFonts.inter',
                              color: Colors.grey,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                // Based on passwordVisible state choose the icon
                                passwordVisible1
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Color.fromARGB(255, 56, 56, 56),
                              ),
                              onPressed: () {
                                // Update the state i.e. toogle the state of passwordVisible vari able
                                setState(() {
                                  passwordVisible1 = !passwordVisible1;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: globals.height * 0.005),
                    ]),
              )
            : Container(),
        !isLoading
            ? Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: globals.height * 0.02,
                        width: globals.width * 0.27,
                        child: TextField(
                          obscureText: !passwordVisible2,
                          controller: pwController2,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Repeat Password',
                            labelStyle: TextStyle(
                              fontFamily: 'GoogleFonts.inter',
                              color: Colors.grey,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                // Based on passwordVisible state choose the icon
                                passwordVisible2
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Color.fromARGB(255, 56, 56, 56),
                              ),
                              onPressed: () {
                                // Update the state i.e. toogle the state of passwordVisible variable
                                setState(() {
                                  passwordVisible2 = !passwordVisible2;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: globals.height * 0.007),
                    ]),
              )
            : Container(),
        !isLoading
            ? SizedBox(
                height: globals.height * 0.03,
                width: globals.width * 0.27,
                // padding: const EdgeInsets.all(10.0),
                child: Container(
                  // height: globals.height * 0.03,
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextButton(
                    onPressed: () async {
                      selectedTime24Hour = (await showTimePicker(
                        context: context,
                        initialTime:
                            selectedTime24Hour != TimeOfDay(hour: 20, minute: 0)
                                ? selectedTime24Hour
                                : TimeOfDay(hour: 20, minute: 00),
                        builder: (BuildContext context, Widget? child) {
                          return MediaQuery(
                            data: MediaQuery.of(context)
                                .copyWith(alwaysUse24HourFormat: true),
                            child: child!,
                          );
                        },
                      ))!;
                      setState(() {
                        selectedTime24Hour = selectedTime24Hour;
                      });
                    },
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text:
                                "Select time of day to receive water refill notifications",
                            style: TextStyle(color: Colors.black54),
                          ),
                          TextSpan(
                            text:
                                " (${selectedTime24Hour.hour.toString().padLeft(2, '0')}:${selectedTime24Hour.minute.toString().padLeft(2, '0')})",
                            style: const TextStyle(
                                color: Color.fromARGB(255, 34, 65, 54)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : Container(),
        !isLoading
            ? SizedBox(
                height: globals.height * 0.003,
              )
            : Container(),
        !isLoading
            ? TextButton(
                onPressed: !isLoading
                    ? () async {
                        setState(() {
                          isLoading = true;
                        });
                        int validator = await dataIsValid(
                          usernameController.text,
                          pwController1.text,
                          pwController2.text,
                          emailController.text,
                        );
                        if (validator == 100) {
                          signUpFirebase(
                              userEmail: emailController.text.trim(),
                              password: pwController1.text.trim(),
                              context: context);
                          setState(() {
                            isLoading = false;
                          });
                          print(emailController.text);
                          String email = emailController.text;
                          String password = pwController1.text.trim();
                          Future.delayed(
                              Duration.zero,
                              () => _navigateToEmailVerify(
                                    context,
                                    email,
                                    usernameController.text.trim(),
                                    password,
                                    selectedTime24Hour,
                                  ));
                        } else if (validator == 101) {
                          setState(() {
                            isLoading = false;
                          });
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: const Text('Password does not match'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'sorry'),
                                    child: const Text('sorry'),
                                  ),
                                ],
                              );
                            },
                          );
                        } else if (validator == 102) {
                          setState(() {
                            isLoading = false;
                          });
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content:
                                    const Text('Password length must be >8'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'sorry'),
                                    child: const Text('sorry'),
                                  ),
                                ],
                              );
                            },
                          );
                        } else if (validator == 103) {
                          setState(() {
                            isLoading = false;
                          });
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: const Text('Email must contain @'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'sorry'),
                                    child: const Text('sorry'),
                                  ),
                                ],
                              );
                            },
                          );
                        } else if (validator == 104) {
                          setState(() {
                            isLoading = false;
                          });
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: const Text(
                                    'A user with this username already exists'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'sorry'),
                                    child: const Text('sorry'),
                                  ),
                                ],
                              );
                            },
                          );
                        } else if (validator == 105) {
                          setState(() {
                            isLoading = false;
                          });
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: const Text(
                                    'A user with this email already exists'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'sorry'),
                                    child: const Text('sorry'),
                                  ),
                                ],
                              );
                            },
                          );
                        } else if (validator == 106) {
                          setState(() {
                            isLoading = false;
                          });
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: const Text(
                                    'Username must be longer than 3 characters'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'sorry'),
                                    child: const Text('sorry'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      }
                    : null,
                child: SizedBox(
                  height: globals.height * 0.02,
                  width: globals.width * 0.27,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Color.fromARGB(255, 34, 65, 54),
                    ),
                    child: Text(
                      'Register',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: globals.width * 0.011,
                        fontWeight: FontWeight.w500,
                        height: 1,
                        color: Color.fromARGB(255, 226, 233, 218),
                      ),
                    ),
                  ),
                ),
              )
            : Container(),
      ],
    );
  }

  Future<User?> signUpFirebase(
      {required String userEmail,
      required String password,
      required BuildContext context}) async {
    print("signUpFirebase");
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text.trim(),
              password: pwController1.text.trim());

      // WRITE DATA TO FIREBASE DATASTORE
      // DOC.ID = EMAIL

      createUser();

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print("here");
      print(e);
      print("here");
    }
    return null;
  }

  Future createUser() async {
    final docUser = FirebaseFirestore.instance
        .collection("users")
        .doc(emailController.text.trim());

    final user = FUser.User(
        email: emailController.text.trim(),
        username: usernameController.text.trim(),
        waterTimeMin: selectedTime24Hour.hour * 60 + selectedTime24Hour.minute);

    final json = user.toJson();

    await docUser.set(json);
  }

  Future<void> postUser(String username, String pw, String email) async {
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

  Future<int> dataIsValid(
      String username, String pw1, String pw2, String email) async {
    if (pw1 != pw2) return 101;
    if (pw1.length <= 7) return 102;
    if (!email.contains('@')) return 103;
    if (await checkExists(username)) return 104;
    if (await checkExists(email)) return 105;
    if (username.length <= 2) return 106;
    return 100;
  }

  Future<bool> checkExists(String username) async {
    String url = 'https://herbledb.000webhostapp.com/get_user_by_username.php';
    var response =
        await http.post(Uri.parse(url), body: {'username_flutter': username});

    if (response.statusCode == 200 && response.body.length > 5) {
      return true;
    } else {
      return false;
    }
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
  }

  void _navigateToEmailVerify(
    BuildContext context,
    String text,
    String username,
    String password,
    TimeOfDay selectedTime24Hour,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => VerifyEmail(
                email: text,
                username: username,
                password: password,
                timeOfDay: selectedTime24Hour,
              )),
    );
  }
}
