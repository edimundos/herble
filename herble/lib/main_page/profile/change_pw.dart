import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:herble/globals.dart' as globals;
import 'package:herble/main_page/main_page.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: PasswordBody());
  }
}

class PasswordBody extends StatefulWidget {
  const PasswordBody({super.key});

  @override
  State<PasswordBody> createState() => _PasswordBodyState();
}

class _PasswordBodyState extends State<PasswordBody> {
  // final passwordController = TextEditingController();
  // final passwordRepeatController = TextEditingController();
  // final passwordB4Controller = TextEditingController();

  // bool isDisabled = false;
  // bool passwordVisible0 = false;
  // bool passwordVisible1 = false;
  // bool passwordVisible2 = false;

  // void dispose() {
  //   passwordB4Controller.dispose();
  //   passwordController.dispose();
  //   passwordRepeatController.dispose();
  //   super.dispose();
  // }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            reverse: true,
            child: Column(children: [
              SizedBox(
                  height: 100,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: GestureDetector(
                            onTap: () {
                              FocusScope.of(context).requestFocus(FocusNode());
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
              const Flexible(
                child: FractionallySizedBox(
                  heightFactor: 0.3,
                ),
              ),
              Center(
                  child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: Text(
                      "Recieve an email to reset your password",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        height: 1,
                        color: const Color.fromARGB(255, 32, 54, 50),
                      ),
                    ),
                  ),
                ],
              ))
            ])));
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
      MaterialPageRoute(builder: (context) => MainPage(index: 3)),
    );
  }
}
