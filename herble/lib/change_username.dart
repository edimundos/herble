import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'globals.dart' as globals;
import 'main_page.dart';

class ChangeUsername extends StatefulWidget {
  const ChangeUsername({super.key});

  @override
  State<ChangeUsername> createState() => _ChangeUsernameState();
}

class _ChangeUsernameState extends State<ChangeUsername> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: UsernameBody());
  }
}

class UsernameBody extends StatefulWidget {
  const UsernameBody({super.key});

  @override
  State<UsernameBody> createState() => _UsernameBodyState();
}

class _UsernameBodyState extends State<UsernameBody> {
  final usernameController = TextEditingController();

  bool isDisabled = false;

  void dispose() {
    usernameController.dispose();
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
                              FocusManager.instance.primaryFocus?.unfocus();
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
                  controller: usernameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'New username',
                    hintText: 'enter your new username',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.cancel),
                      onPressed: () {
                        usernameController.clear();
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
                          usernameController.text,
                        );
                        if (validator == 100) {
                          await updateUsername(
                            usernameController.text,
                          );
                          globals.username = usernameController.text;
                          setState(() {
                            isDisabled = false;
                          });
                          Future.delayed(Duration.zero,
                              () => _navigateToPlantList(context));
                        } else if (validator == 105) {
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
                            isDisabled = false;
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
              ),
            ],
          )),
    );
  }

  Future<void> updateUsername(String username) async {
    String url = 'https://herbledb.000webhostapp.com/update_user.php';
    await http.post(Uri.parse(url), body: {
      'id': globals.userID.toString(),
      'email_flutter': globals.email,
      'username_flutter': username,
      'pw_flutter': globals.password,
    });
  }

  Future<int> dataIsValid(String username) async {
    if (await checkExists(username)) return 105;
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

  void _navigateToPlantList(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MainPage(index: 3)),
    );
  }
}
