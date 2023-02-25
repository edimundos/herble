import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'globals.dart' as globals;
import 'main_page.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
        ),
        body: const PasswordBody());
  }
}

class PasswordBody extends StatefulWidget {
  const PasswordBody({super.key});

  @override
  State<PasswordBody> createState() => _PasswordBodyState();
}

class _PasswordBodyState extends State<PasswordBody> {
  final passwordController = TextEditingController();
  final passwordRepeatController = TextEditingController();
  final passwordB4Controller = TextEditingController();

  bool isDisabled = false;
  bool passwordVisible0 = false;
  bool passwordVisible1 = false;
  bool passwordVisible2 = false;

  void dispose() {
    passwordB4Controller.dispose();
    passwordController.dispose();
    passwordRepeatController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            obscureText: !passwordVisible0,
            controller: passwordB4Controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Current Password',
              hintText: 'enter your current password',
              suffixIcon: IconButton(
                icon: Icon(
                  // Based on passwordVisible state choose the icon
                  passwordVisible0 ? Icons.visibility : Icons.visibility_off,
                  color: Theme.of(context).primaryColorDark,
                ),
                onPressed: () {
                  // Update the state i.e. toogle the state of passwordVisible vari able
                  setState(() {
                    passwordVisible0 = !passwordVisible0;
                  });
                },
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            obscureText: !passwordVisible1,
            controller: passwordController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'New Password',
              hintText: 'enter your new password',
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
            controller: passwordRepeatController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Repeat Password',
              hintText: 'repeat your new password',
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
                  setState(() {
                    isDisabled = true;
                  });
                  int validator = await dataIsValid(
                    passwordB4Controller.text,
                    passwordController.text,
                    passwordRepeatController.text,
                  );
                  if (validator == 100) {
                    Future.delayed(
                        Duration.zero, () => _navigateToPlantList(context));
                    await updatePassword(
                      passwordController.text,
                    );
                    globals.password = passwordController.text;
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
                  }
                }
              : null,
          child: const Text('Confirm'),
        ),
      ],
    );
  }

  Future<void> updatePassword(String password) async {
    String url = 'https://herbledb.000webhostapp.com/update_user.php';
    await http.post(Uri.parse(url), body: {
      'id': globals.userID.toString(),
      'email_flutter': globals.email,
      'username_flutter': globals.username,
      'pw_flutter': password,
    });
  }

  Future<int> dataIsValid(String oldPw, String pw1, String pw2) async {
    if (pw1 != pw2) return 101;
    if (pw1.length <= 7) return 102;
    if (oldPw != globals.password) return 103;
    return 100;
  }

  void _navigateToPlantList(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MainPage()),
    );
  }
}
