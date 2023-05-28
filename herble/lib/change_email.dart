import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    return const Scaffold(body: EmailBody());
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
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            reverse: true,
            child: Column(
              children: [
                SizedBox(
                    height: 100,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: GestureDetector(
                              onTap: () {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MainPage(
                                            index: 3,
                                          )),
                                );
                              },
                              child: const Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.all(15.0),
                                  child: Image(
                                    image: AssetImage("assets/backButton.png"),
                                  ),
                                ),
                              )),
                        ),
                        const SizedBox(
                          width: 10,
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
                ElevatedButton(
                  // ignore: sort_child_properties_last
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Confirm",
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                          height: 1,
                          color: Color.fromARGB(255, 255, 255, 255),
                        )),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 177, 177, 177),
                    elevation: 0,
                  ),
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
                            Future.delayed(Duration.zero,
                                () => _navigateToPlantList(context));
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
                                  content:
                                      const Text('New email must contain @'),
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
                              isDisabled = false;
                            });
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content:
                                      const Text('Old email is not correct'),
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
                ),
              ],
            )));
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
      MaterialPageRoute(builder: (context) => MainPage(index: 3)),
    );
  }
}
