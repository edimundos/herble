import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/src/types.dart';
import 'package:herble/main_page.dart';
import 'package:herble/verif_email_page.dart';
import 'package:http/http.dart' as http;
import 'globals.dart' as globals;
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

  void dispose() {
    emailController.dispose();
    pwController1.dispose();
    pwController2.dispose();
    usernameController.dispose();
    super.dispose();
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
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'enter your email',
                  ),
                ),
              )
            : Container(),
        !isLoading
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                    hintText: 'enter your username',
                  ),
                ),
              )
            : Container(),
        !isLoading
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextField(
                  obscureText: !passwordVisible1,
                  controller: pwController1,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'enter your password',
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
              )
            : Container(),
        !isLoading
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextField(
                  obscureText: !passwordVisible2,
                  controller: pwController2,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Repeat Password',
                    hintText: 'repeat your password',
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
              )
            : Container(),
        !isLoading
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
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
                    child: Text(
                      "Select what time of day do you want to recieve water fill-up notifications (${selectedTime24Hour.hour.toString().length == 1 ? '0${selectedTime24Hour.hour}' : selectedTime24Hour.hour}:${selectedTime24Hour.minute.toString().length == 1 ? '0${selectedTime24Hour.minute}' : selectedTime24Hour.minute})",
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                ),
              )
            : Container(),
        !isLoading
            ? SizedBox(
                height: 20,
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

                        // Future.delayed(
                        //     Duration.zero,
                        //     () => _navigateToEmailVerify(
                        //         context, emailController.text));
                        print(emailController.text);
                        if (validator == 100) {
                          signUpFirebase(
                              userEmail: emailController.text.trim(),
                              password: pwController1.text.trim(),
                              context: context);
                          print(emailController.text);
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
                          // Future.delayed(Duration.zero,
                          //     () => _navigateToPlantList(context));
                        } else if (validator == 101) {
                          setState(() {
                            isLoading = false;
                          });
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: const Text('Password doesnt match'),
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
                        }
                      }
                    : null,
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.black.withOpacity(0),
                    ),
                    child: Container(
                      width: 200,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: <Color>[
                            Color.fromARGB(255, 19, 37, 31),
                            Color.fromARGB(255, 202, 207, 197),
                          ],
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Confirm',
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
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print(e);
    }
    return null;

    // await FirebaseAuth.instance.signInWithEmailAndPassword(
    //   email: emailController.text.trim(),
    //   password: pwController1.text.trim(),
    // );
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
