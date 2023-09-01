import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/src/types.dart';
import 'package:herble/colors.dart';
import 'package:herble/main_page/main_page.dart';
import 'package:herble/start_page/verif_email_page.dart';
import 'package:http/http.dart' as http;
import '../globals.dart' as globals;
import '../start_page/DatabaseUsers.dart' as FUser;
import 'package:email_auth/email_auth.dart';
import 'package:google_fonts/google_fonts.dart';

bool isLoading = false;

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
        // leading: IconButton(
        //   onPressed: () {
        //     Navigator.of(context).pop();
        //   },
        //   icon: const Icon(Icons.arrow_back_ios_new),
        // ),
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
  bool passwordVisible1 = false;
  bool passwordVisible2 = false;
  late TimeOfDay selectedTime24Hour = const TimeOfDay(hour: 20, minute: 0);
  bool submitValid = false;
  bool passwordsMatch = true;
  bool showUsernameExistsMessage = false;
  bool usernameExists = false;
  bool isEmailValid = true;
  bool showPasswordLengthMessage = false;
  bool emailExists = false;
  final emailFocusNode = FocusNode();
  final usernameFocusNode = FocusNode();

  void dispose() {
    emailController.dispose();
    pwController1.dispose();
    pwController2.dispose();
    usernameController.dispose();
    emailFocusNode.dispose();
    usernameFocusNode.dispose();
    super.dispose();
  }

  void checkPasswordsMatch() {
    setState(() {
      passwordsMatch = pwController1.text == pwController2.text;
    });
    updateSubmitValid();
  }

  void checkUsernameExists() async {
    String enteredUsername = usernameController.text;
    if (enteredUsername.isNotEmpty) {
      try {
        bool exists = await checkExists(enteredUsername);
        setState(() {
          usernameExists = exists;
          showUsernameExistsMessage = exists; // Show message based on existence
        });
      } catch (error) {
        print("Error checking username existence: $error");
      }
    }
  }

  void validateEmail() {
    String enteredEmail = emailController.text;
    const emailPattern = r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,7}$';
    bool isValidEmail = RegExp(emailPattern).hasMatch(enteredEmail);
    setState(() {
      isEmailValid = isValidEmail;
    });
  }

  void checkEmailExists() async {
    String enteredEmail = emailController.text;

    if (enteredEmail.isNotEmpty) {
      try {
        bool exists = await checkExists(enteredEmail);
        setState(() {
          emailExists = exists;
        });
      } catch (error) {
        print("Error checking email existence: $error");
      }
    }
  }

  void updateSubmitValid() {
    setState(() {
      submitValid = isEmailValid &&
          !usernameExists &&
          !emailExists &&
          passwordsMatch &&
          pwController1.text.length >= 8 &&
          pwController2.text.isNotEmpty &&
          usernameController.text.isNotEmpty;
      usernameController.text.length >= 3;
      showPasswordLengthMessage =
          pwController1.text.isNotEmpty && pwController1.text.length < 8;
    });
  }

  late EmailAuth emailAuth;

  @override
  void initState() {
    super.initState();
    // Initialize the package
    pwController1.addListener(updatePasswordLengthMessage);
    pwController2.addListener(() {
      setState(() {
        passwordsMatch = pwController1.text == pwController2.text;
      });
    });
    emailController.addListener(validateEmail);
    emailFocusNode.addListener(() {
      if (!emailFocusNode.hasFocus) {
        checkEmailExists(); // Check email existence when focus is lost
        updateSubmitValid();
      }
    });

    usernameFocusNode.addListener(() {
      if (!usernameFocusNode.hasFocus) {
        // Check username existence when focus is lost
        checkUsernameExists();
        updateSubmitValid();
      }
    });
    emailAuth = EmailAuth(
      sessionName: "Sample session",
    );

    /// Configuring the remote server
    emailAuth.config({"server": "https://www.herble.eu/"});
  }

  void updatePasswordLengthMessage() {
    setState(() {
      showPasswordLengthMessage =
          pwController1.text.isNotEmpty && pwController1.text.length < 8;
    });
  }

  /// a void funtion to send the OTP to the user
  /// Can also be converted into a Boolean function and render accordingly for providers
  void sendOtp(String email) async {
    bool result = await emailAuth.sendOtp(recipientMail: email, otpLength: 5);
    if (result) {
      print("Email Verified!");
      setState(() {
        submitValid = true;
      });
    } else {
      print("Invalid Verification Code");
    }
  }

  Widget build(BuildContext context) {
    return Column(
      children: [
        isLoading
            ? const Center(
                child: CircularProgressIndicator(),
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
                          focusNode:
                              emailFocusNode, // Associate the focus node with the field
                          onChanged: (text) {
                            // Validate email when the email field changes and text is not empty
                            validateEmail(); // Validate email format
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: isEmailValid && !emailExists
                                    ? Colors.grey
                                    : Colors.red,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: isEmailValid && !emailExists
                                    ? Colors.grey
                                    : Colors.red,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: isEmailValid && !emailExists
                                    ? mainpallete
                                    : Colors.red,
                                width: 2.0,
                              ),
                            ),
                            labelText: 'Email',
                            labelStyle: TextStyle(
                              fontFamily: 'GoogleFonts.inter',
                              color: isEmailValid && !emailExists
                                  ? Colors.grey
                                  : Colors.red,
                            ),
                          ),
                        ),
                      ),
                      if (!isEmailValid && emailController.text.isNotEmpty)
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0, top: 4.0),
                          child: Text(
                            'Invalid email address',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      if (emailExists && emailController.text.isNotEmpty)
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0, top: 4.0),
                          child: Text(
                            'A user with this email exists',
                            style: TextStyle(
                              color: Colors.red,
                              fontFamily: 'GoogleFonts.inter',
                            ),
                          ),
                        ),
                      SizedBox(height: globals.height * 0.005),
                    ]),
              )
            : Container(),
        !isLoading
            ? SizedBox(
                height: globals.height * 0.02,
                width: globals.width * 0.27,
                child: TextField(
                  controller: usernameController,
                  onChanged: (_) {
                    // Check username existence when the username field changes
                    updateSubmitValid();
                  },
                  focusNode: usernameFocusNode,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: usernameController.text.isEmpty
                            ? Colors.grey
                            : usernameExists &&
                                    usernameController.text.length >= 3
                                ? Colors.grey
                                : Colors.red,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: usernameController.text.isEmpty
                            ? Colors.grey
                            : !usernameExists &&
                                    usernameController.text.length >= 3
                                ? Colors.grey
                                : Colors.red,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: usernameController.text.length >= 3 &&
                                !usernameExists
                            ? mainpallete
                            : Colors.red,
                        width: 2.0,
                      ),
                    ),
                    labelText: 'Username',
                    labelStyle: TextStyle(
                      fontFamily: 'GoogleFonts.inter',
                      color: usernameController.text.isEmpty
                          ? Colors.grey
                          : usernameController.text.length >= 3 &&
                                  !usernameExists
                              ? mainpallete
                              : Colors.red,
                    ),
                  ),
                ),
              )
            : SizedBox(height: globals.height * 0.005),
        if (showUsernameExistsMessage)
          const Padding(
            padding: EdgeInsets.only(left: 8.0, top: 4.0),
            child: Text(
              'This username is taken',
              style: TextStyle(
                color: Colors.red,
                fontFamily: 'GoogleFonts.inter',
              ),
            ),
          ),
        if (usernameController.text.isNotEmpty &&
            usernameController.text.length < 3) // Add this condition
          const Padding(
            padding: EdgeInsets.only(left: 8.0, top: 4.0),
            child: Text(
              'Username must be at least 3 characters long', // Error message
              style: TextStyle(
                color: Colors.red,
                fontFamily: 'GoogleFonts.inter',
              ),
            ),
          ),
        SizedBox(height: globals.height * 0.005),
        !isLoading
            ? Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: globals.height * 0.02,
                        width: globals.width * 0.27,
                        child: TextField(
                          obscureText: !passwordVisible1,
                          controller: pwController1,
                          onChanged: (_) {
                            updatePasswordLengthMessage();
                            checkPasswordsMatch();
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: showPasswordLengthMessage
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: showPasswordLengthMessage
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: showPasswordLengthMessage
                                    ? Colors.red
                                    : mainpallete,
                                width: 2.0,
                              ),
                            ),
                            labelText: 'Password',
                            labelStyle: TextStyle(
                              fontFamily: 'GoogleFonts.inter',
                              color: showPasswordLengthMessage
                                  ? Colors.red
                                  : Colors.grey,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                passwordVisible1
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: const Color.fromARGB(255, 56, 56, 56),
                              ),
                              onPressed: () {
                                setState(() {
                                  passwordVisible1 = !passwordVisible1;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: globals.height * 0.002),
                    ]),
              )
            : Container(),
        if (showPasswordLengthMessage)
          const Align(
            alignment: Alignment.center,
            child: Text(
              'Password must be at least 8 characters long',
              style: TextStyle(
                color: Colors.red,
                fontFamily: 'GoogleFonts.inter',
              ),
            ),
          ),
        SizedBox(height: globals.height * 0.005),
        !isLoading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: globals.height * 0.02,
                      width: globals.width * 0.27,
                      child: TextField(
                        obscureText: !passwordVisible2,
                        controller: pwController2,
                        onChanged: (_) {
                          checkPasswordsMatch(); // Check if passwords match and update submit validity
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: passwordsMatch ? Colors.grey : Colors.red,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: passwordsMatch ? Colors.grey : Colors.red,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: passwordsMatch ? mainpallete : Colors.red,
                              width: 2.0,
                            ),
                          ),
                          labelText: 'Repeat Password',
                          labelStyle: TextStyle(
                            fontFamily: 'GoogleFonts.inter',
                            color: passwordsMatch ? Colors.grey : Colors.red,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              // Based on passwordVisible state choose the icon
                              passwordVisible2
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: const Color.fromARGB(255, 56, 56, 56),
                            ),
                            onPressed: () {
                              // Update the state i.e. toggle the state of passwordVisible variable
                              setState(() {
                                passwordVisible2 = !passwordVisible2;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: globals.height * 0.003),
                    // Check if passwords match and display error message if they don't
                    if (!passwordsMatch && pwController2.text.isNotEmpty)
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0, top: 4.0),
                        child: Text(
                          'The password does not match',
                          style: TextStyle(
                            color: Colors.red,
                            fontFamily: 'GoogleFonts.inter',
                          ),
                        ),
                      ),
                    SizedBox(height: globals.height * 0.005),
                  ],
                ),
              )
            : Container(),
        !isLoading
            ? SizedBox(
                height: globals.height * 0.03,
                width: globals.width * 0.27,
                // padding: const EdgeInsets.all(10.0),
                child: Container(
                  // height: globals.height * 0.03,
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextButton(
                    onPressed: () async {
                      selectedTime24Hour = (await showTimePicker(
                        context: context,
                        initialTime: selectedTime24Hour !=
                                const TimeOfDay(hour: 20, minute: 0)
                            ? selectedTime24Hour
                            : const TimeOfDay(hour: 20, minute: 00),
                        builder: (BuildContext context, Widget? child) {
                          return MediaQuery(
                            data: MediaQuery.of(context)
                                .copyWith(alwaysUse24HourFormat: true),
                            child: child!,
                          );
                        },
                      ))!;
                      setState(() {
                        selectedTime24Hour = selectedTime24Hour;
                      });
                    },
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text:
                                "Select time of day to receive water refill notifications",
                            style: TextStyle(color: Colors.black54),
                          ),
                          TextSpan(
                            text:
                                " (${selectedTime24Hour.hour.toString().padLeft(2, '0')}:${selectedTime24Hour.minute.toString().padLeft(2, '0')})",
                            style: const TextStyle(
                                color: Color.fromARGB(255, 34, 65, 54)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : Container(),
        !isLoading
            ? SizedBox(
                height: globals.height * 0.003,
              )
            : Container(),
        !isLoading
            ? TextButton(
                onPressed: submitValid
                    ? () async {
                        setState(() {
                          isLoading = true;
                        });
                        int validator = await dataIsValid(
                          usernameController.text,
                          pwController1.text,
                          pwController2.text,
                          emailController.text,
                        );
                        if (validator == 100) {
                          signUpFirebase(
                              userEmail: emailController.text.trim(),
                              password: pwController1.text.trim(),
                              context: context);
                          setState(() {
                            isLoading = false;
                          });
                          print(emailController.text);
                          String email = emailController.text;
                          String password = pwController1.text.trim();
                          Future.delayed(
                              Duration.zero,
                              () => _navigateToEmailVerify(
                                    context,
                                    email,
                                    usernameController.text.trim(),
                                    password,
                                    selectedTime24Hour,
                                  ));
                        }
                        // } else if (validator == 106) {
                        //   setState(() {
                        //     isLoading = false;
                        //   });
                        //   showDialog(
                        //     context: context,
                        //     builder: (BuildContext context) {
                        //       return AlertDialog(
                        //         content: const Text(
                        //             'Username must be longer than 3 characters'),
                        //         actions: <Widget>[
                        //           TextButton(
                        //             onPressed: () =>
                        //                 Navigator.pop(context, 'Ok'),
                        //             child: const Text('Ok'),
                        //           ),
                        //         ],
                        //       );
                        //     },
                        //   );
                        // }
                      }
                    : null,
                child: SizedBox(
                  height: globals.height * 0.02,
                  width: globals.width * 0.27,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: submitValid
                          ? const Color.fromARGB(255, 34, 65, 54)
                          : Colors.grey, // Gray color when disabled
                    ),
                    child: Text(
                      'Register',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        height: 1,
                        color: const Color.fromARGB(255, 226, 233, 218),
                      ),
                    ),
                  ),
                ),
              )
            : Container(),
      ],
    );
  }

  Future<User?> signUpFirebase(
      {required String userEmail,
      required String password,
      required BuildContext context}) async {
    print("signUpFirebase");
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text.trim(),
              password: pwController1.text.trim());

      // WRITE DATA TO FIREBASE DATASTORE
      // DOC.ID = EMAIL

      createUser();

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print("here");
      print(e);
      print("here");
    }
    return null;
  }

  Future createUser() async {
    final docUser = FirebaseFirestore.instance
        .collection("users")
        .doc(emailController.text.trim());

    final user = FUser.User(
        email: emailController.text.trim(),
        username: usernameController.text.trim(),
        waterTimeMin: selectedTime24Hour.hour * 60 + selectedTime24Hour.minute);

    final json = user.toJson();

    await docUser.set(json);
  }

  Future<void> postUser(String username, String pw, String email) async {
    String url = 'https://herbledb.000webhostapp.com/post_user.php';
    globals.username = username;
    globals.password = pw;
    globals.email = email;
    globals.wateringTime =
        Time(selectedTime24Hour.hour, selectedTime24Hour.minute);
    await http.post(Uri.parse(url), body: {
      'username_flutter': username,
      'pw_flutter': pw,
      'email_flutter': email,
      'time':
          '${selectedTime24Hour.hour.toString().length == 1 ? '0${selectedTime24Hour.hour}' : selectedTime24Hour.hour}:${selectedTime24Hour.minute.toString().length == 1 ? '0${selectedTime24Hour.minute}' : selectedTime24Hour.minute}:00',
    });
  }

  Future<int> dataIsValid(
      String username, String pw1, String pw2, String email) async {
    if (pw1 != pw2) return 101;
    if (pw1.length <= 7) return 102;
    if (!email.contains('@')) return 103;
    if (await checkExists(username)) return 104;
    if (await checkExists(email)) return 105;
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

  void _navigateToEmailVerify(
    BuildContext context,
    String text,
    String username,
    String password,
    TimeOfDay selectedTime24Hour,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => VerifyEmail(
                email: text,
                username: username,
                password: password,
                timeOfDay: selectedTime24Hour,
              )),
    );
  }
}
