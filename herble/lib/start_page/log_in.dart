import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:herble/main_page/main_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bcrypt/bcrypt.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../globals.dart' as globals;
import 'ForgotPasswordPage.dart';

void main() => runApp(const LogInScreen());
bool stop = false;

bool isLoading = false;

String correctEmail = "";

class LogInScreen extends StatelessWidget {
  const LogInScreen({super.key});
  @override
  Widget build(BuildContext context) {
    const appTitle = 'Log in';
    return MaterialApp(
      title: appTitle,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(appTitle),
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios_new),
          ),
        ),
        body: const MyCustomForm(),
      ),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  State<MyCustomForm> createState() => _MyCustomFormState();
}

class _MyCustomFormState extends State<MyCustomForm> {
  final emailController = TextEditingController();
  final pwController = TextEditingController();
  bool rememberMe = true;
  bool check = false;
  bool passwordVisible = false;

  void dispose() {
    emailController.dispose();
    pwController.dispose();
    super.dispose();
    super.initState();
  }

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isLoading
            ? const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 200,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ],
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
                          labelText: 'Email/Username',
                          labelStyle: TextStyle(
                            fontFamily: 'GoogleFonts.inter',
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: globals.height * 0.005),
                  ],
                ),
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
                        obscureText: !passwordVisible,
                        controller: pwController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                          labelStyle: TextStyle(
                            fontFamily: 'GoogleFonts.inter',
                            fontSize: globals.width * 0.011,
                            color: Colors.grey,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              // Based on passwordVisible state choose the icon
                              passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Color.fromARGB(255, 56, 56, 56),
                            ),
                            onPressed: () {
                              // Update the state i.e. toogle the state of passwordVisible variable
                              setState(() {
                                passwordVisible = !passwordVisible;
                              });
                            },
                          ),
                        ),
                      )),
                  SizedBox(height: globals.height * 0.005),
                ],
              ))
            : Container(),
        !isLoading
            ? Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                    child: GestureDetector(
                      child: Text(
                        "Forgot Password?",
                        textAlign: TextAlign.left,
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 20,
                          decoration: TextDecoration.underline,
                          height: 1,
                          color: Color.fromARGB(255, 116, 129, 127),
                        ),
                      ),
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const ForgotPasswordPage())),
                    ),
                  ),
                ],
              )
            : Container(),
        !isLoading
            ? TextButton(
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  var pass = checkPass(emailController.text, pwController.text);
                  if (await pass) {
                    globals.password = pwController.text;
                    globals.username = emailController.text;
                    globals.isLoggedIn = true;
                    globals.userID = await getUserID(
                      emailController.text,
                    );
                    await getEmailAndUsername();
                    globals.wateringTime = await getUserTime(
                      emailController.text,
                    );

                    signInFirebase();

                    setState(() {
                      isLoading = false;
                    });

                    final prefs = await SharedPreferences.getInstance();
                    if (rememberMe) {
                      await prefs.setInt('userID', globals.userID);
                      await prefs.setString('password', globals.password);
                    } else {
                      await prefs.remove("userID");
                      await prefs.remove("password");
                    }

                    _navigateToPlantList(context);
                  } else {
                    setState(() {
                      isLoading = false;
                    });
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: const Text('Incorrect password/email'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, 'sorry'),
                                child: const Text('sorry'),
                              ),
                            ],
                          );
                        });
                  }
                },
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
                      'Log in',
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

  Future<bool> checkPass(String username, String pw) async {
    String url = 'https://herbledb.000webhostapp.com/get_user_by_username.php';
    var response =
        await http.post(Uri.parse(url), body: {'username_flutter': username});

    if (response.statusCode == 200 && response.body.length > 6) {
      List<dynamic> user = jsonDecode(response.body);
      Map<String, dynamic> userMap = user[0];
      String X = userMap["password"].toString();
      if (BCrypt.checkpw(pw, X)) {
        return true;
      } else {
        return false;
      }
    } else {
      // The request failed
      debugPrint('Request failed with status: ${response.statusCode}');
      return false;
    }
  }

  Future signInFirebase() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: correctEmail,
        password: pwController.text.trim(),
      );
      return true;
    } on FirebaseAuthException catch (e) {
      stop = true;
      print(e);
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

  Future<void> getEmailAndUsername() async {
    String url = 'https://herbledb.000webhostapp.com/get_user_credentials.php';
    var response = await http
        .post(Uri.parse(url), body: {'user_id': globals.userID.toString()});

    if (response.statusCode == 200 && response.body.length > 6) {
      List<dynamic> user = jsonDecode(response.body);
      Map<String, dynamic> userMap = user[0];
      correctEmail = (userMap["email"]).toString().trim();
      print(correctEmail);
      globals.username = (userMap["username"]).toString();
      globals.email = (userMap["email"]).toString();
    } else {
      // The request failed
      debugPrint('Request failed with status: ${response.statusCode}');
    }
  }

  Future<DateTime> getUserTime(String username) async {
    String url = 'https://herbledb.000webhostapp.com/get_user_id.php';
    var response =
        await http.post(Uri.parse(url), body: {'username_flutter': username});

    if (response.statusCode == 200 && response.body.length > 6) {
      List<dynamic> user = jsonDecode(response.body);
      Map<String, dynamic> userMap = user[0];
      List<String> parts = userMap["watering_time"].split(':');
      DateTime time = DateTime(
        2023,
        1,
        1,
        int.parse(parts[0]),
        int.parse(parts[1]),
      );
      return time;
    } else {
      // The request failed
      debugPrint('Request failed with status: ${response.statusCode}');
      return DateTime(2023, 1, 1, 20, 0);
    }
  }

  Future<void> _navigateToPlantList(BuildContext context) async {
    await signInFirebase();

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MainPage(index: 1)),
    );
  }
}
