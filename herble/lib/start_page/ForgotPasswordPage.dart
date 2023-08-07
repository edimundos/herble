import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage>
    with WidgetsBindingObserver {
  final emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    emailController.dispose();
    // WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(
              height: 100,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Text(
                      "Forgot Password",
                      textAlign: TextAlign.left,
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        height: 1,
                        color: const Color.fromARGB(255, 32, 54, 50),
                      ),
                    ),
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
            child: Column(children: [
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
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15.0, 0, 15, 0),
                child: TextFormField(
                  controller: emailController,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(labelText: "Email"),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (email) =>
                      email != null && !EmailValidator.validate(email)
                          ? "Enter a valid email"
                          : null,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15.0, 0, 15, 0),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(50)),
                  icon: Icon(Icons.email_outlined),
                  label: Text("Reset password"),
                  onPressed: () {
                    if (!mounted) return;
                    verifyEmail();
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15.0, 0, 15, 0),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(50),
                      backgroundColor: Colors.blueGrey),
                  icon: Icon(Icons.email_outlined),
                  label: Text("cancel"),
                  onPressed: () {
                    if (!mounted) return;
                    cancel();
                  },
                ),
              )
            ]),
          )
        ],
      ),
    );
  }

  Future<bool> emailExists() async {
    String url = 'https://herbledb.000webhostapp.com/get_user_by_username.php';
    var response = await http.post(Uri.parse(url),
        body: {'username_flutter': emailController.text.trim()});

    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future verifyEmail() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));

    try {
      if (!mounted) return;

      if (await emailExists()) {
        await FirebaseAuth.instance
            .sendPasswordResetEmail(email: emailController.text.trim());

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Password reset email sent")));

        SchedulerBinding.instance.addPostFrameCallback((_) {
          print("jj");
          if (!mounted) return;
          Navigator.popUntil(context, (route) => route.isFirst);
          print("gg");
        });
      }
      return;
    } on FirebaseAuthException catch (e) {
      print(e);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              "Email doesn't exist in our database or something went wrong :(")));

      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.pop(context);
      });

      // TODO
    }
  }

  void cancel() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));

    try {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        print("jj");
        if (!mounted) return;
        Navigator.popUntil(context, (route) => route.isFirst);
        print("gg");
      });
    } on Exception catch (e) {
      print(e);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Something went wrong :(")));

      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.pop(context);
      });
    }
  }
}
