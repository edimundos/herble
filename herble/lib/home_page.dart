import 'package:flutter/material.dart';
import 'package:herble/log_in.dart';
import 'package:herble/sign_up.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('herble'),
          centerTitle: true,
        ),
        backgroundColor: Colors.green[50],
        body: Center(
          child: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton.extended(
                  heroTag: const LogInScreen(),
                  icon: const Icon(Icons.lock_open),
                  label: const Text('Log In'),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return const LogInScreen();
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                FloatingActionButton.extended(
                  heroTag: const SignUpPage(),
                  icon: const Icon(Icons.person_add_outlined),
                  label: const Text('Sign up'),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return const SignUpPage();
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
