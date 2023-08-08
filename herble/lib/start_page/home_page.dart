import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:herble/main_page/main_page.dart';
import 'package:herble/start_page/log_in.dart';
import 'package:herble/notifications/notificationservice.dart';
import 'package:herble/notifications/water_confirmation.dart';
import 'package:herble/glassmorphism.dart';
import 'package:herble/start_page/log_in.dart' as login;
import 'package:herble/start_page/sign_up.dart' as signup;
import 'package:herble/start_page/sign_up.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../globals.dart' as globals;
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

bool isKeyboard = false;
Future<void> rememberMeLogic(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int userIDRemembered = prefs.getInt('userID') ?? 0;
  String? userPWRemembered = prefs.getString('password');
  if (userIDRemembered != 0) {
    globals.userID = userIDRemembered;
    globals.isLoggedIn = true;
    getEmailAndUsername();
    globals.password = userPWRemembered!;
    print("remember me initieated, userID: $userIDRemembered");
    await signInFirebase(globals.email, globals.password);
    _navigateToPlantList(context);
  }
}

Future<void> _navigateToPlantList(BuildContext context) async {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const MainPage(index: 1)),
  );
}

Future signInFirebase(String email, String pw) async {
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: pw,
    );
    return true;
  } on FirebaseAuthException catch (e) {
    stop = true;
    print(e);
  }
}

Future<void> getEmailAndUsername() async {
  String url = 'https://herbledb.000webhostapp.com/get_user_credentials.php';
  var response = await http
      .post(Uri.parse(url), body: {'user_id': globals.userID.toString()});

  if (response.statusCode == 200 && response.body.length > 6) {
    List<dynamic> user = jsonDecode(response.body);
    Map<String, dynamic> userMap = user[0];
    correctEmail = (userMap["email"]).toString().trim();
    globals.username = (userMap["username"]).toString();
    globals.email = (userMap["email"]).toString();
  } else {
    debugPrint('Request failed with status: ${response.statusCode}');
  }
}

class AppStartPage extends StatefulWidget {
  const AppStartPage({super.key});

  @override
  State<AppStartPage> createState() => _AppStartPageState();
}

