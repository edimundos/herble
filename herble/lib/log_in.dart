import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:herble/main_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:herble/notificationservice.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bcrypt/bcrypt.dart';
import 'globals.dart' as globals;

void main() => runApp(const LogInScreen());

bool isLoading = false;

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
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  const SizedBox(
                    height: 200,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ],
              )
            : Container(),
        !isLoading
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email/username',
                    hintText: 'enter your email/username',
                  ),
                ),
              )
            : Container(),
        !isLoading
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextField(
                  obscureText: !passwordVisible,
                  controller: pwController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'enter your password',
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
                ),
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
                    // DateTime now = DateTime.now();
                    // Time notificationTime = Time(now.hour, now.minute + 1, 0);
                    // Duration repeatInterval = const Duration(seconds: 10);
                    // await NotificationService().scheduleNotification(
                    //   3, //id
                    //   'test', //title
                    //   'Click the notification to confirm that you filled it', //text
                    //   notificationTime,
                    //   repeatInterval,
                    // );
                    // globals.isLoggedIn = true;
                    globals.password = pwController.text;
                    globals.username = emailController.text;
                    globals.userID = await getUserID(
                      emailController.text,
                    );
                    await getEmailAndUsername();
                    globals.wateringTime = await getUserTime(
                      emailController.text,
                    );

                    setState(() {
                      isLoading = false;
                    });

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
                        gradient: const LinearGradient(
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
      globals.username = (userMap["username"]).toString();
      globals.email = (userMap["email"]).toString();
    } else {
      // The request failed
      debugPrint('Request failed with status: ${response.statusCode}');
    }
  }

  Future<Time> getUserTime(String username) async {
    String url = 'https://herbledb.000webhostapp.com/get_user_id.php';
    var response =
        await http.post(Uri.parse(url), body: {'username_flutter': username});

    if (response.statusCode == 200 && response.body.length > 6) {
      List<dynamic> user = jsonDecode(response.body);
      Map<String, dynamic> userMap = user[0];
      List<String> parts = userMap["watering_time"].split(':');
      Time time = Time(
        int.parse(parts[0]),
        int.parse(parts[1]),
      );
      return time;
    } else {
      // The request failed
      debugPrint('Request failed with status: ${response.statusCode}');
      return const Time(20, 0);
    }
  }

  void _navigateToPlantList(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MainPage(index: 1)),
    );
  }
}
