import 'package:flutter/material.dart';
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
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
        ),
        body: const UsernameBody());
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
    return Column(
      children: [
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
        TextButton(
          onPressed: !isDisabled
              ? () async {
                  setState(() {
                    isDisabled = true;
                  });
                  int validator = await dataIsValid(
                    usernameController.text,
                  );
                  if (validator == 100) {
                    Future.delayed(
                        Duration.zero, () => _navigateToPlantList(context));
                    await updateUsername(
                      usernameController.text,
                    );
                    globals.username = usernameController.text;
                    setState(() {
                      isDisabled = false;
                    });
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
      MaterialPageRoute(builder: (context) => MainPage()),
    );
  }
}