class _AppStartPageState extends State<AppStartPage> {
  static const backgroundImage = DecorationImage(
    image: AssetImage('assets/StartUpPage.png'),
    fit: BoxFit.cover,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: backgroundImage,
        ),
        child: const MyHomePage(),
      ),
    );
  }
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late AnimationController controller;
  bool isSignIn = false;
  int animLength = 1;
  bool showSignInButton = true;
  bool showRegisterButton = true;

  @override
  void initState() {
    super.initState();
    listenToNotification();
    controller = BottomSheet.createAnimationController(this);
    controller.duration = Duration(seconds: animLength);
    controller.reverseDuration = Duration(seconds: animLength);
    rememberMeLogic(context);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textSpan = TextSpan(
      text: 'herble',
      style: GoogleFonts.italiana(
        fontSize: globals.width * 0.047,
        fontWeight: FontWeight.w400,
        height: 1,
        color: const Color(0xffffffff),
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    final textWidth = textPainter.width;
    final textHeight = textPainter.height;

    return ListView(children: [
      Column(
        children: [
          SizedBox(
            height: globals.height * 0.08,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              // alignment: AlignmentDirectional.bottomCenter,
              children: [
                !isKeyboard
                    ? AnimatedPositioned(
                        duration: Duration(seconds: animLength),
                        curve: Curves.easeInOut,
                        top: showSignInButton
                            ? globals.height * 0.08 - textHeight
                            : 20,
                        left: showSignInButton
                            ? MediaQuery.of(context).size.width / 2 -
                                textWidth / 2
                            : 20,
                        child: Text(
                          'herble',
                          style: GoogleFonts.italiana(
                            fontSize: globals.width * 0.05,
                            fontWeight: FontWeight.w400,
                            // height: globals.height * 0,
                            color: const Color(0xffffffff),
                          ),
                        ),
                        // ),
                      )
                    : Container(),
              ],
            ),
          ),
          // SizedBox(height:20),
          AnimatedOpacity(
              opacity: showSignInButton ? 1.0 : 0.0,
              duration: Duration(seconds: animLength - 1, milliseconds: 600),
              child: Text(
                textAlign: TextAlign.center,
                'a self-watering plant pot company',
                style: GoogleFonts.cormorantGaramond(
                  fontSize: globals.width * 0.015,
                  fontWeight: FontWeight.w400,
                  // height: 1,
                  color: const Color(0xffffffff),
                ),
              ))
        ],
      ),
      SizedBox(height: globals.height * 0.09),
      Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedOpacity(
              opacity: showSignInButton ? 1.0 : 0.0,
              duration: Duration(seconds: animLength),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.black.withOpacity(0),
                ),
                child: Glassmorphism(
                  blur: 1,
                  opacity: 0.5,
                  radius: 10.0,
                  color: Colors.black,
                  child: TextButton(
                    onPressed: showSignInButton == false
                        ? null
                        : () {
                            popUpSignIn();
                            setState(() {
                              showSignInButton = false;
                              showRegisterButton = false;
                            });
                          },
                    child: Container(
                      width: globals.width * 0.18,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 6,
                        // horizontal: 9,
                      ),
                      child: Center(
                        child: Text(
                          'Log in',
                          style: GoogleFonts.inter(
                            fontSize: globals.width * 0.015,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xffffffff),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // ),
                ),
              ),
            ),
            SizedBox(height: globals.height * 0.007),
            AnimatedOpacity(
              opacity: showSignInButton ? 1.0 : 0.0,
              duration: Duration(seconds: animLength),
              child: Glassmorphism(
                blur: 1,
                opacity: 1,
                radius: 10.0,
                color: Colors.white,
                child: TextButton(
                  onPressed: showSignInButton == false
                      ? null
                      : () {
                          popUpRegister();
                          setState(() {
                            showSignInButton = false;
                            showRegisterButton = false;
                          });
                        },
                  child: Container(
                    width: globals.width * 0.18,
                    color: const Color.fromARGB(255, 255, 255, 255),
                    padding: const EdgeInsets.symmetric(
                      vertical: 6,
                      // horizontal: 9,
                    ),
                    child: Center(
                      child: Text(
                        'Register',
                        style: GoogleFonts.inter(
                          fontSize: globals.width * 0.015,
                          fontWeight: FontWeight.w600,
                          color: const Color.fromARGB(255, 98, 123, 119),
                        ),
                      ),
                    ),
                  ),
                ),
                // ),
              ),
            ),
          ],
        ),
      ),
    ]);
  }

  Future<bool> _exitApp() async {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (BuildContext context) =>
            const AppStartPage(), // Replace with your initial screen
      ),
      (Route<dynamic> route) =>
          false, // Remove all previous routes from the stack
    );
    return false;
  }

  void listenToNotification() => NotificationService()
      .onNotificationClick
      .stream
      .listen(onNotificationListener);

  Future<void> onNotificationListener(String? payload) async {
    if (payload != null && payload.isNotEmpty) {
      globals.Plant plant = await getPlantsById(int.parse(payload));
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: ((context) => WaterConfirm(plant: plant))));
    }
  }

  Future<globals.Plant> getPlantsById(int id) async {
    String url = 'https://herbledb.000webhostapp.com/get_plant_by_id.php';
    try {
      var response =
          await http.post(Uri.parse(url), body: {'id': id.toString()});

      if (response.statusCode == 200) {
        List<dynamic> plants = json
            .decode(response.body)
            .map((data) => globals.Plant.fromJson(data as Map<String, dynamic>))
            .toList();
        return plants[0];
      } else {
        throw Exception('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions here
      throw e;
    }
  }

  void popUpSignIn() async {
    showBottomSheet(
      enableDrag: false,
      context: context,
      transitionAnimationController: controller,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: _exitApp,
          child: Opacity(
            opacity: 1,
            child: AnimatedContainer(
              height: MediaQuery.of(context).size.height * 0.6,
              duration: Duration(seconds: animLength),
              curve: Curves.easeInOut,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(40.0),
                  topLeft: Radius.circular(40.0),
                ),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    !login.isLoading
                        ? SizedBox(height: globals.height * 0.02)
                        : Container(),
                    !login.isLoading
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                Text(
                                  "Log in ",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      height: 1,
                                      color: const Color.fromARGB(
                                          255, 34, 65, 54)),
                                ),
                                Text(
                                  " to your account",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                      fontSize: 20,
                                      height: 1,
                                      color: const Color.fromARGB(
                                          255, 34, 65, 54)),
                                ),
                              ])
                        : Container(),
                    SizedBox(height: globals.height * 0.01),
                    StreamBuilder<User?>(
                        stream: FirebaseAuth.instance.authStateChanges(),
                        builder: (context, snapshot) {
                          // if (snapshot.hasData) {
                          //   return MainPage(
                          //     index: 1,
                          //   );
                          // }
                          return const MyCustomForm();
                        }),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.2,
                    ),
                    !login.isLoading
                        ? Align(
                            alignment: Alignment.bottomCenter,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Don't have an account?",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    fontSize: globals.width * 0.01,
                                    height: 1,
                                    color: const Color.fromARGB(
                                        255, 116, 129, 127),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Future.delayed(
                                        Duration(
                                            seconds: animLength,
                                            milliseconds: 300), () {
                                      popUpRegister();
                                    });
                                  },
                                  child: Text(
                                    "Register",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.inter(
                                      fontSize: globals.width * 0.01,
                                      fontWeight: FontWeight.bold,
                                      height: 1,
                                      color:
                                          const Color.fromARGB(255, 34, 65, 54),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void popUpRegister() async {
    showBottomSheet(
        enableDrag: false,
        context: context,
        transitionAnimationController: controller,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: _exitApp,
            child: Opacity(
              opacity: 1,
              child: AnimatedContainer(
                height: MediaQuery.of(context).size.height * 0.8,
                duration: Duration(seconds: animLength),
                curve: Curves.easeInOut,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40.0),
                    topLeft: Radius.circular(40.0),
                  ),
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      !signup.isLoading
                          ? SizedBox(height: globals.height * 0.015)
                          : Container(),
                      !signup.isLoading
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                  Text(
                                    "Register ",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.inter(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        height: 1,
                                        color: const Color.fromARGB(
                                            255, 34, 65, 54)),
                                  ),
                                  Text(
                                    " an account",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.inter(
                                        fontSize: 20,
                                        height: 1,
                                        color: const Color.fromARGB(
                                            255, 34, 65, 54)),
                                  ),
                                ])
                          : Container(),
                      SizedBox(height: globals.height * 0.01),
                      const LogInForm(),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.19),
                      !signup.isLoading
                          ? Align(
                              alignment: Alignment.bottomCenter,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Already have an account?",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.inter(
                                      fontSize: globals.width * 0.01,
                                      height: 1,
                                      color: const Color.fromARGB(
                                          255, 116, 129, 127),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Future.delayed(
                                          Duration(
                                              seconds: animLength,
                                              milliseconds: 300), () {
                                        popUpSignIn();
                                      });
                                    },
                                    child: Text(
                                      "Log in",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.inter(
                                        fontSize: globals.width * 0.01,
                                        fontWeight: FontWeight.bold,
                                        height: 1,
                                        color: const Color.fromARGB(
                                            255, 34, 65, 54),
                                      ),
                                    ),
                                  ),
                                ],
                              ))
                          : Container(),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
