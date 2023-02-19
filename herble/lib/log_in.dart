import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:herble/sign_up.dart';
import 'package:herble/plant_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bcrypt/bcrypt.dart';
import 'globals.dart' as globals;

void main() => runApp(const LogInScreen());

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

  @override
  bool passwordVisible = false;

  void dispose() {
    emailController.dispose();
    pwController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            controller: emailController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Email/username',
              hintText: 'enter your email/username',
            ),
          ),
        ),
        Padding(
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
                  passwordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Theme.of(context).primaryColorDark,
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
        ),
        TextButton(
          onPressed: () async {
            var pass = checkPass(emailController.text, pwController.text);
            if (await pass) {
              globals.isLoggedIn = true;
              globals.userID = await getUserID(
                emailController.text,
              );
              globals.wateringTime = await getUserTime(
                emailController.text,
              );
              _navigateToPlantList(context);
            } else {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: const Text('Incorrect password/email'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'sorry'),
                          child: const Text('sorry'),
                        ),
                      ],
                    );
                  });
            }
          },
          child: const Text('Confirm'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return const SignUpPage();
                },
              ),
            );
          },
          child: const Text('Sign up'),
        ),
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
      MaterialPageRoute(builder: (context) => PlantListScreen()),
    );
  }
}
