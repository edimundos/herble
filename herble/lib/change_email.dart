import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'globals.dart' as globals;
import 'main_page.dart';

class ChangeEmail extends StatefulWidget {
  const ChangeEmail({super.key});

  @override
  State<ChangeEmail> createState() => _ChangeEmailState();
}

class _ChangeEmailState extends State<ChangeEmail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
        ),
        body: const EmailBody());
  }
}

class EmailBody extends StatefulWidget {
  const EmailBody({super.key});

  @override
  State<EmailBody> createState() => _EmailBodyState();
}

class _EmailBodyState extends State<EmailBody> {
  final emailController = TextEditingController();
  final emailB4Controller = TextEditingController();

  bool isDisabled = false;

  void dispose() {
    emailB4Controller.dispose();
    emailController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            controller: emailB4Controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Old Email',
              hintText: 'enter your old email',
              suffixIcon: IconButton(
                icon: Icon(Icons.cancel),
                onPressed: () {
                  emailB4Controller.clear();
                },
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            controller: emailController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Email',
              hintText: 'enter your email',
              suffixIcon: IconButton(
                icon: Icon(Icons.cancel),
                onPressed: () {
                  emailController.clear();
                },
              ),
            ),
          ),
        ),
        TextButton(
          onPressed: !isDisabled
              ? () async {
                  setState(() {
                    isDisabled = true;
                  });
                  int validator = await dataIsValid(
                    emailB4Controller.text,
                    emailController.text,
                  );
                  if (validator == 100) {
                    Future.delayed(
                        Duration.zero, () => _navigateToPlantList(context));
                    await updateEmail(
                      emailController.text,
                    );
                    globals.email = emailController.text;
                    setState(() {
                      isDisabled = false;
                    });
                  } else if (validator == 103) {
                    setState(() {
                      isDisabled = false;
                    });
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: const Text('New email must contain @'),
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
                  } else if (validator == 102) {
                    setState(() {
                      isDisabled = false;
                    });
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: const Text('Old email is not correct'),
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

  Future<void> updateEmail(String email) async {
    String url = 'https://herbledb.000webhostapp.com/update_user.php';
    await http.post(Uri.parse(url), body: {
      'id': globals.userID.toString(),
      'email_flutter': email,
      'username_flutter': globals.username,
      'pw_flutter': globals.password,
    });
  }

  Future<int> dataIsValid(String emailOld, String email) async {
    if (emailOld != globals.email) return 102;
    if (!email.contains('@')) return 103;
    if (await checkExists(email)) return 105;
    return 100;
  }

  Future<bool> checkExists(String email) async {
    String url = 'https://herbledb.000webhostapp.com/get_user_by_username.php';
    var response =
        await http.post(Uri.parse(url), body: {'username_flutter': email});

    if (response.statusCode == 200 && response.body.length > 5) {
      return true;
    } else {
      return false;
    }
  }

  void _navigateToPlantList(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MainPage()),
    );
  }
}
