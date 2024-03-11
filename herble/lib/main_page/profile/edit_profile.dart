import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:herble/globals.dart' as globals;
import 'package:herble/main_page/main_page.dart';

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
  final emailController = TextEditingController();

  bool isDisabled = false;

  @override
  void initState() {
    super.initState();
    usernameController.text = globals.username;
    emailController.text = globals.email;
  }

  @override
  void dispose() {
    emailController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          reverse: true,
          child: Column(
            children: [
              SizedBox(
                  height: globals.height * 0.045,
                  child: Row(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                          ),
                          onPressed: () async {
                            FocusManager.instance.primaryFocus?.unfocus();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MainPage(
                                        index: 3,
                                      )),
                            );
                          },
                          child: Row(
                            children: [
                              SizedBox(
                                width: globals.width * 0.09,
                                height: globals.height * 0.014,
                                child: Center(
                                  child: Text(
                                    'Cancel',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.inter(
                                      fontSize: globals.width * 0.017,
                                      fontWeight: FontWeight.w400,
                                      height: 1,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 25.0),
                          child: Text(
                            'Edit profile',
                            style: GoogleFonts.inter(
                              fontSize: globals.width * 0.017,
                              fontWeight: FontWeight.w600,
                              height: 1,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: globals.width * 0.095,
                        height: globals.height * 0.015,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              elevation: 0),
                          onPressed: !isDisabled
                              ? () async {
                                  setState(() {
                                    isDisabled = true;
                                  });
                                  int validator = await dataIsValid(
                                    usernameController.text,
                                    emailController.text,
                                  );
                                  if (validator == 100) {
                                    await updateEmail(
                                      emailController.text,
                                    );
                                    await updateUsername(
                                      usernameController.text,
                                    );
                                    globals.email = emailController.text;
                                    globals.username = usernameController.text;
                                    setState(() {
                                      isDisabled = false;
                                    });
                                    Future.delayed(Duration.zero,
                                        () => _navigateToPlantList(context));
                                  } else if (validator == 103) {
                                    setState(() {
                                      isDisabled = false;
                                    });
                                    // ignore: use_build_context_synchronously
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          content: const Text(
                                              'A user with this username already exists'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, 'Ok'),
                                              child: const Text('Ok'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  } else if (validator == 104) {
                                    setState(() {
                                      isDisabled = false;
                                    });
                                    // ignore: use_build_context_synchronously
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          content: const Text(
                                              'Username must be longer than 3 characters'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, 'Ok'),
                                              child: const Text('Ok'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  } else if (validator == 101) {
                                    setState(() {
                                      isDisabled = false;
                                    });
                                    // ignore: use_build_context_synchronously
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          content: const Text(
                                              'New email must contain @'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, 'Ok'),
                                              child: const Text('Ok'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  } else if (validator == 102) {
                                    setState(() {
                                      isDisabled = false;
                                    });
                                    // ignore: use_build_context_synchronously
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          content: const Text(
                                              'A user with this email already exists'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, 'Ok'),
                                              child: const Text('Ok'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                }
                              : null,
                          child: Center(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 25.0),
                                child: SizedBox(
                                  child: Text(
                                    'Save',
                                    style: GoogleFonts.inter(
                                      fontSize: globals.width * 0.017,
                                      fontWeight: FontWeight.w400,
                                      height: 1,
                                      color: const Color.fromARGB(
                                          255, 31, 100, 58),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  )),
              Padding(
                padding: const EdgeInsets.only(left: 9),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Email',
                    style: GoogleFonts.inter(
                      fontSize: globals.width * 0.014,
                      fontWeight: FontWeight.w500,
                      height: 1,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.cancel),
                      onPressed: () {
                        emailController.clear();
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 9, top: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Username',
                    style: GoogleFonts.inter(
                      fontSize: globals.width * 0.014,
                      fontWeight: FontWeight.w500,
                      height: 1,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.cancel),
                      onPressed: () {
                        usernameController.clear();
                      },
                    ),
                  ),
                ),
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

  Future<int> dataIsValid(String username, String emailController) async {
    if (!emailController.contains('@')) return 101;
    if (emailController == globals.email) {
    } else if (await checkExists(emailController)) return 102;
    if (username == globals.username) {
    } else if (await checkExists(username)) return 103;
    if (username.length <= 2) return 104;

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

//
  Future<void> updateEmail(String email) async {
    String url = 'https://herbledb.000webhostapp.com/update_user.php';
    await http.post(Uri.parse(url), body: {
      'id': globals.userID.toString(),
      'email_flutter': email,
      'username_flutter': globals.username,
      'pw_flutter': globals.password,
    });
  }

  Future<bool> checkExistsEmail(String email) async {
    String url = 'https://herbledb.000webhostapp.com/get_user_by_username.php';
    var response =
        await http.post(Uri.parse(url), body: {'username_flutter': email});

    if (response.statusCode == 200 && response.body.length > 5) {
      return true;
    } else {
      return false;
    }
  }
}
