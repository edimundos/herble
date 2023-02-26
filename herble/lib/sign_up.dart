import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:herble/main_page.dart';
import 'package:http/http.dart' as http;
import 'globals.dart' as globals;

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
  bool isDisabled = false;
  bool passwordVisible1 = false;
  bool passwordVisible2 = false;

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
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            controller: emailController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Email',
              hintText: 'enter your email',
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            controller: usernameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Username',
              hintText: 'enter your username',
            ),
          ),
        ),
        Padding(
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
                  passwordVisible1 ? Icons.visibility : Icons.visibility_off,
                  color: Theme.of(context).primaryColorDark,
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
        Padding(
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
                  passwordVisible2 ? Icons.visibility : Icons.visibility_off,
                  color: Theme.of(context).primaryColorDark,
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
        TextButton(
          onPressed: !isDisabled
              ? () async {
                  print(isDisabled);
                  setState(() {
                    isDisabled = true;
                  });
                  print(isDisabled);
                  int validator = await dataIsValid(
                    usernameController.text,
                    pwController1.text,
                    pwController2.text,
                    emailController.text,
                  );
                  if (validator == 100) {
                    Future.delayed(
                        Duration.zero, () => _navigateToPlantList(context));
                    await postUser(
                      usernameController.text,
                      pwController2.text,
                      emailController.text,
                    );
                    globals.isLoggedIn = true;
                    globals.username = usernameController.text;
                    globals.userID = await getUserID(
                      usernameController.text,
                    );
                    setState(() {
                      isDisabled = false;
                    });
                  } else if (validator == 101) {
                    setState(() {
                      isDisabled = false;
                    });
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: const Text('Password doesnt match'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'sorry'),
                              child: const Text('sorry'),
                            ),
                          ],
                        );
                      },
                    );
                  } else if (validator == 102) {
                    setState(() {
                      isDisabled = false;
                    });
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: const Text('Password length must be >8'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'sorry'),
                              child: const Text('sorry'),
                            ),
                          ],
                        );
                      },
                    );
                  } else if (validator == 103) {
                    setState(() {
                      isDisabled = false;
                    });
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: const Text('Email must contain @'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'sorry'),
                              child: const Text('sorry'),
                            ),
                          ],
                        );
                      },
                    );
                  } else if (validator == 104) {
                    setState(() {
                      isDisabled = false;
                    });
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: const Text(
                              'A user with this username already exists'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'sorry'),
                              child: const Text('sorry'),
                            ),
                          ],
                        );
                      },
                    );
                  } else if (validator == 105) {
                    setState(() {
                      isDisabled = false;
                    });
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: const Text(
                              'A user with this email already exists'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'sorry'),
                              child: const Text('sorry'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                }
              : null,
          child: const Text('Confirm'),
        ),
      ],
    );
  }

  Future<void> postUser(String username, String pw, String email) async {
    String url = 'https://herbledb.000webhostapp.com/post_user.php';
    globals.username = username;
    globals.password = pw;
    globals.email = email;
    await http.post(Uri.parse(url), body: {
      'username_flutter': username,
      'pw_flutter': pw,
      'email_flutter': email,
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
}
